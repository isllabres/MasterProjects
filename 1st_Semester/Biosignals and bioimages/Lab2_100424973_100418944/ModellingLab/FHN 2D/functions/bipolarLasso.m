%% FitzHugh-Nagumo model GUI
% Master in Information Health Engineering
% Course 2019/2010
% Course: Biosignals and bioimages
% Gonzalo R. R�os-Mu�oz
% Code version 1.0 November 2019
% Universidad Carlos III de Madrid

% This function calculates the bipolar signals w.r.t the catheter electrode
% positions
% DO NOT MODIFY
function return_lasso = bipolarLasso(lasso_signals, lasso_points_x, lasso_points_y, video_frame, aux_U)

return_lasso = lasso_signals;

for i = 1:length(lasso_points_x)-1
    
    positive_electrode = aux_U(lasso_points_y(i+1),lasso_points_x(i+1));
    negative_electrode = aux_U(lasso_points_y(i),lasso_points_x(i));
    
    bipolar_value = positive_electrode - negative_electrode;
    
    return_lasso(i,video_frame) = bipolar_value;
    
end