%filter_INIT Function that initializes a tracker using a particle filter
%      tracker = filter_INIT(f0,bbox,numParticles,A)     
%Parameters:
%       - f0: first frame where the object has been identified
%       - bbox: bounding box outlining the object within f0
%Output:
%        - tracker: structure with the tracker.

function [ tracker ] = filter_INIT(f0,bbox)
    
    %PARAMETERS OF THE PARTICLE FILTER
    K=128; %K is the number of bins in the histogram
    numParticles=1000; %Nunmber of particles
    t=1; % Delay between frames for the state-transition matrix
    
    %Set the initial state X_init=[bb_center_x bb_center_y bb_width  bb_height velocity_x velocity_y velocity_width velocity_height]
    x_init = [bbox(1)+0.5*bbox(3) bbox(2)+0.5*bbox(4) bbox(3) bbox(4) zeros(1,4)]';
    
    %State-transition matrix: constant velocity model
    A=[eye(4) t*eye(4); zeros(4) eye(4)];   
    
    %We obtain the visual representation of the original object
    bbox = round(bbox);
    objim = f0(bbox(2):bbox(2)+bbox(4), bbox(1):bbox(1)+bbox(3),:);
    
    %Compute the reference histogram => work in hsv space
    hist_ref =  computeHSVHistograms (objim, K);  % Calculamos el histograma de referencia.
    
    %Copy the state to all particles x is PxN being P the number of
    %parameters and N the number of particles
    x=repmat(x_init,1,numParticles);
    
    %Initialize weights uniformly
    w=(1/numParticles)*ones(numParticles,1);
    %Cumulative weights for particle resampling
    c=cumsum(w);
    
    %Vector with standard deviations of additive gaussian noise
    Sigma=[0.1 0.1 0.01 0.01 1e-2 1e-2 1e-3 1e-3]'; %Each dimension corresponds with one element in the state

    %Make sigma of static variables proportional to bounding box size
    Sigma(1:2)=Sigma(1:2).*min(bbox(3),bbox(4));
    Sigma(3)=Sigma(3).*bbox(3);
    Sigma(4)=Sigma(4).*bbox(4);
    
    % Generate the tracker structure
    tracker = struct('x',x,'c',c,'w',w,'hist_ref',hist_ref,...
        'bbox',bbox,'K',K,'N',numParticles,'A',A,'Sigma',Sigma,'Sigma_orig',Sigma);
end

