function save_results(ResDB)
    % save_results imprime las tablas de resultados a partir de la estructura ResDB
    % Inputs:
    %   ResDB - estructura que contiene los resultados de multiples ejecuciones

    % Verificar que la estructura tenga elementos
    if isempty(ResDB)
        error('La estructura ResDB esta vacia.');
    end
    
        % Definir la ruta de la carpeta "results" en el directorio raíz
    resultsDir = fullfile(pwd, '.', 'results'); % Asumiendo que 'functions' está en un nivel más bajo

    % Crear carpeta "results" si no existe
    if ~exist(resultsDir, 'dir')
        mkdir(resultsDir);
    end

    % Obtener el numero de ejecuciones
    numRuns = length(ResDB);
    
    % Inicializar arreglos para las tablas
    timeSpent = zeros(numRuns, 1);
    fitness = cell(numRuns, 1);
    OF = zeros(numRuns, 1);
    penalties = zeros(numRuns, 1); % Suponiendo que no hay penalizaciones
    avgConvergenceRate = zeros(numRuns, 1);

    % Recorrer cada ejecucion y llenar las tablas
    for i = 1:numRuns
        % Verificar que los campos necesarios existan
        if isfield(ResDB(i), 'tOpt')
            timeSpent(i) = ResDB(i).tOpt; % Tiempo total 
        else
            error('El campo tOpt no existe en la ejecucion %d.', i);
        end
        
        if isfield(ResDB(i), 'fitVector')
            fitness{i} = ResDB(i).fitVector(:)'; % Aplanar el vector de fitness
            avgConvergenceRate(i) = mean(ResDB(i).fitVector(:)); % Promedio de la tasa de convergencia
        else
            error('El campo fitVector no existe en la ejecucion %d.', i);
        end
        
        if isfield(ResDB(i), 'Fit_and_p')
            if isscalar(ResDB(i).Fit_and_p)
                OF(i) = ResDB(i).Fit_and_p; % Valor de la funcion objetivo
            else
                % Calcular el promedio de Fit_and_p
                OF(i) = mean(ResDB(i).Fit_and_p); % Tomar el pormedio                
            end
        else
            error('El campo Fit_and_p no existe en la ejecucion %d.', i);
        end
    end

    % Crear tabla de tiempo
    Table_Time = table(timeSpent, 'VariableNames', {'timeSpent'});
    Table_Time.Properties.RowNames = strcat('Run ', string(1:numRuns));

    % Crear tabla de fitness
    Table_Fitness = table(fitness, 'VariableNames', {'fitness'});
    Table_Fitness.Properties.RowNames = strcat('Run ', string(1:numRuns));


    % Crear tabla de resultados
    Table_Results = table(OF, penalties, avgConvergenceRate, ...
                          'VariableNames', {'OF', 'Penalties', 'avgConvergenceRate'});
    Table_Results.Properties.RowNames = strcat('Run ', string(1:numRuns));


    % Calcular estadisticas de prueba
    PstdOF = std(OF); % Desviacion estandar de la funcion objetivo
    PminOF = min(OF); % Valor minimo de la funcion objetivo
    PmaxOF = max(OF); % Valor maximo de la funcion objetivo
    PvarOF = var(OF); % Varianza de la funcion objetivo
    AvgTime = mean(timeSpent); % Tiempo promedio

    Table_TrialStats = table(mean(OF), PstdOF, PminOF, PmaxOF, PvarOF, AvgTime, ...
                              'VariableNames', {'RankingIndex', 'PstdOF', 'PminOF', 'PmaxOF', 'PvarOF', 'AvgTime'});
    %Table_TrialStats.Properties.RowNames = {'Overall Stats'};

    % Imprimir las tablas
    disp('Table_Time =');
    disp(Table_Time);
    
    disp('Table_Fitness =');
    disp(Table_Fitness);
    
    disp('Table_Results =');
    disp(Table_Results);
    
    disp('Table_TrialStats =');
    disp(Table_TrialStats);
    
     % Guardar las tablas en archivos .txt
    save_table_to_file(Table_Time, fullfile(resultsDir, 'Table_Time'));
    save_table_to_file(Table_Fitness, fullfile(resultsDir, 'Table_Fitness'));
    save_table_to_file(Table_Results, fullfile(resultsDir, 'Table_Results'));
    save_table_to_file(Table_TrialStats, fullfile(resultsDir, 'Table_TrialStats'));
end

function save_table_to_file(T, baseFilename)
    % Función auxiliar para guardar tablas en archivos .txt
    % T: tabla a guardar
    % baseFilename: nombre base del archivo (sin extensión)

    % Encontrar el número de archivo para evitar sobrescritura
    fileIndex = 1;
    filename = sprintf('%s_%d.txt', baseFilename, fileIndex);
    
    while exist(filename, 'file')
        fileIndex = fileIndex + 1;
        filename = sprintf('%s_%d.txt', baseFilename, fileIndex);
    end
    
    % Guardar la tabla en el archivo
    writetable(T, filename, 'Delimiter', '\t', 'WriteRowNames', true);
end

