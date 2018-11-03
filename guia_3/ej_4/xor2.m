close all;
clear;

% Caracteristicas De La Red.
n_entradas = 2;
neuronas_capa_1 = 2;
neuronas_capa_2 = 1;
beta = 1;

% Parametros Simulated Annealing.
T_paso = 0.0005;
T_inicial = 10;
k = 0.01;
perturbacion_W = 0.1;
perturbacion_w = 0.1;

% Tablas A Aprender.
x = [   -1, -1;
        -1,  1;
         1, -1;
         1,  1;
    ];

x = [x, ones(2^n_entradas, 1)];

yd = [  -1;
         1;
         1;
        -1;
     ];

% Matrices Iniciales.
W = randn(neuronas_capa_1, n_entradas + 1);
w = randn(neuronas_capa_2, neuronas_capa_1 + 1);

ECMS = [];
 
T = T_inicial;
while(T > 0)
    % Propago.
    ECM = 0;
    y = zeros(2^n_entradas, 1);
    for i = 1:2^n_entradas
        h_entrada = W * x(i, :)';
        v = tanh(beta * h_entrada);
        h_salida = w * [v; 1];
        y(i) = tanh(beta * h_salida);
        ECM = ECM + (y(i) - yd(i))^2;
    end
    ECM = ECM / 2;
    
    % Perturbacion.
    % En W.
    W_nueva = W;
    [filas, columnas] = size(W);
    fila = floor(rand() * filas) + 1;
    columna = floor(rand() * columnas) + 1;
    W_nueva(fila, columna) = W_nueva(fila, columna) + randn() * perturbacion_W;
    % En w.
    w_nueva = w;
    [filas, columnas] = size(w);
    fila = floor(rand() * filas) + 1;
    columna = floor(rand() * columnas) + 1;
    w_nueva(fila, columna) = w_nueva(fila, columna) + randn() * perturbacion_w;
    
    % Propago.
    ECM_nuevo = 0;
    y = zeros(2^n_entradas, 1);
    for i = 1:2^n_entradas
        h_entrada = W_nueva * x(i, :)';
        v = tanh(beta * h_entrada);
        h_salida = w_nueva * [v; 1];
        y(i) = tanh(beta * h_salida);
        ECM_nuevo = ECM_nuevo + (y(i) - yd(i))^2;
    end
    ECM_nuevo = ECM_nuevo / 2;
    
    % Veo si acepto cambios.
    if(ECM_nuevo <= ECM)
        W = W_nueva;
        w = w_nueva;
    else
        p = exp(-(ECM_nuevo - ECM) / T / k);
        if(rand < p)
        	W = W_nueva;
            w = w_nueva;
        end
    end
    
    % Bajo temperatura.
    T = T - T_paso;

    ECMS = [ECMS, ECM];
end


     
disp('Error Cuadratico Medio:');
ECM
     
disp('Salidas:');
y = zeros(2^n_entradas, 1);
for i = 1:2^n_entradas
    h_entrada = W * x(i, :)';
    v = tanh(beta * h_entrada);
    h_salida = w * [v; 1];
    y(i) = tanh(beta * h_salida);
end
y
 
figure(1);
hold on;

%Divido los puntos en azules y rojos.
x_azul = [];
x_rojo = [];
for i = 1:2^n_entradas
    if(yd(i) == 1)
        x_azul = [x_azul; x(i,:)];
    else
        x_rojo = [x_rojo; x(i,:)];
    end
end

plot(x_azul(:,1), x_azul(:,2), 'ob');
plot(x_rojo(:,1), x_rojo(:,2), 'or');
axis([-2, 2, -2, 2]);

x1 = -2:0.01:2;
x2 = - W(1,1) / W(1,2) * x1 - W(1,3) / W(1,2);
plot(x2, x1, 'b--');

x2 = - W(2,1) / W(2,2) * x1 - W(2,3) / W(2,2);
plot(x2, x1, 'r--');

legend('Puntos Y = 1', 'Puntos Y = -1', 'Frontera De Desicion 1', ...
    'Frontera De Desicion 2');

figure(2);
plot(ECMS);