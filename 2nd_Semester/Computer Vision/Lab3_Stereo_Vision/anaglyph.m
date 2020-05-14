% Function that generates an anaglyph
% Sintaxis: anaglyph(imageName,bw)
% Inputs:
%       %imageName: Name of the image (without extension)
%       %bw: if bw=1, the image is first converted to graylevel, otherwise colors are kept 
function anaglyph(imageName,bw)

% 
%------------- BEGIN CODE --------------

% assign each image
folder=['images/' imageName];
namedL = [folder '/imageL.jpg'];
namesR = [folder '/imageR.jpg'];
imL = imread(namedL(1:end-4),namedL(end-2:end));
imR = imread(namesR(1:end-4),namesR(end-2:end));

if(bw)
    imLg=rgb2gray(imL);
    imL(:,:,1)=imLg;
    imL(:,:,2)=imLg;
    imL(:,:,3)=imLg;
    imRg=rgb2gray(imR);
    imR(:,:,1)=imRg;
    imR(:,:,2)=imRg;
    imR(:,:,3)=imRg;
end

figH = figure;
set(figH,'userdata',0);

swapButt = uicontrol(figH,'style','pushbutton','String','Swap RL','value',0,'pos',[20 10 58 20]);
zoomInButt = uicontrol(figH,'style','pushbutton','String','Zoom +','pos',[80 10 58 20]);
zoomOutButt = uicontrol(figH,'style','pushbutton','String','Zoom -','pos',[140 10 58 20]);

set(swapButt,'callback',{@swap,imL,imR,figH});
set(zoomInButt,'callback',{@zoomCLB,-0.1})
set(zoomOutButt,'callback',{@zoomCLB,+0.1})

plotAnaglyph(imL,imR);

if nargout == 1,
    varargout = {figH};
end

% -------------------------------------------------------
% Plots the anaglyphic image
function plotAnaglyph(imL,imR)

anaglyph=zeros(size(imL),'uint8');
anaglyph(:,:,1) = uint8(imL(:,:,1));
anaglyph(:,:,2:3) = uint8(imR(:,:,2:3));

image(anaglyph);
axis equal
set(gca,'YTickLabel',[])
set(gca,'XTickLabel',[])
set(gca,'XTick',[])
set(gca,'YTick',[])
set(gca,'color',[0 0 0])
set(gcf,'color',[0 0 0])
shg

% -------------------------------------------------------
% Swaps right/left
function swap(UiHandle,action,A,B,figH)
flag = get(figH,'userdata');
switch flag
case 1
    plotAnaglyph(A,B);
    set(figH,'userdata',0);
case 0
    plotAnaglyph(B,A);
    set(figH,'userdata',1);
end
% -------------------------------------------------------
% Zoom
function zoomCLB(UiHandle,action,D)
origCVA = get(gca,'CameraViewAngle');
set(gca,'CameraViewAngle',origCVA+D)
%------------- END OF CODE --------------