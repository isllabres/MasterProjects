%% affine covariant detectors
EstimationOrientation = true; 
EstimateAffineShape = [true, false];
Verbose = true;
Methods = ['DoG', 'Hessian', 'HessianLaplace', 'HarrisLaplace', 'MultiscaleHessian', 'MultiscaleHarris'];
PeakThreshold = [];

image_path = './S1 - Feature Detection & Matching/images/roofs1.jpg';
image = imread(image_path);
dims = size(image);
rgb_dim = size(dims);

if (rgb_dim(2)>2)
    image = rgb2gray(image); 
end
imshow(image);
hold on

image_single = single(image);

cov_mat = vl_covdet(image_single, 'Method', 'DoG', 'EstimateAffineShape', true);
vl_plotframe(cov_mat)

for i = 1 : length(Methods)
    subplot(2,2,i)
    vl_covdet()    
    title(['Peak threshold ',num2str(peak_thresholds(i))])
end
