clc;
clear all;
close all;

%%
% ����ͼƬ��·��
video = 'Bass';
path_str =[ './results/' video '/'];
% ��ȡͼƬ�б�
im_list = dir([path_str '*.png']);
% ���ñ������Ƶ������
avi_name = [video '.avi'];
% fpsΪ֡Ƶ�������������������
aviobj = avifile(avi_name,'fps',16,'Compression','None','Quality',100);

% ��ʼ֡
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