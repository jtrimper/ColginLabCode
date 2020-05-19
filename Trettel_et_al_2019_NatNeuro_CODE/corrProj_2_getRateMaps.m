function region = corrProj_2_getRateMaps(region)
% function region = corrProj_2_getRateMaps(region)
%
% PURPOSE:
%   Function to attach the rate map for each grid cell for each open field session
%   and for each CA1 cell for each Linear Track session.
%    NOTE: CA1 place cells are linearized circular track maps
%          MEC grid cells are binned 2D rate maps
%
% INPUT:
%   region = re-run project uber data structure
%
% OUTPUT:
%  region = same as input, but includes extra field 'ratemap' for each grid cell and CA1 cell
%
% JBT 8/29/2017
% Colgin Lab


runThresh = 5; %cm/s
gridBinSize = 2.5; %cm^2
fprintf('Using %d cm bins. Hit any key to acknowledge or Ctrl+C to cancel.\n', gridBinSize); 
pause; 
radBinSize = 5; %degrees - for binning radial rate maps
gWinWidth = 5; %bins - Gaussian window width (# degrees = gWinWidth * radBinSize)
vidSampRate = 29.96998; %frames per second

gridBinEdges = 0:gridBinSize:100-gridBinSize;
radBinEdges = 0:radBinSize:360-radBinSize; 

curDir = pwd;
dataDir = 'H:\CORR_PROJECT_RERUN\DATASET';
cd(dataDir);

for reg = 1:2
    %     for reg = 1
    fprintf('%s\n', region(reg).name)
    cd(region(reg).name)
    for r = 1:length(region(reg).rat)
        %         for r = 6
        fprintf('\t%s\n', region(reg).rat(r).name);
        cd(region(reg).rat(r).name)
        for s = 1:length(region(reg).rat(r).session)
            %             for s = 5
            fprintf('\t\tSession %d\n', s);
            cd(['Session' num2str(s)])
            for d = 1
                fprintf('\t\t\tDay %d\n', d);
                cd(['Day' num2str(d)])
                
                if reg == 1 %MEC
                    tNum = 2; %Open Field
                else %CA1
                    tNum = 1; %Circular Track
                end
                
                cd(region(reg).rat(r).session(s).day(d).task(tNum).name);
                fprintf('\t\t\t\t%s\n', region(reg).rat(r).session(s).day(d).task(tNum).name)
                
                
                goodU = [];
                for b = 1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout)
                    fprintf('\t\t\t\t\tBout %d\n', b);
                    cd(['Begin' num2str(b)]);
                    
                    
                    % READ IN RUNSPEED & COORDS, CO MOVING WINDOW AVERAGE ON RUNSPEED AND
                    instRs = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).instRs;
                    [mwRs, mwInds] = mw_avg(instRs,15,7,1); % moving window average the runspeed to 0.5 s windows with 0.23 s steps
                    mwRs = [instRs(1:mwInds(1)-1)' mwRs instRs(mwInds(end)+1:length(instRs))']; %#ok -- make the length of the moving window version match
                    velFilt = zeros(1,length(mwRs));
                    velFilt(mwRs>=runThresh) = 1;
                    coords = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).coords;
                    
                    
                    if reg == 1 %MEC
                        
                        %EMPTY MATRICES FOR AMOUNT OF TIME AND SPIKE COUNT
                        numBinSamps = zeros(floor(100/gridBinSize), floor(100/gridBinSize));
                        numBinSpks = zeros(floor(100/gridBinSize), floor(100/gridBinSize), length(region(reg).rat(r).session(s).day(d).task(tNum).bout(1).unit));
                        
                        
                        % GET AMOUNT OF TIME MOVING IN EACH GRID BIN
                        for x = 1:floor(100/gridBinSize) %100 cm/binSize = #Bins in x dim
                            xBinLims = [(x-1)*gridBinSize x*gridBinSize];
                            for y = 1:floor(100/gridBinSize) %100 cm/binSize = #Bins in x dim
                                yBinLims = [(y-1)*gridBinSize y*gridBinSize];
                                
                                binInds = find(coords(:,2)>=xBinLims(1) & coords(:,2)<=xBinLims(2)... %within the x bin
                                    & coords(:,3)>=yBinLims(1) & coords(:,3)<=yBinLims(2));
                                
                                if ~isempty(binInds)
                                    numBinSamps(x,y) = numBinSamps(x,y) + sum(velFilt(binInds));
                                end
                                
                            end %y (dim2)
                        end %x (dim1)
                        
                        
                        % GET THE SPIKE COUNT FOR EACH BIN WHILE THE RAT WAS ACTUALLY MOVING IN THAT BIN
                        for u = 1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit)
                            if region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u).type == 1 %if grid cell
                                goodU = [goodU u]; %#ok 
                                spkTms = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u).spkTms;
                                for st = 1:length(spkTms)
                                    stInd = find(coords(:,1)<=spkTms(st), 1, 'Last');
                                    if velFilt(stInd) == 1 %if rat was moving fast enough when spike occurred
                                        spkXPos = coords(stInd,2);
                                        xBin = find(gridBinEdges<=spkXPos,1, 'Last');
                                        spkYPos = coords(stInd,3);
                                        yBin = find(gridBinEdges<=spkYPos,1, 'Last');
                                        numBinSpks(xBin,yBin,u) = numBinSpks(xBin,yBin,u) + 1;
                                    end
                                end
                                
                            end %if u is grid cell
                        end %unit
                        
                        
                        % CALCULATE THE RATE MAP
                        goodU = unique(goodU); %fine all the grid cells/pyramidal cells
                        tmpVctr = 1:u;
                        numBinSpks(:,:,setdiff(tmpVctr,goodU)) = []; %get rid of spk count matrices for units that weren't grid/pyram
                        timePerBin = numBinSamps ./ vidSampRate; %convert # of vid samples to amt of time
                        timePerBin(timePerBin==0) = NaN;
                        for u = 1:length(goodU)
                            rateMap = numBinSpks(:,:,u) ./ timePerBin;
                            smRateMap = gc_ratemap_smooth(rateMap); % <- smooth with a normalized version of the window Sean said to use
                            region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u).rateMap = smRateMap;
                        end
                        
                        
                        
                        
                    else %CA1

                        
                        %EMPTY MATRICES FOR AMOUNT OF TIME AND SPIKE COUNT
                        numBinSamps = zeros(1,360/radBinSize);
                        numBinSpks = zeros(360/radBinSize, length(region(reg).rat(r).session(s).day(d).task(tNum).bout(1).unit));
                        
                        % GET AMOUNT OF TIME MOVING IN EACH RADIAL BIN
                        for x = 1:floor(360/radBinSize) %100 cm/binSize = #Bins in x dim
                            binLims = [(x-1)*radBinSize x*radBinSize];
                            
                            binInds = find(coords(:,2)>=binLims(1) & coords(:,2)<=binLims(2)); %within the x bin
                            
                            if ~isempty(binInds)
                                numBinSamps(x) = numBinSamps(x) + sum(velFilt(binInds));
                            end
                            
                        end %x (dim1)
                      
                        % GET THE SPIKE COUNT FOR EACH BIN WHILE THE RAT WAS ACTUALLY MOVING IN THAT BIN
                        for u = 1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit)
                            spkTms = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u).spkTms;
                            for st = 1:length(spkTms)
                                stInd = find(coords(:,1)<=spkTms(st), 1, 'Last');
                                if velFilt(stInd) == 1 %if rat was moving fast enough when spike occurred
                                    spkPos = coords(stInd,2);
                                    posBin = find(radBinEdges<=spkPos,1, 'Last');
                                    numBinSpks(posBin,u) = numBinSpks(posBin,u) + 1;
                                end
                            end
                            
                        end %unit
                        
                    
                        
                         
                        % CALCULATE THE RATE MAP
                        timePerBin = numBinSamps ./ vidSampRate; %convert # of vid samples to amt of time
                        timePerBin(timePerBin==0) = NaN;
                        for u = 1:size(numBinSpks,2)
                            rateMap = numBinSpks(:,u) ./ timePerBin';
                            gWin = gausswin(gWinWidth); %make a gaussian window
                            gWin = gWin ./ sum(gWin); %normalize it
                            smRateMap = conv(rateMap, gWin); 
                            
                            %smoothing with a Gauss window will add a few points so we need to remove them
                            halfGWin = floor(gWinWidth/2); 
                            smRateMap(end-halfGWin+1:end) = []; 
                            smRateMap(1:halfGWin) = []; 
                            
                            region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u).rateMap = smRateMap;
                        end
                        
                    end %region
                    
                    cd ..
                end %bout
                
                cd ../.. %out of task, out of day
            end %day
            cd ..
        end %session
        cd ..
    end %rat
    cd ..
end %region

cd(curDir);

end %fnctn