%% Clear
clc; clear;

%% Define Subjects
subjects = { ...
    'twix_subj1_meas_MID00605_FID182859_BEAT_LIBREon_eye_(23_09_24).mat', ...
    'twix_subj2_meas_MID00580_FID182834_BEAT_LIBREon_eye_(23_09_24).mat', ...
    'twix_subj3_meas_MID00554_FID182808_BEAT_LIBREon_eye_(23_09_24).mat' ...
};

data_path = '/home/debi/jaime/mreye_track/data/pilot/Twix/';

%% Load and Extract Coil Names for All Subjects
CoilNames = cell(1, length(subjects));

addpath('fix_jaime');

for subj = 1:length(subjects)
    % Load Twix data
    load(fullfile(data_path, subjects{subj}), 'twix');
    
    % Get coil information
    [~, ~, ~, ~, ~, CoilNames{subj}, ~] = Get_Coil_Info(twix.twix);
    
    % Display coil names for verification
    fprintf('Coil Names for Subject %d:\n', subj);
    disp(CoilNames{subj});
end

%% Compare Coil Orders Across Subjects
fprintf('\n=== Coil Order Comparison ===\n');

num_coils = length(CoilNames{1});

for i = 1:num_coils
    fprintf('Coil %d: ', i);
    names = cellfun(@(c) c{i}, CoilNames, 'UniformOutput', false);
    
    if isequal(names{:})
        fprintf('%s (Same in all subjects)\n', names{1});
    else
        fprintf('Different across subjects: %s | %s | %s\n', names{:});
    end
end
