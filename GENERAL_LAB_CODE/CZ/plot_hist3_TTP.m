xbin = 0.01;
xaxis0=0+xbin/2:xbin:1-xbin/2;
ybin = 10;
yaxis0=0+ybin/2:ybin:720-ybin/2;
axis0={xaxis0,yaxis0};
Tg_z=(hist3([[Tg(:,1),Tg(:,2)];[Tg(:,1),Tg(:,2)+360]],axis0))';
Tg_z=Tg_z./sum(sum(Tg_z));

Wt_z=(hist3([[Wt_downsample(:,1),Wt_downsample(:,2)];[Wt_downsample(:,1),Wt_downsample(:,2)+360]],axis0))';
Wt_z=Wt_z./sum(sum(Wt_z));




figure(1);
colormap('jet')
imagesc(xaxis0,yaxis0,smooth2a(Tg_z,5,5));
set(gca,'YDir','Normal');
colorbar;
title('Tg Theta Phase Precession');


figure(2)
colormap('jet')
imagesc(xaxis0,yaxis0,smooth2a(Wt_z,5,5));
set(gca,'YDir','Normal');
colorbar;
title('Wt downsampled Theta Phase Precession');
