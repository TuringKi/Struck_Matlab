function x = genHoGFeature(I)
    I_gray = I;
    if size(I, 3) > 1
        I_gray = rgb2gray(uint8(I));
    end
    temp = fhog(single(I_gray),4,9);
    x= temp(:);

end