close all;
clear;

%Patron a guardar.
patron = [1; 1; 1; -1];

%Matriz de pesos sinapticos.
W = patron * patron' - eye(4);

%Estado inicial.
estado_inicial = [1; -1; 1; 1];

%Sincronica.
iteraciones = 10;
resultado_sinc = estado_inicial;
for i = 1:iteraciones
    resultado_sinc = signo(W * resultado_sinc);
end

%Asincronica.
iteraciones = 50;
resultado_asinc = evolucionar(estado_inicial, W, iteraciones);

%Resultados.
disp('Resultado evolucion sincronica:');
resultado_sinc

disp('Resultado evolucion asincronica');
resultado_asinc