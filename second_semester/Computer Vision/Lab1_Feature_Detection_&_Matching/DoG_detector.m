% SIFT ALGORITHM
default_peaks = 0;
default_edges = 10;
default_octaves = 10;
default_level = 3;
default_first_octave = 0;
%% 2.1 Running the basic algorithm 
image_path = './S1 - Feature Detection & Matching/images/roofs1.jpg';
n_frames = 30;
figure(1)
frames = SIFT_algorithm(image_path, n_frames, default_peaks, default_edges, default_octaves, default_level, default_first_octave);
title('Basic SIFT algorithm')

%% 2.2.1 Peak and Edge Threholds 
% a) Peak threshold : The peak threshold filters peaks of the DoG scale space that are too small (in absolute value)
peak_thresholds = [0, 10, 20, 30];
image_path = './S1 - Feature Detection & Matching/images/blobs.png';
n_frames = 'all';
figure(2)
for i = 1 : length(peak_thresholds)
    subplot(2,2,i)
    frames = SIFT_algorithm(image_path, n_frames, peak_thresholds(i), default_edges, default_octaves, default_level, default_first_octave);
    title(['Peak threshold ',num2str(peak_thresholds(i))])
end

%Obtain fewer features as peak_thresh is increased.

% b) Edge threshold: eliminates peaks of the DoG scale space whose curvature is too small 
%(such peaks yield badly localized frames)
image_path = './S1 - Feature Detection & Matching/images/edges.png';
EdgeThresholds = [1.5, 3.5, 5, 10];
n_frames = 'all';
figure(3)
for i = 1 : length(EdgeThresholds)
    subplot(2,2,i)
    frames = SIFT_algorithm(image_path, n_frames, default_peaks, EdgeThresholds(i), default_octaves, default_level, default_first_octave);
    title(['Edge threshold ',num2str(EdgeThresholds(i))])
end
%obtaining more features as edge_thresh is increased
%% 2.2.2 Scale Parameters 
% The DoG detector accepts three scale parameters, namely: 
% Octaves maximum possible (Set the number of octave of the DoG scale
% space.)
image_path = './S1 - Feature Detection & Matching/images/edges.png';
octaves = [0,1,2,4];
n_frames = 'all';
figure(4)
for i = 1 : length(octaves)
    subplot(2,2,i)
    frames = SIFT_algorithm(image_path, n_frames, default_peaks, default_edges, octaves(i), default_level, default_first_octave);
    title(['Octave ',num2str(octaves(i))])
end

% Levels 3 (Set the number of levels per octave of the DoG scale space.)
image_path = './S1 - Feature Detection & Matching/images/edges.png';
levels = [1, 3, 10, 50];
n_frames = 'all';
figure(5)
for i = 1 : length(levels)
    subplot(2,2,i)
    frames = SIFT_algorithm(image_path, n_frames, default_peaks, default_edges, default_octaves, levels(i), default_first_octave);
    title(['Level ',num2str(levels(i))])
end

% FirstOctave 0 (Set the index of the first octave of the DoG scale space.)
image_path = './S1 - Feature Detection & Matching/images/edges.png';
first_octave = [1, 3, 4, 5];
n_frames = 'all';
figure(6)
for i = 1 : length(levels)
    subplot(2,2,i)
    frames = SIFT_algorithm(image_path, n_frames, default_peaks, default_edges, default_octaves, default_level, first_octave(i));
    title(['First octave ',num2str(first_octave(i))])
end

% - Why including both octaves and levels? What is the difference between them? 
% - What is the internal process of the detection system to start a new octave? 
% - How is the invariance to scale achieved by the DoG detector? 
% NOTE: You can read the section 3 of the Lowe�s paper to understand some of these concepts. 

% EVALUATION 1. Execute the SIFT (DoG) detector with the following two setups: 
% a. numOctaves=1;numLevels=30 
% b. numOctaves=3;numLevels=10 
%
%   NOTE: Keep the rest of the parameters constant in both executions.  Compare the two alternatives in terms of: 
%       � Execution times required by the detection process using these two setups (you can use matlab commands �tic�,�toc� to measure running times).
%       Give reasoned explanations of the results.
%       � Visualization of the detected features and their scales. Which setup provides larger features? Why? 
%       Relate your answers with the concepts of Octave and Levels.

