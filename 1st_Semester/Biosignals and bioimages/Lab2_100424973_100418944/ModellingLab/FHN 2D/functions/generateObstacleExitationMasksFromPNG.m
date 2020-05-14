%% FitzHugh-Nagumo model GUI
% Master in Information Health Engineering
% Course 2019/2010
% Course: Biosignals and bioimages
% Gonzalo R. Ríos-Muñoz
% Code version 1.0 November 2019
% Universidad Carlos III de Madrid

% DO NOT MODIFY

function [Obstacle_Mask, Excitation_Mask, Extra_Mask1, Extra_Mask2, Unidirectional_Mask] = generateObstacleExitationMasksFromPNG(png_file, Nx, Ny)

A = imread(png_file, 'PNG');

if size(A,1)<Nx || size(A,2)<Ny
   error('Image cannot be smaller than the model size defined by Nx & Ny parameters'); 
end

% Excitation Mask RED

R_A = A(:,:,1)>180;
G_A = A(:,:,2)<80;
B_A = A(:,:,3)<80;

Excitation_Mask = and(R_A,G_A);
Excitation_Mask = and(Excitation_Mask,B_A);

% % % figure(1)
% % % subplot(1,2,1)
% % % imagesc(A)
% % % title('Original Image')
% % % subplot(1,2,2)
% % % imagesc(Excitation_Mask)
% % % title('Excitation Mask')

% 1st Extra Mask GREEN

R_A = A(:,:,1)<120;
G_A = A(:,:,2)>180;
B_A = A(:,:,3)<120;

Extra_Mask1 = and(R_A,G_A);
Extra_Mask1 = and(Extra_Mask1,B_A);

% % % figure(2)
% % % subplot(1,2,1)
% % % imagesc(A)
% % % title('Original Image')
% % % subplot(1,2,2)
% % % imagesc(Extra_Mask1)
% % % title('1^s^t Extra Mask')


% 2nd Extra Mask BLUE

R_A = A(:,:,1)<100;
G_A = A(:,:,2)<100;
B_A = A(:,:,3)>180;

Extra_Mask2 = and(R_A,G_A);
Extra_Mask2 = and(Extra_Mask2,B_A);

% % % figure(3)
% % % subplot(1,2,1)
% % % imagesc(A)
% % % title('Original Image')
% % % subplot(1,2,2)
% % % imagesc(Extra_Mask2)
% % % title('2^n^d Extra Mask')


% Unidirectional Mask - YELLOW

R_A = A(:,:,1)>220;
G_A = A(:,:,2)>220;
B_A = A(:,:,3)<40;

Unidirectional_Mask = and(R_A,G_A);
Unidirectional_Mask = and(Unidirectional_Mask,B_A);

% % % figure(4)
% % % subplot(1,2,1)
% % % imagesc(A)
% % % title('Original Image')
% % % subplot(1,2,2)
% % % imagesc(Unidirectional_Mask)
% % % title('Unidirectional Mask')


% Obstacle Mask ~ REST OF COLORS

R_A = A(:,:,1)==255;
G_A = A(:,:,2)==255;
B_A = A(:,:,3)==255;

Obstacle_Mask = or(R_A,G_A);
Obstacle_Mask = or(Obstacle_Mask,B_A);
% Add also the excitation and extra pixels
Obstacle_Mask = or(Obstacle_Mask,Excitation_Mask);
Obstacle_Mask = or(Obstacle_Mask,Extra_Mask1);
Obstacle_Mask = or(Obstacle_Mask,Extra_Mask2);

% % % figure(5)
% % % subplot(1,2,1)
% % % imagesc(A)
% % % title('Original Image')
% % % subplot(1,2,2)
% % % imagesc(Obstacle_Mask)
% % % title('Obstacle Mask')


% [ Obstacle_Mask, Excitation_Mask, Extra_Mask1, Extra_Mask2, Unidirectional_Mask ]
Obstacle_Mask = Obstacle_Mask(1:Nx,1:Ny);
Excitation_Mask = Excitation_Mask(1:Nx,1:Ny);
Extra_Mask1 = Extra_Mask1(1:Nx,1:Ny);
Extra_Mask2 = Extra_Mask2(1:Nx,1:Ny);
Unidirectional_Mask = Unidirectional_Mask(1:Nx,1:Ny);