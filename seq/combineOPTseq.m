%% zero the world
clear,clc
restoredefaultpath;
%% load functions
fun_dir = fullfile(pwd,'functions');
addpath(genpath(fun_dir));
%% get target folder and seq
targetFolder = kb_ls(fullfile(pwd,'Subj_*'));
for i=1:numel(targetFolder)
    block_seqs = kb_ls(fullfile(targetFolder{i},'block_*.txt'));
    for j=1:numel(block_seqs)
        if isequal(j,1)
            temp = importdata(block_seqs{j});
        else
            addtemp = importdata(block_seqs{j});
            temp = [temp;addtemp];
        end
    end
    temp_sets{i} = temp;
    disp(['target combined # subj' sprintf('%02d',i)])
end
%% output seq
for k=1:numel(temp_sets)
    dlmwrite(['seq_subj_' sprintf('%02d',k) '.txt'],temp_sets{k},'delimiter','\t','newline','pc');
end