classdef Alpine
    methods
        function obj = Alpine()
            % Constructor vacío
        end
        
        function f = evaluate(~, x)
            % Método para evaluar la función de Alpine
            % x debe ser un vector de tamaño n
            n = length(x);
            if n < 1
                error('El vector de entrada debe tener al menos 1 elemento.');
            end
            
            % Evaluación de la función de Alpine
            f = sum(abs(x .* sin(x) + 0.1 * x));
        end
        
        function grad = gradient(~, x)
            % Método para calcular el gradiente de la función de Alpine
            % x debe ser un vector de tamaño n
            n = length(x);
            if n < 1
                error('El vector de entrada debe tener al menos 1 elemento.');
            end
            
            grad = zeros(size(x));
            for i = 1:n
                grad(i) = sin(x(i)) + (0.1 * cos(x(i)) * x(i)) + (0.1 * sin(x(i)));
            end
        end
        
        function visualize(~, xmin, xmax, ymin, ymax, resolution)
            % Método para visualizar la función de Alpine
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
            title('Función de Alpine');
            colorbar;
            view(30, 30); % Cambiar el ángulo de vista
        end
    end
end
