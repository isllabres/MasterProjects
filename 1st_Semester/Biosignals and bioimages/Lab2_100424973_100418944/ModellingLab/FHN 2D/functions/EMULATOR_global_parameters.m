%% FitzHugh-Nagumo model GUI
% Master in Information Health Engineering
% Course 2019/2010
% Course: Biosignals and bioimages
% Gonzalo R. Ríos-Muñoz
% Code version 1.0 November 2019
% Universidad Carlos III de Madrid

% FUNCTION FOR VARIABLE INITIALIZATION DO NOT MODIFY
function [global_parameters] = EMULATOR_global_parameters(Nt_input, png_file_input, fs2_shift_input, Nx_input, Ny_input)

%%
% MAIN VARIABLES
%%%
Nt = Nt_input; % # of time steps

% U dynamic noise
init_dyn_noise_std = 1;
init_dyn_noise_var = init_dyn_noise_std.^2;
dyn_noise_std = 1e-2;
dyn_noise_var = dyn_noise_std.^2;

%%
% EXTRA STIM Time shift and Simulation mask
%%%
fs2_shift = fs2_shift_input;
png_file = png_file_input;

%%
% Initial conditions & Model Variables
%%%
tf = 3*20;                        % Total Simulation Time
L = 0.12;
H = 0.12;

T = 5e-3;                       % Time increment
S = 3e-2;
S2 = S^2;
D = S2;
speed = 5;

F = 200;                        % Impulse amplitude

TF = 30;                        % Forcing signal period
tF0 = 1;	

Nx = Nx_input;                  % # of horizontal nodes
Ny = Ny_input;                  % # of vertical nodes

num_nodes = Nx*Ny;

%%
% Model Variables
%%%
alpha = [0 6 0 -5/3];
beta = [2.1 -0.6 0.6];

Uout = -1.389;                 % Boundary conditions U
Vout = -3.1501;                 % Boundary conditions V

%% Struct

% U dynamic noise
global_parameters.init_dyn_noise_std = init_dyn_noise_std;
global_parameters.init_dyn_noise_var = init_dyn_noise_var;
global_parameters.dyn_noise_std = dyn_noise_std;
global_parameters.dyn_noise_var = dyn_noise_var;

% Extra
global_parameters.fs2_shift = fs2_shift;
global_parameters.png_file = png_file;

% Initial conditions & Model Variables
global_parameters.tf = tf;
global_parameters.L = L;
global_parameters.H = H;

global_parameters.T = T;
global_parameters.S = S;
global_parameters.S2 = S2;
global_parameters.D = D;
global_parameters.speed = speed;

global_parameters.F = F;
global_parameters.TF = TF;
global_parameters.tF0 = tF0;

global_parameters.Nt = Nt;

global_parameters.Nx = Nx;
global_parameters.Ny= Ny;

global_parameters.num_nodes = num_nodes;

% Model Variables
global_parameters.alpha = alpha;
global_parameters.beta = beta;

global_parameters.Uout = Uout;
global_parameters.Vout = Vout;
