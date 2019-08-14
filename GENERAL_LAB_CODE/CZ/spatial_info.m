function [spatial_info_all]=spatial_info(rateMaps_all,timeMaps_all,mapAxis)
% rateMaps_all  is the ratemap of whole session
% timeMaps_all is the time map of the whole session
% mapAxis is the x (or y) axis

len=length(mapAxis);
Nc=size(rateMaps_all,2);
Ss=size(rateMaps_all,1);
spatial_info_all=zeros(Ss,Nc);

for ss=1:Ss
    
for nc=1:Nc
    ratemap_all=rateMaps_all{nc,1};
    % calculate the ratemap for whole session, and get the place field bins
    fBins0 = fieldBins(ratemap_all,5);
    if isempty(fBins0)
        spatial_info_all(nc,1)=nan;
        continue
    end
    
    % use the whole map, not limit the ratemap into the place field
    ratemap_all=reshape(rateMaps_all{nc,1},len*len,1);
    time_all = reshape(timeMaps_all{nc,1},len*len,1);
    ind=find(~isnan(ratemap_all));
    ratemap_all=ratemap_all(ind);
    Pxx_all = time_all(ind)./sum(time_all(ind));
    
    % spatial information content
    infor_all = 0;
    for nb = 1:length(ind)
        infor_all = infor_all + Pxx_all(nb) * (ratemap_all(nb)/mean(ratemap_all)) * log2(ratemap_all(nb)/mean(ratemap_all));
    end
    spatial_info_all(Ss,Nc) = infor_all;
end
end