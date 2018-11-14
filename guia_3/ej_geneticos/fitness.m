function fitness_individuo = fitness(individuo, W, w, x, yd, n_entradas, beta)
    ECM_individuo = 0;
    y = zeros(2^n_entradas, 1);
    for j = 1:2^n_entradas
        h_entrada = W * x(j, :)';
        v = tanh(beta * h_entrada);
        h_salida = w * [v; 1];
        y(j) = tanh(beta * h_salida);
        ECM_individuo = ECM_individuo + (y(j) - yd(j))^2;
    end
    fitness_individuo = 1 / ECM_individuo;
end