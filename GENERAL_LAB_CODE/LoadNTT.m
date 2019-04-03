function [timestamp,spkwaveform,bv,ir] = LoadNTT(NTTfile)

fieldSelection(1) = 1; % Timestamps
fieldSelection(2) = 0; % Spike Channel Numbers
fieldSelection(3) = 0; % Cell Numbers
fieldSelection(4) = 0; % Spike Features
fieldSelection(5) = 1; % Samples
extractHeader = 1;
extractMode = 1; % Extract all data

[timestamp,spkwaveform,header] = Nlx2MatSpike(NTTfile,fieldSelection,extractHeader,extractMode,[]);

for ii = 1:size(header,1)
    if ~isempty(strfind(header{ii},'-ADBitVolts'))
        bvloc = ii;
        ind = strfind(header{ii},'.');
    end
    if ~isempty(strfind(header{ii},'-InputRange'))
        irloc = ii;
    end
end
bv = zeros(1,length(ind));
for dd = 1:length(ind)-1
    bv(dd) = str2num(header{bvloc}(ind(dd)-1:ind(dd+1)-2));
end
bv(end) = str2num(header{bvloc}(ind(end)-1:end));
bv = bv*10^6;  %bit-microvolt conversion
ir = [str2num(header{irloc}(13:16)),...
      str2num(header{irloc}(17:20)),...
      str2num(header{irloc}(21:24)),...
      str2num(header{irloc}(25:end))];%Input range in microvolts