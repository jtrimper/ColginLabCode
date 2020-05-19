function [Struct] = PCANetworkFunc_relearn(Struct, paint)
%
% This function used to re-learn the grid-cells using the scrambled place cell weight to location 
% combinations. 

%matrix used for cacluating the autocorrelations
n_mat=mulMatCross(zeros(Struct.N),zeros(Struct.N));

% Don't bother re-calculating the locations. Just pull them from the structure. 
placeCenters = Struct.placeCenters; 
X = reshape(placeCenters(1,:)', 25,25); 
Y = reshape(placeCenters(2,:)', 25,25); 



%% DOG properties -- Define the place fields. 
%   This will just repeat what has already been done during the initial simulations. PF locations are
%   not different, nor are PF features (aside from shuffled weights), but we need the variables here 
%   and they're not all saved in the structure so gotta re-create them

% % place cell STD and angle -sombrero hat
sigma_x = Struct.PcSize;
sigma_y = Struct.PcSize;
theta = 2*pi*rand(1,length(placeCenters)); %Gives a "tilt" to the place cell... not used when sigma_x =sigma_y
a_std = cos(theta).^2/2/sigma_x.^2 + sin(theta).^2/2/sigma_y.^2;
b_std = -sin(2*theta)/4/sigma_x.^2 + sin(2*theta)/4/sigma_y.^2 ;
c_std = sin(theta).^2/2/sigma_x.^2 + cos(theta).^2/2/sigma_y.^2;
% place cells sombrero hat - 2nd Gaussians
sigma_x2 = 2*sigma_x;
sigma_y2 =2*sigma_y;
theta2 = 2*pi*rand(1,length(placeCenters));
a_std2 = cos(theta2).^2/2/sigma_x2.^2 + sin(theta2).^2/2/sigma_y2.^2;
b_std2 = -sin(2*theta2)/4/sigma_x2.^2 + sin(2*theta2)/4/sigma_y2.^2 ;
c_std2 = sin(theta2).^2/2/sigma_x2.^2 + cos(theta2).^2/2/sigma_y2.^2;
% Disks properties
r1 =  Struct.PcSize;%widths(u);
r2 = r1*2;
%creating the disks pre-run
gamma1 = 1;% inside r1 value
%gamma2 = bestGamma(r1,r2,placeCenters(1:2,i),gamma1,NN,X1,Y1);
NN = Struct.Resolution ;
G1 = zeros(NN,NN,length(placeCenters));
xx=linspace(0,Struct.maxx,NN);
yy=linspace(0,Struct.maxy,NN);
[X1,Y1] = ndgrid(xx, yy);
for i=1:length(placeCenters)
    %gamma2 is the value in the outer disk. it's negative and
    %together with the positive value inside the total sum should
    %be zero
    %fixing gamma2 according to resolution and with modulo
    gamma2 = bestGamma(r1,r2,placeCenters(1:2,i),gamma1,NN,X1,Y1);
    I=zeros(NN);
    % Boundary coditions - periodic!!!
    diff_x = min(mod(X1-placeCenters(1,i),Struct.maxx),mod(placeCenters(1,i)-X1, Struct.maxx));
    diff_y = min(mod(Y1-placeCenters(2,i),Struct.maxx),mod(placeCenters(2,i)-Y1, Struct.maxy));
    %difne the disks and their values
    circleEq =diff_x.^2+ diff_y.^2;
    I  (circleEq<r1^2  )  = gamma1;
    I  ( (circleEq>=r1^2  )  &  (circleEq<=r2^2  ))  = - gamma2;
    G1(:,:,i) =I;
end
Struct.DisksData = G1;



%% Model variables - Weights

% Get the previously created place-cell weights
J = Struct.J'; %it was transposed upon storage during the first round of this function 

% Get the previously stored lateral weights (GC/GC weights)
W = Struct.W; %this is symmetrical about the diagonal so transposition makes no difference

% the relative importance of the inter layer connections (equally important if 0.5)
rho=0.5; %<- same as on the first go around




%% Initial conditions

% Initializing vector for input from place cells to grid cells, scaled by rho and factoring in both lateral and ff weights
h = zeros(1,Struct.NmEC); % 1 x #GCs

% Initializing vector for avg of h over time:  
h_avg = zeros(1,Struct.NmEC); % 1 x #GCs

% Initializing input data (place cell rates)
r = zeros(1,Struct.N1); % 1 x #PCs

% Initialize start location
x = Struct.maxx/2; %starting in the middle of the square arena
y = Struct.maxy/2;
curDir = 0;

% Initialize Derivatives (only applied if using gaussian)
r_prev = 0;
r_gaussian =0;

% Initialize time variables
tind = 0;
dt = 1;
t = 0;


%% !! Main simulation loop
fprintf('Simulation starting. Press ctrl+c to end...\n')
fprintf(['Input type:',Struct.placeCellType,'\n'])
fprintf(['Architecture type:',Struct.Arc,'\n'])
if paint==1
    fig1 = figure;
end
while t<Struct.simdur
    
    % Increase time 
    tind = tind+1;
    t = dt*tind;
    
    
    %% Get rat's new coordinates
    
    % Next direction to move in
    randDir = mod(curDir + Struct.angular*randn,2*pi); %make rat move in a random direction
    curDir = randDir; % rad
    
    % Next location based on angular velocity and linear velocity
    next_x=mod(x+Struct.vel*cos(randDir),Struct.maxx); %find the rat's next coordinates
    next_y=mod(y+Struct.vel*sin(randDir),Struct.maxy);
    
    % Actual new location
    x = next_x;
    y = next_y;
    
    
    %% Calculating new place cells firing rate
    
    % Periodic distance from the rat in X & Y for each place cell
    diff_x = min(mod(x-placeCenters(1,:),Struct.maxx),mod(placeCenters(1,:)-x,Struct.maxx));
    diff_y = min(mod(y-placeCenters(2,:),Struct.maxx),mod(placeCenters(2,:)-y,Struct.maxy));
    
    % Euclidean distance (squared) according to the 1st and 2nd Gaussian for each place cell 
    %    i.e., the scale for how active each cell should be based on the rat's location
    %          These will be applied to different degrees based on which type of place field you went with
    squareDists = (a_std.*(diff_x).^2 +2*b_std.*(diff_x).*(diff_y) + c_std.*(diff_y).^2 );
    squareDists2 = (a_std2.*(diff_x).^2 +2*b_std2.*(diff_x).*(diff_y) + c_std2.*(diff_y).^2 );
    
    A = sigma_x^2/sigma_x2^2; %for us, it's gonna be 0.25
    if strcmp(Struct.placeCellType,'DOG')
        
        % How much each place cell is active at this location based on the mexican hat place field
        r = (Struct.psiSat.*exp(-squareDists)) - (Struct.psiSat)*A.*exp(-squareDists2)+eps;
    
    elseif strcmp(Struct.placeCellType,'Disk')
        r = zeros(1,Struct.N1);
        x_mat1=repmat(x,1,NN);
        y_mat1=repmat(y,1,NN);
        [~, ind_x1]=min(abs(xx - x_mat1));
        [~, ind_y1]=min(abs(yy - y_mat1));
        r(1:end) = G1(ind_x1,ind_y1,:);
    
    elseif  strcmp(Struct.placeCellType,'Gaussian')
        r_prev_prev = r_prev;
        r_prev = r_gaussian;
        r_gaussian = Struct.psiSat.*exp(-squareDists) ;%use only the smallest guassian for the place-cells
    
        %% Zero mean if needed
        if strcmp(Struct.meanZaro,'diff')
            delta_r = r_gaussian - r_prev;
            delta_r2 = r_prev - r_prev_prev;
            delta2_r = (delta_r - delta_r2);
            r = delta2_r;
        elseif strcmp(Struct.meanZaro,'adpat')
            h_adpt = h-h_avg;
            h_avg = h_avg + Struct.b2*(h-h_avg);
            r = r_gaussian;  %might be over-run if uusing dirvatives
        end
        
    end
    
    %Update learning rule
    epsilon = (1/(tind*Struct.delta+Struct.epsilon));
    
    if strcmp(Struct.Arc, 'single')
        h =  (J*r')' ;
    elseif strcmp(Struct.Arc, 'multiple')
        h =  (1-rho)*(J*r' )' + rho*(W*(h+eps)')'; 
         %h = weightedImportanceOfFFWeights * (weights * activation)    +  
         %      weightedImportanceOfLateralWeights * (LateralWeights * previousOutput)
        
    end
    
    if  strcmp(Struct.meanZaro,'adpat')  && strcmp(Struct.placeCellType,'Gaussian')
        h_out = h_adpt;
    else
        h_out = h;
    end
    
    %output function. can be linear, but requires some slope
    if strcmp(Struct.output, 'sigmoid')
        slope = 100;
        psi =Struct.psiSat*.7 *atan(slope*(h_out));
    elseif strcmp(Struct.output, 'linear')
        slope = 100;
        psi =slope* h_out;
    end
    
    %updating weights. Oja rule
    deltaJ = psi'*r -  eye(Struct.NmEC,Struct.NmEC).*(psi'*psi)*J;
    J = J +epsilon*(deltaJ);
    if strcmp(Struct.Arc, 'multiple')
        %inter-output layer. weights need to be learned very slow. there's
        %a positive feedback...
        W= W - 0.001*epsilon*(psi'*psi);
        %No self connections
        W = (ones(size(W)) - eye(size(W))).*W; %(NOTE: dot product...)
    end
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %sanger rule
    if strcmp(Struct.Arc, 'sanger')
        h =  (J*r')' ;
        J = J + epsilon*(h'*r -tril(h'*h)*J);
    end
    %%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %non-negativity of weights
    if Struct.NonNegativity
        J(J<0)=0;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%    drwaing
    if paint
        numcell = 1;
        if((mod(tind,Struct.simdur/100)==0))
            fprintf(['Simulation time is:', num2str(tind),'\n'])
            
            subplot(3,2,1:2)
            plot(W(numcell,:),'r');
            title([' Lateral weights. #Iteration ',num2str(tind)])
            xlabel('Grid cells')
            subplot(3,2,3:4)
            plot(J(numcell,:),'g' )%current position inside the rec
            title([' Inter layer weight  - J, to grid cell number ', num2str(numcell) ])
            xlabel('Place cells')
            subplot(3,2,5)
            %imagesc(reshape(J(numcell,:),N,N))
            Vq = griddata(placeCenters(1,:),placeCenters(2,:),J(numcell,:),X,Y);
            imagesc(X(1,:),Y(:,1),Vq);
            title(['Spatial activity of weights - J ',]), colormap jet
            axis equal
            cross_map=Cross_Correlation( Vq, Vq,n_mat);
            subplot(3,2,6)
            imagesc(cross_map);
            title(['AutoCorrelation of weights - J, ',]), colormap jet
            axis equal
            drawnow
            pause(.00001);
            hold off;
        end
    end
    
    if Struct.saveInput
        Struct.TemporalInput(:,tind) = r;
    end
    
    Struct.J = J';
end

%InputSaved =  Struct.TemporalInput;

close (fig1)
end




