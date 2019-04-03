function ts1 = MaskByTSD(ts0, tsd0)
%
% ts1 = ts/MaskByTSD(ts0, tsd0)
% 
% INPUTS:
%    ts0 = ts object
%    tsd0 = tsd object
%
% OUTPUTS:
%    ts1 = ts only including times in which nearest tsd sample
%          is not NaN
%
% ADR 2000
% v 4.0: JCJ 3/3/2003 includes support for time units



if isempty(strmatch('units',fieldnames(ts0)))
    warning('units not specified: assuming units = sec (converstions preformed)' )
    unit ='sec';
else
    unit = ts0.units;
    
end



SpikesIn = Data(ts0);
nSpikes = length(SpikesIn);

tTime = Range(tsd0, unit);
tData = Data(tsd0);

for iS = 1:nSpikes
  if isnan(tData(binsearch(tTime, SpikesIn(iS))))
    SpikesIn(iS) = nan;
  end
end

ts1 = ts(SpikesIn(find(~isnan(SpikesIn))),unit);
