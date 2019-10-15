function pf = get_2d_pf_entries(coords, pf, minInPfDur, minAvgSpd)
% function pf = get_2d_pf_entries(coords, pf, minInPfDur, minAvgSpd)
%
%  **See 'NOTE' below **
%
% PURPOSE:
%  Function returns the indices for each epoch where the rat crossed into the
%  place fields defined in pfCms for at least minInPfDur ms at an average
%  speed of greater than minAvgSpeed cm/s.
%   - Method follows Schlesiger et al., 2012, Nat Neuro
%   - NOTE: This method will return all entries into the pf, including when
%           the rat turned around. Use 'get_2d_pf_passes' to get only 
%           the 'runs' where the rat crossed near the center of the pf 
%           on a relatively straight trajectory (following de Almeida et al., 2012)
%
% INPUT:
%        coords = nx3 matrix giving rat's positional information
%                 - Output of 'read_in_coords'
%            pf = data structure output of get_2d_pfs, containing indices and 
%                 scaled indices for place field boundaries
%    minInPfDur = minimum time in ms for the pf entry/exit to be considered a pass
%     minAvgSpd = minimum average speed while the rat is in the place-field
%                 for the pf entry/exit to be considered a pass
%
% OUTPUT:
%          pf = same as input structure but with additional subfield 'entries'
%               containing a matrix of frame time indices for the coords matrix
%                [i.e., entry of pf = coords(,1); exit of pf = coords(:,2)
%
% JB Trimper
% 09/2019
% Colgin Lab


tpf = mean(diff(coords(:,1))); %time per frame

%Get runspeed and smooth it out
rs = get_runspeed(coords); %runspeed
smRs = smooth_runspeed(rs);

for p = 1:length(pf)
    tmpPfInds = pf(p).cms;
    pf(p).entries = []; 
    
    inPfBnry = inpolygon(coords(:,2), coords(:,3), tmpPfInds(1,:), tmpPfInds(2,:));
    
    inPfChunks = bwconncomp(inPfBnry, 4);
    
    for c = 1:length(inPfChunks.PixelIdxList)
        tmpInds = inPfChunks.PixelIdxList{c};
        if length(tmpInds)*tpf >= minInPfDur/1000
            avgSpd = mean(smRs(tmpInds,2));
            if avgSpd >= minAvgSpd
                pf(p).entries = [pf(p).entries; tmpInds(1) tmpInds(end)];
            end
        end
    end
end


end %fnctn