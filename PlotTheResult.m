% Plot the Data
defaultX = 0 : 10 : 200;
defaultY = 0 : 10 : 200;

h(1) = figure;
plot(defaultX,defaultY,'--*r',DirectConnections_Crowd_WIGroup(:,1),DirectConnections_Crowd_WIGroup(:,Number_of_simulations+2),'-..k');
title('Crowded Sparse Scenario');
xlim([0 200]);
ylim([0 200]);
legend('Default','Modified WI Group');
xlabel('# of devices');
ylabel('# of Direct Connections to Cellular Tower');

h(2) = figure;
plot(defaultX,defaultY,'--*r',DirectConnections_Random_WIGroup(:,1),DirectConnections_Random_WIGroup(:,Number_of_simulations+2),'-..k');
title('Random Scenario');
xlim([0 200]);
ylim([0 200]);
legend('Default','Modified WI Group');
xlabel('# of devices');
ylabel('# of Direct Connections to Cellular Tower');      

figName = sprintf('Performance Comparison.fig');
figNameOut = fullfile(pwd,'Users Data','Output Data',figName);
savefig(h,figNameOut);
close(h);