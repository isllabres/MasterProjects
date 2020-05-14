path1 = 'S1 - Feature Detection & Matching/images/oso2.jpg';
path2 = 'S1 - Feature Detection & Matching/images/oso1.jpg';
%path1 = 'S1 - Feature Detection & Matching/images/roofs1.jpg';

n_frames = 10;

angle1 = 360 .* rand(1,1);
angle2 = 360 .* rand(1,1);

image1 = imread(path1);
image2 = imread(path2);

image1_rot = imrotate(image1,angle1);
image2_rot = imrotate(image2,angle2);

%%

thresh = 1.5;
[m_sift, s_sift,f_sift_1,f_sift_2, m_cov, s_cov,f_cov_1,f_cov_2, d_sift_1, d_sift_2] = ImageMatching (image1_rot, image2_rot, n_frames, thresh);

[m0,n0] = size(m_sift);
[m1,n1] = size(f_sift_1);
[m2,n2] = size(f_sift_2);

features = [n1, n2];

ratio = n0/min(features);

figure()
showMatches(image1_rot, image2_rot, f_sift_1,f_sift_2, m_sift(:, 10:20))
%plotMatches(m_sift, s_sift, image1, image2, f_sift_1,f_sift_2)