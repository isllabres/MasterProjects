% Matching Descriptors and Computing Images Similarity
function [m_sift, s_sift,f_sift_1,f_sift_2, m_cov, s_cov,f_cov_1,f_cov_2, d_sift_1, d_sift_2] = ImageMatching (image1, image2, n_frames, thresh)

figure
[f_sift_1, d_sift_1, f_cov_1, d_cov_1] = Different_descriptors(image1, n_frames);


figure
[f_sift_2, d_sift_2, f_cov_2, d_cov_2] = Different_descriptors(image2, n_frames);

[m_sift, s_sift] = vl_ubcmatch(d_sift_1, d_sift_2, thresh);
[m_cov, s_cov] = vl_ubcmatch(d_cov_1, d_cov_2, thresh);

end