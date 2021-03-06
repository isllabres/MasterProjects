function basic_matching(strFile1,strFile2)
close all;
run('vlfeat-0.9.20/toolbox/vl_setup');
addpath('geometric');
close all;

%We load an image pair
im1=imread(['images/' strFile1 '.jpg']);
im2=imread(['images/' strFile2 '.jpg']);
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
matchingTH=1.5;
[matches, scores] = vl_ubcmatch(d1,d2,matchingTH);
Nmatches=length(scores);
%Plot matches
figure(1);
showMatches(im1,im2,f1,f2,matches);
title('Original Matches');
disp(['Original Matches: ' num2str(Nmatches)]);


