%% zero the world
clear,clc
restoredefaultpath;
%% load functions
fun_dir = fullfile(pwd,'functions');
addpath(genpath(fun_dir));
%% load colorspace function
%mex colorspace.c % use to creat mex file from C code.
%% visual property and convert to PRESENTATION COMPATIABLE
% could use onlie coder: http://www.workwithcolor.com/color-converter-01.htm
HB_RGB = hsv2rgb(0,0,0.8)*255; %reverse: rgb2hsv
LB_RGB = hsv2rgb(0,0,0.2)*255; %reverse: rgb2hsv; if use online generated hex code: hex2rgb(H_BRITNESS)*255;
B_SIZE = 5.2; % in degree
S_SIZE = 2.1; % in degree
% SIZE
display.dist = 50; % cm
display.width = 61.75; % cm
display.resolution = [1920,1080];
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
% %% draw circle
% figure
% filledCircle([0,0],pix_B/2,10240,LB_RGB/255);
% axis square
% axis([-96 96 -96 96]);
% set(gca,'Color','k');
% set(gca,'box','off')
% set(gca,'xtick',[])
% set(gca,'ytick',[])
% set(gcf, 'Units', 'points', 'Position', [0, 0, 256, 256], 'PaperUnits', 'points', 'PaperSize', [256, 256])
% export_fig test -png -r96 -p0 -q100
% 
% figure
% filledCircle([0,0],pix_S,10240,LB_RGB/255);
% axis([-200 200 -200 200]);
% axis off
% 
% figure
% filledCircle([0,0],pix_B,10240,HB_RGB/255);
% axis([-200 200 -200 200]);
% axis off
% 
% figure
% filledCircle([0,0],pix_S,10240,HB_RGB/255);
% axis([-200 200 -200 200]);
% axis off
%% draw cirlc in pixel
B_mask = circ(pix_B/2, [300 300], [150 150]);
S_mask = circ(pix_S/2, [300 300], [150 150]);

RGB  = ones(300, 300, 3)*HB_RGB(:,:,1)/255;  % RGB Image
R    = RGB(:, :, 1);
G    = RGB(:, :, 2);
B    = RGB(:, :, 3);
bk_HB = cat(3, R, G, B);

RGB  = ones(300, 300, 3)*LB_RGB(:,:,1)/255;  % RGB Image
R    = RGB(:, :, 1);
G    = RGB(:, :, 2);
B    = RGB(:, :, 3);
bk_LB = cat(3, R, G, B);

RGB  = ones(300, 300, 3)*0;  % RGB Image
R    = RGB(:, :, 1);
G    = RGB(:, :, 2);
B    = RGB(:, :, 3);
bk_black = cat(3, R, G, B);


stim_HB_B = bk_HB.*cat(3,B_mask,B_mask,B_mask);
stim_HB_S = bk_HB.*cat(3,S_mask,S_mask,S_mask);
stim_LB_B = bk_LB.*cat(3,B_mask,B_mask,B_mask);
stim_LB_S = bk_LB.*cat(3,S_mask,S_mask,S_mask);

%imshow(stim_HB_B);
imwrite(stim_HB_B,'stim_HB_B.bmp');
imwrite(stim_LB_B,'stim_LB_B.bmp');
imwrite(stim_HB_S,'stim_HB_S.bmp');
imwrite(stim_LB_S,'stim_LB_S.bmp');
imwrite(bk_black,'stim_NONE.bmp');