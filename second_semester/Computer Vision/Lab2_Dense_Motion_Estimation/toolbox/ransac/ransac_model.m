% function ransac_model(start_query,end_query,ext4_hm_images)
function ransac_model(ext4_hm_images)
% % DataQuery = load ('desc/all_souls_000002.mat');
% % 
% % desc1 = DataQuery.descrips;
% % coor1 = DataQuery.locs;
% % 
% % DataImageRef = load ('desc/all_souls_000040.mat');
% % 
% % desc2 = DataQuery.descrips;
% % coor2 = DataQuery.locs;


% Call FLANN lib
FLANNPATH = '/home/mberdonces/Documentos/aficus_oxford/cebaz/flann-1.6.11-src/src/matlab';
RANSACPATH = ('/home/mberdonces/Documentos/aficus_oxford/RANSAC');


%Create FLANN folder
if exist('flann')~=7
    error('Please create /flann folder');
end

%Add path.
addpath(FLANNPATH);
addpath(RANSACPATH);

%Load data
load('query_index.mat');
load('index.mat');

% start_query=1; %inputs of the function: start and end query
% end_query=1;

% number of images

% size_index = length(index);
size_index = 10;
% number of queries
size_query_index=1;
% size_query_index= length(query_index);



%For the number of queries

for q=start_query:end_query
	%initialize an empty string
	parameters=[];
	
    %Define variables
	parameters.target_precision = 0.9;
	nearest_neighbours = 2;
    
	%Load descriptors of the images Query. Load the name of the query file
	%(q)
	load(['desc/', char(regexprep(query_index(q), 'oxc1_', '')), '.mat']);	
% 	load(['desc/all_souls_000002.mat']);
    
    %Transponse descriptors and store them into Qdescrip
    %Descrips is a matrix Nx128 where N = number of keypoints.
    Qdescrips=descrips';
    Qlocs=locs';
%     
%     newratio=cell(2,size_index);
    
    
	% From 1 to the number of images (150)

    for i=1:ext4_hm_images
    
%     i=1;    
        %If the length of the string's names are not equal ??
        if ~strncmp(index(i),query_index(q),max(length(char(index(i))),length(char(query_index(q)))))
            
            
            %Compute distance in query...
            disp(['Computing distance in query ', num2str(q), '-', num2str(end_query), ' :: Image: ', num2str(i), '/', num2str(size(index,1))])
            
            %Load descriptors of the image into Idescrips
            load(['desc/', char(regexprep(index(i), 'oxc1_', '')), '.mat']);
            
            clear Idescrips
            clear Ilocs
            
            Idescrips=descrips';
            Ilocs=locs';
           
            % Obtain index and distances applying FLANN to obtain nearest
            % neighbors
            % Qdescrips are the descriptors of the Query.
            % Idescrips are the descriptors of the Image.
            clear result
            clear dists
           
            [result, dists] = flann_search(Idescrips,Qdescrips,nearest_neighbours,parameters);
            
            % "result" is a ranking with the index number of the keypoints in
            % the image.
            % "dists" is the distance. nth column means nth nearest
            % neighbor.


            %Save the results of FLANN in a new folder.
%             save(['flann2/', char(regexprep(query_index(q), 'oxc1_', '')), '-', char(regexprep(index(i), 'oxc1_', '')), '.mat'], 'result', 'dists')

%           end

            %Creat Thdist. Only Thdist < threshold will be considered OK
            %points.
            LoweTh = 0.8;
            %The new paper tell us that the threshold can be 0.6
%             LoweTh=0.6;
 
            % get the ratio of the distance between the two first nearest neighbors
            clear radio_dists
            ratio_dists = dists(1,:)./dists(2,:);
            
                        
            % List the indexes whose ratios pass the threshold.
            % ratios = ratio_dists(:,idx);
                
            
            % find the indexes which pass the threshold
            clear idxQ
            clear idxR
            
            %Los idxQ y idxR tienen la misma dimension pero no los mismos
            %valores:
            
            % idxQ are the indexes of the query, whose ratio is less than
            % the threshold.
            % idxR are the indsize_index = length(index);exes for the image reference.
            
            idxQ=find(ratio_dists<LoweTh);
            
            idxR=result(1,idxQ);
            
%             % Get the indexes
%             clear sel_query
%             clear sel_image
%             sel_query = result(1,idxQ);
%             sel_image = result(1,idxR);
            
            % List the indexes for query and image reference in a common
            % variable.
            
%             clear result_rank
%             result_rank(1,:) = result(1,idxQ);
%             result_rank(2,:) = result(1,idxR);
%             result_rank(1,:) = sel_query
%             result_rank(2,:) = 

            % The same for coordenates.
            clear sel_image_locs
            clear sel_query_locs
            sel_query_locs=Qlocs(:,idxQ);
            sel_image_locs=Ilocs(:,idxR);
            
            
%             vectorfinal = [idx; ratio_dists(1,idx)];

            %Threshold for RANSAC
            threshold= 0.005;

            
            %Two different functions / Two different options
%           [F, inliers] = ransacfitfundmatrix(sel_query_locs, sel_image_locs, threshold);
            [F, inliers] = ransacfithomography_vgg(sel_query_locs, sel_image_locs, threshold)
            
            % inliers hace referencia a los índices que venían en los idxQ
            % e idxR
            idxQ_inliers = idxQ(inliers);
            idxR_inliers = idxR(inliers);
            
            newratio.filename = index(idxQ_inliers);
%             newratio.rankposition = length(inliers)/length(descrips);
            
            ratiocm(1,i) = length(inliers)/min(length(Idescrips),length(Qdescrips))
%             ratiocm(q,i) = length(inliers)/min(length(Idescrips),length(Qdescrips))
           
            %PLOT AND SHOW RESULTS. COMPARE THEM.
            %Green for initial keypoints
                         %Blue for after-FLANN keypoints
            %Red for after-RANSAC keypoints
            
            figure(1)
                queryName=['oxbuild_images/' char(regexprep(query_index(q), 'oxc1_', '')) '.jpg'];   
                
                imshow(queryName)
                hold on
                    plot(Qlocs(1,:),Qlocs(2,:),'+g')
                    plot(Qlocs(1,idxQ_inliers),Qlocs(2,idxQ_inliers),'*r')
                    title('Query image')
                hold off
           
            figure(2)
                imageName=['oxbuild_images/' char(regexprep(index(i), 'oxc1_', '')) '.jpg'];  
                imshow(imageName)
                
                hold on
                plot(Ilocs(1,:),Ilocs(2,:),'+g')
                plot(Ilocs(1,idxR_inliers),Ilocs(2,idxR_inliers),'*r') 
                title('Reference image')
                hold off
        end
        
                 
    end

                % me tengo que quedar con los que sobrepasen (o no) un
                % determinado threshold, quedarme con sus result en un nuevo
                % vector y luego buscar en esos result,las coordenadas que
                % tenian esos puntos, para pasarselos a RANSAC  
                
                
                %REORDENAR para la Query que sea
                [lista_ordenada,lista_index] = sort(ratiocm,'descend')                
                
                
                
                %Apply RANSAC
                % EL PROBLEMA AHORA ES QUE RANSAC ESPERA EN DISTS UN VECTOR
                % DE DOS FILAS MINIMO
                
            
%                 save(['flann2/ransac/', char(regexprep(query_index(q), 'oxc1_', '')), '-', char(regexprep(index(i), 'oxc1_', '')), '.mat'], 'FundMatrix', 'inliers')
end

    




