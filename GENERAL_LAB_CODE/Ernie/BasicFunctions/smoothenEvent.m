    %this function find continuous event and remove jitters in between the
    %events (i.e. the events that are very close to each other are
    %combined). The outputs (sevent1,sevent2,cevent) are in
    %logical index while (cevent_center,cevent_start,cevent_end) are position scalar
    function [sevent1,sevent2,cevent,cevent_center,cevent_start,cevent_end] = smoothenEvent(event1,event2,duration,interval_threshold)
    
    inbound_start=find(diff(event1)==1)+1;
    inbound_stop=find(diff(event1)==-1);
    outbound_start=find(diff(event2)==1)+1;
    outbound_stop=find(diff(event2)==-1);
    
    %begin condition
    if event1(1) == 1
        inbound_start = [1; inbound_start];
        
    elseif event2(1) == 1
        outbound_start = [1; outbound_start];
        
    end    
    
    %end condition
    if event1(end) == 1
        inbound_stop = [inbound_stop; size(event1,1)];
        
    elseif event2(end) == 1
        outbound_stop = [outbound_stop; size(event2,1)];
        
    end
    
    inbound_dur = inbound_stop-inbound_start;
    logical_dur = inbound_dur < duration;
    inbound_start(logical_dur) = [];
    inbound_stop(logical_dur) = [];
    
    outbound_dur = outbound_stop-outbound_start;
    logical_dur = outbound_dur < duration;
    outbound_start(logical_dur) = [];
    outbound_stop(logical_dur) = [];

    logical_interval = zeros(numel(inbound_start)-1,1);

    for k = 1:numel(inbound_start)-1;
        logical_interval(k) = (inbound_start(k+1)-inbound_stop(k)) <= interval_threshold;    
    end

    logical_interval = logical(logical_interval);
    inbound_start([false ; logical_interval]) = [];
    inbound_stop([logical_interval ; false]) = [];

    logical_interval = zeros(numel(outbound_start)-1,1);

    for k = 1:numel(outbound_start)-1;
        logical_interval(k) = (outbound_start(k+1)-outbound_stop(k)) <= interval_threshold;    
    end

    logical_interval = logical(logical_interval);
    outbound_start([false ; logical_interval]) = [];
    outbound_stop([logical_interval ; false]) = [];
    
    sevent1=zeros(size(event1));
    cevent=zeros(size(event1));
    cevent_center=zeros(size(event1));
    cevent_start=[];
    cevent_end=[];
    for kk=1:size(inbound_start)
        sevent1(inbound_start(kk):inbound_stop(kk))=1;
        
        if min(abs(outbound_start-inbound_stop(kk)))==1
            outbound_start_continuousloc=find(abs(outbound_start-inbound_stop(kk))==1);
            cevent(inbound_start(kk):outbound_stop(outbound_start_continuousloc))=1;
            cevent_center(inbound_stop(kk))=1;
            cevent_start = [cevent_start; inbound_start(kk)];
            cevent_end = [cevent_end; outbound_stop(outbound_start_continuousloc)];
            
        end
        
    end
    sevent1=logical(sevent1);
    cevent=logical(cevent);
    cevent_center=find(cevent_center);
    
    sevent2=zeros(size(event2));
    for kk=1:size(outbound_start)
        sevent2(outbound_start(kk):outbound_stop(kk))=1;
    end
    sevent2=logical(sevent2);
   
    end