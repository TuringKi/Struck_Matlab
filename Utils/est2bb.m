function [ bb ] = est2bb( tmplsize,est )
%EST2BB 此处显示有关此函数的摘要
%   此处显示详细说明
    w = tmplsize(1);
    h = tmplsize(2);
    p = est;
	M = reshape(p, 2,3);
	
	corners = [1 -w/2 -h/2;1 w/2 -h/2;1 w/2 h/2;1 -w/2 h/2;1 -w/2 -h/2]';
	corners = M * corners;

	ww = (corners(1,2) - corners(1,1) + corners(1,3) - corners(1,4)) / 2;
	hh = (corners(2,4) - corners(2,1) + corners(2,3) - corners(2,2)) / 2;

	center = corners(:,1)' + [ww hh]/2;
    
    bb = [center ww hh];

end

