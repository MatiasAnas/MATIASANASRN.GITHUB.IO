function E = energia_hopfield(W, estados)
    E = 0;
    for i = 1:length(estados)
        for j = 1:length(estados)
            E = E + W(i, j) * estados(i) * estados(j);
        end
    end
    E = - E / 2;
end