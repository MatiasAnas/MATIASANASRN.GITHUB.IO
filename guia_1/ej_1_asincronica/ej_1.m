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
resultado = evolucionar(s1, W, 1);
e1 = sum(resultado ~= s1);

resultado = evolucionar(s2, W, 1);
e2 = sum(resultado ~= s2);

resultado = evolucionar(s3, W, 1);
e3 = sum(resultado ~= s3);

disp("Errores en cada patron:")

[e1, e2, e3]

%Pruebo con una mas ruidosa.
s1_ruido = imread('s1_ruido2.bmp');
s1_ruido = s1_ruido(:) * 2 - 1;

resultado =  evolucionar(s1_ruido, W, 1);

disp("Resultados de imagen con mas errores:");
error_en_patron = sum(s1_ruido ~= s1)
error_final = sum(resultado ~= s1)