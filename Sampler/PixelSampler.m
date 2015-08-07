function [samples] = PixelSampler(center,region,radius)

	samples = [];
	s = center;
	count = 1;
	r2 = radius * radius;
	for iy = -radius:radius
		for ix = -radius:radius
			if (ix * ix + iy * iy > r2)
				continue;
			end
			x = center(1,1) + ix;
			y = center(2,1) + iy;
			s(1:2,1) = [x,y]';
			if(isInside(region,s))
				samples(:,count) = s;
			end
			count = count + 1;
		end
	end