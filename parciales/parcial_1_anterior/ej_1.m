close all;
clear;

%Numero De Neuronas.
N = 500;
%Numero De Iteraciones
ITERACIONES = 5;

%Probabilidad De Error.
probabilidad = 0.005;

%Algoritmo.

m = 0;
maximos = zeros(1, ITERACIONES);

for k = 1:ITERACIONES
	P_error = 0;
	while((P_error < probabilidad) && (m <= N))
        m = m + 1;
        P = signo(randn(N, m));
        W = P * P' - m * eye(N);
        errores = 0;
        for i = 1:m
            resultado = signo(W * P(:, i));
            errores = errores + sum(resultado ~= P(:, i));
        end
        P_error = errores / (m * N);
    end
	maximos(k) = m / N;
end

disp('p/N Maximo:');
maximo = mean(maximos)