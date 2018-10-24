close all;
clear;

n_entradas = 3;
neuronas_capa_1 = 15;
neuronas_capa_2 = 1;
MAX_ERROR = 1;
MAX_ITERACIONES = 40000;

eta = 0.02;
beta = 1;

PASO_X = 10;
PASO_Y = 10;
PASO_Z = 10;

x = [];
for x_var = linspace(0, 2 * pi, PASO_X)
    for y_var = linspace(0, 2 * pi, PASO_Y)
        for z_var = linspace(-1, 1, PASO_Z)
            x = [x; x_var, y_var, z_var];
        end
    end
end

[largo_de_tabla_de_entrada, b] = size(x);

x = [x, ones(largo_de_tabla_de_entrada, 1)];

yd = [];
for i = 1:largo_de_tabla_de_entrada
    f = (sin(x(i, 1)) + cos(x(i, 2)) + x(i, 3)) / 3;
    yd = [yd; f];
end

% Si se quedo en un minimo local no satisfactorio, vuelve a empezar.
iteracion = MAX_ITERACIONES;
while(iteracion == MAX_ITERACIONES)
    iteracion = 0;
    
    W = randn(neuronas_capa_1, n_entradas + 1);
    w = randn(neuronas_capa_2, neuronas_capa_1 + 1);

    ECMS = [];
    
    aprendio = 0;
    while((aprendio == 0) && (iteracion < MAX_ITERACIONES))
        %Actualizo matriz de pesos sinapticos.
        secuencia = randperm(largo_de_tabla_de_entrada);
        for i = secuencia
            h_entrada = W * x(i, :)';
            v = tanh(beta * h_entrada);
            h_salida = w * [v; 1];
            y = tanh(beta * h_salida);

            delta_salida = beta * (1 - tanh(beta * h_salida).^2) * (yd(i) - y);
            delta_entrada = beta * (1 - tanh(beta * h_entrada).^2) .* w(:, 1:neuronas_capa_1)' * delta_salida;

            deltaw = eta * delta_salida * [v; 1];
            w = w + deltaw';

            deltaW = eta * delta_entrada * x(i, :);
            W = W + deltaW;
        end

        %Chequeo si aprendio.
        ECM = 0;
        y = zeros(largo_de_tabla_de_entrada, 1);
        for i = 1:largo_de_tabla_de_entrada
            h_entrada = W * x(i, :)';
            v = tanh(beta * h_entrada);
            h_salida = w * [v; 1];
            y(i) = tanh(beta * h_salida);
            ECM = ECM + (y(i) - yd(i))^2;
        end
        
        ECMS = [ECMS, ECM];
        
        if(ECM > MAX_ERROR)
            aprendio = 0;
        else
            aprendio = 1;
        end
        
        iteracion = iteracion + 1;
    end
end
     
disp('Error Cuadratico Medio:');
ECM

figure(1);

f = [];
f_red = [];
% x_var variando, y_var = pi/2 y z_var = 0;
for x_var = linspace(0, 2 * pi, PASO_X * 10)
    %Funcion original.
    f = [f, sin(x_var)/3];
    
    %Red neuronal.
    h_entrada = W * [x_var, pi / 2, 0, 1]';
	v = tanh(beta * h_entrada);
	h_salida = w * [v; 1];
	y = tanh(beta * h_salida);
    f_red = [f_red, y];
end

hold on;
plot(linspace(0, 2 * pi, PASO_X * 10), f);
plot(linspace(0, 2 * pi, PASO_X * 10), f_red);
axis([0 2*pi, -0.5 0.5]);
title('X Variando | Y = PI / 2 | Z = 0');
xlabel('X');
ylabel('f');
legend('Real', 'Red');

figure(2);

f = [];
f_red = [];
% x_var = 0, y_var = variando y z_var = 0;
for y_var = linspace(0, 2 * pi, PASO_Y * 10)
    %Funcion original.
    f = [f, cos(y_var)/3];
    
    %Red neuronal.
    h_entrada = W * [0, y_var, 0, 1]';
	v = tanh(beta * h_entrada);
	h_salida = w * [v; 1];
	y = tanh(beta * h_salida);
    f_red = [f_red, y];
end

hold on;
plot(linspace(0, 2 * pi, PASO_Y * 10), f);
plot(linspace(0, 2 * pi, PASO_Y * 10), f_red);
axis([0 2*pi, -0.5 0.5]);
title('X = | - Y = Variando | Z = 0');
xlabel('Y');
ylabel('f');
legend('Real', 'Red');

figure(3);

f = [];
f_red = [];
% x_var = 0, y_var = pi/2 y z_var variando;
for z_var = linspace(-1, 1, PASO_Z * 10)
    %Funcion original.
    f = [f, z_var/3];
    
    %Red neuronal.
    h_entrada = W * [0, pi/2, z_var, 1]';
	v = tanh(beta * h_entrada);
	h_salida = w * [v; 1];
	y = tanh(beta * h_salida);
    f_red = [f_red, y];
end

hold on;
plot(linspace(-1, 1, PASO_Z * 10), f);
plot(linspace(-1, 1, PASO_Z * 10), f_red);
axis([-1 1, -0.5 0.5]);
title('X = 0 | Y = PI / 2 | Z Variando');
xlabel('Z');
ylabel('f');
legend('Real', 'Red');

figure(4);

plot(ECMS);
title('Evolucion Del ECM');
xlabel('ECM');
ylabel('Iteracion');

