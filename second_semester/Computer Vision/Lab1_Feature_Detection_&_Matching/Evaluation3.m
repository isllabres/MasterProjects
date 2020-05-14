%% Evaluation 3
image_path='./images/roofs1.jpg';
n_frames = 30;
[f1,d1,f2,d2] = Different_descriptors(image_path, n_frames);
%we can see that the descriptors are invariant to affine transformations