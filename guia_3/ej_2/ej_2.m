close all;
clear;

% Numero de ciudades.
CIUDADES = 200;

% Numero de neuronas.
N = CIUDADES * 2 + 1;

% Parametros de aprendizaje.
eta = 0.8;                                  %Constante de aprendizaje.
ITERACIONES = 100000;                       %Maximo de iteraciones.
s = linspace(CIUDADES, 0.1, ITERACIONES);	%Variacion lineal.

% Pesos iniciales en forma de anillo.
indices = 2 : N; 
phi = 2 * pi * linspace(0, 1, N);
wx = cos(phi) + 0.5;
wy = sin(phi) + 0.5;

% Genero ciudades.
x = rand(1, CIUDADES);
y = rand(1, CIUDADES);

% Situacion Inicial
figure(1);
hold on;
plot(wx, wy, 'k')
plot(x, y, 'or')
axis([-1.0 2.0 -1.0 2.0])
title('Situacion Inicial');

% Ciudad inicial.
wx(1) = x(1);
wy(1) = y(1);

% Procesamiento
for i = 1 : ITERACIONES
    % Elijo ciudad al azar.
    indice_ciudad = randi(CIUDADES);
    
    % Cierro el anillo. (Obsoleto, se implemento una distancia circular).
    %wx(N + 1) = wx(1);
    %wy(N + 1) = wy(1);
    
    % Veo neurona ganadora.
    d = sqrt((wx - x(indice_ciudad)) .^ 2 + (wy - y(indice_ciudad)) .^ 2);
    indices_ganadores = find(d == min(d));
    indice_ganadora = indices_ganadores(1);
    
    % Calculo la distancia circular.
    distancias = zeros(size(indices));
    for m = 1 : length(indices)
        indice = indices(m);
        if(indice_ganadora > indice)
            distancia_derecha = indice + length(indices) - indice_ganadora;
            distancia_izquierda = indice_ganadora - indice;
            distancias(m) = min([distancia_derecha, distancia_izquierda]);
        elseif(indice_ganadora < indice)
            distancia_derecha = indice_ganadora + length(indices) - indice;
            distancia_izquierda = indice - indice_ganadora;
            distancias(m) = min([distancia_derecha, distancia_izquierda]);
        else
            distancias(m) = 0;
        end
    end
    
    %Vecindad.
    % Sin distancia circular. (Obsoleto).
    % vecindad = exp(-(abs(indices - indice_ganadora) .^ 2) / (2 * (s(i)^2)));
    % Con distancia circular.
    vecindad = exp(-(distancias .^ 2) / (2 * (s(i)^2)));
    
    % Actualizacion de pesos sinapticos.
	wx(2 : N) = wx(2 : N) + eta * vecindad .* (x(indice_ciudad) - wx(2 : N));
	wy(2 : N) = wy(2 : N) + eta * vecindad .* (y(indice_ciudad) - wy(2 : N));

end

% Situacion Final
figure(2);
hold on;
plot(wx, wy, 'k')
plot(x, y, 'or')
axis([-0.1 1.1 -0.1 1.1])
title('Situacion Final');