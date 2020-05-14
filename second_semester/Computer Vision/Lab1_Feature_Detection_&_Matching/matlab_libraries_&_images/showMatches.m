%Function that shows matches between two images
% im1: Image 1 (grayscale)
% im2: Image 2 (grayscale)
% f1:  Features in image 1
% f2:  Features in image 2
% matches: indexes of matches as returned by vl_ubcmatch
function showMatches(im1,im2,f1,f2,matches)

dh1 = max(size(im2,1)-size(im1,1),0) ;
dh2 = max(size(im1,1)-size(im2,1),0) ;


imagesc([padarray(im1,dh1,'post') padarray(im2,dh2,'post')]) ;
o = size(im1,2) ;
line([f1(1,matches(1,:));f2(1,matches(2,:))+o], ...
     [f1(2,matches(1,:));f2(2,matches(2,:))],'Color', 'c');
%  line([coord_q(i,1) coord_r(result(i),1)+cols1], [coord_q(i,2) coord_r(result(i),2) ], 
% %                 plot(coord_q(i,1),coord_q(i,2),'r*');
% %                 plot(coord_r(result(i),1)+cols1,coord_r(result(i),2),'r*');
% title(sprintf('%d tentative matches', numMatches)) ;
axis image off ;

