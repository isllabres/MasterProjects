function [Vx,Vy,reliab] = optFlowBB( I1, I2, patchR, searchR, sigma, thr, show , medida)
% Calculate optical flow using B
%
% Calculate optical flow using correlation, followed by lucas & kanade on
% aligned squares for subpixel accuracy.  Locally, the closest patch within
% some search radius is found.  The distance measure used is the euclidean
% distance between patches -- NOT normalized correlation since we assume
% pixel brightness constancy.  Once the closest matching patch is found,
% the alignment between the two patches is further refined using lucas &
% kanade to find the subpixel translation vector relating the two patches.
%
% This code has been refined for speed, but since it is nonvectorized code
% it can be fairly slow.  Running time is linear in the number of pixels
% but the constant is fairly large.  Test on small image (150x150) before
% running on anything bigger.
%
% USAGE
%  [Vx,Vy,reliab] = optFlowCorr( I1, I2, patchR, searchR,
%                                 [sigma], [thr], [show] )
%
% INPUTS
%  I1, I2      - input images to calculate flow between
%  patchR      - determines correlation patch size around each pixel
%  searchR     - search radius for corresponding patch
%  sigma       - [1] amount to smooth by (may be 0)
%  thr         - [.001] RELATIVE reliability threshold
%  show        - [0] figure to use for display (no display if == 0)
%
% OUTPUTS
%  Vx, Vy      - x,y components of flow  [Vx>0->right, Vy>0->down]
%  reliab  - reliability of optical flow in given window (cornerness of
%            window)
%
% EXAMPLE
%
% See also OPTFLOWHORN, OPTFLOWLK
%
% Piotr's Image&Video Toolbox      Version 2.0
% Copyright 2008 Piotr Dollar.  [pdollar-at-caltech.edu]
% Please email me if you find bugs, or have suggestions or questions!
% Licensed under the Lesser GPL [see external/lgpl.txt]


if( nargin<5 || isempty(sigma)); sigma=1; end;
if( nargin<6 || isempty(thr)); thr=0.000; end;
if( nargin<7 || isempty(show)); show=0; end;

% error check inputs
if( ndims(I1)~=2 || ndims(I2)~=2 )
  error('Only works for 2d input images.');
end
if( any(size(I1)~=size(I2)) )
  error('Input images must have same dimensions.');
end
if( isa(I1,'uint8')); I1 = double(I1); I2 = double(I2); end;

% smooth images (using the 'smooth' flag causes this to be slow)
I1b = gaussSmooth( I1, [sigma sigma], 'smooth' );
I2b = gaussSmooth( I2, [sigma sigma], 'smooth' );

% precomputed constants
subpixelaccuracy = 0;
siz = size(I1);
bigR = searchR + patchR;
n = (2*patchR+1)^2;
widthD = 2*searchR+1;


% % pad I1 and I2 by searchR in each direction
% I1b = padarray(I1b,[searchR searchR],0,'both');
% I2b = padarray(I2b,[searchR searchR],0,'both');
[H W] = size(I1b);

% auxI1=uint8(I1b)';
% auxI2=uint8(I2b)';
% fid=fopen('./im1.bin','wb');
% fwrite(fid,auxI1(:),'uint8');
% fclose(fid);
% fid=fopen('./im2.bin','wb');
% fwrite(fid,auxI2(:),'uint8');
% fclose(fid);
% os=computer;
[Vx Vy]=bm(I1b',I2b',patchR,searchR,medida,thr);
Vx=Vx';
Vy=Vy';
Vx=imresize(Vx,[H W]);
Vy=imresize(Vy,[H W]);
% if(strcmp(os,'PCWIN'))
%     command=sprintf('toolbox\\images\\BM.exe im1.bin im2.bin %d %d %d %d %d', patchR,searchR,H,W,medida);
% else
%     command=sprintf('./toolbox/images/bm ./im1.bin ./im2.bin %d %d %d %d %d', patchR,searchR,H,W,medida);
%     
% end
% system(command);
% fid=fopen('./u.bin','r');
% u=fread(fid,'int');
% Vx=reshape(u,W,H)';
% fclose(fid);
% fid=fopen('./v.bin','r');
% v=fread(fid,'int');
% fclose(fid);
% Vy=reshape(v,W,H)';
% reliab=0;

% % loop over each window
% Vx = zeros( sizB-2*bigR ); Vy = Vx;  reliab = Vx;
% for r = bigR+1:sizB(1)-bigR
%   for c = bigR+1:sizB(2)-bigR
%       [r c]
%     T = I1b( r-patchR:r+patchR, c-patchR:c+patchR );
%     IC = I2b( r-bigR:r+bigR, c-bigR:c+bigR );
% 
%     [I_SSD,I_NCC]=template_matching_gray(T,IC,[]);
%     if(medida==1)
%         [vy vx]=find(I_SSD==max(I_SSD(:)),1);
%     else
%         [vy vx]=find(I_NCC==max(I_NCC(:)),1);
%     end
%     %Ahora restamos el offset
%     v(1)=vy-round(size(I_SSD,1)/2);
%     v(2)=vx-round(size(I_SSD,2)/2);
%     
%     % record reliability and velocity
%     Vx(r-bigR,c-bigR) = v(2);
%     Vy(r-bigR,c-bigR) = v(1);
%   end;
% end;
% 

% resize all to get rid of padding
% Vx = arrayToDims( Vx, siz );
% Vy = arrayToDims( Vy, siz );
% reliab = arrayToDims( reliab, siz );
% 
% % scale reliab to be between [0,1]
% reliab = reliab / max([reliab(:); eps]);
% Vx(reliab<thr) = 0;  Vy(reliab<thr) = 0;

% show quiver plot on top of reliab
% if( show )
%   reliab( reliab>1 ) = 1;
%   figure(show); clf; im( I1 );
%   hold('on'); quiver( Vx, Vy, 0,'-b' ); hold('off');
% end


