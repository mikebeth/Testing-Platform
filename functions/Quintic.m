classdef Quintic
    properties
        a = 1; % Coeficiente para el término cúbico
        b = -5; % Coeficiente para el término cuadrático
        c = 4; % Coeficiente para el término lineal
    end
    
    methods
        function obj = Quintic(a, b, c)
            % Constructor que permite establecer los valores de a, b y c
            if nargin > 0
                obj.a = a;
            end
            if nargin > 1
                obj.b = b;
            end
            if nargin > 2
                obj.c = c;
            end
        end
        
        function f = evaluate(obj, x)
            % Método para evaluar la función quintic
            % x debe ser un vector de tamaño n
            n = length(x);
            if n < 1
                error('El vector de entrada debe tener al menos 1 elemento.');
            end
            
            % Evaluación de la función quintic
            f = obj.a * sum(x.^5) + obj.b * sum(x.^3) + obj.c * sum(x);
        end
        
        function grad = gradient(obj, x)
            % Método para calcular el gradiente de la función quintic
            % x debe ser un vector de tamaño n
            n = length(x);
            if n < 1
                error('El vector de entrada debe tener al menos 1 elemento.');
            end
            
            grad = zeros(size(x));
            grad = 5 * obj.a * x.^4 + 3 * obj.b * x.^2 + obj.c; % Derivada de la función quintic
        end
        
        function visualize(obj, xmin, xmax, ymin, ymax, resolution)
            % Método para visualizar la función quintic
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
            title('Función Quintic');
            colorbar;
            view(30, 30); % Cambiar el ángulo de vista
        end
    end
end
