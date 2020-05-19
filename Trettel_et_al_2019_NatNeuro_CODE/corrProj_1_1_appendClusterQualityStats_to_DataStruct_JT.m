function region = corrProj_1_1_appendClusterQualityStats_to_DataStruct_JT(region,dataDir,restart_reg, restart_r)
% function region = corrProj_1_1_appendClusterQualityStats_to_DataStruct_JT(region,dataDir,restart_reg, restart_r)
%
% PURPOSE:
%   Purpose of function is to append cluster quality statistics to region data structure
%
% INPUT:
%        region = project uber data structure created from corrProj_1
%       dataDir = path to where the data is stored
%                 e.g., dataDir = 'H:\CORR_PROJECT_RERUN\DATASET';
%   restart_reg = which region to pick up from 
%   restart_rat = which rat to pick up from
%
% OUTPUT:
%   region = uber data structure, with quality 
%
% SGT 12/2017, modified from/by JBT 8/2017
% Colgin Lab


curDir = pwd;
cd(dataDir);

regNames = {'MEC', 'CA1'};
taskNames = {'LinearTrack', 'OpenField', 'Overnight'};
if(~isempty(restart_reg))
    reg_start = restart_reg;
    rat_start = restart_r;
else
    reg_start=1;
    rat_start=1;
end

for reg = reg_start:2
    fprintf('%s\n', regNames{reg});
    cd(regNames{reg})
    
    ratSubDirs = dir('Rat-*');
    for r = rat_start:length(ratSubDirs)
        fprintf('\t%s\n', ratSubDirs(r).name);
        
        cd(ratSubDirs(r).name);

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
                            
                            % ATTACH CLUSTER QUALITY MEASURES
                            uCntr = 1;
                            for tt = 1:length(ttFileList{1})
                                tmpTt = ttFileList{1}{tt};
                                
                                try
                                    Readtfile(tmpTt);
                                    %                                     tmp_tsp = readSpikeData(tmpTt,pwd);
                                    readCheck = 1;
                                catch
                                    keyboard
                                    readCheck = 0;
                                end
                                
                                if readCheck == 1
                                    
                                    %                                     tmpstring = strsplit(pwd,'\');
                                    %                                     if(strcmpi(tmpstring{end-1},'openfield'))
                                    %                                         tmpstring{end-1}='BigSquare';
                                    %                                     end
                                    %
                                    %                                     tmp_dir_str = dir('..\..');
                                    %                                     sess_date_str=tmp_dir_str(3).name; %SGT
                                    %                                     ntt_dir = ['D:\Sean\',tmpstring{end-4},'\',tmpstring{end-1},'\',sess_date_str,'\',tmpstring{end}];
                                    %
                                    ntt_dir = pwd; %JBT
                                    
                                    clustQualStruct = batch_Create_CQ_struct({tmpTt},0,ntt_dir);
                                    
                                    region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(uCntr).clusterQual = clustQualStruct;

                                    
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
        save(['I:\JBT_RERUN\DATASET\ClusterQuality_MidRun_Region-',num2str(reg),'_Rat-',num2str(r),'.mat'],'region','-v7.3');
    end %rat
    cd ..
end %region

cd(curDir);
end %fnctn


