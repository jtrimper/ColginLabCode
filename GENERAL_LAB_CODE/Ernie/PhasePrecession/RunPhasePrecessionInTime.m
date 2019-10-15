dirlist = dir;
parentfd = pwd;
for ff = 3:size(dirlist,1)
    cd(strcat(parentfd,'\',dirlist(ff).name))
    
%-------------below for single day folder------------------%    

outdir = strcat(cd,'\out_PhasePrecssionInTime_alignMaximalFR_',date);
if ~isdir(outdir)
    mkdir(outdir)
end

[tfile] = Readtextfile('gclist.txt');
for tt = 1:size(tfile,1)
    s = strfind(tfile{tt,1},'TT');
    e = strfind(tfile{tt,1},'_');
    EEGfile{tt,1} = strcat('CSC',tfile{tt,1}(s+2:e-1),'.ncs');
end

for ii = 1:size(tfile,1)

    [p,fighandle] = PhasePrecessionInTime(tfile{ii,1},EEGfile{ii,1},'sleep');
    
    filename = strcat(outdir,'\PhasePrecssionInTime_',tfile{ii,1}(1:end-2),'_sleep');
    imageStore(fighandle,'png',filename)
    close(fighandle)
end

%-------------above for single day folder------------------%

end