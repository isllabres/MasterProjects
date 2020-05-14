%% FitzHugh-Nagumo model GUI
% Master in Information Health Engineering
% Course 2019/2010
% Course: Biosignals and bioimages
% Gonzalo R. Ríos-Muñoz
% Code version 1.0 October 2019
% Universidad Carlos III de Madrid
%%
% S01_calculate_V_nullcline.m SCRIPT

% V-nullcline
% Calculate the nuclei alpha and beta related to the variables b, c and d
alpha =b/c; % 1 line of code
beta = d/c;% 1 line of code

% Create a vector for the U axis from -3 to 6 in steps of 0.1
U_ref = -3:0.1:6;% 1 line of code

% Create the V nullcline line as a linear funcion with respect to U_ref
% slope alpha and bias equals beta
V_line =  alpha*U_ref + beta;% 1 line of code

% Plot in the Y axis V_line and in the X axis U_ref
plot(U_ref, V_line) % 1 line of code
hold on