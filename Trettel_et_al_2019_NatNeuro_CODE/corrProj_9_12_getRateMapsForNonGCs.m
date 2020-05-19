function region = corrProj_9_12_getRateMapsForNonGCs(region)
% function region = corrProj_9_12_getRateMapsForNonGCs(region)
%
% PURPOSE:
%  To attach rate-maps for non-grid cells.
%
% INPUT:
%  region = project uber data structure (using version from 12/30/2017)
%
% OUTPUT:
%  region = same data structure, but with CA1 data removed, and ratemaps added for nonGCs
%
% JB Trimper
% 5/2018
% Colgin Lab



%% SET PARAMETERS
runThresh = 5; %cm/s
gridBinSize = 3; %cm^2
vidSampRate = 29.96998; %frames per second

gridBinEdges = 0:gridBinSize:100-gridBinSize;


%% GO TO MEC DATA DIRECTORY
curDir = pwd;
dataDir = 'F:\STORAGE\LAB_STUFF\COLGIN_LAB\PROJECTS\Grid_Cell_Correlations_TrettelProj\CORR_PROJECT_RERUN\DATASET\MEC';
cd(dataDir);


%% GET RID OF CA1 BECAUSE WE'RE NOT GOING TO USE IT AT ALL IN THE ANALYSES TO FOLLOW
if length(region) == 2
    region(2) = [];
end
reg = 1; %just deal with MEC from now on
tNum = 2; %Open Field




for r = 1:length(region(reg).rat)
    fprintf('\t%s\n', region(reg).rat(r).name);
    cd(region(reg).rat(r).name)
    for s = 1:length(region(reg).rat(r).session)
        fprintf('\t\tSession %d\n', s);
        cd(['Session' num2str(s)])
        for d = 1
            fprintf('\t\t\tDay %d\n', d);
            cd(['Day' num2str(d)])
            
            cd(region(reg).rat(r).session(s).day(d).task(tNum).name);
            
            goodU = [];
            for b = 1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout)
                fprintf('\t\t\t\tBout %d\n', b);
                cd(['Begin' num2str(b)]);
                
                
                % READ IN RUNSPEED & COORDS, DO MOVING WINDOW AVERAGE ON RUNSPEED AND
                instRs = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).instRs;
                [mwRs, mwInds] = mw_avg(instRs,15,7,1); % moving window average the runspeed to 0.5 s windows with 0.23 s steps
                mwRs = [instRs(1:mwInds(1)-1)' mwRs instRs(mwInds(end)+1:length(instRs))']; %#ok -- make the length of the moving window version match
                velFilt = zeros(1,length(mwRs));
                velFilt(mwRs>=runThresh) = 1;
                coords = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).coords;
                
                
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
                    gcOrNonGc = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u).type;
                    if  gcOrNonGc == 2 %if non-grid cell
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
                goodU = unique(goodU); %fine all the non-grid cells
                if ~isempty(goodU)
                    timePerBin = numBinSamps ./ vidSampRate; %convert # of vid samples to amt of time
                    timePerBin(timePerBin==0) = NaN;
                    for u = goodU
                        rateMap = numBinSpks(:,:,u) ./ timePerBin;
                        smRateMap = gc_ratemap_smooth(rateMap); % <- smooth with a normalized version of the window Sean said to use
                        region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u).rateMap = smRateMap;
                    end
                end
                cd ../
                
            end %bout
            
            cd ../.. %out of task, out of day
        end %day
        cd ..
    end %session
    cd ..
end %rat


cd(curDir);

end %fnctn