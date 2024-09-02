%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Vortex Island Estimation of Distribution Algorithm++                %
%       Dr. Yoan Martínez-López, Camaguey University, Cuba              %
%       Eng. Miguel Bethencourt, Camaguey University, Cuba              %
%       Dt. Julio Madera, Camaguey University, Cuba                     %
%       Dr. Ansel Rodriguez, CICESE, Mexico                             %
%       Dr. Wenlei Bai, the Oracle Energy and Water, Oracle America Inc.,% 
%           Austin, TX,USA                                               % 
%       Haoxiang Qin,  the School of Software Engineering,                % 
%          South China University of Technology, Guangzhou 510006, China  % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ref:
% Do?an, B., & Ölmez, T. (2015). A new metaheuristic for numerical function optimization: Vortex Search algorithm. Information Sciences, 293, 125-145.
% Madera, J., Alba, E., & Ochoa, A. (2006). A parallel island model for estimation of distribution algorithms. In Towards a new evolutionary computation (pp. 159-186). Springer, Berlin, Heidelberg.
% Martínez-López, Y., Madera, J., Rodríguez-González, A. Y., & Barigye, S. (2019). Cellular estimation Gaussian algorithm for continuous domain. Journal of Intelligent & Fuzzy Systems, 36(5), 4957-4967.
% Martínez-López, Y., Rodríguez-González, A. Y., Quintana, J. M., Moya, A., Morgado, B., & Mayedo, M. B. (2019, July). CUMDANCauchy-C1: a cellular EDA designed to solve the energy resource management problem under uncertainty. In Proceedings of the Genetic and Evolutionary Computation Conference Companion (pp. 13-14).
% Martínez-López, Y., Rodríguez-González, A. Y., Quintana, J. M., Mayedo, M. B., Moya, A., & Santiago, O. M. (2020, July). Applying some EDAs and hybrid variants to the ERM problem under uncertainty. In Proceedings of the 2020 Genetic and Evolutionary Computation Conference Companion (pp. 1-2).
% Martínez-López, Y., Rodríguez-González, A. Y., Madera, J., Mayedo, M. B., & Lezama, F. (2021). Cellular estimation of distribution algorithm designed to solve the energy resource management problem under uncertainty. Engineering Applications of Artificial Intelligence, 101, 104231.
% Rodríguez-González, A. Y., Lezama, F., Martínez-López, Y., Madera, J., Soares, J., & Vale, Z. (2022). WCCI/GECCO 2020 Competition on Evolutionary Computation in the Energy Domain: An overview from the winner perspective. Applied Soft Computing, 109162.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% email: cybervalient@gmail.com, betamiguel00@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [Fit_and_p, FVr_bestmemit, fitMaxVector] = VIEDA(VIEDAParameters, funcion)

    % Extract parameters
    I_NP = VIEDAParameters.I_NP;
    I_D = numel(VIEDAParameters.up_habitat_limit);
    I_itermax = VIEDAParameters.I_itermax;
    FVr_minbound = VIEDAParameters.low_habitat_limit;
    FVr_maxbound = VIEDAParameters.up_habitat_limit;
    Sub_Pop = VIEDAParameters.Sub_Pop;
    Sub_Pop_Size = VIEDAParameters.Sub_Pop_Size;
    Elitist_Selection = VIEDAParameters.Elitist_Selection;
    radius = VIEDAParameters.radius;
    w_BB_BC = VIEDAParameters.w_BB_BC;

    % Initialize population and arrays
    fitMaxVector = nan(1, I_itermax);
    fitSolutionVector = nan(I_itermax, I_D);

    gen = 1; % iterations
    Center = zeros(I_NP, I_D);
    change_amplitud = 2;

    % Generate initial population
    FM_pop = genpop(I_NP, I_D, FVr_minbound, FVr_maxbound);

    % Evaluate the initial population
    S_val = zeros(1, I_NP);
    for i = 1:I_NP
        S_val(i) = feval(funcion, FM_pop(i, :));
    end

    [fxopt, O_position] = sort(S_val, 'ascend');
    FVr_bestmemit = FM_pop(O_position(1), :); % best member of current iteration
    fitMaxVector(1, gen) = S_val(O_position(1));
    Bindex = O_position(1);

    bestValue = S_val(O_position(1));
    fitSolutionVector(gen, 1:I_D) = FVr_bestmemit;

    FM_newpop = FM_pop;
    range = (FVr_maxbound - FVr_minbound) / 2;

    % Main loop
    while gen < I_itermax
        SelectedIndividualIndexes = getSelectedIndividualIndexes(S_val, Elitist_Selection);

        for i = 1:Sub_Pop
            BB_rand = (1 + sawtooth(0.2 * pi * 0.1 * gen, w_BB_BC)) / change_amplitud;
            if BB_rand < 0.75
                BB_rand = 0.75;
            end
            r = BB_rand;

            old_Mu = FVr_minbound + range / (i + 1);
            for k = 1:I_D
                if rand < r
                    old_Mu(k) = old_Mu(k) + (mean(Center(O_position(1), :)) + (FM_pop(O_position(1), k) - FVr_minbound(k)) * randn / (gen + 1));
                end
            end

            [Mu, Sigma] = getEstimadedModel3(FM_pop, SelectedIndividualIndexes, old_Mu, FVr_minbound, FVr_maxbound, r, range);

            SubPopIndividualIdexes = GetSubPopIndividualIdexes(i, Sub_Pop_Size);
            NewSubPop = sampleNewIndividualsFromModelholdBoudary(Sub_Pop_Size, Mu, Sigma);

            for j = 1:Sub_Pop_Size
                FM_newpop(SubPopIndividualIdexes(j), :) = NewSubPop(j, :);
            end
        end

        FM_pop = getUnboudedPop(FM_newpop, FVr_minbound, FVr_maxbound);

        % Evaluation of new Pop
        for i = 1:I_NP
            S_val(i) = feval(funcion, FM_pop(i, :));
        end

        [S_best_val, I_best_index] = min(S_val);

        if S_best_val < bestValue
            FVr_bestmemit = FM_pop(I_best_index, :);
            Bindex = I_best_index;
            bestValue = S_best_val;
        end

        S_val(Bindex) = bestValue;
        FM_pop(Bindex, :) = FVr_bestmemit;

        fprintf('Best Fitness value: %f\n', bestValue);
        fprintf('Generation: %d\n', gen);

        gen = gen + 1;
        fitMaxVector(1, gen) = bestValue;
        fitSolutionVector(gen, 1:I_D) = FVr_bestmemit;
    end

    Fit_and_p = [fitMaxVector(1, gen) 0];
end

% ...

function pop = genpop(a, b, lowMatrix, upMatrix)
    pop = lowMatrix + (upMatrix - lowMatrix) .* rand(a, b);
end


%%
function unboudedIndiv = rebound(unboudedIndiv,FVr_minbound,FVr_maxbound)

    [idx] = find(~(FVr_minbound <= unboudedIndiv));
    unboudedIndiv(idx) = FVr_minbound(idx);
    [idx] = find(~(unboudedIndiv <=FVr_maxbound()));
    unboudedIndiv(idx) = FVr_minbound(idx);

end


function unboudedPop = getUnboudedPop(FM_pop,FVr_minbound,FVr_maxbound)

    [hs,ws] = size(FM_pop);
    unboudedPop = nan(hs,ws);
    
    for i = 1: hs
    unboudedPop(i,:) = rebound(FM_pop(i,:),FVr_minbound,FVr_maxbound);
    end
        
end



function SubPopIndividualIdexes = GetSubPopIndividualIdexes(index,Sub_Pop_Size)
    
    SubPopIndividualIdexes = nan(1,Sub_Pop_Size,'single');
    base = (index - 1) * Sub_Pop_Size;
    
    for index = 1:Sub_Pop_Size
        SubPopIndividualIdexes(index) = base + index;
    end
    
end



function SelectedIndividualIndexes = getSelectedIndividualIndexes(S_val,Elitist_Selection)

    [~,I] = sort(S_val);       
    SelectedIndividualIndexes = I(1:Elitist_Selection);
 
end


function [Mu,Sigma] = getEstimadedModel3(FM_pop, SelectedIndividualIndexes, old_Mu,FVr_minbound,FVr_maxbound,r,range)

    parents = FM_pop(SelectedIndividualIndexes, :);        
    
    Mu = mean(parents); 
    
    Sigma = std(parents);
    
    r = Sigma;
    
    [~,all] = size(FM_pop);

    for i = 1: all
        if range(i) == 0
            continue;  
        end
        
         if Mu(i) <= FVr_minbound(i) 
            Mu(i) = Mu(i) + Sigma(i);
          continue;
         end
        
         if Mu(i) >= (FVr_maxbound(i) + FVr_minbound(i))/2 %8 (18492) 4(18490) 2(18495)
           Mu(i) = Mu(i) - r(i);
          continue;
         end
         
        if Mu(i) <= old_Mu(i)
           Mu(i) = Mu(i)-r(i);       
           % Mu(i) = Mu(i) -  (range(i))*0.1; 
          continue;
        end
        
        if Mu(i) > old_Mu(i)
           Mu(i) = Mu(i) + r(i);   
           %Mu(i) = Mu(i)  + (range(i))*0.1;  
          continue;
        end

    end

end

function f_value = feval(funcion, FM_pop) % Needs to be implemented. Has has parameters a function and values from the population and Return Function evaluates in the population values 

        f_value = funcion.evaluate(FM_pop);
 
end


function NewSubPop = sampleNewIndividualsFromModelholdBoudary(Sub_Pop_Size,Mu,Sigma)

    [~,ws] = size(Mu);
    NewSubPop = nan (Sub_Pop_Size,ws);              
    
    for j = 1: ws
        NewSubPop(:,j) = normrnd(Mu(j), Sigma(j), Sub_Pop_Size, 1);     
    end
    
end


