classdef Ackley
    properties
        a = 20; % Parámetro a
        b = 0.2; % Parámetro b
        c = 2 * pi; % Parámetro c
    end
    
    methods
        function obj = Ackley(a, b, c)
            % Constructor que permite establecer los valores de a, b y c
            if nargin > 0
                obj.a = a;
                obj.b = b;
                obj.c = c;
            end
        end
        
        function f = evaluate(obj, x)
            % Método para evaluar la función de Ackley
            % x debe ser un vector de tamaño 2
            if length(x) ~= 2
                error('El vector de entrada debe tener exactamente 2 elementos.');
            end
            
            sum1 = x(1)^2 + x(2)^2;
            sum2 = cos(obj.c * x(1)) + cos(obj.c * x(2));
            f = -obj.a * exp(-obj.b * sqrt(sum1 / 2)) - exp(sum2 / 2) + obj.a + exp(1);
        end
        
        function grad = gradient(obj, x)
            % Método para calcular el gradiente de la función de Ackley
            % x debe ser un vector de tamaño 2
            if length(x) ~= 2
                error('El vector de entrada debe tener exactamente 2 elementos.');
            end
            
            sum1 = x(1)^2 + x(2)^2;
            exp1 = exp(-obj.b * sqrt(sum1 / 2));
            exp2 = exp(0.5 * (cos(obj.c * x(1)) + cos(obj.c * x(2))));
            
            df_dx1 = obj.b * x(1) * exp1 / sqrt(sum1 / 2) + (obj.c * sin(obj.c * x(1)) * exp2) / 2;
            df_dx2 = obj.b * x(2) * exp1 / sqrt(sum1 / 2) + (obj.c * sin(obj.c * x(2)) * exp2) / 2;
            grad = [df_dx1; df_dx2];
        end
        
        function visualize(obj, xmin, xmax, ymin, ymax, resolution)
            % Método para visualizar la función de Ackley
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
            title('Función de Ackley');
            colorbar;
            view(30, 30); % Cambiar el ángulo de vista
        end
    end
end