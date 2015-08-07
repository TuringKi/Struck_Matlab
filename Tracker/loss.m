function [ y ] = loss( a, b )
    y = 1 - Overlap(a,b);
end

