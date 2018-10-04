close all;
clear;

n_entradas = 2;
eta = 1;

x = [   -1, -1;
        -1,  1;
         1, -1;
         1,  1;
    ];

x = [x, ones(2^n_entradas, 1)];

yd = [  -1;
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


figure;
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
x2 = - W(1) / W(2) * x1 - W(3) / W(2);
plot(x2, x1, 'b--');

legend('Puntos Y = 1', 'Puntos Y = -1', 'Frontera De Desicion');