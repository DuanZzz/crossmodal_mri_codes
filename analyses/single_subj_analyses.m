%% single subject analyses
% Subj 00 = Jinbo
% Subj 01 = Ruan
% Subj 02 = Duan
% Subj 03 = Cai
%% zero the world
clear,clc
restoredefaultpath;
%% target subj
targetSubj = 'subj_03';

%% load functions
fun_dir = fullfile(pwd,'functions');
toolbox_dir = fullfile(pwd,'toolbox');
addpath(genpath(fun_dir));
addpath(genpath(toolbox_dir));
%% load raw data
rootDir = '/Volumes/Data/Project/mri_data/';
rawDataFile = kb_ls(fullfile(rootDir, targetSubj, 'behv','*.csv'));
rawData = readtable(rawDataFile{1});
%% group data
target_data = rawData(:,{'visual_size', 'visual_brightness', 'audio_pitch','audio_location','button','RT'});
target_data.button = target_data.button - 1;
target_data = target_data(target_data.RT <= 1000,:);
target_data = target_data(target_data.RT > 200,:);
statarray = grpstats(target_data,{'visual_size', 'visual_brightness', 'audio_pitch','audio_location'},{'mean','gname'});
condition_data = array2table(table2array(table([cellfun(@str2num,statarray.gname),statarray.mean_button*100])));
condition_data.Properties.VariableNames={'vs','vb','ap','al','right_respon'};
%% vis results
temp = reshape(condition_data.right_respon,5,10);
temp_data = temp;
%% tag condition
for i=1:size(statarray.gname,1)
    [temp_name,temp_ele] =  determine_condition(statarray.gname(i,:));
    cond_tag{i,:}=temp_name;
    cond_ele{i,:}=temp_ele;
    clear temp_name temp_ele
end
%% output data
result = reshape(temp,1,50);
[uniName, uniIndex] = unique(cond_tag);
k = 1;
for i=1:length(uniIndex)
    check = cond_tag{uniIndex(i)};
    rec_idx = [];
    for j=1:size(cond_tag,1)
        if isequal(cond_tag{j},check)
            rec_idx = [rec_idx,j];
        end
    end
    if size(rec_idx,2)==2
        redunPart{k}=rec_idx;
        k=k+1;
    end
end
redunIdx = cell2mat(redunPart');
for i=1:size(redunIdx,1)
    temp = mean(result(redunIdx(i,:)));
    result(redunIdx(i,1)) = temp;
    result(redunIdx(i,2)) = nan;
end

exportTemp = array2table(result(find(1-isnan(result))));
exportTemp.Properties.VariableNames=cond_tag(find(1-isnan(result)))';

writetable(exportTemp,[targetSubj '.csv'],'WriteVariableNames',true);

%% visual check
temp_plot_data = reshape(result(find(1-isnan(result))),5,5);
p = plot(temp_plot_data);

legend('Audio Only','Audio-Visual PS-incon PB-con','Audio-Visual PS-con PB-incon','Audio-Visual PS-incon PB-incon','Audio-Visual PS-con PB-con','Location','northwest');
xticks([1,2,3,4,5])
xticklabels({'-22.5','-10','0','10','22.5'});
xlabel('Sound Location');
yticks([0,25,50,75,100]);
ylabel('Proportion of ''Right'' response');
p(1).LineWidth = 1;
p(1).LineStyle = '-';
p(1).Color = 'm';
p(1).Marker = 's';


p(2).LineWidth = 1;
p(2).LineStyle = '--';
p(2).Color = 'r';
p(2).Marker = 's';

p(3).LineWidth = 1;
p(3).LineStyle = '-.';
p(3).Color = 'b';
p(3).Marker = 's';

p(4).LineWidth = 1;
p(4).LineStyle = '--';
p(4).Color = 'b';
p(4).Marker = 's';

p(5).LineWidth = 1;
p(5).LineStyle = '-.';
p(5).Color = 'r';
p(5).Marker = 's';

grid on
grid minor

%% save fig
print(['curve_' targetSubj],'-dpng','-r300')
close all

%% left shift
p_debug = plot(temp_data(:,1:2));
grid on
grid minor

legend('Audio Only - High Pitch','Audio Only - Low Pitch','Location','northwest');
xticks([1,2,3,4,5])
xticklabels({'-22.5','-10','0','10','22.5'});
xlabel('Sound Location');
yticks([0,25,50,75,100]);
ylabel('Proportion of ''Right'' response');

p_debug(1).LineWidth = 1;
p_debug(1).LineStyle = '-';
p_debug(1).Color = 'r';
p_debug(1).Marker = 's';


p_debug(2).LineWidth = 1;
p_debug(2).LineStyle = '-';
p_debug(2).Color = 'b';
p_debug(2).Marker = 's';

print('high_low_pitch_check','-dpng','-r300')
close all

%% check Zero Loc Sound
%{
H_pitch = audioread('H_Z.wav');
L_pitch = audioread('L_Z.wav');
H_pitch_modify = audioread('H_Z_modify.wav');

subplot(1,3,1)
hist(L_pitch)
title('Low Pitch Amplitude Hist')

grid on
grid minor

subplot(1,3,2)
hist(H_pitch)

grid on
grid minor

subplot(1,3,3)
hist(H_pitch_modify)
grid on
grid minor

title('High Pitch Refined Amplitude Hist')
legend('Left Channel','Right Channel','Location','northeast');

print('snd_high_low_pitch_check','-dpng','-r300')
close all
%}
%% explore
p_explore = plot(temp_data);
grid on
grid minor

legend('Audio Only - High Pitch','Audio Only - Low Pitch','Big Size - High Brightness - High Pitch','Big Size - High Brightness - Low Pitch','Big Size - Low Brightness - High Pitch','Big Size - Low Brightness - Low Pitch','Small Size - High Brightness - High Pitch','Small Size - High Brightness - Low Pitch','Small Size - Low Brightness - High Pitch','Small Size - Low Brightness - Low Pitch','Location','northwest');
xticks([1,2,3,4,5])
xticklabels({'-22.5','-10','0','10','22.5'});
xlabel('Sound Location');
yticks([0,25,50,75,100]);
ylabel('Proportion of ''Right'' response');
p_explore(1).LineWidth = 3;
p_explore(1).LineStyle = '-.';
p_explore(1).Color = [46,139,87]./255;
p_explore(1).Marker = '*';

p_explore(2).LineWidth = 3;
p_explore(2).LineStyle = '-.';
p_explore(2).Color = 'r';
p_explore(2).Marker = '*';

print('explore_check','-dpng','-r300')
close all
