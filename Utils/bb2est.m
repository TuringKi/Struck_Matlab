function [ est ] = bb2est( bb,sz )
%BB2EST �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    p = bb;
    p(5) =0.0;
    est = [p(1), p(2), p(3)/sz(1), p(5), p(4)/p(3), 0];

end

