%% ParticleFilterSampler: function description
function [particles,XX] = ParticleFilterSampler(im,est,sz,N,sigma)
	particles = repmat(affparam2geom(est(:)), [1,N]);
          particles = particles + randn(6,N).*repmat(sigma(:), [1,N]);
         wimgs = warpimg(double(im), affparam2mat(particles), sz);
        XX = cell(size(particles,2),1);

    for i = 1:size(particles,2)
        if size(im, 3) == 1
            wimg =wimgs(:,:,i);
        else
             wimg =wimgs(:,:,:,i);
        end
        XX{i} = wimg;
        
    end
end
