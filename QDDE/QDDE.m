function [Fit_and_p,FVr_bestmemit, fitMaxVector] = ...
    QDDE(qddeParameters,funcion)

rand('state',1) %Guarantee same initial population
I_NP         = qddeParameters.I_NP;
F_weight     = qddeParameters.F_weight;
F_CR         = qddeParameters.F_CR;
I_D          = numel(qddeParameters.up_habitat_limit); %Number of variables or dimension
FVr_minbound = qddeParameters.low_habitat_limit;
FVr_maxbound = qddeParameters.up_habitat_limit;
I_itermax    = qddeParameters.I_itermax;
regionbest = 999999999 * ones(1,3060);     %regionbest(i,j)表示对应区域的最小值
regionpen = 999999999 * ones(1,3060);
regionbestpos = zeros(3060, 2);   %bestpos的第i行存放第i区域最优解的x值和y值
bestpos=[0,0];
bestfit=999999999;
bestpen=0;
initnum=1000;
colxy=[0,0;0,0;0,0;0,0];    %colxy表示协作向量
fnc = qddeParameters.fnc;
F_weight_old=repmat(F_weight,I_NP,3);
F_weight= F_weight_old;
F_weight(1,1)=F_weight(1,1)-0.1;
F_weight(1,3)=F_weight(1,1)+0.1;
F_CR_old=repmat(F_CR,I_NP,1);
F_CR=F_CR_old;
nn=0;


stind1=1;
stind2=1;
for ii=1:2.5:33
    for jj=200:200:17800
        aa(stind1,stind2)=1+ii;
        stind2=2;
        aa(stind1,stind2)=2000+jj;
        stind2=1;
        stind1=stind1+1;
    end
end


for pp=1:1157
    [inval,inpen]=feval(aa(pp,:),funcion);
    if(inval<bestfit)
    bestpen=inpen;
    bestfit=inval;
    bestpos=aa(pp,:);
    end
    num=posfindnum(aa(pp,:));
    if inval<regionbest(num)
        regionbest(num)=inval;
        regionpen(num)=inpen;
        regionbestpos(num,:)=aa(pp,:);
    end
end

FM_pop=bestpos;
gen=1;
count=0;    %count=i表示迭代i次后仍没有更优秀个体的产生
while gen<1500
    %生成初始的协作向量
    other.a=(I_itermax-gen)/I_itermax;
    other.lowerlimit=FVr_minbound; %lower limit of the problem
    other.upperlimit = FVr_maxbound; %upper limit of the problem
    
    colxy(1,:)=getcol1(regionbestpos,regionbest);
    colxy(2,:)=getcol2(regionbestpos,regionbest);
    colxy(3,:)=getcol3(regionbestpos,regionbest);
    colxy(4,:)=getcol4(regionbestpos,regionbest);
    %更新变异系数等
    %进行更新
    [FM_ui,~]=generate_trial(FM_pop, colxy);
    FM_ui=update(FM_ui,FVr_minbound,FVr_maxbound);
    %进行评估
    [S_val_temp,pen]=feval(FM_ui,funcion);
    %% Elitist Selection
    if(S_val_temp<bestfit)
    count=0;
    bestpen=pen;
    bestfit=S_val_temp;
    bestpos=FM_ui;
    FM_pop=FM_ui;
    else
        count=count+1;
    end
    num=posfindnum(FM_ui);
    if S_val_temp<regionbest(num)
        regionbest(num)=S_val_temp;
        regionpen(num)=pen;
        regionbestpos(num,:)=FM_ui;
    end

    fprintf('Fitness value: %f\n', bestfit)
    fprintf('Generation: %d\n',gen)
    gen=gen+1;
end
evaend=false;
nownum=2657;
 randomNumber = rand;
 startang=2*pi*randomNumber;
while true
    if evaend==true
        break;
    end
    [FM_ui,~,fpen,fbestval,evaend,thisnum,anglenum]=generate_trial1(FM_pop,bestfit,bestpen,nownum,startang,funcion);
    bestpen=fpen;
    startang=anglenum;
    FM_pop=FM_ui;
    bestfit=fbestval;
    nownum=nownum+thisnum;
end
bestpos=FM_ui;
Fit_and_p=[bestfit bestpen];
FVr_bestmemit=bestfit;
fitMaxVector=bestpos;
end


function pop=genpop(a,b,lowMatrix,upMatrix)
pop=unifrnd(lowMatrix,upMatrix,a,b);
end
function[num]= posfindnum(a)
    x=a(1);
    y=a(2);
    xnum=floor((x-1)/2);
    ynum=floor((y-2000)/100);
    if xnum==17
        xnum=16;
    end
    num=xnum*180+ynum;
    if num==0
        num=1;
    end
end
function [FM_ui,msg]=generate_trial(FM_pop, colxy)
   cho=randi([1, 7]);
   switch cho
       case 1
           randco1=0.3 + 1.2 * rand;
           randco2=0.3 + 1.2 * rand;
           colxy(1,:)=colxy(1,:)*randco1;
           colxy(2,:)=colxy(2,:)*randco2;
           coe1=1 + 0.5 * rand;
           coe2=1 + 0.5 * rand;
           disvex=colxy(1,:)*coe1+colxy(3,:)*coe2;
           chu=randi([50, 200]);
           disvex=disvex/chu;
           jdg=rand;
           if jdg<0.5
                FM_ui=FM_pop+disvex;
           else
                FM_ui=FM_pop-disvex;
           end
       
       case 2
           randco1=0.3 + 1.2 * rand;
           randco2=0.3 + 1.2 * rand;
           colxy(1,:)=colxy(1,:)*randco1;
           colxy(2,:)=colxy(2,:)*randco2;
           coe1=1 + 0.5 * rand;
           coe2=1 + 0.5 * rand;
           disvex=colxy(1,:)*coe1+colxy(2,:)*coe2;
            chu=randi([50, 200]);
           disvex=disvex/chu;
           jdg=rand;
           if jdg<0.5
                FM_ui=FM_pop+disvex;
           else
                FM_ui=FM_pop-disvex;
           end
        
       case 3
           randco1=0.3 + 1.2 * rand;
           randco2=0.3 + 1.2 * rand;
           colxy(1,:)=colxy(1,:)*randco1;
           colxy(2,:)=colxy(2,:)*randco2;
           coe1=1 + 0.5 * rand;
           coe2=1 + 0.5 * rand;
           disvex=colxy(3,:)*coe1+colxy(2,:)*coe2;
           chu=randi([50, 200]);
           disvex=disvex/chu;
           jdg=rand;
           if jdg<0.5
                FM_ui=FM_pop+disvex;
           else
                FM_ui=FM_pop-disvex;
           end

        case 4
           randco1=0.3 + 1.2 * rand;
           randco2=0.3 + 1.2 * rand;
           colxy(1,:)=colxy(1,:)*randco1;
           colxy(2,:)=colxy(2,:)*randco2;
           coe1=1 + 0.5 * rand;
           coe2=1 + 0.5 * rand;
           disvex=colxy(4,:)*coe1+colxy(2,:)*coe2;
           chu=randi([50, 200]);
           disvex=disvex/chu;
           jdg=rand;
           if jdg<0.5
                FM_ui=FM_pop+disvex;
           else
                FM_ui=FM_pop-disvex;
           end
        
       case 5
           randco1=0.3 + 1.2 * rand;
           randco2=0.3 + 1.2 * rand;
           colxy(1,:)=colxy(1,:)*randco1;
           colxy(2,:)=colxy(2,:)*randco2;
           coe1=1 + 0.5 * rand;
           coe2=1 + 0.5 * rand;
           disvex=colxy(3,:)*coe1+colxy(4,:)*coe2;
           chu=randi([50, 200]);
           disvex=disvex/chu;
           jdg=rand;
           if jdg<0.5
                FM_ui=FM_pop+disvex;
           else
                FM_ui=FM_pop-disvex;
           end

        case 6
           randco1=0.3 + 1.2 * rand;
           randco2=0.3 + 1.2 * rand;
           colxy(1,:)=colxy(1,:)*randco1;
           colxy(2,:)=colxy(2,:)*randco2;
           coe1=1 + 0.5 * rand;
           coe2=1 + 0.5 * rand;
           disvex=colxy(2,:)*coe1-colxy(3,:)*coe2;
          chu=randi([50, 200]);
           disvex=disvex/chu;
           jdg=rand;
           if jdg<0.5
                FM_ui=FM_pop+disvex;
           else
                FM_ui=FM_pop-disvex;
           end
        case 7
           randco1=0.3 + 1.2 * rand;
           randco2=0.3 + 1.2 * rand;
           colxy(1,:)=colxy(1,:)*randco1;
           colxy(2,:)=colxy(2,:)*randco2;
           coe1=1 + 0.5 * rand;
           coe2=1 + 0.5 * rand;
           disvex=colxy(1,:)*coe1-coe2*colxy(4,:);
            chu=randi([50, 200]);
           disvex=disvex/chu;
           jdg=rand;
           if jdg<0.5
                FM_ui=FM_pop+disvex;
           else
                FM_ui=FM_pop-disvex;
           end    
   end
   msg=' QDDE/current-to-best/1';   
end

function [p]=update(p,lowMatrix,upMatrix)
        [idx] = find(p<lowMatrix);
        p(idx)=lowMatrix(idx);
        [idx] = find(p>upMatrix);
        p(idx)=upMatrix(idx);

end

function [p]=getcol1(regionbestpos,regionbest)
        while true
            gnxl(1,1)=1+ rand * 17;
            gnxl(1,2)=2000+ rand * 9000;
            num1=posfindnum(gnxl);
            if regionbest(num1)~=999999999
                p=regionbestpos(num1,:);
                break;
            end
             if regionbest(num1)>1
                p=regionbestpos(num1,:);
                break;
            end
        end
end

function [p]=getcol2(regionbestpos,regionbest)
       while true
            gnxl(1,1)=18+ rand * 17;
            gnxl(1,2)=2000+ rand * 9000;
            num1=posfindnum(gnxl);
            if regionbest(num1)~=999999999
                p=regionbestpos(num1,:);
                break;
            end
       end
end

function [p]=getcol3(regionbestpos,regionbest)
        while true
            gnxl(1,1)=1+ rand * 17;
            gnxl(1,2)=11000+ rand * 9000;
            num1=posfindnum(gnxl);
            if regionbest(num1)~=999999999
                p=regionbestpos(num1,:);
                break;
            end
            if regionbest(num1)>1
                p=regionbestpos(num1,:);
                break;
            end
        end
end

function [p]=getcol4(regionbestpos,regionbest)
            while true
            gnxl(1,1)=18+ rand * 17;
            gnxl(1,2)=11000+ rand * 9000;
            num1=posfindnum(gnxl);
            if regionbest(num1)~=999999999
                p=regionbestpos(num1,:);
                break;
            end  
             if regionbest(num1)>1
                p=regionbestpos(num1,:);
                break;
            end            
            
            end
end

function [FM_ui,msg,fpen,fbestval,evaend,thisnum,anglenum]=generate_trial1(FM_pop,bestfit,bestpen,nownum,startang,funcion)

    FM_ui=FM_pop;
    fpen=bestpen;
    fbestval=bestfit;
    thisnum=0;
    evaend=false;
   
    initangle=startang+ rand() * 0.1;
    for ir=0:364
    unit=2*pi/360;
    ttx=floor(ir/2);
    if mod(ir, 2) == 0
        angle=initangle+unit*ttx;
    else
        angle=initangle-unit*ttx;
    end
    disx=cos(angle);
    disy=sin(angle);
    if (thisnum+nownum)<3500
        FM_try(1,1)=FM_pop(1,1)+disx*0.1;
        FM_try(1,2)=FM_pop(1,2)+disy*0.2;
    else
        jjlen= rand() * 0.6;
        FM_try(1,1)=FM_pop(1,1)+disx*jjlen;
        FM_try(1,2)=FM_pop(1,2)+disy*jjlen;
    end
    [tryval,pen]=feval(FM_try,funcion);    
    thisnum=thisnum+1;
    if (thisnum+nownum)>5000
        evaend=true;
        break;
    end
    if tryval<bestfit
        fpen=pen;
        FM_ui=FM_try;
        fbestval=tryval;
        break;
    end
    fprintf('Fitness value: %f\n', fbestval)
    fprintf('Generation: %d\n',(thisnum+nownum))
    end
    anglenum=angle;
     msg=' QDDE/current-to-best/1';  
end


function [inval, inpen] = feval( FM_pop, funcion)
    % Evaluar la función en la población
    inval = funcion.evaluate(FM_pop);
    

    

        inpen = (inval - 2.5);

end
