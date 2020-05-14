
%% 
function frames = SIFT_algorithm(image_path, n_frames, peak_thresh, edge_thresh, octave, level, firstOctave)
%
%  frames after SIFT algorithm from a given image (at 'image_path')
%  
%  Arguments:
%  
%       image_path  (input)   location of the image
%       n_frames    (input)   number of frames to show in te image, if 'all'
%                             show all features
%
%       frames      (output)  all frames after SIFT algorith from a given image

image = imread(image_path);
dims = size(image);
rgb_dim = size(dims);

if (rgb_dim(2)>2)
    image = rgb2gray(image); 
end
imshow(image);
hold on

image_single = single(image);
frames = vl_sift(image_single,'PeakThresh', peak_thresh,'edgethresh', edge_thresh, 'Octaves', octave, 'Levels', level, 'FirstOctave', firstOctave);
if (strcmp(n_frames,'all'))
    frames_show = frames;
else
    size_frames = size(frames);
    idx_feat=randperm(size_frames(2)); 
    frames_show=frames(:,idx_feat(:,1:n_frames));
end

vl_plotframe(frames_show)
hold off

end





