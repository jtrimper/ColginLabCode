function [for_ind, bak_ind] = splitRun(pos,t,varargin)
dur_thr = 0; % in sec
if nargin > 2
    dur_thr = varargin{1,1};
end
sampfreq = 1/mean(diff(t));

%Set the boundary for track end
poslength = max(pos)-min(pos);
posend = max(pos) - poslength*.1;
posstart = min(pos) + poslength*.1;

%Select forward direction run 
forward = [diff(pos)>0 false];
forward(1) = false; %flank the event with false to avoid end problem
fstart = find(diff(forward)==1)+1;
fend = find(diff(forward)==-1)+1;
% fin = pos(fstart)<=posstart & pos(fend)>=posend; %have to start from one end and end up on the other end

for_ind = false(size(pos));
fstart_in = fstart;%fstart(fin);
fend_in = fend;%fend(fin);
for ff = 1:size(fstart_in,2)
    if fend_in(ff)-fstart_in(ff) > sampfreq*dur_thr
        for_ind(fstart_in(ff):fend_in(ff)) = true;
    end
end

%Select backward direction run 
backward = [diff(pos)<0 false];
backward(1) = false; %flank the event with false to avoid end problem
bstart = find(diff(backward)==1)+1;
bend = find(diff(backward)==-1)+1;
% bin = pos(bstart)>=posend & pos(bend)<=posstart; %have to start from one end and end up on the other end

bak_ind = false(size(pos));
bstart_in = bstart;%bstart(bin);
bend_in = bend;%bend(bin);
for bb = 1:size(bstart_in,2)
    if bend_in(bb)-bstart_in(bb) > sampfreq*dur_thr
        bak_ind(bstart_in(bb):bend_in(bb)) = true;
    end
end

end