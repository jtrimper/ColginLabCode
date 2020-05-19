function region = fix_sleep_stXCorr_field_names(region)

ssNames = {'REM', 'nREM'};
for reg = 1:2
    fprintf('Region %d\n', reg);
    for r = 1:length(region(reg).rat)
        fprintf('\tRat %d\n', r);
        for s = 1:length(region(reg).rat(r).session)
            fprintf('\t\tSession %d\n', s);
            
            if ~isempty(region(reg).rat(r).session(s).state)
                
                for ss = 2:3
                    fprintf('\t\t\t%s\n', ssNames{ss-1});
                    try
                    for cp = 1:length(region(reg).rat(r).session(s).state(ss).cellPair)
                        
                        region(reg).rat(r).session(s).state(ss).cellPair(cp).stXCorr = region(reg).rat(r).session(s).state(ss).cellPair(cp).crossCorr;
                        region(reg).rat(r).session(s).state(ss).cellPair(cp).normStXCorr = region(reg).rat(r).session(s).state(ss).cellPair(cp).normCrossCorr;
                        
                    end
                    catch;keyboard;end
                    
                    region(reg).rat(r).session(s).state(ss).cellPair = rmfield(region(reg).rat(r).session(s).state(ss).cellPair, 'crossCorr');
                    region(reg).rat(r).session(s).state(ss).cellPair = rmfield(region(reg).rat(r).session(s).state(ss).cellPair, 'normCrossCorr');
                end
            end
        end
    end
end    
