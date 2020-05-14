%-----------------------------------------------------------------
% function [dsp_f dsp] = stereo(img_L,img_R, maxs, win_size)
%
% 3D from stereo.  This function takes a stereo pair
% (that should already be registered to become a standard stereo 
% so the only difference is in the % 'x' dimension), 
% and produces a 'disparity map.'  The output here is
% pixel disparity, which can be converted to actual distance from the
% cameras if information about the camera geometry is known.
% 
% The output here does show which objects are closer.
% Brighter = closer
%
% EXAMPLE:
% img_L = imread('tsuL.jpg');
% img_R = imread('tsuR.jpg');
% [dsp_f dsp] = stereo(img_L,img_R,20,win_size);
%
% Inputs:
%   img_L  = left image
%   img_R  = right image
%   maxs   = maximum pixel disparity.  (depends on image pair)
%   win_size  = size of window used when smoothing
% Outputs:
%   dsp   = pixel disparities before final filtering (0 indicates bad pixel)
%   dsp_f = final disparity map after mode filtering
%
% Algorithm: 
% 1) Compute pixel disparity by comparing shifted versions of images.  
% 2) Use 2D median filter to replace low-confidence information with 
%    information from high-confidence neighbors.
% 
% Coded by Shawn Lankton (http://www.shawnlankton.com) Feb. 2008
% Modified by Iván González Díaz
%-----------------------------------------------------------------

function [fdsp, dsp] = stereo(img_L,img_R, maxs,win_size)
  tolerance = 3; %-- how close R-L and L-R values need to be
  weight    = 5; %-- weight on gradients opposed to color
  minVal    = 2; %minimum value of the disparity to be considered in the final filtering
  
  %--determine pixel correspondence Left-to-Right and Right-to-Left
  [dsp1, diff1] = slide_images(img_L,img_R,  1,  maxs, win_size, weight);
  [dsp2, diff2] = slide_images(img_R,img_L, -1, -maxs, win_size, weight);
  
  %--keep only high-confidence pixels and filter the image
  dsp = winner_take_all(dsp1,diff1,dsp2,diff2,tolerance);
  %Find low confidence pixels
  mask_low = dsp<minVal;
  
  %ROI median filtering for low confidence areas
  fdsp=dsp;
  fdsp1= nlfilter(fdsp,[51 51],@(fdsp)roimedianfilt1(fdsp, minVal));
%   fdsp1= colfilt(fdsp,[51 51],'sliding',@(fdsp)roimedianfilt2(fdsp, minVal));
  fdsp(mask_low) = fdsp1(mask_low);
  
  %Final median filtering
  fdsp = medfilt2(fdsp,[win_size win_size],'symmetric');  



%%----- HELPER FUNCTIONS
function val=roimedianfilt1(A,minVal)
A=A(:);
L=length(A);
if(A(floor(L/2)+1)>=minVal)
    val=0;
else
    A=A(A>=minVal);
    if(~isempty(A))
        val=median(A);
    else
        val=0;
    end    
end


%%----- HELPER FUNCTIONS
function val=roimedianfilt2(A,minVal)
A(A<minVal)=NaN;
val=median(A,'omitnan');


    
%-- takes the best disparity when we're within tolerance
% pd are the disparities
% mask_low is a binary mask with low confidence pixels
function [pd, mask_low] = winner_take_all(d1,m1,d2,m2,tolerance)
  pixel_dsp = zeros(size(d1));               %-- initialize output
  idx1 = find(abs(d1-d2)<tolerance & m1<m2); %-- find where d1 is best (m1<m2)
  idx2 = find(abs(d1-d2)<tolerance & m2<m1); %-- find where d2 is best (m2<m1)
  pixel_dsp(idx1) = d1(idx1);                %-- fill with d1
  pixel_dsp(idx2) = d2(idx2);                %-- fill with d2
  pd = pixel_dsp;
  
  
%-- slides images across each other to get disparity estimate
% disparity : best displacement
% mindiff: minimum visual distance between matched blocks
function [disparity, mindiff] = slide_images(i1,i2,mins,maxs,win_size,weight)
  [dimy,dimx,c] = size(i1);
  disparity = zeros(dimy,dimx);    %-- init outputs
  mindiff = inf(dimy,dimx);    
  
  h = ones(win_size)/win_size.^2;  %-- averaging filter

  [g1x g1y g1z] = gradient(double(i1)); %-- get gradient for each image
  [g2x g2y g2z] = gradient(double(i2));
  
  step = sign(maxs-mins);          %-- adjusts to reverse slide
  for i=mins:step:maxs
    s  = shift_image(i2,i);        %-- shift image and derivs
    sx = shift_image(g2x,i);
    sy = shift_image(g2y,i);
    sz = shift_image(g2z,i);

    %--CSAD  is Cost from Sum of Absolute Differences
    %--CGRAD is Cost from Gradient of Absolute Differences
    diffs = sum(abs(i1-s),3);       %-- get CSAD and CGRAD

    gdiffx = sum(abs(g1x-sx),3);
    gdiffy = sum(abs(g1y-sy),3);
    gdiffz = sum(abs(g1z-sz),3);
    gdiff = gdiffx+gdiffy+gdiffz;
    
    CSAD  = imfilter(diffs,h);
    CGRAD = imfilter(gdiff,h);
    d = CSAD+weight*CGRAD;          %-- total 'difference' score
    
    idx = find(d<mindiff);          %-- put corresponding disarity
    disparity(idx) = abs(i);        %   into correct place in image
    mindiff(idx) = d(idx);
  end
  
%-- Shift an image
function I = shift_image(I,shift)
  dimx = size(I,2);
  if(shift > 0)
    I(:,shift:dimx,:) = I(:,1:dimx-shift+1,:);
    I(:,1:shift-1,:) = 0;
  else 
    if(shift<0)
      I(:,1:dimx+shift+1,:) = I(:,-shift:dimx,:);
      I(:,dimx+shift+1:dimx,:) = 0;
    end  
  end
  
