function [ rawData, param ] = readRadialRawData( filepathRawData, param )
%readRadialRawData 

if strcmp(param.mapVBVD, 'new')
    fprintf('Reading data with mapVBVD... \n')
    
    % VBVD multi (reads multi-twix)
    
    twix_obj = mapVBVD(filepathRawData); % Unmodified from IDEA user forum
    %twix_obj = mapVBVD_JH(filepathRawData); % Can handle large files (>2^16 lines)

    if iscell(twix_obj)
        twix_obj = twix_obj{end};
    end
    
    %param.FoV = twix_obj.hdr.Meas.FOV;
        
    twix_obj.image.flagIgnoreSeg = true; % Essential to read the data correctly        
    rawData = twix_obj.image{''}; % Get squeezed image
    rawData = permute(rawData,[1 3 2]); % Swap order of coils and lines
    
    % Coil names are read with VBVD
    try
        coilStruct = twix_obj.hdr.MeasYaps.sCoilSelectMeas.aRxCoilSelectData{1,1}.asList;
        for coilNbr = 1:twix_obj.image.NCha
            param.coilNames{coilNbr} = coilStruct{1,coilNbr}.sCoilElementID.tElement; 
        end
    catch
            disp('Coils could not be read.')
    end
else
    % Can handle large files (>2^16 lines)
    [twix_obj, rawData] = fReadSiemensRawData_simo( filepathRawData );
end

% Shift max of lines to their center
if isfield(param, 'shiftLinesToCenter') && param.shiftLinesToCenter
    rawData = shiftLines(rawData);
end

%--------------------------------------------------------------------------
% Initialize parameters
%--------------------------------------------------------------------------
tic; %Start stopwatch after loading the data

%****** ACQUISITION PARAMETERS ******%
param.Np       = double(twix_obj.image.NCol);              % Number of samples per line (readout)
param.Nshot    = double(twix_obj.image.NSeg);              % Number of heartbeats (shots)
param.Nseg     = double(twix_obj.image.NLin/param.Nshot);  % Number of segments per heartbeat (shot)
param.Nlines   = double(twix_obj.image.NLin);              % Total number of lines (readouts)
param.Ncoil    = double(twix_obj.image.NCha);              % Number of coils

%****** TIME DATA ******%
if strcmp(param.mapVBVD, 'new')
    %New version of VBVD uses lowercase letters
    PMUTimeStamp    = double( twix_obj.image.pmutime );
    TimeStamp       = double( twix_obj.image.timestamp );
    TimeStamp       = TimeStamp - min(TimeStamp);
    PMUTimeStamp_ms = PMUTimeStamp * 2.5;
    TimeStamp_ms    = TimeStamp * 2.5;    
    TimeStamp_s     = TimeStamp_ms / 1000;
    param.TimeStamp_ms = TimeStamp_ms;
    param.PMUTimeStamp_ms = PMUTimeStamp_ms;
    param.TimeStamp_s = TimeStamp_s;
    param.PMUTimeStamp_s = param.PMUTimeStamp_ms / 1000;
else
    % fReadSimo
    PMUTimeStamp    = double( twix_obj.image.PMUTimeStamp );
    TimeStamp       = double( twix_obj.image.TimeStamp );
    TimeStamp       = TimeStamp - min(TimeStamp);
    PMUTimeStamp_ms = PMUTimeStamp * 2.5;
    TimeStamp_ms    = TimeStamp * 2.5;
    TimeStamp_s     = TimeStamp_ms / 1000;
    param.TimeStamp_ms = TimeStamp_ms;
    param.PMUTimeStamp_ms = PMUTimeStamp_ms;
    param.TimeStamp_s = TimeStamp_s;
    param.PMUTimeStamp_s = param.PMUTimeStamp_ms / 1000;
end

if isfield(param, 'trajectory_correction') && param.trajectory_correction
    rawData = angularSystemDelayCorrection_JH( rawData, param ); %TBD: Set trajectory automatically
end

