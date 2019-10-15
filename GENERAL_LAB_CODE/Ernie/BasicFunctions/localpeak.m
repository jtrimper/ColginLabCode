%type=1 find peak; type=2 find trough
function [peakind,numpeak] = localpeak(input,type)

    if size(input,2) < size(input,1)
        input = input';
    end

    if type == 1
        di = diff(input);
        posdiff = di>0;
        negdiff = di<0;
        posdiff = [false, posdiff];
        negdiff = [negdiff,false];
        peakind=find(negdiff+posdiff==2);
        
    elseif type ==2
        di = diff(input);
        posdiff = di>0;
        negdiff = di<0;
        posdiff = [posdiff,false];
        negdiff = [false,negdiff];
        peakind=find(negdiff+posdiff==2);
        
    end
    
    numpeak = size(peakind,2);
    
end