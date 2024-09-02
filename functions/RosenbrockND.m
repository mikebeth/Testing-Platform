classdef RosenbrockND
    properties
        n; % Dimensión
    end
    
    methods
        function obj = RosenbrockND(n)
            % Constructor que establece la dimensión de la función
            obj.n = n;
        end
        
        function f = evaluate(obj, x)
            % Método para evaluar la función de Rosenbrock en n dimensiones
            % x debe ser un vector de tamaño n
            if length(x) ~= obj.n
                error('El vector de entrada debe tener exactamente %d elementos.', obj.n);
            end
            
            f = 0;
            for i = 1:obj.n-1
                f = f + 100 * (x(i+1) - x(i)^2)^2 + (1 - x(i))^2;
            end
        end
        
        function grad = gradient(obj, x)
            % Método para calcular el gradiente de la función de Rosenbrock en n dimensiones
            % x debe ser un vector de tamaño n
            if length(x) ~= obj.n
                error('El vector de entrada debe tener exactamente %d elementos.', obj.n);
            end
            
            grad = zeros(obj.n, 1);
            for i = 1:obj.n
                if i > 1
                    grad(i-1) = grad(i-1) + 200 * (x(i) - x(i-1)^2) * (-2 * x(i-1)) + 2 * (x(i-1) - 1);
                end
                if i < obj.n
                    grad(i) = grad(i) + 200 * (x(i) - x(i-1)^2);
                end
            end
        end
        
        function visualize(obj, xmin, xmax, resolution)
            % Método para visualizar la función de Rosenbrock en 2 dimensiones
            % xmin, xmax: rango de los ejes
            % resolution: número de puntos en cada eje
            
            if obj.n ~= 2
                error('La visualización solo está disponible para 2 dimensiones.');
            end
            
            [X, Y] = meshgrid(linspace(xmin, xmax, resolution), ...
                             linspace(xmin, xmax, resolution));
            Z = zeros(size(X));
            for i = 1:size(X, 1)
                for j = 1:size(X, 2)
                    Z(i, j) = obj.evaluate([X(i, j), Y(i, j)]);
                end
            end
            
            figure;
            surf(X, Y, Z);
            xlabel('x_1');
            ylabel('x_2');
            zlabel('f(x_1, x_2)');
            title('Función de Rosenbrock en 2D');
            colorbar;
            view(30, 30); % Cambiar el ángulo de vista
        end
    end
end