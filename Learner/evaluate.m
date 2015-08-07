function score = evaluate(model,x)
    score = 0.0;
    svs = model.svs;
    N = length(svs);
    for i = 1:N
        score = score + svs(i).b * kernel(svs(i).x,x);
    end
end