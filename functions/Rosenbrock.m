

classdef Rosenbrock
    properties
        a = 1; % Parámetro a
        b = 100; % Parámetro b
    end
    
    methods
        function obj = Rosenbrock(a, b)
            % Constructor que permite establecer los valores de a y b
            if nargin > 0
                obj.a = a;
                obj.b = b;
            end
        end
        
        function f = evaluate(obj, x)
            % Método para evaluar la función de Rosenbrock
            % x debe ser un vector de tamaño 2
            if length(x) ~= 2
                error('El vector de entrada debe tener exactamente 2 elementos.');
            end
            
            f = (obj.a - x(1))^2 + obj.b * (x(2) - x(1)^2)^2;
        end
        
        function grad = gradient(obj, x)
            % Método para calcular el gradiente de la función de Rosenbrock
            % x debe ser un vector de tamaño 2
            if length(x) ~= 2
                error('El vector de entrada debe tener exactamente 2 elementos.');
            end
            
            df_dx1 = -2 * (obj.a - x(1)) - 4 * obj.b * x(1) * (x(2) - x(1)^2);
            df_dx2 = 2 * obj.b * (x(2) - x(1)^2);
            grad = [df_dx1; df_dx2];
        end
        
        function visualize(obj, xmin, xmax, ymin, ymax, resolution)
            % Método para visualizar la función de Rosenbrock
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
            title('Función de Rosenbrock');
            colorbar;
            view(30, 30); % Cambiar el ángulo de vista
        end
    end
end

