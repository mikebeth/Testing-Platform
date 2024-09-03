classdef Rastrigin
    properties
        A = 10; % Parámetro A
    end
    
    methods
        function obj = Rastrigin(A)
            % Constructor que permite establecer el valor de A
            if nargin > 0
                obj.A = A;
            end
        end
        
        function f = evaluate(obj, x)
            % Método para evaluar la función de Rastrigin
            % x debe ser un vector de tamaño n
            n = length(x);
            if n < 1
                error('El vector de entrada debe tener al menos 1 elemento.');
            end
            
            f = obj.A * n + sum(x.^2 - obj.A * cos(2 * pi * x));
        end
        
        function grad = gradient(obj, x)
            % Método para calcular el gradiente de la función de Rastrigin
            % x debe ser un vector de tamaño n
            n = length(x);
            if n < 1
                error('El vector de entrada debe tener al menos 1 elemento.');
            end
            
            grad = zeros(size(x));
            for i = 1:n
                grad(i) = 2 * x(i) + 2 * obj.A * pi * sin(2 * pi * x(i));
            end
        end
        
        function visualize(obj, xmin, xmax, ymin, ymax, resolution)
            % Método para visualizar la función de Rastrigin
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
            title('Función de Rastrigin');
            colorbar;
            view(30, 30); % Cambiar el ángulo de vista
        end
    end
end

