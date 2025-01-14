%%
raw_data = ['/Users/cag/Documents/Dataset/' ...
    '20241002_MRIAcquisition_Yiwei/PrePilot_YiweiJia/Raw/' ...
    'meas_MID00273_FID178443_BEAT_LIBREon_T2_eye_(23_09_24).dat'];
<<<<<<< HEAD

twix = mapVBVD_JB(raw_data);
=======
>>>>>>> e6d59d0465e71b8f2dd375b96a6f38ac2e76fe6a

twix = mapVBVD_JB(raw_data);
<<<<<<< HEAD

=======
>>>>>>> e6d59d0465e71b8f2dd375b96a6f38ac2e76fe6a

%%
% return all image-data
image_data = twix.image();
% return all image-data with all singular dimensions removed/squeezed:
image_data = twix.image{''}; % '' necessary due to a matlab limitation
% return only data for line numbers 1 and 5; all dims higher than 4 are
% grouped into dim 5):
image_data = twix.image(:,:,[1 5],:,:);
% return only data for coil channels 2 to 6; all dims higher than 4 are
% grouped into dim 5); but work with the squeezed data order
% => use '{}' instead of '()':
image_data = twix.image{:,2:6,:,:,:};

%%
image_data = twix.image.unsorted(); % no slicing supported atm