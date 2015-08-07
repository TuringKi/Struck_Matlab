function [ds,os] = eval_getOverlapAndCenterE(path)
    files=dir(path);
    n=size(files);
    ds=zeros(1,50);
    os=zeros(1,100);
    counter=0;
    for i=3:n
       name=files(i).name;
       if strcmp(name(end-3:end),'.mat')
       load([path '\' name]);
       ds=ds+pre_d;
       os=os+pre_o;
       counter=counter+1;
       end
    end
    ds=ds/counter;
    os=os/counter;
end