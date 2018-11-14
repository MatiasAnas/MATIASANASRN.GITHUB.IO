close all;
clear;

% Cantidad De Neuronas.
Nx = 20;
Ny = 20;

% Cantidad De Muestras.
MUESTRAS = 20000;
% Cantidad De Iteraciones Con El Mismo Sigma.
ITERACIONES_POR_SIGMA = 200;

% Cantidad De Iteraciones
MAX_ITERACIONES = MUESTRAS / ITERACIONES_POR_SIGMA;

% Genero Las Muestras
radios = sqrt(rand(MUESTRAS, 1));
angulos = 2 * pi * rand(MUESTRAS,1);
x = radios .* cos(angulos);
y = radios .* sin(angulos);

% Caracteristicas De La Red
k = 0.1;                    % Constante De Aprendizaje
sigma_inicial = 20;			% Ancho De La Vecindad
sigma_final = 0.1;

% Los distribuyo logaritmicamente.
s = logspace(log10(sigma_final), log10(sigma_inicial), MAX_ITERACIONES + 1);	
s = fliplr(s);

% Pesos Sinapticos.
wx = 2 * rand(Nx, Ny) - 1;
wy = 2 * rand(Nx, Ny) - 1;

% Grafico Situacion Inicial
figure(1)
hold on;
plot(x, y,'xy')
plot(wx,  wy, 'r', 'LineWidth', 1)
plot(wx', wy','r', 'LineWidth', 1)
plot(wx,  wy, 'ob');
axis([-1.1 1.1 -1.1 1.1])
title('Situacion Inicial');

% Entreno.
for m = 1:MUESTRAS
    % Sigma Actual.
    sigma = s(ceil(m / ITERACIONES_POR_SIGMA + 0.01));
    
    % Hallo Ganadora.
    dist_x = abs(x(m) - wx);
    dist_y = abs(y(m) - wy);
    d = sqrt((dist_x .^ 2) + (dist_y .^ 2));
    [x_ganadora, y_ganadora] = find(d==min(min(d)));
    indice_ganadora = [x_ganadora(1) y_ganadora(1)];    % Me quedo con el primer minimo en caso de que haya mas de uno.

    dwx = zeros(size(wx));
    dwy = zeros(size(wy));
       
    for i = 1 : Nx
        for j = 1 : Ny
            dif_x = i - indice_ganadora(1);
            dif_y = j - indice_ganadora(2);
            dist = sqrt(dif_x^2 + dif_y^2);
            vecindad = exp(-1.*((dist).^2)./(2*(sigma^2)));
            dwx(i, j) = k*vecindad.*(x(m)-wx(i,j));
            dwy(i, j) = k*vecindad.*(y(m)-wy(i,j));
        end
    end
    wx = wx + dwx;
    wy = wy + dwy;
end

% Grafico Situacion Final.
figure(2)
hold on;
plot(x, y,'xy')
plot(wx,  wy, 'r', 'LineWidth', 2)
plot(wx', wy','r', 'LineWidth', 2)
plot(wx,  wy, 'ob');
axis([-1.1 1.1 -1.1 1.1])
title('Situacion Final');