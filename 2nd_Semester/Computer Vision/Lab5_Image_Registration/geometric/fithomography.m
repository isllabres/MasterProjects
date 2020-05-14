% FITHOMOGRAPHY - fits 2D homography over a set of matched points
% This code follows the normalised direct linear transformation 
% algorithm given by Hartley and Zisserman "Multiple View Geometry in
% Computer Vision" p92.
%
% Usage:
%
% [H, inliers]=fithomography(x1, x2, thInliers)
%
% Arguments:
%          x1  - 3xN set of homogeneous points.  
%          x2  - 3xN set of homogeneous points such that x1<->x2.%
%    thInliers - Threshold over the estimation error that allows to decide
%    if a point is an inlier or an outlier of the geometric transformation
% Returns:
%     H         - The Homography.
%     inliers   - An array of indices of the elements of x that were
%                 the inliers for the geometric model.

function [H, inliers]=fithomography(x1, x2, thInliers)
[x1, T1] = normalise2dpts(x1);
[x2, T2] = normalise2dpts(x2);
H=homography2d(x1, x2);
[inliers, H] = homogdist2d(H, x1, x2, thInliers);
H = T2\H*T1;