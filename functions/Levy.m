classdef Levy
    properties
        % Parámetros de la función Levy
        a = 1; % Parámetro de desplazamiento
        b = 1; % Parámetro de escala
    end
    
    methods
        function obj = Levy(a, b)
            % Constructor que permite establecer los valores de a y b
            if nargin > 0
                obj.a = a;
            end
            if nargin > 1
                obj.b = b;
            end
        end
        
        function f = evaluate(obj, x)
            % Método para evaluar la función de Levy
            % x debe ser un vector de tamaño n
            n = length(x);
            if n < 1
                error('El vector de entrada debe tener al menos 1 elemento.');
            end
            
            % Evaluación de la función de Levy
            term1 = sin(pi * (1 + (x(1) + 1) / 4));
            term2 = (x(1) + 1) / 4;
            sum_term = 0;
            for i = 2:n
                sum_term = sum_term + ((x(i) - 1)^2) * (1 + 10 * sin(pi * (x(i) + 1))^2);
            end
            
            f = (term1^2) + (term2^2) + sum_term;
        end
        
        function grad = gradient(obj, x)
            % Método para calcular el gradiente de la función de Levy
            % x debe ser un vector de tamaño n
            n = length(x);
            if n < 1
                error('El vector de entrada debe tener al menos 1 elemento.');
            end
            
            grad = zeros(size(x));
            % Cálculo del gradiente (simplificado para la función de Levy)
            grad(1) = 2 * (x(1) + 1) * (sin(pi * (1 + (x(1) + 1) / 4)) + (pi / 4) * cos(pi * (1 + (x(1) + 1) / 4)));
            for i = 2:n
                grad(i) = 2 * (x(i) - 1) * (1 + 10 * sin(pi * (x(i) + 1))^2);
            end
        end
        
        function visualize(obj, xmin, xmax, ymin, ymax, resolution)
            % Método para visualizar la función de Levy
            % xmin, xmax, ymin, ymax: rango de los ejes x e y
            % resolution: número de puntos en cada eje
            
            % Crear malla de puntos
            [X, Y] = meshgrid(linspace(xmin, xmax, resolution), ...
                             linspace(ymin, ymax, resolution));
            
            % Evaluar la función en la malla
            Z = zeros(size(X));
            for i = 1:size(X, 1)
                for j = 1:size(X, 2)
                    Z(i, j) = obj.evaluate([X(i, j), Y(i, j)]);
                end
            end
            
            % Graficar la superficie
            figure;
            surf(X, Y, Z);
            xlabel('x');
            ylabel('y');
            zlabel('f(x, y)');
            title('Función de Levy');
            colorbar;
            view(30, 30); % Cambiar el ángulo de vista
        end
    end
end
