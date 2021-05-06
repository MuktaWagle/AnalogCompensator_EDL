%g is the compensator
T = readtable('Book1.csv'); %csv file of data
%syms s
s = tf('s');
%c = (s+2513.27)^3/(6*(s+1382.3)^3); %in rad per sec
%c=15*(s/(1600*6.28)+1)^3/(s/(200*6.28)+1)^3;
c=14.75*(s/10000+1)^3/((s*7.8/10000)+1)^3;
bode(c)
%c=10*s/s
mag0 = zeros(40,1);
for j=1:1:40
    mag0(j) = evalfr(c,1i*T.Freq_rad_sec_(j));
end
mag1 = 20*log10(abs(mag0));
corr = T.Magnitude + mag1; %change gain if Magnitude_1
phas = T.Suitable + angle(mag0); %use Suitable instead of phase

figure;
subplot(2,1,1);

semilogx(T.Freq_Hz_, corr)
title('Magnitude');  %dc gain can be added
xline(100);
yline(0);
xlabel("Frequency (Hz)");
ylabel("Magnitude (dB)");

subplot(2,1,2); 
semilogx(T.Freq_Hz_, phas)
yline(-180);
title('Phase');
xlabel("Frequency (Hz)");
ylabel("Magnitude (dB)");


C_s = C(1i*T.Freq_rad_sec_);
G_s = 10.^(T.Magnitude./20).*exp(1i.*2.*pi.*T.Suitable);
closed_tf_noise = (G_s)./(1 + C_s.*G_s);
closed_tf_v = (C_s.*G_s)./(1 + C_s.*G_s);
figure
semilogx(T.Freq_Hz_, 20*log10(abs(closed_tf_noise)),T.Freq_Hz_, 20*log10(abs(closed_tf_v)))
title('Output to Noise and Power Transfer Function');
%semilogx(T.Freq_Hz_, 20*log10(abs(closed_tf_v)))
legend("Noise", "Music")
xline(100);
xlabel("Frequency (Hz)");
ylabel("Magnitude (dB)");


function val = C(w)
    %val=10*w./w
    val = 14.75.*(w./(10000)+1).^3./(w./(1282)+1).^3;
end
