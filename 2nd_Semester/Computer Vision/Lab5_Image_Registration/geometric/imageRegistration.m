%Function that registers two images related by a transform matrix H
%Inputs:
        %- im1: original image 1
        %- im2: original image 2
        %- H: transformation matrix from im1 to im2
        %- coord1: euclidean (or homogeneous) coordinates of matched points
        %           in im1
%	Author: Iván González Díaz (2016)
%		Universidad Carlos III de Madrid
function imageRegistration(im1,im2,H,coord1)

% %Auxiliar code: count the number of open figures
% ag = findobj('Type','Figure');
% nf = length(ag);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%BLENDING MASK GENERATION%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mask=zeros(size(im1,1),size(im1,2));
%Setting the matched points to 1 in the mask
idxMask=round(coord1(1,:)-1)*size(im1,1)+round(coord1(2,:));
mask(idxMask)=1;
%Generating the mask that joins the matched points
mask = imclose(mask,strel('disk',200));
mask = imdilate(mask,strel('disk',50));
%Low-pass filtering for smooth blending
sigma=5;
hs=round(3*sigma);
mask=imfilter(double(mask),fspecial('gaussian',[hs hs],sigma));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%IMAGE REGISTRATION%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Compute the outputview for the transformation (the coordinates of im2, the reference for the alignment)
height=size(im2,1);
width=size(im2,2);
outputView= imref2d([height width], [1 size(im2,2)], [1 size(im2,1)]);

%Apply the transformation matrix both to the im1 and its mask
tform = projective2d(H');
regIm = imwarp(im1,tform,'outputView',outputView);
regMask = imwarp(mask,tform,'outputView',outputView);

%Show registered and end images
f=figure;
imshow(im2);
caxes = findobj(f,'type','axes');
title(caxes,'Image 2');

f=figure;
imshow(regIm,[]);
caxes = findobj(f,'type','axes');
title(caxes,'Registered image 1');

%f=figure;
%imshow(regMask);
%caxes = findobj(f,'type','axes');
%title(caxes,'Blending Mask');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%IMAGE BLENDING%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Generate a color mask
cregMask=repmat(regMask,[1 1 3]);
%Generate the blended image
blended=(1-cregMask).*im2double(im2)+cregMask.*im2double(regIm);
f=figure;
imshow(blended);
caxes = findobj(f,'type','axes');
title(caxes,'Blended Image pair');

