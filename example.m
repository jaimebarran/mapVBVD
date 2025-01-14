%%
raw_data = ['/Users/cag/Documents/Dataset/' ...
    '20241002_MRIAcquisition_Yiwei/PrePilot_YiweiJia/Raw/' ...
    'meas_MID00273_FID178443_BEAT_LIBREon_T2_eye_(23_09_24).dat'];

twix = mapVBVD_JB(raw_data);

%%
raw_data = ['/home/debi/jaime/repos/mapVBVD/data/' ...
    'MultiRaidFileExtract_ECG_demo-20241115T103256Z-001/' ...
    'MultiRaidFileExtract_ECG_demo/data/meas_MID00211_FID122713_BEAT_2Dga_baseline.dat'];
twix = mapVBVD_JB(raw_data);


%%
% return all image-data
image_data = twix{1,2}.image();
% return all image-data with all singular dimensions removed/squeezed:
image_data = twix{1,2}.image{''}; % '' necessary due to a matlab limitation
% return only data for line numbers 1 and 5; all dims higher than 4 are
% grouped into dim 5):
image_data = twix{1,2}.image(:,:,[1 5],:,:);
% return only data for coil channels 2 to 6; all dims higher than 4 are
% grouped into dim 5); but work with the squeezed data order
% => use '{}' instead of '()':
image_data = twix{1,2}.image{:,2:4,:,:,:};
%
image_data = twix{1,2}.image.unsorted(); % no slicing supported atm