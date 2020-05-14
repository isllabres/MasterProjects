%Function that overlays BBs on an image
%      im = showBB(im,bbs)     
%Parameters:
%       - im: the image
%       - bbs: A Nx4 matrix,  with N bounding boxes defined by
%              [minx miny width hright]
%Output:
%        - im: the image with overlaid bbs
function im=showBB(im,bbs)
[H W channels]=size(im);
if(channels==1)
    bwim=im;
    im(:,:,2)=bwim;
    im(:,:,3)=bwim;
    im=im2uint8(im);
end
colors=[0 255 0;0 0 255; 255 0 0; 255 255 0; 0 255 255; 255 0 255;255 128 0;0 255 128;128 255 0; 128 128 128; 128 128 0; 128 0 128; 0 128 128;];
for b=1:size(bbs,1)
    bb=bbs(b,:);
    bb=round(bb);
    bb(3)=min(bb(1)+bb(3),W);
    bb(4)=min(bb(2)+bb(4),H);
    
    bb(1)=max(bb(1),1);
    bb(2)=max(bb(2),1);
    try
        im(bb(2),bb(1):bb(3),1)=colors(b,1);
        im(bb(2),bb(1):bb(3),2)=colors(b,2);
        im(bb(2),bb(1):bb(3),3)=colors(b,3);
        im(bb(4),bb(1):bb(3),1)=colors(b,1);
        im(bb(4),bb(1):bb(3),2)=colors(b,2);
        im(bb(4),bb(1):bb(3),3)=colors(b,3);
        im(bb(2):bb(4),bb(1),1)=colors(b,1);
        im(bb(2):bb(4),bb(1),2)=colors(b,2);
        im(bb(2):bb(4),bb(1),3)=colors(b,3);
        im(bb(2):bb(4),bb(3),1)=colors(b,1);
        im(bb(2):bb(4),bb(3),2)=colors(b,2);
        im(bb(2):bb(4),bb(3),3)=colors(b,3);
    catch
        disp('Bounding box is getting out of the image')
    end
end

