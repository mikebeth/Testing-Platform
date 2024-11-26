% Author: Jakub Kudela
% Description:	Initial parameters used in the DE
% 

%Settings used 
           
deParameters.NP=10;
deParameters.maxfcalls = 5000;
deParameters.F = 0.8;


deParameters.low_habitat_limit = [1,2000];
deParameters.up_habitat_limit  = [35,20000];
deParameters.fnc = 'fitnessFun_PValloc';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%