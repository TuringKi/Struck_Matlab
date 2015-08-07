function wimg = warpimg(img, p, sz)

if size(img, 3) == 1
    wimg = warpgray(img,p,sz);
else
    channel = size(img, 3);
    wimg = zeros(sz(1),sz(2),channel,size(p,2));
   
    for i = 1:channel
       I = img(:,:,i);

         wimg(:,:,i,:) = warpgray(I,p,sz);
    end
    
    
end



