%% FitzHugh-Nagumo model GUI
% Master in Information Health Engineering
% Course 2019/2010
% Course: Biosignals and bioimages
% Gonzalo R. R�os-Mu�oz
% Code version 1.0 November 2019
% Universidad Carlos III de Madrid

clear all;
close all;
clc;

addpath('./functions')
addpath('./Masks')

%% Variables you can modify
sim = 3; % Selects 1 -> 'single', 2 -> 'flat' or 3 -> 'circular'
case_number = 4; % [1-6] except for 'single' [1-5]
Nt = 20000; % Simulation length in samples/iterations

%% Select the '.png' mask to simulate
% For the planar wavefront
png_file = 'PlanarPropagation.png';
fs2_shift = 0; % Set it to 0 if no second forcing signal is desired
% For the rotor case
%%%%% CREO QUE ES ESTO LO QUE HABIA QUE DESCOMENTAR Y CAMBIAR %%%%%%%%%%
 png_file = 'RotorSimple.png';
 fs2_shift = 4000; % 1 line of code
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Ny, Nx, numberOfColorChannels] = size(imread(png_file));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pseudo-LASSO layout
%%%
radio_lasso = 25;
[lasso_points_x, lasso_points_y] = lassoPoints(Nx, Ny, radio_lasso);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Global variables DO NOT MODIFY THEM
%%%
global_parameters = EMULATOR_global_parameters(Nt, png_file, fs2_shift, Nx, Ny);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2D simulation
%%%
tic;
[U, V, Fs, M0, M1, M2, Fs2] = EMULATOR_simulation(global_parameters);
simulation_time = toc

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Additional variables for plotting and storing data
%%%
num_signals = length(lasso_points_x)-1;

EMULATOR_figure = figure;

video_period = 200;
video_frame = 1;
lasso_signals = [];

for t = 2:Nt

    if t>20 && mod(t,video_period)==0
        %% Bipolar signals
        aux_U = reshape(U(:,:,t),Nx,Ny);
        lasso_signals = bipolarLasso(lasso_signals, lasso_points_x, lasso_points_y, video_frame, aux_U);
        
        %% PLOT
        EMULATOR_figure_script
        pause(0.05)
        
        video_frame = video_frame + 1;
    end
end

