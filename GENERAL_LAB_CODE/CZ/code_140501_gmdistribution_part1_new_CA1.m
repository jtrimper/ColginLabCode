% eg: E:\Chenguang Zheng\DATA\Rat44\2014-02-24_09-33-35-BS

num_cluster=2;
% generate_ind=1;

date='20140725';

%R=clust2_R;
spechist_CA1_mean_sub=spechist_dCA1_mean(minf2:maxf2,:);
% spechist_CA1_mean_sub(:,end)=0;

spechist_data= spechist_CA1_mean_sub;
outdir='C:\Users\ColginLab\Documents\MATLAB\MainFunctions\Code & Data gamma&speed HP+MEC\';
Rat='all rat';
CSCname='all TT';
note1=strcat('_SpecByVel');
note2=strcat('_generated_SpecByVel');
note3=strcat('_GM_fit-cluster-',num2str(num_cluster));
note4=strcat('_Lamda_L');
note5=strcat('_Lamda_L difference');
z_threshold=0.6;

minf=find(F<=25);
minf=minf(end);
maxf=find(F>=100);
maxf=maxf(1);
nf_rlt=maxf-minf+1;

binx=0.25;
biny=0.05;

% % log
% x0=binx:binx:7;
% y0=1.8:biny:4;

% nonlog
x0=vr(2:end);
y0=F(minf2:maxf2);
f=y0;

lenx=length(x0);
leny=length(y0);
x=ones(leny,1)*x0;
y=y0'*ones(1,lenx);
zz=spechist_data(:,1:lenx);
z=zeros(leny,lenx);
% f=2.^(y0-log2(4/30));
F0=F(minf:maxf);
for ii=1:leny
    ind_1=find(abs(F0-f(ii))==min(abs(F0-f(ii))));
    z(ii,:)=zz(ind_1,:);
end
min_z=min(min(z));
max_z=max(max(z));
z_norm=(z-min_z)./(max_z-min_z);

% if generate_ind==1  % generate new random dots in each bins
    R=[];  % generate 2-D norm random numbers in each speed-frequency bin
    num_rnd=30;
    for ii=1:lenx
        for jj=1:leny
            mu = [x0(ii),y0(jj)];
            SIGMA = [binx/4 0; 0 biny/4];
            if z_norm(jj,ii)>z_threshold
                r=mvnrnd(mu,SIGMA,2000);
                ind_1=find(abs(r(:,1)-x0(ii))<=binx/2 & abs(r(:,2)-y0(jj))<=biny/2);
                r=r(ind_1,:);
                if length(ind_1)>=floor(num_rnd*z_norm(jj,ii))
                    ind0=floor(rand(floor(num_rnd*z_norm(jj,ii)),1).*length(ind_1));
                    ind0(ind0==0)=1;
                    r=r(ind0,:);
                else
                end
                R=[R;r];
            end
        end
    end
    R=R';
    % figure;
    % plot(R(1,:),R(2,:),'.');
    
    z_dens=zeros(leny,lenx);
    for ii=1:size(R,2)
        indx=find(abs(R(1,ii)-x0)==min(abs(R(1,ii)-x0)));
        indy=find(abs(R(2,ii)-y0)==min(abs(R(2,ii)-y0)));
        z_dens(indy,indx)=z_dens(indy,indx)+1;
    end
% else  % ues the current random dots
% end

options=statset('Display','final','MaxIter',10000);
model=gmdistribution.fit(R',num_cluster,'Options',options);
clust3_model=model;

%%
mu=model.mu;
Sigma=model.Sigma;
weight=model.PComponents;

% if model.mu(1,1)<model.mu(2,1)
%     mu=model.mu;
%     Sigma=model.Sigma;
%     weight=model.PComponents;
% else
%     mu=[model.mu(2,:);model.mu(1,:)];
%     Sigma1(:,:,1)=model.Sigma(:,:,2);
%     Sigma2(:,:,2)=model.Sigma(:,:,1);
%     weight=[model.PComponents(2),model.PComponents(1)];
% end

Pdf0=zeros(size(R,2),1);
for n=1:num_cluster
    mu0=mu(n,:);
    Sigma0=Sigma(:,:,n);
    pdf0= mvnpdf(R',mu0,Sigma0).*weight(n);
    Pdf0=Pdf0+pdf0;
end
lamda=sum(log(Pdf0));
clust3_lamda=lamda;

%% PLOT
% plot original SpecByVel
% A=figure(1);
% uimagesc(x0,y0,z_norm);
% axis xy; axis tight;
% colorbar
% set(gca, 'FontSize',20);
% tickx=[0,2,4,6];
% set(gca, 'XTick',tickx);
% set(gca, 'XTickLabel',2.^tickx*0.75);
% ticky=log2([30,60,100].*(4/30));
% set(gca, 'YTick',ticky);
% set(gca, 'YTickLabel',[30,60,100]);
% xlabel('running speed (cm/s)','FontSize',20);
% ylabel('frequency (Hz)','FontSize',20);
% tit=['Original SpecByVel (normalized)'];
% title(tit,'FontSize',20);
% filenam1 = strcat(Rat,'-CSC',num2str(CSCname),note1);
% saveas(1, strcat(outdir,'\',filenam1,'.png'),'png');

% Plot Generated SpecByVel
B=figure(2);
uimagesc(x0,y0,z_dens);
axis xy; axis tight;
set(gca, 'FontSize',20);
tickx=[0,2,4,6];
set(gca, 'XTick',tickx);
set(gca, 'XTickLabel',tickx);
ticky=log2([30,60,100].*(4/30));
set(gca, 'YTick',ticky);
set(gca, 'YTickLabel',ticky);
tit=['Generated SpecByVel'];
title(tit,'FontSize',20);
filenam2 = strcat(Rat,'-CSC',num2str(CSCname),note2);
saveas(2, strcat(outdir,'\',filenam2,'.png'),'png');

subdir='C:\Users\ColginLab\Documents\MATLAB\MainFunctions\Code & Data gamma&speed HP+MEC';
num_cluster=5;
% model=clust5_model_allRat_CA1;
ffa = figure('Units','normalized','Position',[0 0 0.5625 1]);
speed=R(1,:)';
frequency=R(2,:)';
mux=model.mu(:,1)';
muy=model.mu(:,2)';
weight=model.PComponents;
h=ezcontour(@(speed,frequency)pdf(model,[speed,frequency]),[0,x0(end)],[y0(1),y0(end)]);
set(gca, 'FontSize',20);
tickx=0:7;
set(gca, 'XTick',tickx);
set(gca, 'XTickLabel',2.^tickx*0.75);
labley=[4,8,12,20,30,40,60,80,100,120];
% ticky=2:5;
ticky=log2(labley.*(4/30));
set(gca, 'YTick',ticky);
set(gca, 'YTickLabel',labley);
hold on
for ii=1:num_cluster
    mux0=mux(ii);
    muy0=muy(ii);
    % text(mux0,muy0,strcat('x=',num2str(mux0),', y=',num2str(muy0),', w=',num2str(weight(ii))));
    text(mux0,muy0,strcat('w=',char(vpa(weight(ii),2))),'FontSize',20);
end
hold off
xlabel('running speed (cm/s)','FontSize',20);
ylabel('frequency (Hz)','FontSize',20);
tit=[areaname,'-cluster-',num2str(num_cluster)];
title(tit,'FontSize',20);
filenam = strcat(tit);
saveas(ffa, strcat(subdir,'\',date,'-',filenam,'.png'),'png');
saveas(ffa, strcat(subdir,'\',date,'-',filenam,'.eps'),'epsc');

% close all;
% 
% for n=1:num_cluster
%     subplot(1,3,n);
%     mu=model.mu(:,n)';
%     Sigma=model.Sigma(:,:,n);
%     [X0,Y0] = meshgrid(x0,y0);
%     PDF = mvnpdf([X0(:) Y0(:)],mu,Sigma);
%     PDF = reshape(PDF,length(y0),length(x0));
%     imagesc(x0,y0,PDF)
%     % surf(x1,x2,F);
%     %caxis([min(F(:))-.5*range(F(:)),max(F(:))]);
%     %axis([-3 3 -3 3 0 .4])
%     %xlabel('x1'); ylabel('x2'); zlabel('Probability Density');
%     axis xy
% end


% scatter(R(1,:),R(2,:),5,'.')
% axis([0,6,1.8,4]);
% set(gca, 'FontSize',20);
% xlabel('running speed','FontSize',20);
% ylabel('frequency','FontSize',20);

clust_lamda_CA1(1,1)=clust1_lamda_Rat6_CA1;
clust_lamda_CA1(1,2)=clust2_lamda_Rat6_CA1;
clust_lamda_CA1(1,3)=clust3_lamda_Rat6_CA1;
clust_lamda_CA1(1,4)=clust4_lamda_Rat6_CA1;
clust_lamda_CA1(1,5)=clust5_lamda_Rat6_CA1;

clust_lamda_CA1(2,1)=clust1_lamda_Rat13_CA1;
clust_lamda_CA1(2,2)=clust2_lamda_Rat13_CA1;
clust_lamda_CA1(2,3)=clust3_lamda_Rat13_CA1;
clust_lamda_CA1(2,4)=clust4_lamda_Rat13_CA1;
clust_lamda_CA1(2,5)=clust5_lamda_Rat13_CA1;

clust_lamda_CA1(3,1)=clust1_lamda_Rat17_CA1;
clust_lamda_CA1(3,2)=clust2_lamda_Rat17_CA1;
clust_lamda_CA1(3,3)=clust3_lamda_Rat17_CA1;
clust_lamda_CA1(3,4)=clust4_lamda_Rat17_CA1;
clust_lamda_CA1(3,5)=clust5_lamda_Rat17_CA1;

clust_lamda_CA1(4,1)=clust1_lamda_Rat24_CA1;
clust_lamda_CA1(4,2)=clust2_lamda_Rat24_CA1;
clust_lamda_CA1(4,3)=clust3_lamda_Rat24_CA1;
clust_lamda_CA1(4,4)=clust4_lamda_Rat24_CA1;
clust_lamda_CA1(4,5)=clust5_lamda_Rat24_CA1;

ffa = figure('Units','normalized','Position',[0 0 0.5625 1]);
hold on
for n=1:4  % number of rats
    plot([1,2,3,4,5],clust_lamda_CA1(n,:),'lineWidth',3,'color',[58 95 205]./255);
    scatter([1,2,3,4,5],clust_lamda_CA1(n,:),'fill','markerfacecolor',[58 95 205]./255);
end
set(gca, 'FontSize',20);
xlim([0.5,5.5]);
tickx=1:5;
set(gca, 'XTick',tickx);
xlabel('L: number of  normal density functions','FontSize',20);
ylabel('lamda_L','FontSize',20);
tit=['log likelihood function each cluster-',areaname];
title(tit,'FontSize',20);
filenam = strcat(tit);
saveas(ffa, strcat(subdir,'\',date,'-',filenam,'.png'),'png');
saveas(ffa, strcat(subdir,'\',date,'-',filenam,'.eps'),'epsc');





ffa = figure('Units','normalized','Position',[0 0 0.5625 1]);
hold on
for n=1:4  % number of rats
    lamda_diff(n,:)=clust_lamda_CA1(n,:)-clust_lamda_CA1(n,5);
    plot([1,2,3,4,5],lamda_diff(n,:),'lineWidth',3,'color',[58 95 205]./255);
    scatter([1,2,3,4,5],lamda_diff(n,:),'fill','markerfacecolor',[58 95 205]./255);
end
set(gca, 'FontSize',20);
xlim([0.5,5.5]);
tickx=1:5;
set(gca, 'XTick',tickx);
set(gca, 'XTickLabel',['L1';'L2';'L3';'L4';'L5']);
%ylim([-2000,0]);
%ticky=-2000:500:0;
%set(gca, 'YTick',ticky);
ylabel('lamda_L','FontSize',20);
tit=['log likelihood function-',areaname];
title(tit,'FontSize',20);
filenam = strcat(tit);
saveas(ffa, strcat(subdir,'\',date,'-',filenam,'.png'),'png');
saveas(ffa, strcat(subdir,'\',date,'-',filenam,'.eps'),'epsc');

lamda_diff_mean=mean(lamda_diff);
lamda_diff_sem=std(lamda_diff)./sqrt(4);
ffa = figure('Units','normalized','Position',[0 0 0.5625 1]);
errorbar(1:5,lamda_diff_mean,lamda_diff_sem,'lineWidth',3,'color',[58 95 205]./255);
set(gca, 'FontSize',20);
xlim([0.5,5.5]);
tickx=1:5;
set(gca, 'XTick',tickx);
set(gca, 'XTickLabel',['L1';'L2';'L3';'L4';'L5']);
%ylim([-2000,0]);
%ticky=-2000:500:0;
% set(gca, 'YTick',ticky);
ylabel('lamda_L','FontSize',20);
tit=['mean log likelihood function-',areaname];
title(tit,'FontSize',20);
filenam = strcat(tit);
saveas(ffa, strcat(subdir,'\',date,'-',filenam,'.png'),'png');
saveas(ffa, strcat(subdir,'\',date,'-',filenam,'.eps'),'epsc');