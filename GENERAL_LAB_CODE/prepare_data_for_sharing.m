function prepare_data_for_sharing()
% function prepare_data_for_sharing()

rootDir = 'C:\Users\John\Desktop\LAB_STUFF\OTHER\MEC_Data_for_CRCNS';

taskNames = {'LinearTrack', 'OpenField', 'Overnight'};
boutNames = {'Begin', 'Begin', 'Sleep'};

cd(rootDir);
ratSubDirs = dir('Rat*');
for r = 1:6
    fprintf('%s\n', ratSubDirs(r).name);
    cd(ratSubDirs(r).name);
    sesSubDirs = dir('Session*');
    for s = 1:length(sesSubDirs)
        fprintf('\t%s\n', sesSubDirs(s).name);
        cd(sesSubDirs(s).name);
        daySubDirs = dir('Day*');
        for d = 1:length(daySubDirs)
            fprintf('\t\t%s\n', daySubDirs(d).name);
            cd(daySubDirs(d).name)
            try
                rmdir('LinearTrack', 's'); 
            catch
               fprintf('\t\t\tNo Linear Track directory for this day.\n'); 
            end
%             for t = 1:3
%                 try
%                     cd(taskNames{t});
%                     taskCheck = 1;
%                 catch
%                     fprintf('\t\t\tNo %s task for this day\n', taskNames{t});
%                     taskCheck = 0;
%                 end
%                 
%                 if taskCheck == 1
%                     fprintf('\t\t\t\t%s\n', taskNames{t});
%                     boutSubDirs = dir([boutNames{t} '*']);
%                     for b = 1:length(boutSubDirs)
%                         fprintf('\t\t\t\t%s\n', boutSubDirs(b).name);
%                         cd(boutSubDirs(b).name);
%                         
%                         %Remove *.mat files
%                         matFiles = dir('*.mat');
%                         
%                         for mf = 1:length(matFiles)
%                             delete(matFiles(mf).name);
%                         end
%                         
%                         
%                         %Remove LFPs (*.ncs)
%                         lfpFiles = dir('*.ncs');
%                         for n = 1:length(lfpFiles)
%                             delete(lfpFiles(n).name);
%                         end
%                         
%                         cd ..
%                     end %bout
%                     cd ..
%                 end %if task existed
%             end %task
            cd ..
        end %day
        cd ..
    end %session
    cd ..
end %rat



