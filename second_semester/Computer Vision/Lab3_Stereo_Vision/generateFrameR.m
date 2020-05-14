% Function that generates a Right Frame from a Left Frame and User Inputs
% generateFrameR(imageName,f,B,Ws)
% Inputs:
%       imageName: Image Name (without extension)
%       f: Focal Length (mm)
%       T: Baseline between cameras (cm)
%       Ws: Sensor Width (mm)
function generateFrameR(imageName,f,T,Ws)
close all;

%Step 1: We load and show frame L 
folder=['images/' imageName];
im=imread([folder '/imageL.jpg']);
[H W c]=size(im);
figure(1);imshow(im);
title('Image L');

%Step 2: We read the regions in the segmentation and choose their depth
files=dir([folder '/r*.png']);
R=length(files);
Z=zeros(H,W);

for r=1:R
    mask=imread([folder '/r' num2str(r) '.png']);
    mask_show=im.*uint8(mask>0);
    mask_bin=rgb2gray(mask)>0;
    figure(2);imshow(mask_show);
    depth=input('Choose the Z (depth) for this region (meters): ');    
    Z(mask_bin>0)=depth*100;
end
figure(2);imshow(Z,[min(Z(:)) max(Z(:))]);
title('Map of Depth (Z)');

Z(Z==0)=1000;

%Step 3: Convert from a Depth Map to a Disparity Map (in mm)
Dmm=(T*0.01*f)./Z;


%Step 4: Convert to a Disparity Map in pixels
px_x_mm=W/Ws;
D=ceil(Dmm*px_x_mm);
figure(3);imshow(D,[min(D(:)) max(D(:))]);
title('Map of Disparity (D)');

%Step 5: Generate the Right Frame by shifts
imR=zeros(size(im));
for y=1:H
    for x=1:W
        nx=x-D(y,x);
        if(nx>0 && nx<=W)
            imR(y,nx,:)=im(y,x,:);
        end
    end
end

%Step 6: Fill wholes (occlusions) from their neighborhoods
hs=27;
in=imR(:,:,1);
imR(:,:,1) = nlfilter(in,[hs hs],@(in)roimedianfilt(in));
in=imR(:,:,2);
imR(:,:,2) = nlfilter(in,[hs hs],@(in)roimedianfilt(in));
in=imR(:,:,3);
imR(:,:,3) = nlfilter(in,[hs hs],@(in)roimedianfilt(in));


%Step 7: Show and store resulting image R
imR=uint8(imR);
figure(4);imshow(imR);
title('Image R');
imwrite(imR,[folder '/imageR.jpg']);


%%----- HELPER FUNCTIONS
function val=roimedianfilt(A)
A=A(:);
L=length(A);
if(A(floor(L/2)+1)>0)
    val=A(floor(L/2)+1);
else
    A=A(A>0);
    if(~isempty(A))
        val=median(A);
    else
        val=0;
    end    
end
