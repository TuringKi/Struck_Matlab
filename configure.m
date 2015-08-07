global opt;

opt.radius = 30; 

opt.tmplsize = [32 32];

%%definition:
GEN_RESULT_IMG = 0;
SHOW_RESULT = 1;
OUTPU_DIR = '../Results/';
DEBUG = 1;
%DATA_SET_BASE_DIR = 'E:/DATASET/benchmark50-100';
VISUAL_CHACKING = 1;
VISUAL_FIG = [];

opt.particles.N = 600;
opt.particles.sigma = [15 15]';
opt.kernel_sigma = 0.2;

opt.ssvm_mC = 100;
opt.ssvm_BudgetSize = 60;
opt.DEBUG = DEBUG;
opt.SHOW_APPEARANCES = 1;
opt.USECOLOR = 1;

opt.particles.N = 550;
opt.particles.N_search_scale = 100;
opt.particles.sigma = [15,  15, 0.02, 0.0, 0.03, 0.0]';
opt.particles.scale_search_range = 0.4;