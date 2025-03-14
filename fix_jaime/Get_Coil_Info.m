function [BodyCoils, SpineCoils, CoilMask, PTFLAG, NoiseMTX, CoilName, CoilScale] = Get_Coil_Info(twix_obj)
% Function to extract coil information from the twix object

% Initialize NoiseMTX
NoiseMTX = [];

% Check if twix_obj is a cell
if iscell(twix_obj)
    Noise = permute(twix_obj{1,1}.noise.unsorted, [1,3,2]);
    NoiseMTX = reshape(Noise, [size(Noise,1)*size(Noise,2), size(Noise,3)]);
    
    % Process noise measurements
    Noise = twix_obj{1,1}.noise();
    Noise = squeeze(mean(mean(mean(abs(Noise), 1), 3), 6));
    twix_obj = twix_obj{1,2}; % Extract correct part of twix_obj
else
    Noise = [];
end

% Extract coil list and scale factors
coil_list = twix_obj.hdr.MeasYaps.sCoilSelectMeas.aRxCoilSelectData{1,1}.asList;
scale_list = twix_obj.hdr.MeasYaps.sCoilSelectMeas.aRxCoilSelectData{1,1}.aFFT_SCALE;

% Preallocate arrays
nCoils = length(coil_list);
CoilADC = zeros(nCoils,1);
CoilScale = zeros(nCoils,1);
CoilName = cell(nCoils,1);
BodyCoils = false(nCoils,1);
SpineCoils = false(nCoils,1);
PTFLAG = false; % Initialize PTFLAG

% Extract ADC channels and scale factors
for iCoil = 1:nCoils
    CoilADC(iCoil) = coil_list{iCoil}.lADCChannelConnected;
    CoilScale(iCoil) = scale_list{iCoil}.flFactor;
end

% Sort coils based on ADC channel
[~, iCoilADC] = sort(CoilADC);
coil_list = coil_list(iCoilADC);
CoilScale = CoilScale(iCoilADC);
CoilName = CoilName(iCoilADC); % Apply the same sorting to CoilName

% Loop through coils to classify them
for iCoil = 1:nCoils
    % Extract coil identifiers
    coilID = coil_list{iCoil}.sCoilElementID.tCoilID;
    tElement = coil_list{iCoil}.sCoilElementID.tElement;

    % Detect Body_12 coil for PTFLAG
    if contains(coilID, 'Body_12')
        PTFLAG = true;
    end

    % Classify as Body or Spine coil
    if contains(tElement, {'B', 'FL', 'H', 'N'})
        BodyCoils(iCoil) = true;
    else
        SpineCoils(iCoil) = true;
    end

    % Store coil element name
    CoilName{iCoil} = tElement;
end

% Determine CoilMask based on noise measurements
if isempty(Noise)
    CoilMask = true(size(BodyCoils));
else
    CoilMask = ~isoutlier(Noise)';
end

% If no BodyCoils detected, assume all are BodyCoils
if sum(BodyCoils) == 0
    BodyCoils = true(size(BodyCoils));
end

end
