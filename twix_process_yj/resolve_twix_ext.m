clc; clear all;
subject_num = 2;

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

twix_image2 = twix.twix{1,2};
rawEXT = twix_image2.PMUdata.raw.EXT;
rawTimestamp = twix_image2.PMUdata.raw.EXT.TimeStamp;
rawEXTData = twix_image2.PMUdata.raw.EXT.data;

%
stop_time_ms = (rawTimestamp(end)-rawTimestamp(1)) * 2.5;
rawTime_ms = linspace(0, stop_time_ms, length(rawTimestamp));
ext1 = double(rawEXTData(:,1));
ext2 = double(rawEXTData(:,2));%remember to convert the data type, otherwise something wrong with rawTimestamp.
%
raw_pmu_ext = array2table([rawTimestamp'; rawTime_ms(:)' ; ext1(:)'; ext2(:)']', 'VariableNames', ...
    {'PMU_timestamp', 'PMU_time_ms', 'EXT1', 'EXT2'});


%%
rawdatafile = fullfile(datadir,strcat(rawdata_name, '.dat')); 

twix_obj = mapVBVD_JH(rawdatafile);
twix_obj = twix_obj{end};
% time stamps from the rawdata
mriTimeStamp       = double( twix_obj.image.timestamp );
mriTime_ms    = (mriTimeStamp - min(mriTimeStamp)) * 2.5;
%%
% STEP2: Cut the MultiRaid PMU structure to have the same starting point as the acquisition
% raw_pmu_ext([find(raw_pmu_ext.PMU_timestamp < mriTimeStamp(1)); find(raw_pmu_ext.PMU_timestamp > mriTimeStamp(end))],:)=[];
raw_pmu_ext([find(raw_pmu_ext.PMU_timestamp > mriTimeStamp(end))],:)=[];

raw_pmu_ext.PMU_time_ms = raw_pmu_ext.PMU_time_ms-min(raw_pmu_ext.PMU_time_ms);

%% Check the first event in eye tracker time axis

raw_pmu_mark = raw_pmu_ext;

raw_pmu_mark((raw_pmu_ext.EXT1 == 0) & (raw_pmu_ext.EXT2 == 0),:)=[];

diff_ms = diff(raw_pmu_mark.PMU_time_ms);
diff_stamp = diff(raw_pmu_mark.PMU_timestamp);
disp('The time diff between start of EXT and the first measurement of MRI:')
diff_start_mri = (raw_pmu_ext.PMU_timestamp(1) - mriTimeStamp(1))*2.5
disp('The time diff between start of EXT and the first mark of EXT:')
diff_start_mark = (raw_pmu_ext.PMU_timestamp(1) - raw_pmu_mark.PMU_timestamp(1))*2.5
disp('the first mark of EXT - the first mri measure:')
disp(num2str(diff_start_mri - diff_start_mark))

%% Generate a cell report
report={};
report{1,1}='pmu_timestp_start'; report{1,2}=raw_pmu_ext.PMU_timestamp(1);
report{2,1}='pmu_timestp_end'; report{2,2}=raw_pmu_ext.PMU_timestamp(end);
report{3,1}='pmu_mark_start'; report{3,2}=raw_pmu_mark.PMU_timestamp(1);
report{4,1}='pmu_mark_end'; report{4,2}=raw_pmu_mark.PMU_timestamp(end);
report{5,1}='raw_pmu_ext'; report{5,2}=raw_pmu_ext;
report{6,1}='raw_pmu_mark'; report{6,2}=raw_pmu_mark;

report{7,1}='mri_timestp_start'; report{7,2}=mriTimeStamp(1);
report{8,1}='mri_timestp_end'; report{8,2}=mriTimeStamp(end);
report{9,1}='mriTimeStamp'; report{9,2}=mriTimeStamp;
report{10,1}='ET_trigger_dot'; 
%
if subject_num == 1
    report{10,2}=498;
    trigger_interval = 1989.4;
elseif subject_num == 2
    report{10,2}=497;
    trigger_interval = 2006.6;
elseif subject_num == 3
    report{10,2}=496;
    trigger_interval = 1994;
end

report{11,1}='ET_offset_first_dot_mriStart'; report{11,2}=trigger_interval - report{10,2} - (report{3,2}-report{1,2})*2.5;
disp('The report cell is generated!')

%%

reportPath = ['/home/debi/jaime/acquisitions/MREyeTrack/Twix/' ...
        'report_subj', num2str(subject_num),'.mat'];
save(reportPath, 'report');
disp('report has been saved here:')
disp(reportPath)