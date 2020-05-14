% Function that computes a Depth Map from a pair of images 
% Sintaxis: computeZMap(imageName,f,B,Ws,win_size)
% Inputs:
%       imageName: Name of the image pair (without extensión)
%       f: Flocal Length (mm)
%       B: Baseline between cameras (cm)
%       Ws: Sensor Width (mm)
%       win_size: window size for the matching algorithm

function computeZMap(imageName,f,B,Ws,win_size)
close all;

addpath('./stereo_toolbox');
maxD = 50; %Maximum allowed Disparity (in px)
border = 50; %Border in pixels to be removed from the 3D depth map (to improve visualization)

%We read images
folder=['images/' imageName];
imL=imread([folder '/imageL.jpg']);
imR=imread([folder '/imageR.jpg']);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%Computing Disparity in pixels%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% D is a matrix with the image dimensions HxW containing 
% the disparity (in px) for every pixel in the left image
[D D_nf] = stereo(imL,imR, maxD,win_size);
minD=min(D(D>0));
D=max(D,minD);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%Generating the Depth Map%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%Write Your code here%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Relate sensor and image by computing the pixel width (in mm/px)
pxWidth = Ws/size(imL, 2);

%Transform the Disparity matrix from pixels to mm
D = D*pxWidth;

%Compute the depth of the points in meters
Z = ((10*f*B)./D)/1000

%We limit Z values to improve visualization
maxZ=min(2*prctile(Z(:),50),1.01*prctile(Z(:),95));
Z=min(Z,maxZ);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%Showing the Depth Map%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Showing 2D results
figure();
subplot(2,2,1), imshow(imL); title('left image');
subplot(2,2,2), imshow(imR); title('right image');
colormap gray;
subplot(2,2,3), imshow(D,[0 max(D(:))]); title('Disparity map'); axis image;
subplot(2,2,4), imshow(Z,[0 max(Z(:))]); title('Depth map');axis image; 

%Show the Z Map in 3D
figure;mesh(-100*Z(:,border:end-border)');title('Depth map 3D (in cm)');axis image; 
