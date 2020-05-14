%% SEIZURE DETECTION 


%First of all we load the data and the sample frequencies for each pacient
eegS=load('eegSeizure_v2.mat');
eegS1=eegS.eegEpilepsy_1;
eegS2=eegS.eegEpilepsy_2;
freq1=eegS.eegEpilepsy_1_freq;
freq2=eegS.eegEpilepsy_2_freq;

%% PATIENT ONE
eeg_s1_sub=[];
s=[];
f=[];
t=[];

%Normalize and subsampling the signals before doing the Short Time Fourier
%Transform (stft)

for i=1:size(eegS1,1)
 eegS1_norm=eegS1(i,:)./max(eegS1(i,:));
 eeg_s1_sub(i,:)=downsample(eegS1_norm,3);
 [s(:,:,i), f, t]= stft(eeg_s1_sub(i,:),2^10 , 2^7/2, 2^12, round(freq1)/3);

end

cut_freq=find(f>20,1);
s_cut=abs(s(1:cut_freq,:,:));


%We have to eliminate the peak that appears in all the frequencies because
%its could be produce by an impedance as it is shown in this graph
%To do so, we calculate the mean of each frequency until that peak, and
%subsitute it by this value. We iterate this proccess several times to
%avoid its effect
    mesh(t,f(1:cut_freq),s_cut(1:cut_freq,:,1));
    set(gca, 'FontName','Times New Roman','FontSize',14);
    xlabel('Time,s');
    ylabel('Frequency,Hz');
    title('Amplitude spectrogram of the signal');
    hand1=colorbar;
    set(hand1,'FontName','Times New Roman','FontSize',14);
    ylabel(hand1, 'Abs amplitude');
    colormap(jet)

for j=1:8
    [val,pos]=max(s_cut,[],2); 
    pos=squeeze(pos);
    outlier = mode(mode(pos,2));
    s_cut(:,outlier,:)=mean(s_cut(:,1:outlier-1,:),2);
end

%Due that when a seizure appear it usually has high values in all the
%frequencies, we calculate the mean for every time instance, and only a 2d
%signal remains for each channel 
s_mean=mean(s_cut);
s_mean=squeeze(s_mean);
s_mean_freq=mean(s_cut,2);

%To the peak detection we use as threshold 2*mean value of each channel 
threshold=2*mean(s_mean);
pos_seizures=zeros(length(s_mean),size(threshold,2));

%The seizure detection is done thresholding the signal
for h=1:size(s_mean,2)
    for j=1:length(s_mean)
         if s_mean(j,h)>threshold(h)
                pos_seizures(j,h)=7;
         
         elseif s_mean(j,h)<threshold(h) && find(t>20,1)<j && j<(length(s_mean)-find(t>20,1)) && any(s_mean(j-find(t>20,1):j+find(t>20,1),h) > threshold(h))
                pos_seizures(j,h)=7;
                
         end
    end 
end 

%Subplot of the seizures detected in each channel          
for i=1:16
    subplot(8,2,i),plot(t,s_mean(:,i)), hold on, plot(t,0.5*pos_seizures(:,i))
    xlabel('Time,s');
    ylabel('Amplitud');
    title('Seizures detected in each channel')
    set(gca,'FontSize',6);

end

%To detect the real seizures we do the mode between all the channels to see
%if that event occurs in the majority of the channles or not 
pos_seizures_mode=mode(pos_seizures,2);

%Visualization of all the signals andd the seizures detected
figure()
plot(t,pos_seizures_mode),ylim([0,10])
hold on 
plot(t,s_mean)
xlabel('Time,s');
ylabel('Amplitud,Hz');
title('Seizures detected')


%Detect the time at each seizure starts and stops
start_stop=zeros(length(pos_seizures_mode),1);



for i = 1:length(pos_seizures)
    if i>1 && pos_seizures_mode(i)~=0 && pos_seizures_mode(i-1)==0
        start_stop(i)=1;
    elseif  i< length(pos_seizures_mode) && pos_seizures_mode(i)~=0 && pos_seizures_mode(i+1)==0
        start_stop(i)=2;
    end
end

time_seizures=[];
time_seizures(:,1)=t(start_stop==1);
time_seizures(:,2)=t(start_stop==2);

%Obtain the duration and mean duration of each seizure and the duration 
duration_seizures=time_seizures(:,2)-time_seizures(:,1);
mean_dur=mean(duration_seizures);

seizure_signals=[];
samp_seizure_orig=time_seizures*freq1;

for i=1:length(samp_seizure_orig)
    seizure_signals_aux=eegS1(1,samp_seizure_orig(i,1):samp_seizure_orig(i,2));
    seizure_signals=[seizure_signals seizure_signals_aux];

end


 ss_norm=seizure_signals./max(seizure_signals);
 [ss, fs, ts]= stft(ss_norm,2^10 , 2^7/2, 2^12, round(freq1));
%We only keep the first 20Hz of the signal
fs_cut=find(fs>20,1);

%Plot the stft of the signal that only contains the seizures

figure()
mesh(ts,fs(1:fs_cut),abs(ss(1:fs_cut,:)));
set(gca, 'FontName','Times New Roman','FontSize',14);
xlabel('Time,s');
ylabel('Frequency,Hz');
title('Amplitude spectrogram of the signal');
hand1=colorbar;
set(hand1,'FontName','Times New Roman','FontSize',14);
ylabel(hand1, 'abs Amplitude');
colormap(jet)

%% PATIENT 2

eeg_s2_sub=[];
s2=[];
f2=[];
t2=[];

%Normalize and subsampling the signals before doing the Short Time Fourier
%Transform (stft)

for i=1:size(eegS2,1)
 eegS2_norm=eegS2(i,:)./max(eegS2(i,:));
 eeg_s2_sub(i,:)=downsample(eegS2_norm,8);
 [s2(:,:,i), f2, t2]= stft(eeg_s1_sub(i,:),2^10 , 2^7/2, 2^12, round(freq1)/8);

end

cut_freq=find(f2>20,1);
s_cut2=abs(s2(1:cut_freq,:,:));

%We have to eliminate the peak that appears in all the frequencies because
%its could be produce by an impedance as it is shown in this graph
%To do so, we calculate the mean of each frequency until that peak, and
%subsitute it by this value. We iterate this proccess several times to
%avoid its effect
    mesh(t,f(1:cut_freq),s_cut(1:cut_freq,:,1));
    set(gca, 'FontName','Times New Roman','FontSize',14);
    xlabel('Time,s');
    ylabel('Frequency,Hz');
    title('Amplitude spectrogram of the signal');
    hand1=colorbar;
    set(hand1,'FontName','Times New Roman','FontSize',14);
    ylabel(hand1, 'Abs amplitude');
    colormap(jet)



%Due that when a seizure appear it usually has high values in all the
%frequencies, we calculate the mean for every time instance, and only a 2d
%signal remains for each channel 
s_mean2=mean(s_cut2);
s_mean2=squeeze(s_mean2);


%To the peak detection we use as threshold 2*mean value of each channel 
threshold2=2*mean(s_mean22);
pos_seizures2=zeros(length(s_mean2),size(threshold,2));

%The seizure detection is done thresholding the signal
for h=1:size(s_mean2,2)
    for j=1:length(s_mean2)
         if s_mean(j,h)>threshold2(h)
                pos_seizures2(j,h)=7;
         
         elseif s_mean2(j,h)<threshold2(h) && find(t2>20,1)<j && j<(length(s_mean2)-find(t2>20,1)) && any(s_mean2(j-find(t2>20,1):j+find(t2>20,1),h) > threshold(h))
                pos_seizures2(j,h)=7;
                
         end
    end 
end 

%Subplot of the seizures detected in each channel          
for i=1:64
    subplot(8,2,i),plot(t,s_mean2(:,i)), hold on, plot(t2,0.5*pos_seizures2(:,i))
    xlabel('Time,s');
    ylabel('Amplitud');
    title('Seizures detected in each channel')
    set(gca,'FontSize',6);

end

%To detect the real seizures we do the mode between all the channels to see
%if that event occurs in the majority of the channles or not 
pos_seizures_mode2=mode(pos_seizures2,2);

%Visualization of all the signals andd the seizures detected
figure()
plot(t,pos_seizures_mode2),ylim([0,10])
hold on 
plot(t,s_mean2)
xlabel('Time,s');
ylabel('Amplitud,Hz');
title('Seizures detected')


%Detect the time at each seizure starts and stops
start_stop2=zeros(length(pos_seizures_mode2),1);



for i = 1:length(pos_seizures2)
    if i>1 && pos_seizures_mode2(i)~=0 && pos_seizures_mode2(i-1)==0
        start_stop2(i)=1;
    elseif  i< length(pos_seizures_mode2) && pos_seizures_mode2(i)~=0 && pos_seizures_mode2(i+1)==0
        start_stop2(i)=2;
    end
end

time_seizures2=[];
time_seizures2(:,1)=t(start_stop2==1);
time_seizures2(:,2)=t(start_stop2==2);

%Obtain the duration and mean duration of each seizure and the duration 
duration_seizures2=time_seizures2(:,2)-time_seizures2(:,1);
mean_dur2=mean(duration_seizures2);

seizure_signals=[];
samp_seizure_orig=time_seizures*freq1;

for i=1:length(samp_seizure_orig)
    seizure_signals_aux=eegS1(1,samp_seizure_orig(i,1):samp_seizure_orig(i,2));
    seizure_signals=[seizure_signals seizure_signals_aux];

end


 ss_norm=seizure_signals./max(seizure_signals);
 [ss, fs, ts]= stft(ss_norm,2^10 , 2^7/2, 2^12, round(freq1));
%We only keep the first 20Hz of the signal
fs_cut=find(fs>20,1);

%Plot the stft of the signal that only contains the seizures

figure()
mesh(ts,fs(1:fs_cut),abs(ss(1:fs_cut,:)));
set(gca, 'FontName','Times New Roman','FontSize',14);
xlabel('Time,s');
ylabel('Frequency,Hz');
title('Amplitude spectrogram of the signal');
hand1=colorbar;
set(hand1,'FontName','Times New Roman','FontSize',14);
ylabel(hand1, 'abs Amplitude');
colormap(jet)





         







  



