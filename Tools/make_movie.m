clc;
clear all;
close all;

%%
% 设置图片的路径
video = 'Bass';
path_str =[ './results/' video '/'];
% 获取图片列表
im_list = dir([path_str '*.png']);
% 设置保存的视频的名字
avi_name = [video '.avi'];
% fps为帧频，调节这个参数就行了
aviobj = avifile(avi_name,'fps',16,'Compression','None','Quality',100);

% 起始帧
start_ind = 1;
step = 1;
numFrames = length(im_list);

for i = start_ind:step:numFrames
    fprintf('process %s image.\n', im_list(i,1).name);
    im_str = [path_str im_list(i,1).name];
%     im_str = [path_str num2str(i) '.jpg'];
    im = imread(im_str);
    aviobj = addframe(aviobj, im);
end

aviobj = close(aviobj);