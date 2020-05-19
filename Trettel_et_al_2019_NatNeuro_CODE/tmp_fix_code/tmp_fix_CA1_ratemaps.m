function region = tmp_fix_CA1_ratemaps(region)
% function region = tmp_fix_CA1_ratemaps(region)
%
% tmp function to chop off the extra indices that were added on by
% gaussian smoothing to each CA1 radial rate map




for reg = 2
    fprintf('%s\n', region(reg).name)
    for r = 1:length(region(reg).rat)
        fprintf('\t%s\n', region(reg).rat(r).name);
        for s = 1:length(region(reg).rat(r).session)
            fprintf('\t\tSession %d\n', s);
            for d = 1
                fprintf('\t\t\tDay %d\n', d);
                
                tNum = 1; %Circular Track
                
                fprintf('\t\t\t\t%s\n', region(reg).rat(r).session(s).day(d).task(tNum).name)
                
                for b = 1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout)
                    fprintf('\t\t\t\t\tBout %d\n', b);
                    
                    
                    for u = 1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit)
                        fprintf('\t\t\t\t\t\tUnit #%d\n', u); 
                        smRateMap = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u).rateMap;
                        fprintf('\t\t\t\t\t\t\tStart Length = %d\n', length(smRateMap)); 
                        
                        %smoothing with a Gauss window will add a few points so we need to remove them
                        smRateMap(end-1:end) = [];
                        smRateMap(1:2) = [];
                        
                        fprintf('\t\t\t\t\t\t\tEnd Length = %d\n\n', length(smRateMap)); 
                        
                        region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u).rateMap = smRateMap;
                    end
                    
                    
                end %bout
            end %day
        end %session
    end %rat
end %region

end %fnctn