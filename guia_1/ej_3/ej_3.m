close all;
clear;

%Numero De Neuronas.
N = 500;
%Numero De Patrones
m = 50;

%Genero patrones.
P = signo(randn(N,m));
%Calculo matriz.
W = P * P' - m * eye(N);

porcentaje_de_conexiones_perdidas = 0;
paso_de_porcentaje = 1;

P_errores = [];
porcentajes_conexiones_perdidas = [];

while(porcentaje_de_conexiones_perdidas <= 100)
    A = (rand(N) > (porcentaje_de_conexiones_perdidas / 100));
    W_err = W .* A;
    errores = 0;
	for i = 1:m
        resultado = signo(W_err * P(:, i));
        errores = errores + sum(resultado ~= P(:, i));
    end
    P_error = errores / (m * N);
    P_errores = [P_errores, P_error];
    porcentajes_conexiones_perdidas = [porcentajes_conexiones_perdidas, porcentaje_de_conexiones_perdidas];
    porcentaje_de_conexiones_perdidas = porcentaje_de_conexiones_perdidas + paso_de_porcentaje;
end

figure(1);
plot(porcentajes_conexiones_perdidas, P_errores);
title('Porcentaje De Conexiones Rotas VS Probabilidad De Error');
xlabel('Porcentaje De Conexiones Rotas');
ylabel('Probabilidad De Error');
axis([0, 100, 0, 0.5]);