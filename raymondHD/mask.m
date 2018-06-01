function mTSD = Mask(tsd, varargin)
%
% mTS = ts/Mask(ts, TrialPairs....)
%
% INPUTS:
%    ts = ts object
%    TrialPairs = pairs of start/end times (can be matrices of n x 2)
%                 NOTE: must be SAME units as tsd!
%
% OUTPUTS:
%    mts = ts object with times *not* in TrialPairs set to NaN
%
% ADR 1998
% version L4.1 
% v4.1  jcj verified compatibility with units, no major changes made



% Unwrap trial pairs
MaskOFF = [StartTime(tsd)-1];
MaskON = []; 
for iTP = 1:length(varargin)
   curMask = varargin{iTP};
   MaskOFF = cat(1, MaskOFF, curMask(:,2));
   MaskON = cat(1,MaskON, curMask(:,1));
end
MaskON = cat(1, MaskON, EndTime(tsd)+1);
nTransitions = length(MaskON);
MaskON = sort(MaskON);
MaskOFF = sort(MaskOFF);

% Construction output tsd
mTSD = tsd;

% Now implement mask
for iT = 1:nTransitions
   f = find(mTSD.t > MaskOFF(iT) & mTSD.t < MaskON(iT));
   mTSD.t(f) = NaN;
end
