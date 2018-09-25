close all;
clear all;

N = 10;

estados = signo(randn(N));
estados = [zeros(1, N + 2); zeros(N, 1), estados, zeros(N, 1); zeros(1, N + 2)];
%randperm
%ind2sub

E = 0;
for i = 2: length(estados(:, 1)) - 1
    for j = 2: length(estados(1, :)) - 1
        E = E - (1/2) * estados(i, j) * (estados(i - 1, j) + estados(i + 1 ,j) + estados(i, j - 1) + estados(i, j + 1));
    end
end

T = 5;
paso_temp = 0.01;
k = 1;
M = [];

while T >= 0
    for cant_veces = 1: 10
        cambios = randperm(N * N);
        [x, y] = ind2sub(size(estados) - 2, cambios);
        for l = 1: N * N
            nuevos_estados = estados;
            nuevos_estados(x(l) + 1, y(l) + 1) = nuevos_estados(x(l) + 1, y(l) + 1) * -1;
        
            E_nueva = 0;
            for i = 2: length(estados(:, 1)) - 1
                for j = 2: length(estados(1, :)) - 1
                    E_nueva = E_nueva - (1/2) * nuevos_estados(i, j) * (nuevos_estados(i - 1, j) + nuevos_estados(i + 1 ,j) + nuevos_estados(i, j - 1) + nuevos_estados(i, j + 1));
                end
            end
            
            if E_nueva < E
                estados = nuevos_estados;
                E = E_nueva;
            else
                p = exp(-(E_nueva - E) / (k * T));
                if rand() < p
                    estados = nuevos_estados;
                    E = E_nueva;
                end
            end
        end
    end
    T = T - paso_temp;
    M = [sum(sum(estados)) M];
end
      
eje_temp = 0: paso_temp: 5;

figure;
plot(eje_temp, M);
