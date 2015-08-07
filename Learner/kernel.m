function val = kernel(a,b)
    %val = exp( - 0.07 * norm(a - b));
    val = a'*b / (norm(a) * norm(b));
end