%Function that computes a 2D histogram in the HSV color space (considers HS)
function hist = computeHSVHistograms(im,K)

% histogram initialization
hist=zeros(K*K,1);

% Conver image to HSV and double precision
im =rgb2hsv(im);
im = im2double(im);

% Trabajamos con H y S para mejorar rendimiento, pues los resultados son similares
% a trabajar con V. Vectorizamos la imagen para trabajar mas comodamente
im=shiftdim(im,2);
im=im(:,:);
if size(im,1)<size(im,2)
    im=shiftdim(im,1);
end

im=im(:,1:2);  % Only H and S (remove Value)

%Quantize the values
r=ceil(double(im+1e-30)*K);

rlin=(r(:,1)-1)*K+r(:,2);
hist(rlin)=hist(rlin)+1;
hist=hist/sum(hist);

