
function Fs = forcing_signal(F, tF0, FT, T, Nt)

Fs = zeros([1 Nt]); % Forcing signal
Fs(fix(tF0/T):fix(FT/T):Nt) = F;
for i=1:floor((Nt-fix(tF0/T))/fix(FT/T))+1
    cas=(i-1)*fix(FT/T)+fix(tF0/T);
    bal=floor(fix(FT/T)/20);
    for j=cas-bal:cas+bal
        Fs(j)=F-(abs(j-cas)/bal*F);
    end
end