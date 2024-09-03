clc; clear all; close all;
tTotalTime = tic; % 

% Seleccion del algoritmo y la funcion
Select_algorithm = 1;
Select_function  = 3;

% Cargar la funcion
switch Select_function
    case 1
        addpath('functions');  
        loadRosenParameters; % Cargar los parametros
        funcion = Rosenbrock(rosenParameters.a, rosenParameters.b);
              
    case 2
        addpath('functions');  
        loadGriewankParameters; % Cargar los parametros
        funcion = Griewank(griewankParameters.a, griewankParameters.b);
        
        
    case 3
        addpath('functions');  
        loadTrigonometricParameters; % Cargar los parametros
        funcion = Trigonometric(trigonometricParameters.amplitude, trigonometricParameters.frequency);
        
    otherwise
        fprintf(1, 'No funcion selected\n');
end

% Seleccion del algoritmo
switch Select_algorithm
    case 1
        addpath('VIEDA');
        algorithm = 'VIEDA';
        VIEDAparameters; 
        No_solutions = VIEDAParameters.I_NP; 
    otherwise
        fprintf(1, 'No algorithm selected\n');
end

noRuns = 10; 
ResDB = struct([]); 

for iRuns = 1:noRuns
    tOpt = tic;
    rand('state', sum(noRuns * 100 * clock)); 
    
    switch Select_algorithm
        case 1
            % Ejecutar el algoritmo y almacenar los resultados
            [ResDB(iRuns).Fit_and_p, ...
             ResDB(iRuns).sol, ...
             ResDB(iRuns).fitVector] = ...                    
             VIEDA(VIEDAParameters, funcion); 
    end 
    
    ResDB(iRuns).tOpt = toc(tOpt); % Tiempo de cada prueba
end

tTotalTime = toc(tTotalTime); % Tiempo total
save_results(ResDB); 

