function [Fit_and_p, Sol, fitVector] = ...
    alg_run_island_DE(deParameters,funcion)
% Author: Jakub Kudela
% Description:	Simple island-model DE, no 'CR' as the islands are all in 1D only

popsize = deParameters.NP;
maxfcalls = deParameters.maxfcalls;
F = deParameters.F;
lowerB = deParameters.low_habitat_limit;
upperB = deParameters.up_habitat_limit;

fnc= deParameters.fnc;
fitVector = [];
rand('state',1) %Guarantee same initial population for reproducibility
bestfit = Inf;
js = lowerB(1):upperB(1);
vals = exp(linspace(log(lowerB(2)),log(upperB(2)),popsize))+randn(1,popsize); %initial pop for all islands
vals = max(min(vals,upperB(2)),lowerB(2)); %enforce bounds

presceen_vals = zeros(35,popsize);
%eval all islands
for j=1:length(js)
    for i=1:popsize
        val = [js(j),vals(i)];
        [S_val,penalties]=feval(val,funcion);
        presceen_vals(j,i) = S_val;
        if S_val<bestfit
            bestfit = S_val;
            Sol = val;
            Fit_and_p = [S_val, penalties];
        end
    end
    fitVector(:,end+1) = Fit_and_p;
end
fprintf("Current best: Iter = %i, OBJ = %f, pen = %f\n", length(fitVector),fitVector(:,end));

minvals = min(presceen_vals,[],2);
[~,idx] = sort(minvals);
js_selected = idx(1:popsize); % keep only popsize islands
pops = repmat(vals,popsize,1);
pop_vals = presceen_vals(js_selected,:);

fcalls = popsize*length(js);
rem_calls = maxfcalls-fcalls;
rem_iters = floor((rem_calls/popsize)/popsize);

%evolve islands separately
for i=1:rem_iters
    for j=1:popsize
        children = zeros(1,popsize);
        for jj = 1:popsize
            perm = randperm(popsize,3);
            children(jj) = pops(j,perm(1)) + F*(pops(j,perm(2)) - pops(j,perm(3)));
        end
        for jj = 1:popsize
            val = [js_selected(j),children(jj)];
            [S_val,penalties]=feval(val,funcion);
            if S_val < pop_vals(j,jj)
                pops(j,jj) = children(jj);
                pop_vals(j,jj) = S_val;
                if S_val<bestfit
                    bestfit = S_val;
                    Sol = val;
                    Fit_and_p = [S_val, penalties];
                end
            end
        end
        fitVector(:,end+1) = Fit_and_p;
    end
    fprintf("Current best: Iter = %i, OBJ = %f, pen = %f\n", length(fitVector),fitVector(:,end));
end

end

function [S_val,penalties] = feval( FM_pop, funcion)
% Evaluar la función en la población
S_val = funcion.evaluate(FM_pop);
penalties = 0;

end
