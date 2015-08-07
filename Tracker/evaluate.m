function [ score ] = evaluate( x )
    global model
    
    score = 0;
    svs = model.svs;
    for i = 1 : length(svs)
        sv = svs(i);
        score = score + sv.w * kernel(sv.x, x);
    end
end

