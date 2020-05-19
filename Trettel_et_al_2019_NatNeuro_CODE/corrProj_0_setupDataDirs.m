function corrProj_0_setupDataDirs(rat)
% function corrProj_0_setupDataDirs(rat)
%
% PURPOSE:
%   Set up directories and subdirectories for MEC part of corr project containing
%   only what I need in the exact fashion that I want it organized.
%
% INPUT:
%   rat = current uber data structure for corr project
%
% OUTPUT:
%   Functions makes directories and subdirectories, and moves files into them
%
% JBT 8/28/2017
% Colgin Lab

curDir = pwd; %keep track of where you are
origDir = 'C:\Users\John Trimper\Desktop\LAB_STUFF\PROJECTS\Grid_Cell_Correlations_TrettelProj\DATASET';
cd('H:\CORR_PROJECT_RERUN\DATASET\MEC'); %go to new root director

taskNames = {'OpenField', 'LinearTrack', 'Overnight'};

for r = 1:length(rat)
    fprintf('Rat %d\n', r);
    mkdir(rat(r).name);
    cd(rat(r).name);
    for s = 1:length(rat(r).session)
        fprintf('\tSession %d\n', s);
        sesDirName = ['Session' num2str(s)];
        mkdir(sesDirName);
        cd(sesDirName);
        
        % FIGURE OUT WHICH TASKS WERE RUN ON EACH DAY SO YOU CAN MAKE A DATA DIRECTORY FOR THEM
        taskBin = zeros(3,length(rat(r).session(s).dates));
        for t = 1:3
            for d = 1:length(rat(r).session(s).task(t).day)
                taskBin(t,d) = ~isempty(rat(r).session(s).task(3).day);
            end
        end
        
        
        % GET THE LIST OF UNITS USED SO YOU CAN COPY THE RIGHT ONES OVER
        tmpCurDir = pwd;
        cd(origDir);
        cd(rat(r).name);
        cd('Combo_Results');
        cd(rat(r).session(s).dates{1});
        ttTextFile = dir('combo_ttfile_checked.txt');
        if ~isempty(ttTextFile)
            fid = fopen('combo_ttfile_checked.txt');
            ttFileList = textscan(fid,'%s', 'delimiter', '\n');
            fclose(fid);
        else
            fprintf('No tetrode list for this session!\n');
            keyboard
        end
        copyfile('combo_ttfile_checked.txt', [tmpCurDir '\tt_list.txt']) %move the tt-list to the new folder and rename it
        cd(tmpCurDir); %get back to where you started
        
        
        % FIGURE OUT WHICH LFP TETRODE YOU'RE GOING TO USE
        
        
        for d = 1:length(rat(r).session(s).dates)
            fprintf('\t\tDay %d\n', d);
            dayDirName = ['Day' num2str(d)];
            mkdir(dayDirName);
            cd(dayDirName);
            tmpDate = rat(r).session(s).dates{d};
            
            % MAKE AN EMPTY TEXT FILE WHERE THE TITLE OF IT INDICATES THE TEST SESSION DATE
            fid = fopen(tmpDate, 'w+');
            fclose(fid);
            
            % MAKE A DIRECTORY FOR EACH TASK RUN ON THAT DAY
            for t = 1:3
                fprintf('\t\t\tTask %d: %s\n', t, taskNames{t});
                if taskBin(t,d) == 1
                    mkdir(taskNames{t});
                    cd(taskNames{t});
                    taskDir = pwd;
                    
                    
                    for b = 1:length(rat(r).session(s).task(t).day(d).bout)
                        fprintf('\t\t\t\tBout %d\n', b);
                        if t < 3
                            boutDir = ['Begin', num2str(b)];
                        else
                            boutDir = ['Sleep', num2str(b)];
                        end
                        mkdir(boutDir);
                        cd(boutDir);
                        boutAddress = pwd;
                        
                        % GET ALL THE T FILES WE CARE ABOUT FROM THE ORIGINAL DIRECTORY
                        %  Go to the source directory
                        try
                            cd(rat(r).session(s).task(t).day(d).bout(b).dir)
                            goodDir = 1; 
                        catch
                            goodDir = 0; 
                        end
                        
                        if goodDir == 1
                            firstGood = 0;
                            for tt = 1:length(ttFileList{1})
                                curTtFile = ttFileList{1}{tt};
                                if length(ttFileList{1}{tt}) > 6
                                    firstGood = firstGood + 1;
                                    try
                                        copyfile(curTtFile,boutAddress);
                                    catch
                                    end
                                    
                                    if firstGood == 1
                                        if length(curTtFile) == 7
                                            lfpTet = curTtFile(3);
                                        else
                                            lfpTet = curTtFile(3:4);
                                        end
                                    end
                                end
                            end
                            %  And get the file for the LFP we want to use
                            try
                                copyfile(['CSC' lfpTet '.ncs'], boutAddress)
                            catch
                                fprintf('\t\t\t\t\tNo data in this directory.\n');
                            end
                            
                            %  And get the coordinates file if not an overnight session
                            if t < 3
                                copyfile('VT1.nvt', boutAddress)
                            end
                            
                        else
                            fprintf('\t\t\t\t\tData directory does not exist.\n');
                        end
                        
                        cd(taskDir);
                        
                    end %bout (begin/sleep)
                    cd ../
                end %if the rat did this task on this day
            end %task
            cd ../
        end %day
        cd ../
    end %session
    cd ../
end %rat


cd(curDir);

end%fnctn