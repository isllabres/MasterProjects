
%% 
function [frames1, descriptors1, frames2, descriptors2] = Different_descriptors(image, n_frames)

dims = size(image);
rgb_dim = size(dims);

if (rgb_dim(2)>2)
    image = rgb2gray(image); 
end


image_single = single(image);
[frames1, descriptors1] = vl_sift(image_single);
if (strcmp(n_frames,'all'))
    frames_show = frames1;
    descriptors_show = descriptors1;
    size_frames = size(frames1);
    idx_feat=randperm(size_frames(2)); 
    sel1 = idx_feat(:,1:size_frames(2));
    
else
    size_frames = size(frames1);
    idx_feat=randperm(size_frames(2)); 
    sel1 = idx_feat(:,1:n_frames);
    frames_show=frames1(:,sel1);
    descriptors_show = descriptors1(:,sel1);
end

subplot(1,2,1)
imshow(image);
hold on
vl_plotframe(frames_show)
hold on
p1 = vl_plotsiftdescriptor(descriptors_show, frames_show)
set(p1,'color','y')
title('Descriptors using vl sift')
[frames2, descriptors2]= vl_covdet(image_single, 'Method', 'DoG','EstimateAffineShape', true ); 


coordsf1 = frames1(1:2,sel1);
sel2 = knnsearch(frames2(1:2,:)',coordsf1');
subplot(1,2,2)
imshow(image)
hold on
vl_plotframe(frames2(:,sel2));
hold on
p1 = vl_plotsiftdescriptor(descriptors2(:,sel2), frames2(:,sel2))
set(p1,'color','b')
title('Descriptors using vl covdet')

end