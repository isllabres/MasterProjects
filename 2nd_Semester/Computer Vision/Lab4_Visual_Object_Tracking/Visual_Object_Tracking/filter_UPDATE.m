%filter_INIT Function that updates a tracker using a particle filter
%      tracker = filter_UPDATE(tracker,fr)     
%Parameters:
%       - tracker: structure with the tracker.
%       - fr: frame to be processed
%       - a: concrete value of alpha
%       - b: concrete value of beta
%Output:
%        - tracker: structure with the updated tracker.
function [ tracker ] = filter_UPDATE(tracker, fr)

    
    N = tracker.N; %Number of particles
    hist_ref = tracker.hist_ref; %Reference Histogram  for comparison
    K = tracker.K; %Number of bins in the histogram
    P = size(tracker.x,1); %Number of params in the state
    x_new = tracker.x;
    new_w = tracker.w;
    [height, width, aux]=size(fr); %Dimensions of the frame
    idx_particles=zeros(N,1);
    
    %Particles loop
    for i=1:1:N

        %%%%STEP 1: PARTICLE RESAMPLING%%%%%%%%%%%%%%%%%%%
        val=rand;
        idx_particle = find(val<tracker.c,1);
        idx_particles(idx_particle)=idx_particles(idx_particle)+1;
        
        z=tracker.x(:,idx_particle);
        
        %%%%STEP 2: UPDATE THE PARTICLE STATE%%%%%%%%%%%%%%%%%%%
        %Generate noise
        %Matrix with noise
        noise=tracker.Sigma.*randn(P,1);
        x_new(:,i)=(tracker.A*z+noise);

        %%%%STEP 3: EXTRACT THE CANDIDATE AREA%%%%%%%%%%%%%%%%%%%
        try
            % We extract the region in the image corresponding with the
            % bounding box
            limy=[ceil(x_new(2,i)-0.5*x_new(4,i)) floor(x_new(2,i)+0.5*x_new(4,i))];
            limy=min(max(limy,1),height);
            limx=[ceil(x_new(1,i)-0.5*x_new(3,i)) floor(x_new(1,i)+0.5*x_new(3,i))];
            limx=min(max(limx,1),width);
            candidate_reg=fr(limy(1):limy(2),limx(1):limx(2),:); 
        catch
            candidate_reg = zeros(size(hist_ref));
        end
    
        %%%%%%%%%%STEP 4: COMPUTE THE COLOR HISTOGRAM%%%%%%%%%%%%%%%%    
        hist=computeHSVHistograms(candidate_reg,K);
    
        %%%%%%%%%%STEP 4: COMPUTE THE BATTACHARYYA COEFICCIENT BETWEEN HISTOGRAMS%%%%%%%%%%%%%%%%    
        hist_intersect=sum(sqrt(hist_ref.*hist));
        
        %Alpha controls how sharp are the weights
        alpha=35;
        tracker.w(i) = hist_intersect.^alpha;   %Update the weight of the particle
    end  
    
     
    %%%%STEP 5: UPDATE X, NORMALIZE THE WEIGHTS AND RECOMPUTE C%%%%%%%%%%%%%%%%%%%
    tracker.x=x_new;
    if (sum(tracker.w)>1e-30)
        tracker.w=tracker.w/sum(tracker.w);
    else
        disp('Error');
        tracker.w(:)=1/N;
    end
    tracker.c=cumsum(tracker.w);
    
    %%%%STEP 6: ESTIMATE THE BOUNDING BOX%%%%%%%%%%%%%%%%%%%
    % Weighted average
%     x_global=sum(repmat(tracker.w(i)',P,1).*tracker.x,2);
%     tracker.bbox=[x_global(1)-0.5*x_global(3) x_global(2)-0.5*x_global(4) x_global(3) x_global(4)];
%    
    %Best particle
    [~,idx_particle]=max(tracker.w);
    x_global=tracker.x(:,idx_particle);
    tracker.bbox=[x_global(1)-0.5*x_global(3) x_global(2)-0.5*x_global(4) x_global(3) x_global(4)];
    
    try
        % We extract the region in the image corresponding with the
        % bounding box
        limy=[ceil(x_global(2)-0.5*x_global(4)) ...
            floor(x_global(2)+0.5*x_global(4))];
        limy=min(max(limy,1),height);
        limx=[ceil(x_global(1)-0.5*x_global(3)) ...
            floor(x_global(1)+0.5*x_global(3))];
        limx=min(max(limx,1),width);
        best_reg=fr(limy(1):limy(2),limx(1):limx(2),:); 
    catch
        best_reg = zeros(size(hist_ref));
    end
   
    %% STEP 7: COMPUTE THE COLOR HISTOGRAM OF THE BEST PARTICLE (Our code) %%%%%%%%%%%%%%%%    
    hist_bestparticle = computeHSVHistograms(best_reg,K);
    %%%%%%%%%%STEP 7: COMPUTE THE BATTACHARYYA COEFICCIENT BETWEEN HISTOGRAMS%%%%%%%%%%%%%%%%
    hist_intersect = sum(sqrt(hist_bestparticle.*hist_ref));

%% STEP 8 --- UPDATE SIGMA: (Our code) calculate sigma (noise) - BASED ON THE PAPER

    alph = 4; %controls the stepness of the transition
    beta = 0.05; %adjust the position in which the transition takes place
    blindness = (erf(alph*((1-hist_intersect)-beta))+1)/2;


    new_static_sigma =blindness*tracker.Sigma_orig(1:4);
    new_dynamic_sigma = (1-blindness)*tracker.Sigma_orig(5:end);

    new_Sigma = [new_static_sigma ; new_dynamic_sigma];
    %Make sigma of static variables proportional to bounding box size
    new_Sigma(1:2)=new_Sigma(1:2).*min(tracker.bbox(3),tracker.bbox(4));
    new_Sigma(3)=new_Sigma(3).*tracker.bbox(3);
    new_Sigma(4)=new_Sigma(4).*tracker.bbox(4);
    tracker.Sigma = new_Sigma;
    

    if (blindness<0.0001) %update ref histogram and sigma
        tracker.hist_ref = hist_bestparticle;
        fprintf('Histogram update\n');
    %         tracker.Sigma_orig = new_Sigma;
    end
    if (min(new_Sigma)<=0.001)%because very low sigmas leads to failure
        %at histogram computation
        tracker.Sigma = tracker.Sigma_orig;
%         fprintf('Sigma reset\n');
    else
        fprintf('NO Sigma reset\n');
    end
end

