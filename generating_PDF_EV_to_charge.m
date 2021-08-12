load('EV_data.mat');
 EV_P = EV_behaviour.EV_LP;
Horizon = 8760;
EV_P = int16(EV_P(:,1:Horizon)./8.0667);

PDF_toCharge = zeros(24,100);

for i = 1:100
    
    dum = EV_P(i,:);
    dum2 = reshape(dum,24,365);
    for j = 1:24
        y = sum(dum2(j,:))/365;
        PDF_toCharge(j,i) = y*100;
    end
end

%% Plot the charging probability

plot(x,PDF_toCharge(:,1),'LineWidth',2,'Marker','*')
hold on
plot(x,PDF_toCharge(:,2),'LineWidth',2,'Marker','*')
xlabel('Time in Hrs')
ylabel('Electric vehicle charging probability in %')
legend('Electric vehicle 1','Electric vehicle 2')

