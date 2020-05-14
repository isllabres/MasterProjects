%% FitzHugh-Nagumo model GUI
% Master in Information Health Engineering
% Course 2019/2010
% Course: Biosignals and bioimages
% Gonzalo R. Ríos-Muñoz
% Code version 1.0 October 2019
% Universidad Carlos III de Madrid
%%
% S03_solve_Equations.m SCRIPT

% Set t_video variable for updating the figures every t_video iterations
% A value of 10 is fine, try to play with this value depending on your PC
% or laptop performance
% Each t_video iterations update the figure
t_video = 10; % 1 line of code

% Main temporal loop for the simulation
for t = 2:Nt
    
    % --Difference equations
    % Load the last value of the signals stored in aux_U, aux_V
    U_ = aux_U; % 1 line of code
    V_ = aux_V ;% 1 line of code
    
    % Generate random noise for the signal
    % use the function randn()
    % Gaussian noise with mean noise_mean and variance noise_var
    I = noise_var*randn(1,length(U_)) +noise_mean ; % 1 line of code
    
    % Apply Eurler approximation to solve the partial differential for U, V
    % equations and update the values of aux_U and aux_V given the past values
    % U_ and V_ for a time step T
    % Tip: aux_U = U_ + T* ( ... + Noise I + 16*D + Forzing signal)
    % The 16*D term represents the "diffusive" property ~ spatial speed
    % propagation
    % Tip: aux_V = V_ + T*(...)
    
    % Calculate new value of U
    aux_U =U_ + T*((coeff(1) + coeff(2)*U_ + coeff(3)*U_^2 + coeff(4)*U_^3) - V_ + I + 16*D+ Fs(t)); % 1 line of code
    
    % Calculate new value of V
    aux_V = V_ + T*a*(b*U_ - c*V_ + d); % 1 line of code
    
    % Store the new values of U and V into their respective positions in
    % U_t and V_t according to the time instant t
    U_t(t) = aux_U; % 1 line of code
    V_t(t) = aux_V; % 1 line of code
    
    
    % Plot the values of the variables
    % Do not modify the axes() functions only the plot
    % Tip: to know what to represent take a look at the xlabel and ylabel
    % information
    if(rem(t,t_video) == 1)
        % The new values of U and V (a 2D point [U(t), V(t)]) in the
        % nullclei figure plot to see their evolution
        axes(handles.fig_equations)
        plot(U_t(t), V_t(t),'*r') % 1 line of code
        hold on
        xlabel('Membrane Potential - U')
        ylabel('Recovery Variable - V')
        legend('V-nullcline', 'U-nullcline', 'U-V values');
        
        % Plot the temporal evolution of U_t
        % Tip: temporal reference from 1 to t
        axes(handles.fig_U)
        plot((1:t),U_t(1:t)) % 1 line of code
        title('Membrane Potential - U')
        
        % Plot the temporal evolution of V_t
        % Tip: temporal reference from 1 to t
        axes(handles.fig_V)
        plot((1:t),V_t(1:t)) % 1 line of code
        title('Membrane Potential - V')
        
        % Plot the forzing signal Fs
        % Tip: temporal reference from 1 to t
        axes(handles.fig_Fs)
        plot((1:t),Fs(1:t)) % 1 line of code
        title('Forcing signal')
        
        % Code to track the simulation progress
        simulation_percentage = (t/Nt)*100;
        pb_simulate_string = ['Simulating... ' num2str(simulation_percentage) '%'];
        set(pb_simulate_handle,'String', pb_simulate_string);
        
        pause(0.001)
    end
    
    if t==Nt
        pb_simulate_string = 'Simulation Completed';
        set(pb_simulate_handle,'String', pb_simulate_string);
    end
    
    % Update handles
    drawnow; % this allows to be interrupted by exit button
    handles=guidata(hObject);
    
    aux_simulating = handles.simulating;
    if aux_simulating == 0
        break; % Stops the for loop
    end
    
end %t