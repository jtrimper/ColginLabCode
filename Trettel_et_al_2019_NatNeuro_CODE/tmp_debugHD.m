empties =  [1     2    11     5     1     2; %CONFIRMED: neither are HD
    1     2    13     8     1     2; %CONFIRMED: neither are HD
    1     4    10     4     1     2; %CONFIRMED: neither are HD
    2     1    10     8     4     2; %THESE ARE THE SAME UNIT!!
    6     1    21     8     2     2; %THESE ARE THE SAME UNIT!!
    6     1    22     8     4     2; %THESE ARE THE SAME UNIT!!
    6     1    23     8     5     2]; %THESE ARE THE SAME UNIT!!

reg = 1;
t = 2;
d = 1;

for e = 1:size(empties,1)
    r = empties(e,1);
    s = empties(e,2);
    uNum = empties(e,3);
    uID = empties(e,4:5);
    hdDists = zeros(60,2,2);
    gcUIDs = [];
    
    %% GET HEAD DIRECTION DISTRIBUTION FOR THE NON-GRID CELL WITH THAT ID
    amtTime = zeros(60,1);
    numSpks = zeros(60,1);
    for b = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout)
        
        %Add up time facing each direction
        amtTime = amtTime + region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(uNum).spkHDDist(:,2);
        
        %Add up # of spikes in each direction
        numSpks = numSpks + region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(uNum).spkHDDist(:,3);
        
        
        if b == 1
            
            %Get radial bin centers (list 'em for each unit; they won't change across units)
            hdDists(:,1,1) = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(uNum).spkHDDist(:,1);
            hdDists(:,1,2) = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(uNum).spkHDDist(:,1);
            
            %Get list of GCs
            for u = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout(b).unit)
                uType = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).type;
                if uType == 1
                    gcUIDs = [gcUIDs; region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).ID]; %#ok
                end
            end
            
        end
    end
    hdDists(:,2,2) = numSpks ./ amtTime;
    
    
    %% GET HEAD DIRECTION DISTRIBUTION FOR THE GRID CELL WITH THAT ID
    gcInd = find(gcUIDs(:,1) == uID(1)   &   gcUIDs(:,2) == uID(2));
    amtTime = zeros(60,1);
    numSpks = zeros(60,1);
    hdMod = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(gcInd).hdMod;
    for b = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout)
        
        %Add up time facing each direction
        amtTime = amtTime + region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(gcInd).spkHDDist(:,2);
        
        %Add up # of spikes in each direction
        numSpks = numSpks + region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(gcInd).spkHDDist(:,3);
        
    end
    hdDists(:,2,1) = numSpks ./ amtTime;
    
    
    %% PLOT THE DATA
    figName = ['R' num2str(r) '; S' num2str(s) '; Unit ' num2str(gcInd)];
    figure('Position', [342 248 1112 491], 'name', figName);
    angles = zeros(1,240);
    angles(3:4:end) = hdDists(:,1,1);
    angles(6:4:end) = hdDists(1:end-1,1,1);
    
    subplot(1,2,1);
    frDist = zeros(1,240);
    frDist(2:4:end) = hdDists(:,2,1);
    frDist(3:4:end) = hdDists(:,2,1);
    
    polar(angles, frDist);
    title(['Grid Cell (HD Mod = ' num2str(hdMod) ')']);
    
    subplot(1,2,2);
    frDist = zeros(1,240);
    frDist(2:4:end) = hdDists(:,2,2);
    frDist(3:4:end) = hdDists(:,2,2);
    
    polar(angles, frDist);
    title('Non-Grid Cell');
    
end
