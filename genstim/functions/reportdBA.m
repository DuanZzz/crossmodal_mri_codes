function report_dBA = reportdBA(snd_name,weightType)
source = dsp.AudioFileReader(snd_name);
fs = source.SampleRate;

% player = audioDeviceWriter('SampleRate',fs);
% 
% scope  = dsp.TimeScope('SampleRate',fs, ...
%     'TimeSpanOverrunAction','Scroll', ...
%     'TimeSpan',3,'ShowGrid',true, ...
%     'YLimits',[20 110],'AxesScaling','Auto', ...
%     'ShowLegend',true,'BufferLength',4*3*fs, ...
%     'ChannelNames', ...
%     {'Lt_AF','Leq_A','Lpeak_A','Lmax_AF'}, ...
%     'Name','Sound Pressure Level Meter');

SPL = splMeter('TimeWeighting','Fast', ...
    'FrequencyWeighting',weightType, ...
    'SampleRate',fs, ...
    'TimeInterval',2);

while ~isDone(source)
    x = source();
    %player(x);
    [~,~,~,Lmax] = SPL(x);
    %scope([Lt,Leq,Lpeak,Lmax])
end

release(source)
% release(player)
release(SPL)
% release(scope)

report_dBA = max(Lmax);
end

