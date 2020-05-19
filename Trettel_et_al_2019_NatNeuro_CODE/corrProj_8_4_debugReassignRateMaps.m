function region = corrProj_8_4_debugReassignRateMaps(newRegion, oldRegion)
% function region = corrProj_8_4_debugReassignRateMaps(newRegion, oldRegion)
%
% PURPOSE:
%   I want to see if using 3cm spatial bins changes the pattern of results so
%   this is to take the new rate maps and assign them to the structure
%   that already has spike times and state times attached.
%
% INPUT:
%   newRegion = region structure containing the rate maps you WANT to use
%   oldRegion = region structure containing the rate maps you want to REPLACE
%
% OUTPUT: 
%   region = oldRegion, but with the new rate maps
%
% JBT 9/2017
% Colgin Lab



for reg = 1:2
    for r = 1:length(newRegion(reg).rat)
        for s = 1:length(newRegion(reg).rat(r).session)
            for d = 1
                
                if reg == 1 %MEC
                    tNum = 2; %Open Field
                else %CA1
                    tNum = 1; %Circular Track
                end
                
                for b = 1:length(newRegion(reg).rat(r).session(s).day(d).task(tNum).bout)
                    for u = 1:length(newRegion(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit)
                        if newRegion(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u).type == 1 %if grid cell
                            oldRegion(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u).rateMap = ...
                                newRegion(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u).rateMap;
                        end %if grid cell or CA1 pyram
                    end %unit
                end %bout
            end %day
        end %session
    end %rat
end %region

region = oldRegion; 

end %fnctn


