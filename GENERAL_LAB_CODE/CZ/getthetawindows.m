function wins = getthetawindows(thetadelta,cutoff,eTSi)
higher = 0;
startt = [];
stopp = [];
data = thetadelta;
for i = 1:length(eTSi)
     if data(i) >= cutoff && ~higher
       startt = [startt;eTSi(i)];
       higher = 1;
     end
   if data(i) < cutoff && higher
       stopp = [stopp;eTSi(i)];
       higher = 0;
   end
end
if length(startt) > length(stopp)
    startt(end) = [];
end
wins = [startt,stopp];
