function [count,centers]=CrossCorrelation(unit1,unit2,range)
%%Compute the difference between the time in two unit firings relative to
%%unit 1

unit1=unit1*1000; %convert to msec
unit2=unit2*1000; %convert to msec

Range=range*1000; %convert to msec

Delay=[];
for i=1:size(unit1,1)
    di=unit2-unit1(i); 
    Delay=[Delay; di( di>-Range & di<+Range )];
end

if size(Delay,1)>0
    % figure
    xvalues=-Range:Range;
    % hist(Delay,xvalues);
    [count, centers]=hist(Delay,xvalues);
    centers = centers./1000; %convert back to sec
else
    count = NaN;
    centers = NaN;
end

end
