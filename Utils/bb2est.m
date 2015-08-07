function [ est ] = bb2est( bb,sz )
%BB2EST 此处显示有关此函数的摘要
%   此处显示详细说明
    p = bb;
    p(5) =0.0;
    est = [p(1), p(2), p(3)/sz(1), p(5), p(4)/p(3), 0];

end

