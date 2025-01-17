clear
clc
%% parameter
v_size = 2;
v_lightness = 2;
snd_pitch = 2;
snd_location = 5;
repeat = 3;
%% block
%block_count = 10;
%for jj=1:block_count
%% inital seq except no sound control
ii = 1;
for i=1:v_size
    for j=1:v_lightness
        for k=1:snd_pitch
            for l=1:snd_location
                seq(ii,1)=i;
                seq(ii,2)=j;
                seq(ii,3)=k;
                seq(ii,4)=l;
                ii = ii + 1;
            end
        end
    end
end
seq = repmat(seq,repeat, 1);
%% inital seq only no sound control
ii = 1;
seq_control=zeros(snd_pitch*snd_location,4);
for i=1:snd_pitch
    for j=1:snd_location
        seq_control(ii,3)=i;
        seq_control(ii,4)=j;
        ii = ii + 1;
    end
end
seq_control = repmat(seq_control,repeat, 1);
%% comb inital seq
final_seq = [seq;seq_control];
%% save it
%save seq_forOPT.txt final_seq -ascii
dlmwrite('seq_forOPT_block_150.txt',final_seq,'delimiter','\t','newline','pc');
%dlmwrite(['seq_forOPT_block_' sprintf('%02d',jj) '.txt'], final_seq,'delimiter','\t','newline','pc');
clear seq  seq_control  final_seq
%end
%% TIDY DIR
for i=18:30
    mkdir(['Subj_',num2str(i)])
end
i=21;
%% move to folder
flist = dir('block*');
for j=1:10
    movefile(flist(j).name,['Subj_',num2str(i)])
end
i=i+1;