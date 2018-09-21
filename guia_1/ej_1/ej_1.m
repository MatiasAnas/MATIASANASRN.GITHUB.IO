s1 = imread('s1.bmp');
s2 = imread('s2.bmp');
s3 = imread('s3.bmp');

s1 = s1(:) * 2 - 1;
s2 = s2(:) * 2 - 1;
s3 = s3(:) * 2 - 1;

P = [s1, s2, s3];

W = P * P' - 3 * eye(50 * 50);
%3 numero de patrones.
%50 x 50 es el tamaño de la imagen.

%Compruebo que se mantiene en el patron.
resultado = signo(W * s1);
e1 = sum(resultado ~= s1);

resultado = signo(W * s2);
e2 = sum(resultado ~= s2);

resultado = signo(W * s3);
e3 = sum(resultado ~= s3);

disp("Errores en cada patron:")

[e1, e2, e3]

%De la imagen con ruido deberia volver a la original.
s1_ruido = imread('s1_ruido.bmp');
s1_ruido = s1_ruido(:) * 2 - 1;

resultado = signo(W * s1_ruido);

disp("Resultados de imagen con errores:");
error_en_patron = sum(s1_ruido ~= s1)
error_final = sum(resultado ~= s1)

%Pruebo con una mas ruidosa.
s1_ruido = imread('s1_ruido2.bmp');
s1_ruido = s1_ruido(:) * 2 - 1;

resultado = signo(W * s1_ruido);

disp("Resultados de imagen con mas errores:");
error_en_patron = sum(s1_ruido ~= s1)
error_final = sum(resultado ~= s1)

%Verificacion de estados espureos.
s_combinacion = signo(s1 + s2 + s3);

resultado = signo(W * s_combinacion);

disp("Verifico el error en el estado espureo que es la suma de los patrones:");
error_en_estado_espureo = sum(resultado ~= s_combinacion)

%Muestro el estado espureo.
resultado_matriz = vec2mat(s_combinacion, 50);
imshow(resultado_matriz);

%Pruebo con una imagen invertida.
s_invertida = - s1;

resultado = signo(W * s_invertida);

disp("Muestro error en imagen invertida:");
error_en_imagen_invertida = sum(resultado ~= s_invertida)