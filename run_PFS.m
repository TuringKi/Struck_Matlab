%% run_ESRT: function description
function results = run_EKER(seq, res_path, bSaveImage)
	close all;
	
	addpath('Mex');
	addpath('Sampler');
	addpath('Features');
	addpath('Utils');
	addpath('Tracker');

	configure;
    rand(0);randn(0);
	%%for evaluation:
	duration = 0;
	fps =0;
	res = [];

	img_files = seq.s_frames;
	rect=seq.init_rect;
	pos = [rect(2)+rect(4)/2,rect(1)+rect(3)/2];
	target_sz = [rect(4),rect(3)];
	p = [pos([2 1]) target_sz([2 1]) 0];
	est0 = [p(1), p(2), p(3)/opt.tmplsize(1), p(5), p(4)/p(3), 0];
	est0 = affparam2mat(est0);
	opt.est = est0;

	opt.bb = [pos([2 1]),target_sz([2 1])];
	
	end_frame = length(img_files);
    %end_frame = 162;

	global model
    
    model = [];
	for frame = 1:end_frame
	   	im_o = imread(seq.s_frames{frame});
		im = imread(seq.s_frames{frame});
		if size(im,3) > 1 && ~opt.USECOLOR,
			im = rgb2gray(im);
		end
		tic;

	%%tracking code here

         if frame > 1
             opt.est = track(im);

         end
        %if frame == 1
         updateModel( im );
        %end
        if VISUAL_CHACKING
            VISUAL_FIG = showResults(VISUAL_FIG,im_o,est2bb(opt.tmplsize,opt.est),frame);
        end

		duration = duration + toc;
		ev_bb = est2bb(opt.tmplsize,opt.est);
		res = [res;ev_bb(1,1:2) - ev_bb(1,3:4)/2,ev_bb(1,3:4)];
 
		if(bSaveImage)
			frame_img = frame2im(getframe(VISUAL_FIG.fig_handle));
            
			savedPath = sprintf('%s%04d.jpg',res_path,frame);
			imwrite(frame_img, savedPath);	
		end
    end
	results.res=res;
	results.type='rect';
	results.fps=seq.len/duration;
	disp(['fps: ' num2str(results.fps)])
end
