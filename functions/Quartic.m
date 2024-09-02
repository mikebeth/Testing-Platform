classdef Quartic
    methods
        function f = evaluate(~, x)
            % Método para evaluar la función Quartic
            % x debe ser un vector de tamaño 2
            if length(x) ~= 2
                error('El vector de entrada debe tener exactamente 2 elementos.');
            end
            
            f = x(1)^4 + x(2)^4 - 3 * (x(1)^2 + x(2)^2) + 0.1 * (x(1) + x(2))^2;
        end
        
        function grad = gradient(~, x)
            % Método para calcular el gradiente de la función Quartic
            % x debe ser un vector de tamaño 2
            if length(x) ~= 2
                error('El vector de entrada debe tener exactamente 2 elementos.');
            end
            
            df_dx1 = 4 * x(1)^3 - 6 * x(1) + 0.2 * (x(1) + x(2));
            df_dx2 = 4 * x(2)^3 - 6 * x(2) + 0.2 * (x(1) + x(2));
            grad = [df_dx1; df_dx2];
        end
        
        function visualize(~, xmin, xmax, ymin, ymax, resolution)
            % Método para visualizar la función Quartic
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
            title('Función Quartic');
            colorbar;
            view(30, 30); % Cambiar el ángulo de vista
        end
    end
end