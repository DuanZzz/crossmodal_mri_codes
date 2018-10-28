% This script initialises the path variables that are needed for running
% the Two!Ears Blackboard System module

basePath = fileparts(mfilename('fullpath'));

% Add all relevant folders to the matlab search path
addPathsIfNotIncluded([{ fullfile(basePath, 'src', 'blackboard_core'),...
                         fullfile(basePath, 'src', 'blackboard_data'),...
                         fullfile(basePath, 'src', 'evaluation'),...
                         fullfile(basePath, 'src', 'knowledge_sources') },...
                         strsplit(genpath(fullfile(basePath, 'src', 'tools')),pathsep) ]);

clear basePath;
