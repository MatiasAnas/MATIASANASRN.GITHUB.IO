close all;
clear;

%Numero De Neuronas.
N = 200;
%Numero De Patrones
m = 10;

%Genero patrones.
P = signo(randn(N, m));
%Calculo matriz.
W = P * P' - m * eye(N);

%Estado inicial aleatorio.
estado_inicial = signo(randn(N, 1));

%Veces que itera la evolucion asincronica.
iteraciones_de_evolucion = 5;

%Energia.
E = [];

resultado = estado_inicial;
for k = 1:iteraciones_de_evolucion
    secuencia = randperm(length(estado_inicial));
    for i = secuencia
        acumulador = 0;
        for j = 1:length(estado_inicial)
            acumulador = acumulador + W(i, j) * resultado(j);
        end
        resultado(i) = signo(acumulador);
        E = [E, energia_hopfield(W, resultado)];
    end
end

figure(1);
plot(E);
title('Evolucion De La Energia');
xlabel('Iteracion');
ylabel('Energia');
