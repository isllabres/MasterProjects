%% FitzHugh-Nagumo model GUI
% Master in Information Health Engineering
% Course 2019/2010
% Course: Biosignals and bioimages
% Gonzalo R. R�os-Mu�oz
% Code version 1.0 November 2019
% Universidad Carlos III de Madrid
%%
function [lasso_points_x, lasso_points_y] = lassoPoints(Nx, Ny, radio_lasso)

% We have 10 electrodes in the catheter
Num_Lasso_electrodes = 10;
theta_angles = linspace(0,2*pi,Num_Lasso_electrodes);

% Calculate the center of the catheter circumference
center_x = round(Nx/2); % 1 line of code
center_y = round(Ny/2); % 1 line of code

% Calculate the X and Y coordinates of the electrodes given the center,
% angle and radius of the catheter
% lasso_points_x and lasso_points_y should have dimension [Num_Lasso_electrodes, 1]
% Tip: Parametric form of the Cartesian coordinates of a circle
lasso_points_x = round(radio_lasso*cos(theta_angles)+center_x) % 1 line of code
lasso_points_y = round(radio_lasso*sin(theta_angles)+center_y) % 1 line of code

