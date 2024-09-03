classdef Trigonometric
    properties
        amplitude = 1;  % Amplitud de la función
        frequency = 1;  % Frecuencia de la función
    end
    
    methods
        function obj = Trigonometric(amplitude, frequency)
            % Constructor que permite establecer los valores de amplitud y frecuencia
            if nargin > 0
                obj.amplitude = amplitude;
            end
            if nargin > 1
                obj.frequency = frequency;
            end
        end
        
        function f = evaluate(obj, x)
            % Método para evaluar la función trigonométrica
            % x debe ser un vector de tamaño n
            n = length(x);
            if n < 1
                error('El vector de entrada debe tener al menos 1 elemento.');
            end
            
            % Evaluación de la función trigonométrica
            f = sum(obj.amplitude * sin(obj.frequency * x));
        end
        
        function grad = gradient(obj, x)
            % Método para calcular el gradiente de la función trigonométrica
            % x debe ser un vector de tamaño n
            n = length(x);
            if n < 1
                error('El vector de entrada debe tener al menos 1 elemento.');
            end
            
            grad = zeros(size(x));
            for i = 1:n
                grad(i) = obj.amplitude * obj.frequency * cos(obj.frequency * x(i)); % Derivada de la función
            end
        end
        
        function visualize(obj, xmin, xmax, resolution)
            % Método para visualizar la función trigonométrica
            % xmin, xmax: rango de los ejes x
            % resolution: número de puntos en el eje x
            
            % Crear malla de puntos
            x = linspace(xmin, xmax, resolution);
            y = obj.evaluate(x);
            
            % Graficar la función
            figure;
            plot(x, y);
            xlabel('x');
            ylabel('f(x)');
            title('Función Trigonométrica');
            grid on;
        end
    end
end
