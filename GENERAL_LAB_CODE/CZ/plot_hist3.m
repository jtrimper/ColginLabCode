xbin = 0.01;
xaxis0=0+xbin/2:xbin:1-xbin/2;
ybin = 20;
yaxis0=0+ybin/2:ybin:720-ybin/2;
axis0={xaxis0,yaxis0};
z=(hist3([[A(:,1),A(:,2)];[A(:,1),A(:,2)+360]],axis0))';
z=z./sum(sum(z));


imagesc(xaxis0,yaxis0,smooth2a(z,3,3));

set(gca,'YDir','Normal');