% corrProj_5_0_attachGridFieldInfoUsingNewMethod
%
% PURPOSE: 
%  To attach statistics for each grid cell's grid field. These are attached to eah grid cell
%  within each bout. The statistics attached are orientation, grid field size, and the coordinates
%  for the ellipse that defines the grid field in the autocorrelogram. 
%
%  Run this as a script, not a function, and update the variables at the top of the function 
%  if you need to pick up after fucking up. 
%
%  This function requires manual input for each unit/bout. You need to tell it whether the
%  auto-selected grid is correct, and if not, which peaks in the autocorrelation matrix should
%  define the grid instead. 
%
% JBT 1/4/2018
% Colgin Lab


rStart = 1;
sStart = 1;
bStart = 1;
uStart = 1;

reg = 1; %MEC
d = 1; %Day 1
t = 2; %Open Field


for r = rStart:length(region(reg).rat)
    fprintf('%s (%d/%d)\n', region(reg).rat(r).name, r, length(region(reg).rat));
    
    
    if r == rStart
        sesNums = sStart:length(region(reg).rat(r).session);
    else
        sesNums = 1:length(region(reg).rat(r).session);
    end
    
    
    for s = sesNums
        fprintf('\tSession %d/%d\n', s, length(region(reg).rat(r).session))
        
        GCs = [];
        for u = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout(1).unit)
            if region(reg).rat(r).session(s).day(d).task(t).bout(1).unit(u).type == 1
                GCs = [GCs u]; %#ok
            end
        end
        numGCs = length(GCs);
        
        if s == sStart && r == rStart
            boutNums = bStart:length(region(reg).rat(r).session(s).day(d).task(t).bout);
        else
            boutNums = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout);
        end
        
        for b = boutNums
            fprintf('\t\tBlock %d/%d\n', b, length(region(reg).rat(r).session(s).day(d).task(t).bout));
            
            if b == bStart && s == sStart && r == rStart
                uNums = uStart:length(region(reg).rat(r).session(s).day(d).task(t).bout(b).unit);
            else
                uNums = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout(b).unit);
            end
            
            
            for u = uNums
                if region(reg).rat(r).session(s).day(d).task(t).bout(1).unit(u).type == 1
                    if isfield(region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u), 'gridSize')
                        if isempty(region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).gridSize)
                            fprintf('\t\tUnit %d/%d [R%d,S%d,B%d]\n', u, numGCs, r, s, b);
                            rateMap = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).rateMap;
                            autoCorr = rateMapXCorr(rateMap, rateMap);
                            [gridSize, gridOrientation, ellipseCoords] = get_gridfield_stats(autoCorr);
                            
                            region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).gridSize = gridSize;
                            region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).gridOrientation = gridOrientation;
                            region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).ellipseCoords = ellipseCoords;
                        end
                    else
                        fprintf('\t\tUnit %d/%d [R%d,S%d,B%d]\n', u, numGCs, r, s, b);
                        rateMap = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).rateMap;
                        autoCorr = rateMapXCorr(rateMap, rateMap);
                        [gridSize, gridOrientation, ellipseCoords] = get_gridfield_stats(autoCorr);
                        
                        region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).gridSize = gridSize;
                        region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).gridOrientation = gridOrientation;
                        region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).ellipseCoords = ellipseCoords;
                    end
                end
            end %unit
        end %bout
        
    end %session
end %rat