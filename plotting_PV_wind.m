
years = [2011:2020];
new_wind_installations = [2085,2415,3327,5278,5818,5443,6584,3371,2189,1650];

% normal plot
plot(years,new_wind_installations,'Marker','*','LineWidth',2);
title('New installations of wind system for years 2011-2020');
xlabel('years');
ylabel('Installations in MW');
% bar plot
bar(years,new_wind_installations);
title('New installations of wind system for years 2011-2020');
xlabel('years');
ylabel('Installations in MW');


years2 = [2000:2016];
PV_investment = [0.26,0.36,0.68,0.76,3.53,4.84,4.01,5.53,7.97,13.6,19.5,15,11.2,4.25,2.37,1.62,1.58]; % in Billion
feed_in_tarrifs = [50.6,50.6,48.1,45.7,57.4,54.5,51.8,49.2,46.8,43,35.4,28.7,20.9,15.5,13.2,12.8,12.7]; % in Cent/kWh

figure
yyaxis left 
bar(years2, PV_investment);
ylabel('Investment in Billion €');

yyaxis right 
plot(years2,feed_in_tarrifs,'Marker','o','LineWidth',2);
ylabel('Feed-in Tarrifs in Cent/kWh');
xlabel('years');
title('Decline in the investment with the reduction in feed-in tarrifs for years 2000-2016');






