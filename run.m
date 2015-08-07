clear all;
close all;
clc;
addpath('Tools');
IS_CHOOSE_VIDEO = 1;
DATA_SET_BASE_DIR = 'E:\DATASET\visual_tracking\benchmark_CVPR2013';
GEN_RESULT_IMG = 1;
SHOW_RESULTS_PLOTS = 1;
OUTPU_DIR = '../Results/';
if IS_CHOOSE_VIDEO 
	video = choose_video(DATA_SET_BASE_DIR);
else
	video = 'David'; %just for test and debuging.
end

if GEN_RESULT_IMG
	if ~exist([OUTPU_DIR])
		mkdir([OUTPU_DIR]);
	end
	if ~exist([OUTPU_DIR video])
		mkdir([OUTPU_DIR video]);
	end
end


%%reading dataset:
[img_files, pos, target_sz, theta,ground_truth, video_path] = load_video_info(DATA_SET_BASE_DIR, video);
for i = 1:length(img_files)
    img_files{i} =[ DATA_SET_BASE_DIR '\' video '\img\'  img_files{i} ];
end
seq.s_frames = img_files;
rect = ground_truth(1,:);
seq.len = length(img_files);
seq.init_rect = [rect([1 2]) - rect([3 4])/2,rect([3 4])];
res_path = [OUTPU_DIR video '\'];
bSaveImage = GEN_RESULT_IMG;


results = run_PFS(seq, res_path, bSaveImage);
res = results.res;
res(:,1:2) = res(:,1:2) + res(:,3:4)/2;

 precisions = precision_plot(res, ground_truth, video, SHOW_RESULTS_PLOTS);
 
[distance_precision, PASCAL_precision, average_center_location_error] = ...
        compute_performance_measures(res, ground_truth,video);
    
fprintf('%s -CLE: %.3g pixels,- Precision (20px):% 1.3f%%, Overlap Precision: %.3g %%,FPS:% 4.2f\n', video,average_center_location_error, 100*precisions(20),100*PASCAL_precision, results.fps);        