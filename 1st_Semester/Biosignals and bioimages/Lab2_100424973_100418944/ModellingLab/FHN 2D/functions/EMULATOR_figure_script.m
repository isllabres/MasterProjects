%% FitzHugh-Nagumo model GUI
% Master in Information Health Engineering
% Course 2019/2010
% Course: Biosignals and bioimages
% Gonzalo R. Ríos-Muñoz
% Code version 1.0 November 2019
% Universidad Carlos III de Madrid

% DO NOT MODIFY

% PLOT EMULATOR FIGURE SCRIPT
clim = [min(min(min(U)))-0.2 max(max(max(U)))+0.2];
colores = hsv(num_signals);
plot_buffer = 100;

figure(EMULATOR_figure)

% Potential + Reference Lasso Points
subplot(2,3,1)
for i = 1:num_signals
    aux_x = lasso_points_x(i);
    aux_y = lasso_points_y(i);
    aux_U(aux_y, aux_x) = 20;
    imagesc(aux_U, clim)
end
imagesc(aux_U, clim)
for i = 1:num_signals
    % Label Lasso points
    aux_x = lasso_points_x(i);
    aux_y = lasso_points_y(i);
    text(aux_x, aux_y-3, num2str(i))
end
title('U')

% Bipolar signals
subplot(2,3,2:3)

hold on
set(gca,'ytick',[])
ref_buffer = max(1,video_frame-plot_buffer+1):video_frame;
min_xlim = ref_buffer(1);
max_xlim = max(ref_buffer(end), plot_buffer);

ylim([-10 (num_signals)*10])
xlim([min_xlim max_xlim])

for i = 1:num_signals
    
    if video_frame > 1
        delete(aux_text_handle(i))
    end
    
    aux_offset = (num_signals-i)*10;
    plot(lasso_signals(i,1:video_frame)+aux_offset, 'color', colores(i,:));
    aux_text_handle(i) = text(min_xlim-10, aux_offset ,['V_{' num2str(i+1) '-' num2str(i) '}']);
end
hold off
title('Bipolar signals')

% Mask
subplot(2,3,4)
mask_png = imread(global_parameters.png_file);
imshow(mask_png)
title('Mask')

% Stimulation signals
subplot(2,3,5:6)
plot(Fs(1:t), 'r')
hold on
plot(Fs2(1:t), 'g')
title('Fs(t)')
legend('Fs', 'Fs2')
hold off
title('Stimulation signals')