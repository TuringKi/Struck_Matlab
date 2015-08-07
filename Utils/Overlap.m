
function ol = Overlap(y1,y2)
    y1_area = y1(3,1) * y1(4,1); 
    y2_area = y2(3,1) * y2(4,1); 
    A = [1 0 -1/2 0;0 1 0 -1/2;1 0 1/2 0;0 1 0 1/2];
    y1 = A * y1;
    y2 = A * y2;
    xx0 = max(y1(1,1),y2(1,1));
    xx1 = min(y1(3,1),y2(3,1));
    yy0 = max(y1(2,1),y2(2,1));
   yy1 = min(y1(4,1),y2(4,1));
    if xx0 >= xx1 || yy0 >= yy1
        ol  = 0.0;
        return;
    end
    areaInt = (xx1 - xx0) *(yy1 - yy0);

    ol = areaInt/(y1_area + y2_area - areaInt);
end