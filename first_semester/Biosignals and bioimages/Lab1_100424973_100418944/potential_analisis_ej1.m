% de la señal eeg extraemos aquellas muestras correspondientes a stims = 1
ERPdata=load('ERPdata.mat');
index2=find(ERPdata.stims==2);
times2=ERPdata.stimtimes(index2);
t=ERPdata.t;
eeg=ERPdata.eeg;

ERP=zeros(length(index2),find(t>=0.6,1));
for i=1:length(times2)
    ERP(i,:)= eeg(find(t>=times2(i),1):(find(t>=times2(i),1)+150));
end
t_vect=linspace(0,0.6,size(ERP,2));
plot(t_vect,ERP')
set(gca,{'YDir'},{'reverse'});


mean_ERP=mean(ERP);

%Create a vector to represent the margins of the time windows

figure()
plot(t_vect,mean_ERP)
hold on 
plot([0.05 0.05],[-40 40],'r');
plot([0.15 0.15],[-40 40],'r');
plot([0.25 0.25],[-40 40],'r');
plot([0.35 0.35],[-40 40],'r');
set(gca,{'YDir'},{'reverse'});

t_muestra=150/600;
peeks=[100 200 300];
window=150/6; %Sacamos las muestras equivalentes a 100ms que serían 25
val=zeros(length(peeks),1);
pos=zeros(length(peeks),1);
val_ERP=zeros(3,window);

for j=1:length(peeks)
    val(j)= max(abs(mean_ERP(round(peeks(j)*t_muestra -window/2):round(peeks(j)*t_muestra + window/2))));
    pos(j)=find(abs(mean_ERP)==val(j),1);
    
    fit=polyfit([pos(j)-window/2:pos(j)+window/2],mean_ERP(pos(j)-window/2:pos(j)+window/2),5);
    val_ERP(j,:)=polyval(fit,[pos(j)-window/2+1:pos(j)+window/2]);
    
    if j<3
    [max_fit(j),pos_fit(j)]= min(val_ERP(j,:));
    
    else
    [max_fit(j),pos_fit(j)]= max(val_ERP(j,:));
    end
end

figure()
plot(t_vect,mean_ERP)
hold on 
scatter(t_vect(pos),mean_ERP(pos),'r','x')
plot(t_vect(pos(1)-window/2+1:pos(1)+window/2),val_ERP(1,:),'g')
plot(t_vect(pos(2)-window/2+1:pos(2)+window/2),val_ERP(2,:),'g')
plot(t_vect(pos(3)-window/2+1:pos(3)+window/2),val_ERP(3,:),'g')
scatter(t_vect(round(pos_fit(1)+pos(1)-window/2)),val_ERP(1,pos_fit(1)),'b','o')
scatter(t_vect(round(pos_fit(2)+pos(2)-window/2)),val_ERP(2,pos_fit(2)),'b','o')
scatter(t_vect(round(pos_fit(3)+pos(3)-window/2)),val_ERP(3,pos_fit(3)),'b','o')

plot([0.05 0.05],[-40 40],'r');
plot([0.15 0.15],[-40 40],'r');
plot([0.25 0.25],[-40 40],'r');
plot([0.35 0.35],[-40 40],'r');

set(gca,'YDir','reverse')
hold off


%Amplitude of the peaks
amplitudes=max_fit

%Latencias of the peaks
latencies=[t_vect(round(pos_fit(1)+pos(1)-window/2)), t_vect(round(pos_fit(2)+pos(2)-window/2)), t_vect(round(pos_fit(3)+pos(3)-window/2))]

       
       

