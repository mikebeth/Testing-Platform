qddeParameters.I_NP=1;
qddeParameters.I_itermax= floor(5000/qddeParameters.I_NP);%
qddeParameters.F_weight=0.3;
qddeParameters.F_CR=0.5;


qddeParameters.low_habitat_limit = [1,2000];
qddeParameters.up_habitat_limit  = [35,20000];
qddeParameters.fnc = 'fitnessFun_PValloc';