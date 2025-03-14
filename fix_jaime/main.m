%% MAIN
%% Clear
clc; clear all;
subject_num = 1;
%% Load twix objects
% addpath('twix_process_yj');
if subject_num == 1
    rawdata_name = 'meas_MID00605_FID182859_BEAT_LIBREon_eye_(23_09_24)';
    load(['/home/debi/jaime/mreye_track/data/pilot/Twix/' ...
        'twix_subj1_meas_MID00605_FID182859_BEAT_LIBREon_eye_(23_09_24).mat']);
    datadir = ['/home/debi/jaime/mreye_track/data/pilot/' ...
        'sub-01/rawdata/meas_MID00605_FID182859_BEAT_LIBREon_eye_(23_09_24).dat'];  
elseif subject_num == 2
    rawdata_name = 'meas_MID00580_FID182834_BEAT_LIBREon_eye_(23_09_24)';
    load(['/home/debi/jaime/mreye_track/data/pilot/Twix/' ...
        'twix_subj2_meas_MID00580_FID182834_BEAT_LIBREon_eye_(23_09_24).mat']);
    datadir = ['/home/debi/jaime/mreye_track/data/pilot/' ...
        'sub-02/rawdata/meas_MID00580_FID182834_BEAT_LIBREon_eye_(23_09_24).dat'];  
else
    rawdata_name = 'meas_MID00554_FID182808_BEAT_LIBREon_eye_(23_09_24)';
    load(['/home/debi/jaime/mreye_track/data/pilot/Twix/' ...
        'twix_subj3_meas_MID00554_FID182808_BEAT_LIBREon_eye_(23_09_24).mat']);
    datadir = ['/home/debi/jaime/mreye_track/data/pilot/' ...
        'sub-03/rawdata/meas_MID00554_FID182808_BEAT_LIBREon_eye_(23_09_24).dat'];  
end

%% Get Coil Info
addpath('fix_jaime');
[BodyCoils,SpineCoils,CoilMask,PTFLAG,NoiseMTX,CoilName,CoilScale] = Get_Coil_Info(twix.twix);

%%