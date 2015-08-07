function [samples,XX] = RadialSampler(im,center,sz,region,radius,nr,nt)
	c0 = center;
    center(1:2,1) = [center([1 2]) - center([3 4])/2];
	rstep = radius / nr;
	tstep = 2 *pi / nt;
	s = center;
	samples = [];
	count = 1;
    ests = [];
    
    samples(:,count) =c0;
    ests(:,count) = bb2est(c0,sz);
     count = count + 1;	
	for ir = 1:nr
		phase = rem(ir,2) * tstep / 2;
		for it = 0:nt - 1
			dx = ir * rstep *cos(it * tstep + phase);
			dy = ir * rstep *sin(it * tstep + phase);
			s(1:2,1) = [center(1,1) + dx + s(3,1)/2,center(2,1) + dy + s(4,1)/2]';			
           
            ests(:,count) = bb2est(s,sz);
            samples(:,count) = s;
            count = count + 1;			
		end
	end

    wimgs = warpimg(double(im), affparam2mat(ests), sz);
    XX = cell(size(ests,2),1);

    for i = 1:size(ests,2)
        if size(im, 3) == 1
            wimg =wimgs(:,:,i);
        else
             wimg =wimgs(:,:,:,i);
        end
        XX{i} = wimg;
    end

%     figure(23);
%     for i = 1:size(wimgs,3)
%         subplot(9,9,i);
%         imshow(wimgs(:,:,i),[]);
%     end