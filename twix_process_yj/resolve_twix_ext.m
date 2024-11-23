clc; clear all;
twix = load('/Users/cag/Documents/Dataset/MREyeTrack/Twix/twix_subj1_meas_MID00605_FID182859_BEAT_LIBREon_eye_(23_09_24).mat');
twix_image2 = twix.twix{1,2};
rawEXT = twix_image2.PMUdata.raw.EXT;
rawTimestamp = twix_image2.PMUdata.raw.EXT.TimeStamp;
rawEXTData = twix_image2.PMUdata.raw.EXT.data;

%%
stop_time_ms = (rawTimestamp(end)-rawTimestamp(1)) * 2.5;
rawTime_ms = linspace(0, stop_time_ms, length(rawTimestamp));
ext1 = double(rawEXTData(:,1));
ext2 = double(rawEXTData(:,2));%remember to convert the data type, otherwise something wrong with rawTimestamp.
%%
raw_pmu_ext = array2table([rawTimestamp'; rawTime_ms(:)' ; ext1(:)'; ext2(:)']', 'VariableNames', ...
    {'PMU_timestamp', 'PMU_time_ms', 'EXT1', 'EXT2'});


%%
rawdata_name = 'meas_MID00273_FID178443_BEAT_LIBREon_T2_eye_(23_09_24)';
datadir = ['/Users/cag/Documents/Dataset/' ...
    '20241002_MRIAcquisition_Yiwei/PrePilot_YiweiJia/Raw'];  
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
% The time diff between start of EXT and the first measurement of MRI:
% 
% diff_start_mri =
% 
%  -70.499999988824129/2.5 = 28
% 
% The time diff between start of EXT and the first mark of EXT:
% 
% diff_start_mark =
% 
%  -38.999999985098839
% 
% the first mark of EXT - the first mri measure:
% -31.5


% raw_pmu_ext.PMU_timestamp(1)  =   2.3334430.8
% raw_pmu_mark.PMU_timestamp(1)= 2.3334446.4