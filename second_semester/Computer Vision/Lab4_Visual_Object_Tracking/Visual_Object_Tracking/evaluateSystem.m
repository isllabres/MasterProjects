%Functiona that evaluates a system using the 4 training sequences
function evaluateSystem()

videos={'Basketball','Biker','Bolt','Skating'};
%As the particle filtering is stichastic, several repetitions will provide
%different values. we compute several and average to get more stable
%results.
numRepetitions=1;

JI=zeros(length(videos),numRepetitions);

for v=1:length(videos)
    video=videos{v};
    fprintf('Processing video %s\n',video);
    for r=1:numRepetitions
        tic
            JIseq=object_tracking(video, 0);
        time_passed=toc;
        time_per_frame=time_passed/length(JIseq);
        fprintf('Average execution time %.2f sec/fr\n',time_per_frame);
        if(time_per_frame)>3.5
            fprintf('Execution is too slow. Setting JI to 0\n')
            JI(v,r)=0;
        else
            JI(v,r)=mean(JIseq);
        end
    end
end

fprintf('Summary of Final results\n')
for v=1:length(videos)
    fprintf('Results for video %s JI=%f\n',videos{v},mean(JI(v,:)));
end
fprintf('Total average Results are JI=%f\n',mean(JI(:)));