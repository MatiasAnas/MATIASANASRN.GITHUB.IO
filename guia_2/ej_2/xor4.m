close all;
clear;

n_entradas = 4;
neuronas_capa_1 = 4;
neuronas_capa_2 = 1;
MAX_ERROR = 1;
MAX_ITERACIONES = 40000;

eta = 0.02;
beta = 1;

x = [   -1, -1, -1, -1;
        -1, -1, -1,  1;
        -1, -1,  1, -1;
        -1, -1,  1,  1;
        
        -1,  1, -1, -1;
        -1,  1, -1,  1;
        -1,  1,  1, -1;
        -1,  1,  1,  1;
        
         1, -1, -1, -1;
         1, -1, -1,  1;
         1, -1,  1, -1;
         1, -1,  1,  1;
        
         1,  1, -1, -1;
         1,  1, -1,  1;
         1,  1,  1, -1;
         1,  1,  1,  1;
    ];

x = [x, ones(2^n_entradas, 1)];

yd = [  -1;
         1;
         1;
        -1;
        
         1;
        -1;
        -1;
         1;
        
         1;
        -1;
        -1;
         1;
        
        -1;
         1;
         1;
        -1;
     ];

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
        secuencia = randperm(2^n_entradas);
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
        y = zeros(2^n_entradas, 1);
        for i = 1:2^n_entradas
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

disp('Salidas Aprendidas:');
y

figure(1);
plot(ECMS);