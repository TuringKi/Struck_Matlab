%% track: function description
function [est] = track(im)
    global model
    global opt
	bb = opt.bb;
    
     [samples, XX] = ParticleFilterSampler(im,opt.est,opt.tmplsize,opt.particles.N, opt.particles.sigma);
     
     X = [];
     for i = 1:length(samples)
         I = XX{i};
         temp = genHoGFeature(I);
          X(:,i) = temp(:);
     end
     scores = zeros(size(X, 2));
     for i = 1:size(X, 2)
        score = 0.0;
        for j = 1:length(model.svs)
            sv = model.svs(j);
            score = score + sv.w * kernel(sv.x, X(:,i));
        end
        scores(i) = score;
     end
     
     max_scores_idx = find(scores == max(scores(:)),1);
     
     est = affparam2mat(samples(:,max_scores_idx));   
     
     
     %handle the scale
    N = opt.particles.N_search_scale; 
     
    particles = repmat(affparam2geom(est(:)), [1,N]);
    scales = 1 - opt.particles.scale_search_range / 2:opt.particles.scale_search_range / N:1 + opt.particles.scale_search_range / 2;
    %scales = scales(scales ~= 1);
    for i = 1:N
        particles(3,i) = particles(3,i) * scales(i);
    end
    warpimgs = warpimg(double(im), affparam2mat(particles), opt.tmplsize);
    
    S = cell(size(particles,2),1);

    for i = 1:size(particles,2)
        if size(im, 3) == 1
            wimg =warpimgs(:,:,i);
        else
             wimg =warpimgs(:,:,:,i);
        end
        S{i} = wimg;
        
    end
    
    X = [];
   
    for i = 1:length(S)
         I = S{i};
         temp = genHoGFeature(I);
          X(:,i) = temp(:);
    end
    
     scores = zeros(size(X, 2));
     for i = 1:size(X, 2)
        score = 0.0;
        for j = 1:length(model.svs)
            sv = model.svs(j);
            score = score + sv.w * kernel(sv.x, X(:,i));
        end
        scores(i) = score;
     end
     
     max_scores_idx = find(scores == max(scores(:)),1);
     
     est = affparam2mat(particles(:,max_scores_idx));   
    
end