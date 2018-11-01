close all;
clear;

n_entradas = 2;
neuronas_capa_1 = 2;
neuronas_capa_2 = 1;
beta = 1;

NUMERO_DE_INDIVIDUOS = 100;
probabilidad_de_mutar = 0.01;
desvio_de_mutacion = 10;

MAX_ERROR = 0.1;

x = [   -1, -1;
        -1,  1;
         1, -1;
         1,  1;
    ];

x = [x, ones(2^n_entradas, 1)];

yd = [  -1;
         1;
         1;
        -1;
     ];
 
%Genero poblacion inicial.
individuos = [];
for i = 1 : NUMERO_DE_INDIVIDUOS
    W = randn(neuronas_capa_1, n_entradas + 1);
    w = randn(neuronas_capa_2, neuronas_capa_1 + 1);
    individuo = [W(:); w(:)];
    individuos = [individuos, individuo];
end

ECM = MAX_ERROR + 1;
while(ECM > MAX_ERROR)
    %Calculo fitness.
    Fitness_individuos = zeros(1, NUMERO_DE_INDIVIDUOS);
    for i = 1 : NUMERO_DE_INDIVIDUOS
        individuo = individuos(:, i);
        W = vec2mat(individuo(1 : 6), n_entradas + 1);
        w = vec2mat(individuo(7 : 9), neuronas_capa_1 + 1);
        Fitness_individuos(i) = fitness(individuo, W, w, x, yd, n_entradas, beta);
    end
    
    %Ordeno de mejor a peor fitness.
    [Fitness_individuos, I] = sort(Fitness_individuos, 'descend');
    individuos = individuos(:, I);
    
    %Mezclo los 90 peores, dejo los 10 mejores como estan.
    nuevos_individuos = individuos(:, 1:10);
    for j = 1 : 90
        primer_elemento = floor(rand * (NUMERO_DE_INDIVIDUOS - 1)) + 1;
        segundo_elemento = floor(rand * (NUMERO_DE_INDIVIDUOS - 1)) + 1;
        corte = floor(rand * (size(individuos, 1) - 1)) + 1;
        
        primera_parte = individuos(1 : corte, primer_elemento);
        segunda_parte = individuos(corte + 1 : size(individuos, 1), segundo_elemento);
        
        nuevo_individuo = [primera_parte; segunda_parte];
        nuevos_individuos = [nuevos_individuos, nuevo_individuo];
    end
    individuos = nuevos_individuos;
    
    %Mutaciones
    for j = 1 : size(individuos, 1)
        for k = 1 : size(individuos, 2)
            p = rand;
            if(p < probabilidad_de_mutar)
                individuos(j, k) = individuos(j, k) + randn * desvio_de_mutacion;
            end
        end
    end
    
    %Recalculo fitness.
    Fitness_individuos = zeros(1, NUMERO_DE_INDIVIDUOS);
    for i = 1 : NUMERO_DE_INDIVIDUOS
        individuo = individuos(:, i);
        W = vec2mat(individuo(1 : 6), n_entradas + 1);
        w = vec2mat(individuo(7 : 9), neuronas_capa_1 + 1);
        Fitness_individuos(i) = fitness(individuo, W, w, x, yd, n_entradas, beta);
    end
    
    %Ordeno de mejor a peor fitness.
    [Fitness_individuos, I] = sort(Fitness_individuos, 'descend');
    individuos = individuos(:, I);
    
    %Calculo la probabilidad de cada individuo de reproducirse.
    Probabilidades = zeros(1, NUMERO_DE_INDIVIDUOS);
    Fitness_total = sum(Fitness_individuos);
    for j = 1 : NUMERO_DE_INDIVIDUOS
        Probabilidades(j) = Fitness_individuos(j) / Fitness_total;
    end
    
    %Obtengo siguiente generacion.
    siguiente_generacion = [];
    for j = 1 : NUMERO_DE_INDIVIDUOS
        p = rand();
        
        k = 1;
        probabilidad_acumulada = Probabilidades(1);
        
        while(k <= NUMERO_DE_INDIVIDUOS)
            if(p < probabilidad_acumulada)
                siguiente_generacion = [siguiente_generacion, individuos(:, k)];
                break;
            else
                k = k + 1;
                probabilidad_acumulada = probabilidad_acumulada + Probabilidades(k);
            end
        end
    end
    individuos = siguiente_generacion;
    
    %Recalculo fitness.
    Fitness_individuos = zeros(1, NUMERO_DE_INDIVIDUOS);
    for i = 1 : NUMERO_DE_INDIVIDUOS
        individuo = individuos(:, i);
        W = vec2mat(individuo(1 : 6), n_entradas + 1);
        w = vec2mat(individuo(7 : 9), neuronas_capa_1 + 1);
        Fitness_individuos(i) = fitness(individuo, W, w, x, yd, n_entradas, beta);
    end
    
    %Ordeno de mejor a peor fitness.
    [Fitness_individuos, I] = sort(Fitness_individuos, 'descend');
    individuos = individuos(:, I);
    
    %Me quedo con el mejor elemento.
    ECM = 1 / fitness(individuos(:, 1), W, w, x, yd, n_entradas, beta);
end

%Mejor individuo.
W = vec2mat(individuos(1 : 6, 1), n_entradas + 1);
w = vec2mat(individuos(7 : 9, 1), neuronas_capa_1 + 1);

%Salidas.
y = zeros(2^n_entradas, 1);
for j = 1:2^n_entradas
    h_entrada = W * x(j, :)';
    v = tanh(beta * h_entrada);
    h_salida = w * [v; 1];
    y(j) = tanh(beta * h_salida);
end
     
disp('Error Cuadratico Medio:');
ECM

disp('Salidas:');
y

figure(1);
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
x2 = - W(1,1) / W(1,2) * x1 - W(1,3) / W(1,2);
plot(x2, x1, 'b--');

x2 = - W(2,1) / W(2,2) * x1 - W(2,3) / W(2,2);
plot(x2, x1, 'r--');

legend('Puntos Y = 1', 'Puntos Y = -1', 'Frontera De Desicion 1', ...
    'Frontera De Desicion 2');