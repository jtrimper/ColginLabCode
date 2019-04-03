%function [exptTheta, thetaInt, exptKappa, kappaInt] = confidence (alpha, N_BOOTSTRAPS, data)
function confidence

alpha=.05;
N_BOOTSTRAPS=1000;
%set(0,'RecursionLimit',N_BOOTSTRAPS*2)
loadStr='load /N/u/anwilson/SP/confidence/TI_1.5Hz';
eval(loadStr);

%Phase condition order: 0:0, 0:90, 0:180, 90:90, 180:180
for expt = 1:5
   if expt==1
      data=zeroZero;
      saveName='zeroZero';
   else
      if expt==2
         data=zeroNinety;
         saveName='zeroNinety';
      else
         if expt==3
            data=zeroOneEighty;
            saveName='zeroOneEighty';
         else
            if expt==4
               data=ninetyNinety;
               saveName='ninetyNinety';
            else
               if expt==5
                  data=oneEightyOneEighty;
                  saveName='oneEightyOneEighty';
               end;
            end;
         end;
      end;
   end;
   
   thetaB=[]; thetaInt=[]; exptTheta=[];
   kappaB=[]; kappaInt=[]; exptKappa=[];
   rBarB=[]; rBarInt=[]; exptrBar=[];

	for trials=1:size(data, 2)
	   [theta, kappa, rBar] = circStats (data(:,trials));
	 	exptTheta=[exptTheta; theta]; 
      exptKappa=[exptKappa; kappa];
      exptrBar=[exptrBar; rBar];
      
	   thetaB=[]; kappaB=[]; rBarB=[];
      
	   for B=1:N_BOOTSTRAPS
         bootstrapTemp=[];
         
	      %Creates a new sample drawn from a von Mise distribution with parameters theta and kappa
   	   for n_Data=1:size(data, 1)
      	   THETA=vonMises (theta, kappa);
            bootstrapTemp=[bootstrapTemp; THETA];
         end;
         
      	%Algorithms 1-4, Fisher (1993), 8.3.5
      	%Data matrices
      	[z0, u0] = algorithm1(data(:,trials));
      	[v0] = algorithm2(u0);
         
      	%Bootstrap matrices
      	[zb, ub] = algorithm1(bootstrapTemp);
      	[vb] = algorithm2(ub);
      	[wb] = algorithm3(ub);
         
      	[muEst, kappaEst, rBar] = algorithm4(z0, v0, wb, zb, size(data,1));
         
      	thetaB=[thetaB; muEst];
         kappaB=[kappaB; kappaEst];
         rBarB=[rBarB; rBar];
      end;
   	thetaB=sort(thetaB);
      kappaB=sort(kappaB);
      rBarB=sort(rBarB);
      
   	l=floor(.5*N_BOOTSTRAPS*alpha + .5);
   	m=N_BOOTSTRAPS-l;
   	thetaInt=[thetaInt; thetaB(l+1) thetaB(m)];
      kappaInt=[kappaInt; kappaB(l+1) kappaB(m)];
      rBarInt=[rBarInt; rBarB(l+1) rBarB(m)];
   end;
   %Row of 0's separates phase conditions
	thetaInt=[thetaInt; 0 0]; kappaInt=[kappaInt; 0 0]; rBarInt=[rBarInt; 0 0];
	exptTheta=[exptTheta; 0 ]; exptKappa=[exptKappa; 0]; exptrBar=[exptrBar; 0];

	saveStr=['save confInt', int2str(expt), ' exptTheta thetaInt exptKappa kappaInt exptrBar rBarInt']
   eval(saveStr);
end;
