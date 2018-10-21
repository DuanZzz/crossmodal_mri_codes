%% zero the world
clear,clc
restoredefaultpath;
%% load functions
fun_dir = fullfile(pwd,'functions');
toolbox_dir = fullfile(pwd,'toolbox');
addpath(genpath(fun_dir));
addpath(genpath(toolbox_dir));
%% audio stim property
H_PITCH = 4500; % in hz
L_PITCH = 250; % in hz
A_DURATION = 100; % in ms
RAMPs = [10 10]; % in ms; linear ramps at on- and off-set
HEARING_DISTANCE = 50; % in cm

%% gen origin sound (no spatial information)
sampleRate = 44100; % in hz/s
duration = A_DURATION/1000; % in sec
time = linspace(0,duration,sampleRate*duration);
longtime = linspace(0,duration*100,sampleRate*duration*100);
% %% Opt amp for same dBA (Sound Level)
% % amplitude
H_AMP = 0.044;
L_AMP = 0.14;
% tagetdBA = 65;
% change_step = 0.01;
% opt_achive_index = 0;
% while opt_achive_index==0
    % gen
    dBA_tone_L_PITCH = L_AMP*sin(2*pi*L_PITCH*longtime);
    dBA_tone_L_PITCH_RAMP = linearRamp (dBA_tone_L_PITCH,RAMPs*(sampleRate/1000));
    audiowrite('dBA_tone_L_PITCH.wav',dBA_tone_L_PITCH_RAMP,sampleRate)

    dBA_tone_H_PITCH = H_AMP*sin(2*pi*H_PITCH*longtime);
    dBA_tone_H_PITCH_RAMP = linearRamp (dBA_tone_H_PITCH,RAMPs*(sampleRate/1000));
    audiowrite('dBA_tone_H_PITCH.wav',dBA_tone_H_PITCH_RAMP,sampleRate)
%
%     % measure
%     weightType = 'A-weighting';
%     % 'A-weighting' | 'C-weighting' | 'Z-weighting' (no weighting)
%     snd_name='dBA_tone_H_PITCH.wav';
%     h_pitch = reportdBA(snd_name,weightType);
%     snd_name='dBA_tone_L_PITCH.wav';
%     l_pitch = reportdBA(snd_name,weightType);
%
%     % check distance
%     h_dist = h_pitch - tagetdBA;
%     l_dist = l_pitch - tagetdBA;
%
%     % opt_index
%     if abs(h_dist)<0.5 && abs(l_dist)<0.5
%         opt_achive_index = 1;
%     end
%     disp(['L_AMP = ' num2str(L_AMP) ' ' 'H_AMP = ' num2str(H_AMP)]);
%     if opt_achive_index==0
%         % modify amplitude
%         if h_dist<0
%             H_AMP = H_AMP + change_step;
%         elseif h_dist>0
%             H_AMP = H_AMP - change_step;
%         end
%         if l_dist<0
%             L_AMP = L_AMP + change_step;
%         elseif l_dist>0
%             L_AMP = L_AMP - change_step;
%         end
%         disp(['change to ->' 'L_AMP = ' num2str(L_AMP) ' ' 'H_AMP = ' num2str(H_AMP)]);
%     else
%         disp(['done! fix to ->' 'L_AMP = ' num2str(L_AMP) ' ' 'H_AMP = ' num2str(H_AMP)]);
%     end
% end
%% results backup
H_AMP = 0.044;
L_AMP = 0.14;

tone_L_PITCH = L_AMP*sin(2*pi*L_PITCH*time);
tone_L_PITCH_RAMP = linearRamp (tone_L_PITCH,RAMPs*(sampleRate/1000));
audiowrite('tone_L_PITCH.wav',[tone_L_PITCH_RAMP,tone_L_PITCH_RAMP],sampleRate)

tone_H_PITCH = H_AMP*sin(2*pi*H_PITCH*time);
tone_H_PITCH_RAMP = linearRamp (tone_H_PITCH,RAMPs*(sampleRate/1000));
audiowrite('tone_H_PITCH.wav',[tone_H_PITCH_RAMP,tone_H_PITCH_RAMP],sampleRate)
%% if need: measure dBA
weightType = 'A-weighting';
%'A-weighting' | 'C-weighting' | 'Z-weighting' (no weighting)
snd_name='dBA_tone_L_PITCH.wav';
l_pitch_dBa = reportdBA(snd_name,weightType);
l_pitch_dB = reportdBA(snd_name,'Z-weighting');

snd_name='dBA_tone_H_PITCH.wav';
h_pitch_dBa = reportdBA(snd_name,weightType);
h_pitch_dB = reportdBA(snd_name,'Z-weighting');
%% prep HRTF
LOCATIONs = [-45 -25, -10, 0, 10, 25 45]; % in degree
%LOCATIONs = [0:45:360]; % in degree

SOFAstart
X = [0 0 0]; % head location (medial)
head_orientation = [0 0];
coordinate_system = 'spherical';
%hrtf = SOFAload([pwd filesep 'datasets' '/SCUT_KEMAR_radius_1.sofa']);
hrtf = SOFAload([pwd filesep 'datasets' '/QU_KEMAR_anechoic_all.sofa']);
conf = SFS_config;
conf.ir.usehcomp = true;
conf.ir.hcompfile = [pwd filesep 'datasets' '/QU_KEMAR_SennheiserHD25_hcomp.wav'];
conf.N = 4096;
%zLOCATIONs = [-30:5:90];
for i=1:length(LOCATIONs)
    xs = [rad(LOCATIONs(i)) 0 1];
    %xs = [0 rad(zLOCATIONs(i)) 0.5];
    ir = get_ir(hrtf,X,head_orientation,xs,coordinate_system,conf);
    hav = audioread('tone_H_PITCH.wav');
    lav = audioread('tone_L_PITCH.wav');
    hsig = auralize_ir(ir,hav,1,conf);
    lsig = auralize_ir(ir,lav,1,conf);
    
    hsig_RAMP = linearRamp(hsig,RAMPs*(sampleRate/1000));
    scale_hsig_RAMP = hsig_RAMP./max(max(hsig_RAMP))*H_AMP;
    
    lsig_RAMP = linearRamp(lsig,RAMPs*(sampleRate/1000));
    scale_lsig_RAMP = lsig_RAMP./max(max(lsig_RAMP))*L_AMP;
    
    
    %sound(scale_hsig_RAMP,conf.fs);
    %pause(0.5);
    
    audiowrite(['h_snd_loc_' num2str(LOCATIONs(i)) '.wav'],scale_hsig_RAMP,conf.fs);
    audiowrite(['l_snd_loc_' num2str(LOCATIONs(i)) '.wav'],scale_lsig_RAMP,conf.fs);
end
%% record info
fileID = fopen('mri_behv_part_para_audio.txt','w');
fprintf(fileID,'%6s %6s\n','High Freq','Low Freq');
fprintf(fileID,'%6.4f %6.4f\n',4500,250);
fprintf(fileID,'%6s %6s\n','High Freq dB','Low Freq dB');
fprintf(fileID,'%6.4f %6.4f\n',h_pitch_dB,l_pitch_dB);
fprintf(fileID,'%6s %6s\n','High Freq dBA','Low Freq dBA');
fprintf(fileID,'%6.4f %6.4f\n',h_pitch_dBa,l_pitch_dBa);
fclose(fileID);

%%
% Reference about dBa<https://www.engineeringtoolbox.com/decibel-d_59.html> 