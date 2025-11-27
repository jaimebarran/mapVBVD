%% Yiwei Jia Feb 03 2025
% The script is specifically used for analyzing Twix and save some
% information as "report" for Dataset "MREyeTrack" acquired on Jan. 27 2024
% ===========update information================================
% Instead of extracting EXT channel from PMUdata.raw.EXT, I fixed the try catch
% code block in mapVBVD_JB so that we can extract EXT directly from
% PMUdata.EXT, which shares the same timestamps as the raw measurements
%%
clc; clear all;
subject_num = 1;
% meas_MID00177_FID317803_yj_seq2
% meas_MID00182_FID317808_JB_LIBRE2p2_a8_woPERewinder
raw_data_idea = ['/Users/cag/Documents/Dataset/datasets/250917/', ...
     'meas_MID00182_FID317808_JB_LIBRE2p2_a8_woPERewinder.dat'];
twix_idea = mapVBVD_JB(raw_data_idea);

raw_data_pulseq = ['/Users/cag/Documents/Dataset/datasets/250917/', ...
     'meas_MID00177_FID317803_yj_seq2.dat'];
twix_pulseq = mapVBVD_JB(raw_data_pulseq);
%%
twix_img = twix{2};
PMU = twix_img.PMUdata;
%%
sum(sum(PMU.EXT))
sum(sum(PMU.raw.EXT.data))
twix_name = ['twix', '_MID00332_FID214628_BEAT_LIBREon_eye_(23_09_24)_sc_trigger'];
twix_path =  ['/Users/cag/Documents/Dataset/250127_acquisition/', twix_name,'.mat'];
disp(['Saving twix into', twix_path]);
save(twix_path, 'twix');

%%
if subject_num == 1
    rawdata_name = meas_name;
    twix = load(['/Users/cag/Documents/Dataset/250127_acquisition/' ...
        'twix_MID00332_FID214628_BEAT_LIBREon_eye_(23_09_24)_sc_trigger.mat']);
    datadir = ['/Users/cag/Documents/Dataset/250127_acquisition'];  
elseif subject_num == 2

else
    rawdata_name = 'meas_MID00554_FID182808_BEAT_LIBREon_eye_(23_09_24)';
    twix = load(['/Users/cag/Documents/Dataset/MREyeTrack/' ...
        'Twix/twix_subj3_meas_MID00554_FID182808_BEAT_LIBREon_eye_(23_09_24).mat']);
    datadir = ['/home/debi/jaime/acquisitions/MREyeTrack/' ...
    'MREyeTrack_subj3/RawData_MREyeTrack_Subj3/'];  
end

twix_image2 = twix.twix{1,2};
pmuEXT = twix_image2.PMUdata.EXT;
pmuTimestamp = twix_image2.image.timestamp;

%%
stop_time_ms = (pmuTimestamp(end)-pmuTimestamp(1)) * 2.5;
time_ms = linspace(0, stop_time_ms, length(pmuTimestamp));
ext1 = double(pmuEXT(1,:));
ext2 = double(pmuEXT(2,:));%remember to convert the data type, otherwise something wrong with rawTimestamp.
%
pmu_ext_table = array2table([pmuTimestamp(:)'; time_ms(:)' ; ext1(:)'; ext2(:)']', 'VariableNames', ...
    {'PMU_timestamp', 'PMU_time_ms', 'EXT1', 'EXT2'});

%%

pmu_mark_table = pmu_ext_table;
pmu_mark_table((pmu_ext_table.EXT1 == 0) & (pmu_ext_table.EXT2 == 0),:)=[];
%%
figure;
plot(time_ms(1:10*1000), pmu_ext_table.EXT1(1:10*1000), time_ms(1:10*1000), pmu_ext_table.EXT2(1:10*1000))
xlabel('time (ms)')
ylabel('pulse amplitude')
% figure;
% plot(time_ms(4000:8000), pmu_ext_table.EXT1(4000:8000), time_ms(4000:8000), pmu_ext_table.EXT2(4000:8000))
%%
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
disp('The report cell is generated!')
%%

reportPath = ['/home/debi/jaime/acquisitions/MREyeTrack/Twix/' ...
        'report_subj', num2str(subject_num),'.mat'];
save(reportPath, 'report');
disp('report has been saved here:')
disp(reportPath)

    % - Subject 001:  1309.5466 - 653.1547 
    % - Subject 002:  914.2604 - 257.8359 
    % - Subject 003:  775.1672 - 118.7039 