%% getPatch: function description
function [I] = getPatch(tempsize,im,rr)

       	rr_w = rr(3);
           rr_x = rr(1);
            rr_y = rr(2);
           rr_h = rr(4);
           I = im(floor(rr_y - rr_h/2):floor(rr_y + rr_h/2),floor(rr_x - rr_w/2):floor(rr_x + rr_w/2));
           I = I(1:end -1,1:end -1);
           I = imresize(I,tempsize);
end