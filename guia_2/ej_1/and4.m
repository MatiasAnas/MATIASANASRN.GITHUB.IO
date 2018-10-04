close all;
clear;

n_entradas = 4;
eta = 1;

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
        -1;
        -1;
        -1;
        -1;
        -1;
        -1;
        -1;
        -1;
        -1;
        -1;
        -1;
        -1;
        -1;
        -1;
         1;
     ];
 
 W = randn(1, n_entradas + 1);
 
 aprendio = 0;
 while(aprendio == 0)
    %Actualizo matriz de pesos sinapticos.
    secuencia = randperm(2^n_entradas);
    for i = secuencia
        y = signo(W * x(i, :)');
        deltaW = eta * x(i, :)' * (yd(i) - y);
        W = W + deltaW';
    end
    %Chequeo si aprendio.
    aprendio = 1;
    for i = 1:2^n_entradas
        y = signo(W * x(i, :)');
        if(yd(i) ~= y)
            aprendio = 0;
        end
    end
 end
 
% Calculo Cantidad De Errores.
errores = 0;
for i = 1:2^n_entradas
    y = signo(W * x(i, :)');
    if(yd(i) ~= y)
        errores = errores + 1;
    end
end

disp('Cantidad de errores:');
errores