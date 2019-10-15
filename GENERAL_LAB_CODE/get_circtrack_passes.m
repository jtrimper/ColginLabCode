function pf = get_circtrack_passes(radPos, pf, coords)
% function pf = get_circtrack_passes(radPos, pf, coords)
%
% PURPOSE:
%  Function returns the indices for each epoch where the rat crossed through the place-field.
%
% INPUT:
%  radPos = radial position on the circular track; see employment
%  pf = structure; output of 'get_circtrack_pfs
%
% OUTPUT:
%    pf = same as input but with additional fields...
%        - pf.passes: includes the start and end index of the coords matrix for
%                     each time the rat passed through the field and all criteria were met
%
%
% JB Trimper
% 09/2019
% Colgin Lab



minRs = 5; %cm/s -- minimum runspeed during pass
%                   - original JBT default = 5 cm


%% GET RAT'S RUNSPEED FOR EACH FRAME AND SMOOTH IT
rs = get_runspeed(coords);
smRs = smooth_runspeed(rs);



%% FIND PASSES THROUGH EACH PF THAT MEET OUR CRITERIA
for p = 1:length(pf)
    ppCntr = 1;
    pf(p).passes = []; %empty catcher for pf passes indices
    
    pfRadPos = pf(p).radPos;
    startField = pfRadPos(1);
    endField = pfRadPos(end);
    
    pfLen = abs(rad2deg(circ_dist(deg2rad(startField), deg2rad(endField))));
    
    pfPassBnry = zeros(1,size(radPos,1));
    pfPassBnry(radPos(:,2)>=startField & radPos(:,2)<=endField) = 1;
    
    pfPassChunks = bwconncomp(pfPassBnry);
    for c = 1:length(pfPassChunks.PixelIdxList)
        
        tmpInds = pfPassChunks.PixelIdxList{c};
        passRs = smRs(tmpInds,2);
        
        %Make sure rat doesn't drop below specified runspeed
        if sum(passRs<minRs) == 0
            
            %Make sure rat is moving in constant direction
            if sum(diff(sign(circ_dist(deg2rad(radPos(tmpInds(1:end-1),2)), deg2rad(radPos(tmpInds(2:end),2)))))) == 0
                
                passDist = abs(rad2deg(circ_dist(deg2rad(radPos(tmpInds(1),2)), deg2rad(radPos(tmpInds(end),2)))));
                
                % Make sure rat traverses almost the whole field
                if passDist >= pfLen - 5 % a little room for bin rounding error
                    try
                        pf(p).passes = [pf(p).passes; tmpInds(1) tmpInds(end)];
                    catch;keyboard;end
                    pf(p).passPos{ppCntr} = radPos(tmpInds(1):tmpInds(end),2);
                    ppCntr = ppCntr + 1;
                end
                
            end %if rat moved in consistent direction
            
        end %if runspeed crit met
        
    end %chunks of inds passing through pf
end %placefield



end %fnctn