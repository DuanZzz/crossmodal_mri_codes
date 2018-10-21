%% zero the world
clear,clc
restoredefaultpath;
%% load functions
fun_dir = fullfile(pwd,'functions');
addpath(genpath(fun_dir));
%% load colorspace function
%mex colorspace.c % use to creat mex file from C code.
%% visual property and convert to PRESENTATION COMPATIABLE
HB_RGB = hsv2rgb(0,0,0.8)*255; %reverse: rgb2hsv
LB_RGB = hsv2rgb(0,0,0.2)*255; %reverse: rgb2hsv; if use online generated hex code: hex2rgb(H_BRITNESS)*255;
B_SIZE = 5.2; % in degree
S_SIZE = 2.1; % in degree
% SIZE
display.dist = 50; % cm
display.width = 44.5; % cm
display.resolution = [1280,800];
ang_B = B_SIZE;
ang_S = S_SIZE;
pix_B = angle2pix(display,ang_B);
pix_S = angle2pix(display,ang_S);
%% record info
fileID = fopen('mri_behv_part_para_visual.txt','w');
fprintf(fileID,'%6s %6s\n','BIG_SIZE','SMALL_SIZE');
fprintf(fileID,'%6.0f %6.0f\n',pix_B,pix_S);
fprintf(fileID,'%6s\n','HIGH_BRIGHTNESS');
fprintf(fileID,'%6.0f\n',HB_RGB);
fprintf(fileID,'%6s\n','LOW_BRIGHTNESS');
fprintf(fileID,'%6.0f\n',LB_RGB);
fclose(fileID);