function region = corrProj_1_makeDataStruct(dataDir)
% function region = corrProj_1_makeDataStruct(dataDir)
%
% PURPOSE:
%   Purpose of function is to create the main data structure that will be used for all analyses.
%   Aside from just organizing everything into a structure for looping, spike times, coordinates,
%   and instantaneous runspeed are attached to the structure for every bout.
%
% INPUT:
%   dataDir = path to where the data is stored
%               e.g., dataDir = 'H:\CORR_PROJECT_RERUN\DATASET';
%
% OUTPUT:
%   region = uber data structure
%
% JBT 8/2017
% Colgin Lab


curDir = pwd;
cd(dataDir);

regNames = {'MEC', 'CA1'};
taskNames = {'LinearTrack', 'OpenField', 'Overnight'};

for reg = 1:2
    fprintf('%s\n', regNames{reg});
    cd(regNames{reg})
    
    region(reg).name = regNames{reg}; %#ok
    
    ratSubDirs = dir('Rat-*');
    for r = 1:length(ratSubDirs)
        fprintf('\t%s\n', ratSubDirs(r).name);
        
        cd(ratSubDirs(r).name);
        region(reg).rat(r).name = ratSubDirs(r).name; %tag the rat index w/ a name
        
        sesSubDirs = dir('Session*');
        for s = 1:length(sesSubDirs)
            fprintf('\t\tSession %d\n', s);
            cd(['Session', num2str(s)]);
            
            % GET THE LIST OF T FILES TO READ IN
            ttTextFile = dir('tt_list.txt');
            if ~isempty(ttTextFile)
                fid = fopen('tt_list.txt');
                ttFileList = textscan(fid,'%s', 'delimiter', '\n');
                fclose(fid);
            end
            
            daySubDirs = dir('Day*');
            for d = 1:length(daySubDirs)
                fprintf('\t\t\tDay %d\n', d);
                cd(daySubDirs(d).name);
                
                for t = 1:3
                    region(reg).rat(r).session(s).day(d).task(t).name = taskNames{t};
                    fprintf('\t\t\t\t%s\n', taskNames{t});
                    try
                        cd(taskNames{t});
                        goodDir = 1;
                    catch
                        goodDir = 0;
                        fprintf('\t\t\t\t\tNo data directory.\n');
                    end
                    
                    if goodDir == 1
                        if t < 3
                            boutSubDirs = dir('Begin*');
                            boutTitle = 'Begin';
                        else
                            boutSubDirs = dir('Sleep*');
                            boutTitle = 'Sleep';
                        end
                        for b = 1:length(boutSubDirs)
                            
                            fprintf('\t\t\t\t\tBout %d/%d\n', b, length(boutSubDirs));
                            cd([boutTitle num2str(b)]);
                            
                            % Attach coordinates and instantaneous runspeed
                            if reg == 1 && t == 2 %MEC / Open Field
                                coords = read_in_coords('VT1.nvt', 100, 100);
                                instRs = get_runspeed(coords);
                                
                                region(reg).rat(r).session(s).day(d).task(t).bout(b).instRs = instRs(:,2);
                                region(reg).rat(r).session(s).day(d).task(t).bout(b).coords = coords;
                                
                            elseif reg == 2 && t == 1 %CA1 / Circ Track
                                [post,posx,posy,circle] = LoadCircPos('VT1.nvt');
                                instRs = speedestimated(post,posx,posy,'circular',circle.radius); %rat's run speed in cm/s
                                radPos = circpos(posx,posy); %radial position
                                coords = [post' radPos'];
                                
                                region(reg).rat(r).session(s).day(d).task(t).bout(b).instRs = instRs;
                                region(reg).rat(r).session(s).day(d).task(t).bout(b).coords = coords;
                                
                            end
                            
                            
                            % ATTACH SPIKE TIMES AND UNIT INFORMATION
                            uCntr = 1;
                            for tt = 1:length(ttFileList{1})
                                tmpTt = ttFileList{1}{tt};
                                
                                try
                                    spkTms = Readtfile(tmpTt);
                                    readCheck = 1;
                                catch
                                    readCheck = 0;
                                end
                                
                                if readCheck == 1
                                    
                                    if length(tmpTt)==7 %grid/place cell
                                        tetNum = str2double(tmpTt(3));
                                        unitNum = str2double(tmpTt(5));
                                        cellType = 1;
                                    elseif length(tmpTt) == 8 %grid/place cell
                                        if reg ~=2 & r ~= 1 %one of Ernie's rat's has an exception
                                            tetNum = str2double(tmpTt(3:4));
                                            unitNum = str2double(tmpTt(6));
                                        else %rat110 had one unit called 'TT2_12.t' and rat113 had one unit called 'TT9_12.t'
                                            % and without this fix, it will be read in as a NaN
                                            tetNum = str2double(tmpTt(3));
                                            unitNum = str2double(tmpTt(5:6));
                                        end
                                        cellType = 1;
                                    elseif length(tmpTt) == 13 %nonGrid cell
                                        tetNum = str2double(tmpTt(3));
                                        unitNum = str2double(tmpTt(5));
                                        cellType = 2;
                                    elseif length(tmpTt) == 14 %nonGrid cell
                                        tetNum = str2double(tmpTt(3));
                                        unitNum = str2double(tmpTt(5));
                                        cellType = 2;
                                    end
                                    
                                    if isnan(tetNum)
                                        keyboard
                                    end
                                    
                                    region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(uCntr).ID = [tetNum unitNum];
                                    region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(uCntr).type = cellType;
                                    region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(uCntr).spkTms = spkTms ./ 10^4;
                                    
                                    
                                    uCntr = uCntr + 1;
                                end %if spkTms read in correctly
                            end %units
                            fprintf('\t\t\t\t\t\tAttached %d units.\n', uCntr-1);
                            
                            cd ..
                        end %bout
                        cd ..
                    end %if there's a data directory
                end %task
                cd ..
            end %day
            cd ..
        end %session
        cd ..
    end %rat
    cd ..
end %region

cd(curDir);
end %fnctn


