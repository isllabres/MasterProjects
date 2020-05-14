function geo_verification(strFile1,strFile2)
close all;
run('vlfeat-0.9.20/toolbox/vl_setup');
addpath('geometric');
close all;

%We load an image pair
im1=imread(['./images/' strFile1 '.jpg']);

im2=imread(['./images/' strFile2 '.jpg']);
%Convert images to grayscale and single precision
ig1=rgb2gray(im1);
is1=single(ig1);
ig2=rgb2gray(im2);
is2=single(ig2);

%We use Hessian-Laplace Detector
featMethod='HessianLaplace';
%With a peak threshold of 100
PeakThreshold=100;
%And affine-covariant features
[f1 d1] = vl_covdet(is1, 'Method',featMethod, 'EstimateAffineShape', true,'EstimateOrientation', true,'Verbose','DoubleImage',true,'PeakThreshold',PeakThreshold);
[f2 d2] = vl_covdet(is2, 'Method',featMethod, 'EstimateAffineShape', true,'EstimateOrientation', true,'Verbose','DoubleImage',true,'PeakThreshold',PeakThreshold);


%Basic Matching
matchingTH=0.5;
[matches, scores] = vl_ubcmatch(d1,d2,matchingTH);%matches is 2xn_matches
Nmatches=length(scores);

%in showmatches we have: 
% line([f1(1,matches(1,:));f2(1,matches(2,:))+o], ...
%      [f1(2,matches(1,:));f2(2,matches(2,:))],'Color', 'c');
%Definimos coordenadas x, y, z (la z son unos) para hacer las coordenadas 
%homogéneas de cada imagen a partir de las coordenadas euclideas
% Given the set of N corresponding pairs X={x1,x2,x3,…,xN} 
% and X’={x’1,x’2,x’3,…,x’N}. We can represent them as 3xN matrices with the 
% pixel homogeneous coordinates (x,y,1).
x1 = ones (3,Nmatches);
%X coordinates
x1(1,:) = f1(1,matches(1,:));
x1(2,:) = f1(2,matches(1,:));

%X' coordinates
x2 = ones (3, Nmatches);
x2(1,:) = f2(1,matches(2,:));
x2(2,:) = f2(2,matches(2,:));


% Call the function ‘fithomography’ setting a threshold, 
% and obtain the list of inliers as well as the Homography.
thInliers = [0.001, 0.01, 0.1, 1];
for i=1:length(thInliers)
[H, inliers]=fithomography(x1, x2, thInliers(i));
disp(['With thershold '  num2str(thInliers(i))]);
disp(['Number of inliers: '  num2str(length(inliers))]);
end

showMatches(im1,im2,f1,f2,matches)

