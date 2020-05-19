%script to copy the ntt files from a temporary hard-drive into the appropriate subdirectory
% of the project folder
%
% JBT 2/1

tetList{1} = [1 2];
tetList{2} = [11 12 9];
tetList{3} = [10 11 12 7 9];
tetList{4} = [3 4];


s = 1; %Ses 1
d = 1; %Day 1


curDir = pwd;
destDirRoot = 'I:\STORAGE\LAB_STUFF\COLGIN_LAB\PROJECTS\Grid_Cell_Correlations_TrettelProj\CORR_PROJECT_RERUN\DATASET\CA1';
sourceDirRoot = 'H:\CORR_PROJECT_RERUN\CA1RatDataForGettingNTTFiles';
cd(sourceDirRoot);

for r = 1:length(region(2).rat)
    cd(region(2).rat(r).name)
    for t = [1 3]
        if t == 1
            cd('CircularTrack');
            boutRoot = 'begin';
            destBoutRoot = 'Begin';
            destTaskName = 'LinearTrack';
            tmpDestRoot = [destDirRoot '\' region(2).rat(r).name '\Session1\Day1\LinearTrack\Begin'];
        else
            cd('Overnight');
            boutRoot = 'sleep';
            tmpDestRoot = [destDirRoot '\' region(2).rat(r).name '\Session1\Day1\Overnight\Sleep'];
        end
        
        boutDirs = dir([boutRoot '*']);
        for b = 1:length(boutDirs)
            cd([boutRoot num2str(b)]);
            
            for tt = tetList{r}
                passFail = copyfile(['TT' num2str(tt) '.ntt'], [tmpDestRoot num2str(b)]);
            end
            
            cd ../
        end %bout
        
        cd ../
    end %task
    cd ../
end%rat
    