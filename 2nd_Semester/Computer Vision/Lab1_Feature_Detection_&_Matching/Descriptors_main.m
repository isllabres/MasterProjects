%% The SIFT descriptor 
image_path = './S1 - Feature Detection & Matching/images/roofs1.jpg';
n_frames = 30;
figure(1)
[frames, descriptors] = SIFT_descriptor(image_path, n_frames);
title('Basic SIFT algorithm with descriptors')
% EVALUATION 2. See the results and answer the following questions: 
% � Can you explain the visualization of a SIFT descriptor? 
% Check the paper by Lowe or the course slides to understand the descriptor. 
% � Establish a relationship among these three elements: 
% a) orientation of a detected local feature, 
% b) visual content of the detected region and 
% c) cell with histogram of gradients of the SIFT descriptor. 
% Include a visual example that illustrates well this relationship. 
% Now check the numeric values of some SIFT descriptors: 
% - What are the max and min values of the components? 
% - How are the gradients quantized? 