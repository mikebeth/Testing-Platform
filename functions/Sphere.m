classdef Sphere
    properties
        % No se requieren parámetros específicos para la función Sphere
    end
    
    methods
        function obj = Sphere()
            % Constructor vacío
        end
        
        function f = evaluate(obj, x)
            % Método para evaluar la función de Sphere
            % x debe ser un vector de tamaño n
            n = length(x);
            if n < 1
                error('El vector de entrada debe tener al menos 1 elemento.');
            end
            
            f = sum(x.^2);
        end
        
        function grad = gradient(obj, x)
            % Método para calcular el gradiente de la función de Sphere
            % x debe ser un vector de tamaño n
            n = length(x);
            if n < 1
                error('El vector de entrada debe tener al menos 1 elemento.');
            end
            
            grad = 2 * x; % El gradiente es simplemente 2*x
        end
        
        function visualize(obj, xmin, xmax, ymin, ymax, resolution)
            % Método para visualizar la función de Sphere
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
            title('Función de Sphere');
            colorbar;
            view(30, 30); % Cambiar el ángulo de vista
        end
    end
end
