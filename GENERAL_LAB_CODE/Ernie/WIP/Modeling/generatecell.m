function [celllist1,celllist2] = generatecell(model1,model2,n)

%%this function shifts the firing location of a model cell on the linear track and match the shifted position to the closest timepoint 


%parameters
range = 1.5; %the range of tracklength for matching

%directory for the spikes
cd(model1.spikeID)

%load the spikes
[S1] = LoadSpikes(model1.cellist);

%Parse the input
pos_lin1 = model1.pos_lin;
post1 = model1.post;
tracklength1 = model1.Tracklength;

%generate position shift and cell ID
pos_shift = randi(floor(tracklength1),1,n)-1;
cell_ID = randi(size(S1,1),1,n);


celllist1 = {n+1,2};
celllist1{1,1} = 'Spiketime';
celllist1{1,2} = 'SpikePosIndex';
for ii=2:n+1
    Choosespike = Data(S1{cell_ID(ii-1),1});
    spikeposIndex1 = match(Choosespike,post1);
    spikepos = pos_lin1(spikeposIndex1);
    newspikepos = spikepos+pos_shift(ii-1);
    newspikepos(newspikepos>tracklength1) = newspikepos(newspikepos>tracklength1)-tracklength1;
    
    timeshift = zeros(size(celllist1,1)-1,size(spikepos,2));
    newspikeposIndex = zeros(size(newspikepos,2),1);
    for pp=1:size(newspikepos,2)
        upper = newspikepos(pp)+range;
        lower = newspikepos(pp)-range;
        
        shift = find(pos_lin1<=upper & pos_lin1>=lower,1)-spikeposIndex1(pp);
        %randomly apply the time shift
        ran = randi(size(shift,2),1);
        newspikeposIndex(pp) = spikeposIndex1(pp)+shift(ran);
        timeshift(ii-1,pp) = ran; %note the value of time is the position index number   
        
    end
    
    celllist1{ii,1} = post1(newspikeposIndex);
    celllist1{ii,2} = newspikeposIndex;
    
end

%%Repeat the same procedure for testing cells
%Parse the input

%directory for the spikes
cd(model2.spikeID)

%load the spikes
[S2] = LoadSpikes(model2.cellist);

pos_lin2 = model2.pos_lin;
post2 = model2.post;
tracklength2 = model2.Tracklength;

celllist2 = {n+1,2};
celllist2{1,1} = 'Spiketime';
celllist2{1,2} = 'SpikePosIndex';
for ii=2:n+1
    Choosespike = Data(S2{cell_ID(ii-1),1});
    spikeposIndex2 = match(Choosespike,post2);
    spikepos = pos_lin2(spikeposIndex2);
    newspikepos = spikepos+pos_shift(ii-1);
    newspikepos(newspikepos>tracklength2) = newspikepos(newspikepos>tracklength2)-tracklength2;
    
    newspikeposIndex = zeros(size(newspikepos,2),1);
    for pp=1:size(newspikepos,2)
        upper = newspikepos(pp)+range;
        lower = newspikepos(pp)-range;
        
        shift = find(pos_lin2<=upper & pos_lin2>=lower)-spikeposIndex2(pp);
        %match the previous timeshift. In case when the second model cell
        %has more spikes, the extra spikes will be assigned randomly in
        %time
        if pp <= size(timeshift,2)
            [~,shift_ind]=min(abs(shift-timeshift(ii-1,pp)));
        else
            shift_ind = randi(size(shift,2),1);
        end
        
        newspikeposIndex(pp) = spikeposIndex2(pp)+shift(shift_ind);
        
    end
    
    celllist2{ii,1} = post2(newspikeposIndex);
    celllist2{ii,2} = newspikeposIndex;
    
end

end

