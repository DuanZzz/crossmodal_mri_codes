%% zero the world
clear,clc
restoredefaultpath;
%% load functions
fun_dir = fullfile(pwd,'functions');
addpath(genpath(fun_dir));
%% load toolbox
% toolbox_dir = fullfile(pwd,'toolbox','Psychtoolbox-3-Psychtoolbox-3-0a49d7b','Psychtoolbox');
% temp=pwd;
% cd(toolbox_dir);
% SetupPsychtoolbox
% cd(temp);
%% gen fixation
% width = 40; dist = 50;
% % horizontal dimension of display (cm) % viewing distance (cm)
% colorOval = [255 0 0]; % color of the two circles [R G B] 
% colorCross = [0 0 0]; % color of the Cross [R G B]
% backcolor = 0;
% d1 = 0.6; d2 = 0.2;
% % diameter of outer circle (degrees) % diameter of inner circle (degrees)
% screen = 1;
% Screen('Preference', 'SkipSyncTests', 1)
% [w,rect] = Screen('OpenWindow', screen, [], []); [cx, cy] = RectCenter(rect);
% ppd = pi*(rect(3)-rect(1))/atan(width/dist/2)/360; % pixel per degree
% HideCursor;
% WaitSecs(2);
% 
% Screen('FillRect', w, backcolor);
% Screen('FillOval', w, colorOval, [cx-d1/2*ppd, cy-d1/2*ppd, cx+d1/2*ppd, cy+d1/2*ppd], d1*ppd);
% Screen('DrawLine', w, colorCross, cx-d1/2*ppd, cy, cx+d1/2*ppd, cy, d2*ppd);
% Screen('DrawLine', w, colorCross, cx, cy-d1/2*ppd, cx, cy+d1/2*ppd, d2*ppd);
% Screen('FillOval', w, colorOval, [cx-d2/2*ppd, cy-d2/2*ppd, cx+d2/2*ppd, cy+d2/2*ppd], d2*ppd);
% 
% Screen(w, 'Flip'); 
% 
% WaitSecs(2); 
% 
% Screen('Close', w);

%% more high resolution method
display.dist = 50; % cm
display.width = 61.75; % cm
display.resolution = [1920,1080];

r1 = angle2pix(display,0.2);
r2 = angle2pix(display,0.6);

r1_mask = circ(r1*100, [50 50]*100, [25 25]*100);
r2_mask = circ(r2*100, [50 50]*100, [25 25]*100);

RGB  = ones(50*100, 50*100, 3);  % RGB Image
R    = RGB(:, :, 1)*1;
G    = RGB(:, :, 2)*0;
B    = RGB(:, :, 3)*0;
template_shape = cat(3, R, G, B);

stage_1=template_shape.*cat(3,r2_mask,r2_mask,r2_mask);

crosshair_mask = zeros([50 50]*100);
%crosshair_mask((50/2*100-5/sqrt(2)*100):(50/2*100+5/sqrt(2)*100),:) = 1;
%crosshair_mask(:,(50/2*100-5/sqrt(2)*100):(50/2*100+5/sqrt(2)*100)) = 1;
crosshair_mask((50/2*100-5*100):(50/2*100+5*100),:) = 1;
crosshair_mask(:,(50/2*100-5*100):(50/2*100+5*100)) = 1;

crosshair_mask=1-crosshair_mask;
final_mask=r1_mask+crosshair_mask;
stage_2=stage_1.*cat(3,final_mask,final_mask,final_mask);

imwrite(imresize(stage_2,1/100),'fixation.bmp');