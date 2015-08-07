function model = updateModel(opt,im,model)
	bb = opt.bb;
    
    if isempty(model)
        model.svs = {};
        model.sps = {};
    end
    
    svs = model.svs;
    sps = model.sps;
    sp = {};
    im_size = size(im);
	region = [1 1 im_size([2 1])]';
	samples = RadialSampler(bb',region,2*opt.radius,5,16);
	N = size(samples,2);
	for i = 1:N
		rr = samples(:,i);
        I = getPatch(opt.tmplsize,im,rr);
        temp = genHoGFeature(I);
        X(:,i) = temp(:);
        s.x = temp(:);
        s.b = 0;
        s.g = 0;
        s.y = Overlap(rr,samples(:,end));
        sp = {sp;s};
    end
    
    
    %process new samples,choose the current postivie sample and the
    %min-gradient sample as the SMO step elements
    
    %add the current frame postivie sample to support vectors
    svs = {svs;[opt.curr_frame,N]};
    
end
