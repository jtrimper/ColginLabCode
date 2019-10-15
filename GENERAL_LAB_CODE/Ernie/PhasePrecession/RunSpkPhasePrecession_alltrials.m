outdir = strcat(cd,'\out_SpkPhasePrecession_',date);
if ~isdir(outdir)
    mkdir(outdir)
end

[tfile] = Readtextfile('gclist.txt');
EEGfile = {};
posfile = {};
for tt = 1:size(tfile,1)
    s = strfind(tfile{tt,1},'TT');
    e = strfind(tfile{tt,1},'_');
    EEGfile{tt,1} = strcat('CSC',tfile{tt,1}(s+2:e-1),'.ncs');
    posfile{tt,1} = 'VT1.nvt'; 
end

for ii = 1:size(tfile,1)

    SpkPhasePrecession(posfile{ii,1},tfile{ii,1},EEGfile{ii,1},outdir,'begin');    
    
end