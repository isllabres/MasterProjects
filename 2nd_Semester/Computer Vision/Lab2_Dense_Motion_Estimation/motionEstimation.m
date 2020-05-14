%Function that computes and visualizes the Optical Flow of a Video Sequence
% Syntaxis: motionEstimation(video_name,step,algorithm,save_output)
%   Inputs:
%     video_name : name of the Video (path is not necessary)
%     step: Temporal Step between frames (step=1 means consecutive frames)  
%     algorithm: Three Options:
%        -'BB' for block-based techniques
%        -'LK' for Lucas-Kanade technique
%        -'HS' for Horn-Schunk technique
%        -'FB' for Farneback technique
%     save_output: if set to 1, it stores the resulting images with the
%     motion field in the folder outputs.
%     extendedVisualization: if set to 0, only the optical flow is shown, if set to 1 
%     extra-visualization about motion compensation and residual is shown
%   Example:
%       motionEstimation('coastguard',1,'BB',0,0)

function motionEstimation(video_pattern,step,algorithm,save_output,extendedVisualization)

%Parameter Section

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Block-based%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  BSL        - It defines the size of the block around a pixel used to 
%               compute its motion. The block is a square of side 2*BSL+1 
%  SRL        - It defines the search range as a square of side 2*SRL+1
%  sigmaCC    - Standard Deviation of a Gaussian Preprocessing Filtering of
%               Images
%  lambda     - Regularization of the Cost Function to strenghten small vectors: 
%               C(u) = em(u) + lambda * ||u||, where em(u) is the error metric 
%               (SSD, SAD or 1-NCC).
%  em         - Error Metric: Used Error Metric=> 1: SSD, 2: SAD, 3: NCC
%               (1-NCC to be an Error Metric)
BSL=5;
SRL=7;
sigmaCC=1;
lambda=1;
em=2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Lukas & Kanade%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  winLK     - Radius of the Circular Neighborhood (Omega)
%  sigmaLK   - Standard Deviation of a Gaussian Preprocessing Filtering of
%              Images
%  thrLK     - Confidence Threshold to decide that an estimation is well
%              right
winLK=10;
sigmaLK=5;
thrLK=2e-5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Horn & Schunk%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  alphaHS  - Regularization parameter (alpha) for the Horn & Schunk
%             Technique
%  sigmaHS  - Standard Deviation of a Gaussian Preprocessing Filtering of
%              Images
alphaHS=1e3;    
sigmaHS=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Farneback%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  neighSizeFB  - Size of square Neighborhood neighSizeFB x neighSizeFB
%  pyramidLevelsFB - Number of levels in the pyramidal estimation
neighSizeFB=5;    
pyramidLevelsFB=1;

%%%%%%%%%%%%%%PROGRAM CODE%%%%%%%%%%%%%%%%%%%%
close all;
scale=1; 
addpath('./toolbox/images');
addpath('./toolbox/filters');




inputVideoDir=sprintf('./videos/%s',video_pattern);
%Automatically compute the length of the video
finit=1;
D=dir([inputVideoDir '/*jpg']);
fend=size(D,1);

videoDir=sprintf('./outputs/%s/',video_pattern);
mkdir(videoDir);
cont=0;

path1=sprintf('%s/%s%03d.jpg',inputVideoDir,video_pattern,finit);
im1=imread(path1);
im1=imresize(im1,scale);
gim1=rgb2gray(im1);


if(strcmp(algorithm,'FB'))
    opticFlow = opticalFlowFarneback('NeighborhoodSize',neighSizeFB,'NumPyramidLevels',pyramidLevelsFB);
    flow = estimateFlow(opticFlow,gim1);
end

%Loop of frames
for i=finit:step:fend-step-1
    cont=cont+1;
    fprintf('.');
    if(rem(i,25)==0)
        fprintf('\n');
    end
    path1=sprintf('%s/%s%03d.jpg',inputVideoDir,video_pattern,i);
    path2=sprintf('%s/%s%03d.jpg',inputVideoDir,video_pattern,i+step);
    im1=imread(path1);
    [H W c]=size(im1);
    im2=imread(path2);
    im1=imresize(im1,scale);
    im2=imresize(im2,scale);
    gim1=rgb2gray(im1);
    gim2=rgb2gray(im2);
    if(strcmp(algorithm,'BB'))
        [Vx,Vy] = optFlowBB( double(gim1), double(gim2), BSL, SRL, sigmaCC, lambda, 0, em ); 
    elseif(strcmp(algorithm,'LK'))
        [Vx,Vy] = optFlowLk( gim1, gim2, winLK, [], sigmaLK,thrLK, 0);
    elseif(strcmp(algorithm,'HS'))
        [Vx,Vy] = optFlowHorn( gim1, gim2, sigmaHS,alphaHS,0) ;
    elseif(strcmp(algorithm,'FB'))
        flow = estimateFlow(opticFlow,gim2);
        Vx=flow.Vx;
        Vy=flow.Vy;
    else
        printf('Algorithm not known');
    end
    
    cVx=round(Vx);
    cVy=round(Vy);
    % We do signal clipping on the the vectors to avoid noisy values
    Vx=sign(Vx).*min(abs(Vx),5);
    Vy=sign(Vy).*min(abs(Vy),5);
    Vx(abs(Vx)<0.1)=0;
    Vy(abs(Vy)<0.1)=0;
    
    %%%%%%%%%%%%%%%%%%%%%OPTICAL FLOW VISUALIZATION%%%%%%%%%%%%%%%%%%%%%
    bs=16;
    bx=W/bs;
    by=H/bs;
    sVx=imresize(Vx,[by bx]);
    sVy=imresize(Vy,[by bx]);
    im2s=min(im2+50,255);
    
    if(~extendedVisualization)
        f = figure(1);
        imshow(im2s,'Border', 'tight');
        hold('on');
        %1.5,
        quiver(bs/2:bs:W,bs/2:bs:H,sVx, sVy,'r-','Linewidth',1);
        hold off;
        pause(0.01);
    end
    if(save_output)
        output=sprintf('outputs/%s/%s%03d.jpg',video_pattern,video_pattern,cont);
        [H,W,D] = size(im2s);
        im=zbuffer_cdata(f);
        imwrite(im,output);
    end
    %Block for extended visualization
    if(extendedVisualization)
        figure(1);
        subplot(2,3,1);
        imshow(im1);
        title('Frame n-1')
        subplot(2,3,2);
        imshow(im2);
        eo=mean(gim2(:).^2);
        title(sprintf('Frame n: Ec=%.2f', eo));
        subplot(2,3,3);
        imshow(im2s,'Border', 'tight');
        hold('on');
        %1.5,
        quiver(bs/2:bs:W,bs/2:bs:H,sVx, sVy,'r-','Linewidth',1);
        hold off;
        title('Motion Vector Map')
        subplot(2,3,5);
        res=gim2-gim1;
        enc=mean(res(:).^2);
        imshow(res,[-255 255]);
        title(sprintf('Residual w/o motion compensation: Ec=%.2f',enc));
        %Compensated Image
        imC=zeros(size(im1));
        for y=1:H
            for x=1:W
                ypos=min(max(y-cVy(y,x),1),H);
                xpos=min(max(x-cVx(y,x),1),W);
                imC(y,x,:)=im1(ypos,xpos,:);
            end
        end
        imC=uint8(imC);
        
        subplot(2,3,4);
        imshow(imC);
        title('Motion Compensated Frame n-1 ');
        
        res=gim2-double(rgb2gray(imC));
        subplot(2,3,6);
        imshow(res,[-255 255]);
        ec=mean(res(:).^2);
        title(sprintf('Residual with motion compensation: Ec=%.2f',ec));
        pause;
    end
end

function cdata = zbuffer_cdata(hfig)
% Get CDATA from hardcopy using zbuffer

% Need to have PaperPositionMode be auto
orig_mode = get(hfig, 'PaperPositionMode');
set(hfig, 'PaperPositionMode', 'auto');

cdata = hardcopy(hfig, '-Dzbuffer', '-r0');

% Restore figure to original state
set(hfig, 'PaperPositionMode', orig_mode); % end
