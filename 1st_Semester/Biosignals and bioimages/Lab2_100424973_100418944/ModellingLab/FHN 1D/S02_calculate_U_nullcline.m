%% FitzHugh-Nagumo model GUI
% Master in Information Health Engineering
% Course 2019/2010
% Course: Biosignals and bioimages
% Gonzalo R. Ríos-Muñoz
% Code version 1.0 October 2019
% Universidad Carlos III de Madrid
%%
% S02_calculate_U_nullcline.m SCRIPT

% U-nullcline
% Calculate the nuclei function U_line that depends on U_ref variable from
% the previous script S01_caculate_V_nullcline.m, coefficients coeff() and
% variable D

U_line = 16*D + coeff(1) + coeff(2)*U_ref + coeff(3)*U_ref.^2 + coeff(4)*U_ref.^3; % 1 line of code

% Plot in the Y axis U_line variable U_line and in the X axis U_ref
plot(U_ref,U_line) % 1 line of code
