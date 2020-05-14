
% Function to evaluate the symmetric transfer error of a homography with
% respect to a set of matched points.
function [inliers, H] = homogdist2d(H, x1, x2, t)
    
%     [x1, T1] = normalise2dpts(x1);
%     [x2, T2] = normalise2dpts(x2);
    
    % Calculate, in both directions, the transfered points    
    Hx1    = H*x1;
    invHx2 = H\x2;
    
    % Normalise so that the homogeneous scale parameter for all coordinates
    % is 1.
    
    x1     = hnormalise(x1);
    x2     = hnormalise(x2);     
    Hx1    = hnormalise(Hx1);
    invHx2 = hnormalise(invHx2); 
    
    d2 = sum((x1-invHx2).^2)  + sum((x2-Hx1).^2);
    inliers = find(abs(d2) < t);    