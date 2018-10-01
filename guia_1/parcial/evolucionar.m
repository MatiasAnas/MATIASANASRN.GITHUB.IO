function resultado = evolucionar(estado_inicial, W, iteraciones)
    resultado = estado_inicial;
    for k = 1:iteraciones
        secuencia = randperm(length(estado_inicial));
        for i = secuencia
            acumulador = 0;
            for j = 1:length(estado_inicial)
                acumulador = acumulador + W(i, j) * resultado(j);
            end
            resultado(i) = signo(acumulador);
        end
    end
end