%plot the log nicely
clear
data = load("log.mat");
angle = data.anglesave(:,1:3);
torque = data.anglesave(:,4:6);
KPa = data.anglesave(:,7:9);
KDa = data.anglesave(:,10:12);
KIa = data.anglesave(:,13:15);
position = data.possave(:,1:3);
desiredposition = data.possave(:,4:6);
KPp = data.possave(:,7:9);
KDp = data.possave(:,10:12);
KIp = data.possave(:,13:15);

figure(2)
for ii = 1:3
subplot(2,3,ii);
plot((1:length(angle))/240,[angle(:,ii) torque(:,ii) KPa(:,ii)*3.14/180 KDa(:,ii)*3.14/180 KIa(:,ii)*3.14/180]);
title(['Angle axis: ' num2str(ii)])
legend('angle','sum', 'KP', 'KD', 'KI')
end
for ii = 1:3
subplot(2,3,ii+3);
plot((1:length(position))/240,[position(:,ii) desiredposition(:,ii) KPp(:,ii) KDp(:,ii) KIp(:,ii)]);
title(['Position axis: ' num2str(ii)])
legend('position','sum', 'KP', 'KD', 'KI')
end