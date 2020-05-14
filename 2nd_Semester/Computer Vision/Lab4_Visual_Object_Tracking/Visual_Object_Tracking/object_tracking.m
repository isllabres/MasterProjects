%Function that tracks a video object through a particle filter
%   arguments:
%               - video: video name 
%               - VERBOSE: 1 if you want to see the visual results
%   output:
%               - JI: average JI in the video
function JI=object_tracking(video, VERBOSE)



videoPath=sprintf('./videos/%s',video);
labelPath=sprintf('./videos/%s.mat',video);
aux=load(labelPath);
labels=aux.labels;
numFrames=size(labels,1);
numFrames=min(numFrames,200);
fr_path=sprintf('%s/0001.jpg',videoPath);
im=imread(fr_path);

%We initialize JI
JI=zeros(numFrames,1);
JI(1)=1.0;


%We initialize the object tracker using the ground truth
tracker=filter_INIT(im,labels(1,:));
if VERBOSE
    %Show the tracker
    im=showBB(im,[labels(1,:); tracker.bbox]);
    %Show the particles
    im=showParticles(im,tracker.x);
    figure(1);imshow(im);
    pause(0.1);
end
    
%Loop of frames
for n=2:numFrames
    %Read the frame
    fr_path=sprintf('%s/%04d.jpg',videoPath,n);
    im=imread(fr_path);
    %Update the partcile filter
    tracker = filter_UPDATE( tracker, im);
    if VERBOSE
        %Show the tracker
        im=showBB(im,[labels(n,:); tracker.bbox]);
        %Show the particles
        im=showParticles(im,tracker.x);
        figure(1);imshow(im);
        pause;
    end
    %Compute the Jacard-Index
    JI(n)=computeJI(labels(n,1:4),tracker.bbox(1:4));
    if rem(n,50)==0
        fprintf('Frame %d/%d average JI %f\n',n,numFrames,mean(JI(1:n)));
    end
end
fprintf('Average JI %f\n',mean(JI));
figure(1); plot(JI);