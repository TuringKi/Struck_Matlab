function [ y ] = kernel( a, b )
    global opt

    y = exp ( -opt.kernel_sigma * norm(a - b)^2);

end

