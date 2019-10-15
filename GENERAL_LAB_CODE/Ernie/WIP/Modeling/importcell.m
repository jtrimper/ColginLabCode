function [celllist1,celllist2] = importcell(model1,model2)

%%this function imports the actual cells for modeling analysis


%directory for the spikes
cd(model1.spikeID)

%load the spikes
[S1] = LoadSpikes(model1.cellist);

celllist1{1,1} = 'Spiketime';
celllist1{1,2} = 'SpikePosIndex';
for ii=1:size(S1,1)
    celllist1{ii+1,1} = Data(S1{ii,1});
    celllist1{ii+1,2} = match(Data(S1{ii,1}),model1.post);
end

%%Repeat the same procedure for testing cells

%directory for the spikes
cd(model2.spikeID)

%load the spikes
[S2] = LoadSpikes(model2.cellist);

celllist2{1,1} = 'Spiketime';
celllist2{1,2} = 'SpikePosIndex';
for ii=1:size(S2,1)
    celllist2{ii+1,1} = Data(S2{ii,1});
    celllist2{ii+1,2} = match(Data(S2{ii,1}),model2.post);
end

end

