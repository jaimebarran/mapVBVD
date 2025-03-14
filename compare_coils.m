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

% Find the subject with the highest number of coils
num_coils = max(cellfun(@length, CoilNames));  % Get the maximum number of coils

for i = 1:num_coils
    fprintf('Coil %d: ', i);
    fprintf('\n');
    
    % Get the coil name for each subject, safely handle exceeding indices
    names = cell(1, length(subjects));  % Initialize a cell array for names
    for subj = 1:length(subjects)
        if i <= length(CoilNames{subj})  % Check if the coil index is valid for the subject
            names{subj} = CoilNames{subj}{i};  % Assign the coil name
        else
            names{subj} = 'None';  % Assign 'None' if the index is out of bounds
        end
    end
    
    % Debug: Print the sizes of CoilNames for each subject
    fprintf('Coil list sizes: ');
    fprintf('%d ', cellfun(@length, CoilNames));  % This will print the number of coils for each subject
    fprintf('\n');
    
    if all(cellfun(@(x) strcmp(x, names{1}), names))
        fprintf('%s (Same in all subjects)\n', names{1});
    else
        fprintf('Different across subjects: ');
        fprintf('%s ', names{:});  % Dynamically print the names for all subjects
        fprintf('\n');
    end
end
