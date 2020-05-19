function clusterRegion = get_cluster_stats_from_region_struct(region)
% function clusterRegion = get_cluster_stats_from_region_struct(region)
%
% PURPOSE: 
%   Function will pull unit data, and only unit data, from each the region structure
%   and attach it to ouutput structure clusterRegion. This is to be done after cluster
%   quality structures are attached to each unit for the purpose of cluster quality analyses. 
%
% INPUT: 
%   region 

d = 1; %Day 1

for reg = 1:2
% for reg = 1 %MEC only
for r = 1:length(region(reg).rat)
    for s = 1:length(region(reg).rat(r).session)
        for t = 1:3
            for b = 1:length(region(reg).rat(r).session(s).day(1).task(t).bout)
                for u = 1:length(region(reg).rat(r).session(s).day(1).task(t).bout(b).unit)
                    
                    % Unit ID
                    clusterRegion(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).ID = ...
                        region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).ID; %#ok
                    
                    % Number of Spikes
                    clusterRegion(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).type = ...
                        region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).type; %#ok
                    
                    % Type (grid/place or not)
                    clusterRegion(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).numSpks = ...
                        length(region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).spkTms); %#ok
                    
                    % Cluster quality stats
                    clusterRegion(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).clusterQual = ...
                        region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).clusterQual; %#ok
                    
                end %unit
            end %bout
        end %task
    end %session
end %rat
end %region

