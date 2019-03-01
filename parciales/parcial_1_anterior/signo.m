function s = signo(x)
    [a, b] = size(x);
    s = zeros(a, b);
    for i = 1:a
        for j = 1:b
            if(x(i, j) >= 0)
                s(i, j) = 1;
            else
                s(i, j) = -1;
            end
        end
    end
end