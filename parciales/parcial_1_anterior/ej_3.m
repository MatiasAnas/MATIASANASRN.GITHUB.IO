close all;
clear;

N = 10;
J = -1; % J = -1 => Paramagnetico.

%Inicializo estados.
estados = signo(randn(N, N));
estados_iniciales = estados;

%Agrego ceros para facilitar el calculo de la energia.
estados = [zeros(1, N + 2); zeros(N, 1), estados, zeros(N, 1); zeros(1, N + 2)];

%Calculo energia.
E = 0;
for i = 2:(N + 1)
    for j = 2:(N + 1)
        E = E + estados(i, j) * (estados(i-1, j) + estados(i+1, j) + estados(i, j-1) + estados(i, j+1));
    end
end
E = - 0.5 * J * E;

T = 5;
T_paso = 0.01;
M = [];
temperaturas = [];

while(T >= 0)
    for k = 1:(20*N*N)
        nuevos_estados = estados;
        columna = floor(rand * N) + 2;
        fila = floor(rand * N) + 2;
        nuevos_estados(fila, columna) = - nuevos_estados(fila, columna);
        
        %Recalculo la energia.
        E_nueva = 0;
        for i = 2:(N + 1)
        	for j = 2:(N + 1)
            	E_nueva = E_nueva + nuevos_estados(i, j) * (nuevos_estados(i-1, j) + nuevos_estados(i+1, j) + nuevos_estados(i, j-1) + nuevos_estados(i, j+1));
        	end
        end
        E_nueva = - 0.5 * J * E_nueva;
        
        if(E_nueva < E)
        	estados = nuevos_estados;
            E = E_nueva;
        else
        	p = exp(-(E_nueva - E)/T);
        	if(rand < p)
            	estados = nuevos_estados;
            	E = E_nueva;
            end
        end
    end
    
    M = [sum(sum(estados)), M];
    temperaturas = [T, temperaturas];
    T = T - T_paso;
end

figure(1);
plot(temperaturas, M);
title('Evolucion De La Magnetizacion Con La Temperatura');
xlabel('Temperatura');
ylabel('Magnetizacion');
axis([0, 5, -110, 110]);

figure(2);
imagesc(estados_iniciales, [-1, 1]);
title('Estados Iniciales');

figure(3);
imagesc(estados(2:(N+1), 2:(N+1)), [-1, 1]);
title('Estados Finales');