classdef Griewank
    properties
        a = 1; % Parámetro de escala
        b = 4000; % Parámetro de escala
    end
    
    methods
        function obj = Griewank(a, b)
            % Constructor que permite establecer los valores de a y b
            if nargin > 0
                obj.a = a;
            end
            if nargin > 1
                obj.b = b;
            end
        end
        
        function f = evaluate(obj, x)
            % Método para evaluar la función de Griewank
            % x debe ser un vector de tamaño n
            n = length(x);
            if n < 1
                error('El vector de entrada debe tener al menos 1 elemento.');
            end
            
            % Evaluación de la función de Griewank
            sum_term = sum(x.^2) / obj.b;
            prod_term = prod(cos(x / sqrt(1:n)));
            f = sum_term - prod_term + obj.a;
        end
        
        function grad = gradient(obj, x)
            % Método para calcular el gradiente de la función de Griewank
            % x debe ser un vector de tamaño n
            n = length(x);
            if n < 1
                error('El vector de entrada debe tener al menos 1 elemento.');
            end
            
            grad = zeros(size(x));
            for i = 1:n
                grad(i) = (x(i) / obj.b) - (sin(x(i) / sqrt(i)) / (2 * sqrt(i)));
            end
        end
        
        function visualize(obj, xmin, xmax, ymin, ymax, resolution)
            % Método para visualizar la función de Griewank
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
            title('Función de Griewank');
            colorbar;
            view(30, 30); % Cambiar el ángulo de vista
        end
    end
end
