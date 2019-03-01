close all;
clear;

%Numero de patrones.
p = 4;

%Size de las imagenes.
N = 50;

%Cargo imagenes.
s1 = imread('padrino.bmp');
s2 = imread('panda.bmp');
s3 = imread('perro.bmp');
s4 = imread('v.bmp');

%Las paso a vector y a valores 1 y -1.
s1 = s1(:) * 2 - 1;
s2 = s2(:) * 2 - 1;
s3 = s3(:) * 2 - 1;
s4 = s4(:) * 2 - 1;

%Construyo matriz de pesos sinapticos.
P = [s1, s2, s3, s4];
W = P * P' - p * eye(N * N);

%Veo si las aprendio.
resultado = signo(W * s1);
e1 = sum(resultado ~= s1);

resultado = signo(W * s2);
e2 = sum(resultado ~= s2);

resultado = signo(W * s3);
e3 = sum(resultado ~= s3);

resultado = signo(W * s4);
e4 = sum(resultado ~= s4);

disp('Errores en las imagenes:');
errores = [e1, e2, e3, e4]

%Estadistica de estados finales.

iteraciones = 1000;

%Numero de veces que cae en cada uno.
n1 = 0;
n2 = 0;
n3 = 0;
n4 = 0;
n_espurios = 0;

for i = 1:iteraciones
    %Genero estado inicial aleatorio.
    estado_inicial = signo(randn(N * N, 1));
    
    %La hago evolucionar hasta que se estabiliza el estado.
    estado = estado_inicial;
    estado_anterior = - estado;
    while(~isequal(estado_anterior, estado))
        estado_anterior = estado;
        estado = signo(W * estado);
    end
    
    %Veo cuantas veces cayo en cada estado guardado o estado espureo.
    if(isequal(estado, s1))
        n1 = n1 + 1;
    elseif(isequal(estado, s2))
        n2 = n2 + 1;
    elseif(isequal(estado, s3))
        n3 = n3 + 1;
    elseif(isequal(estado, s4))
        n4 = n4 + 1;
    else
        n_espurios = n_espurios + 1;
    end
end

disp('Probabilidades de caer en los estados aprendidos');
probabilidades_imagenes = [n1, n2, n3, n4] / iteraciones

disp('Probabilidad de caer en estados espurios');
probabilidad_espurio = n_espurios / iteraciones

