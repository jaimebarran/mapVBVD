%% Yiwei Jia Nov 24 2024
% The script is specifically used for analyzing Twix and save some
% information as "report" for Dataset "MREyeTrack" acquired on Oct. 14 2024
% Output: determine the start of mri in ET time axis
% i.e. the offset from the first trigger to the start of MRI start.
%%
clc; clear all;
subject_num = 2;
%%
if subject_num == 1
    rawdata_name = 'meas_MID00605_FID182859_BEAT_LIBREon_eye_(23_09_24)';
    twix = load(['/home/debi/jaime/acquisitions/MREyeTrack/' ...
        'Twix/twix_subj1_meas_MID00605_FID182859_BEAT_LIBREon_eye_(23_09_24).mat']);
    datadir = ['/home/debi/jaime/acquisitions/MREyeTrack/' ...
    'MREyeTrack_subj1/RawData_MREyeTrack_Subj1/'];  
elseif subject_num == 2
    rawdata_name = 'meas_MID00580_FID182834_BEAT_LIBREon_eye_(23_09_24)';
    twix = load(['/home/debi/jaime/acquisitions/MREyeTrack/' ...
        'Twix/twix_subj2_meas_MID00580_FID182834_BEAT_LIBREon_eye_(23_09_24).mat']);
    datadir = ['/home/debi/jaime/acquisitions/MREyeTrack/' ...
    'MREyeTrack_subj2/RawData_MREyeTrack_Subj2/'];  
else
    rawdata_name = 'meas_MID00554_FID182808_BEAT_LIBREon_eye_(23_09_24)';
    twix = load(['/home/debi/jaime/acquisitions/MREyeTrack/' ...
        'Twix/twix_subj3_meas_MID00554_FID182808_BEAT_LIBREon_eye_(23_09_24).mat']);
    datadir = ['/home/debi/jaime/acquisitions/MREyeTrack/' ...
    'MREyeTrack_subj3/RawData_MREyeTrack_Subj3/'];  
end

%%
reportPath = ['/home/debi/jaime/acquisitions/MREyeTrack/Twix/' ...
    'report_subj' ...
    num2str(subject_num) ...
    '.mat'];
report = load(reportPath);
report = report.report;
mri_start = report{7,2};
mri_timestp = report{9,2};
mark_start = report{3,2};
(mark_start - mri_start)*2.5
%%

if subject_num == 1
    % The unit of ms
    first_trigger_interval = 1989.4;
    ET_trigger_dot = 498;% the value got from notebook
elseif subject_num == 2
    first_trigger_interval = 2006.6;
    ET_trigger_dot = 497;
else
    first_trigger_interval = 1994.0;
    ET_trigger_dot = 496;
end

offset_trigger_mriStart = (first_trigger_interval - (mark_start - mri_start) * 2.5) ;
offset_first_dot_mriStart = offset_trigger_mriStart - ET_trigger_dot;

%%
report{10, 1} = 'ET_trigger_dot';
report{10, 2} = ET_trigger_dot;

report{11, 1} = 'ET_offset_first_dot_mriStart';
report{11, 2} = offset_first_dot_mriStart;

save(reportPath, 'report');
disp('report has been saved here:')
disp(reportPath)