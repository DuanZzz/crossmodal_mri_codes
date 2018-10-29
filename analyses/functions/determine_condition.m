function [cond_name,cond_element] = determine_condition(id_str)
a_ID = id_str{1};
size_ID = id_str{1};
brightness_ID = id_str{2};
pitch_ID = id_str{3};
loc_ID = id_str{4};
%% auditory-only and audiovisual conditions
% A OR AV
if isequal(a_ID,'0')
%{    
if isequal(pitch_ID,'1')
        tag_a = 'A_High_Pitch_';
    elseif isequal(pitch_ID,'2')
        tag_a = 'A_Low_Pitch_';
end
%}
    tag_a = 'A_';
else
    tag_a = 'AV_';
end
%% pitch-size
% PS_CON OR PS_INCON
if isequal(pitch_ID,'1') && isequal(size_ID,'1')
    tag_PS = 'PS_INCON_';
elseif isequal(pitch_ID,'1') && isequal(size_ID,'2')
    tag_PS = 'PS_CON_';
elseif isequal(pitch_ID,'2') && isequal(size_ID,'1')
    tag_PS = 'PS_CON_';
elseif isequal(pitch_ID,'2') && isequal(size_ID,'2')
    tag_PS = 'PS_INCON_';
end
%% pitch-brightness
% PB_CON OR PB INCON
if isequal(pitch_ID,'1') && isequal(brightness_ID,'1')
    tag_PB = 'PB_CON_';
elseif isequal(pitch_ID,'1') && isequal(brightness_ID,'2')
    tag_PB = 'PB_INCON_';
elseif isequal(pitch_ID,'2') && isequal(brightness_ID,'1')
    tag_PB = 'PB_INCON_';
elseif isequal(pitch_ID,'2') && isequal(brightness_ID,'2')
    tag_PB = 'PB_CON_';
end
%% location
switch loc_ID
    case '1'
        tag_l = 'L2';
    case '2'
        tag_l = 'L1';
    case '3'
        tag_l = 'Z';
    case '4'
        tag_l = 'R1';
    case '5'
        tag_l = 'R2';
end

%% ouput
if isequal(tag_a(1:2), 'A_')
    cond_name = [tag_a tag_l];
    cond_element = {tag_a tag_l};
else
    cond_name = [tag_a tag_PS tag_PB tag_l];
    cond_element = {tag_a tag_PS tag_PB tag_l};
end

