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
    % fprintf('Coil Names for Subject %d:\n', subj);
    % disp(CoilNames{subj});
end

%% Compare Coil Orders Across Subjects
fprintf('=== Coil Order Comparison ===\n');

% Find the subject with the highest number of coils
num_coils = max(cellfun(@length, CoilNames));  % Get the maximum number of coils

fprintf('Channels: ');
fprintf('%d ', cellfun(@length, CoilNames));  % This will print the number of coils for each subject
fprintf('\n')

for i = 1:num_coils
    fprintf('Coil %02d -- ', i);
    
    % Get the coil name for each subject, safely handle exceeding indices
    names = cell(1, length(subjects));  % Initialize a cell array for names
    for subj = 1:length(subjects)
        if i <= length(CoilNames{subj})  % Check if the coil index is valid for the subject
            names{subj} = CoilNames{subj}{i};  % Assign the coil name
        else
            names{subj} = 'None';  % Assign 'None' if the index is out of bounds
        end
    end
    
    if all(cellfun(@(x) strcmp(x, names{1}), names))
        fprintf('IDs: ');
        fprintf('%s ', names{:});
        fprintf('(Same in all subjects)\n')
    else
        fprintf('IDs: ');
        fprintf('%s ', names{:});
        fprintf('(Different across subjects) \n');
    end
end

%% Reorder the coils

% Create a new variable for reordered coil names
CoilNamesReordered = CoilNames;

% Determine the smallest set of coil IDs (subject with the least channels)
[min_size, min_idx] = min(cellfun(@numel, CoilNames));
reference_coils = string(CoilNames{min_idx}); % Ensure reference_coils is a string array

% Standardize coil lists to match the smallest set
for i = 1:length(CoilNames)
    CoilNamesReordered{i} = string(CoilNames{i}); % Convert to string array if necessary
    CoilNamesReordered{i} = CoilNamesReordered{i}(ismember(CoilNamesReordered{i}, reference_coils));
end

% Print the header and channel counts
fprintf('\n=== Reordered Coil IDs ===\n');
fprintf('Channels: %d %d %d \n\n', numel(CoilNamesReordered{1}), numel(CoilNamesReordered{2}), numel(CoilNamesReordered{3}));

% Loop through and print each coil with its corresponding IDs
for i = 1:length(CoilNamesReordered{1}) % Loop through each coil
    coil_id_1 = CoilNamesReordered{1}(i); % Subject 1
    coil_id_2 = CoilNamesReordered{2}(i); % Subject 2
    coil_id_3 = CoilNamesReordered{3}(i); % Subject 3
    
    % Determine if coil IDs are the same across subjects
    if isequal(coil_id_1, coil_id_2) && isequal(coil_id_2, coil_id_3)
        status = 'Same in all subjects';
    else
        status = 'Different across subjects';
    end
    
    % Print the coil ID with status in the requested format
    fprintf('Coil %02d -- IDs: %s %s %s (%s)\n', i, coil_id_1, coil_id_2, coil_id_3, status);
end