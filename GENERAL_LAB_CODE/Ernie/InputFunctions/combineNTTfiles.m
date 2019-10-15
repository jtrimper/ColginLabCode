function combineNTTfiles(nttfile,folders,outdir)

if ~isdir(outdir)
    mkdir(outdir)
end

for tt = 1:size(nttfile,1)
    file = nttfile{tt,1};
    Timestamps=[];
    ScNumbers=[];
    CellNumbers=[];
    Features=[];
    Samples=[];
    for ff = 1:size(folders)
        file_dir = strcat(folders{ff,1},'\',file);
        [tp, sc, cn, f, sp, h] =Nlx2MatSpike( file_dir, [1 1 1 1 1],1, 1);
        Timestamps = cat(2,Timestamps,tp);
        ScNumbers = cat(2,ScNumbers,sc);
        CellNumbers = cat(2,CellNumbers,cn);
        Features = cat(2,Features,f);
        Samples = cat(3,Samples,sp);
    end
    
    Mat2NlxSpike(strcat(outdir,'\',file),0,1,[],[1 1 1 1 1]...
        ,Timestamps,ScNumbers, CellNumbers, Features, Samples, h);
end
        
    
