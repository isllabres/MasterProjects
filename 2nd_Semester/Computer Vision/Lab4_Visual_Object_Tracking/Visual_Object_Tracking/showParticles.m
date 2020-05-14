%Function that shows particles as points overlaid in the image (we do not consider width, height and dynamic elements in the state)
%      im = showParticles(im,x)     
%Parameters:
%       - im: the image
%       - x: The matrix with the state respresented by the particles
%Output:
%        - im: the image with overlaid particles
function im=showParticles(im,x)
[H W channels]=size(im);
if(channels==1)
    bwim=im;
    im(:,:,2)=bwim;
    im(:,:,3)=bwim;
    im=im2uint8(im);
end
xcoord=round(x(1,:));
ycoord=round(x(2,:));
xidx=xcoord*H+ycoord;
for c=1:channels
    imC=im(:,:,c);
    imC(xidx)=255;
    im(:,:,c)=imC;
end
