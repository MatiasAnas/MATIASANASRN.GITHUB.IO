close all;
clear;

%Numero De Neuronas.
N = 500;
%Numero De Iteraciones
ITERACIONES = 5;

%Tabla.
tabla_probabilidades = [0.001, 0.0036, 0.01, 0.05, 0.1];

%Tabla de resultados para cada iteracion.
tabla_maximos = zeros(ITERACIONES, length(tabla_probabilidades));
tabla_maximos_libro = [0.105, 0.138, 0.185, 0.37, 0.61];

%Estos son los m con los que arranco, que los saco de la tabla del libro.
%Se hace para ahorrar tiempo, arranca de un 90 porciento del final.
tabla_m_iniciales = floor(tabla_maximos_libro * N * 0.9);

%Algoritmo.
for k = 1:ITERACIONES
    for p = 1:length(tabla_probabilidades)
        m = tabla_m_iniciales(p);
        P_error = 0;
        while((P_error < tabla_probabilidades(p)) && (m <= N))
            m = m + 1;
            P = signo(randn(N,m));
            W = P * P' - m * eye(N);
            errores = 0;
            for i = 1:m
                resultado = signo(W * P(:, i));
                errores = errores + sum(resultado ~= P(:, i));
            end
            P_error = errores / (m * N);
        end
        tabla_maximos(k, p) = m / N;
    end
end

%Tabla de resultados final.
tabla_maximos_promedio = zeros(1, length(tabla_probabilidades));
for p = 1:length(tabla_probabilidades)
    tabla_maximos_promedio(p) = mean(tabla_maximos(:, p));
end

%Presento tabla de resultados.
tabla = [tabla_probabilidades', tabla_maximos_libro', tabla_maximos_promedio']