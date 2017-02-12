% Program to compare the algoithms

Number_of_simulations = 30;

DirectConnections_Crowd_KMeans = zeros(size(10:10:200,2),Number_of_simulations+2);
DirectConnections_Random_KMeans = zeros(size(10:10:200,2),Number_of_simulations+2);
DirectConnections_Crowd_WIGroup = zeros(size(10:10:200,2),Number_of_simulations+2);
DirectConnections_Random_WIGroup = zeros(size(10:10:200,2),Number_of_simulations+2);
DirectConnections_Crowd_WIGroup_Modified = zeros(size(10:10:200,2),Number_of_simulations+2);
DirectConnections_Random_WIGroup_Modified = zeros(size(10:10:200,2),Number_of_simulations+2);


for executions = 1 : Number_of_simulations
   fprintf('Main : %d Executions \n',executions); 
   % Generate Users
   GenerateUsers;
   
%    best_performance_CROWD_KMeans = Performance_Comparison('Crowd');
%    best_performance_RANDOM_KMeans = Performance_Comparison('Random');
   best_performance_CROWD_WIGroup_Modified = WIGroup_Algorithm_Modified('Crowd');
   best_performance_RANDOM_WIGroup_Modified = WIGroup_Algorithm_Modified('Random');
   best_performance_CROWD_WIGroup = WIGroup_Algorithm('Crowd');
   best_performance_RANDOM_WIGroup = WIGroup_Algorithm('Random');
   
   if executions == 1
%         DirectConnections_Crowd_KMeans = best_performance_CROWD_KMeans;
%         DirectConnections_Random_KMeans = best_performance_RANDOM_KMeans;
        DirectConnections_Crowd_WIGroup_Modified = best_performance_CROWD_WIGroup_Modified;
        DirectConnections_Random_WIGroup_Modified = best_performance_RANDOM_WIGroup_Modified;
        DirectConnections_Crowd_WIGroup = best_performance_CROWD_WIGroup;
        DirectConnections_Random_WIGroup = best_performance_RANDOM_WIGroup;
    else
%         DirectConnections_Crowd_KMeans(:,executions+1) = best_performance_CROWD_KMeans(:,2); 
%         DirectConnections_Random_KMeans(:,executions+1) = best_performance_RANDOM_KMeans(:,2);
        DirectConnections_Crowd_WIGroup(:,executions+1) = best_performance_CROWD_WIGroup(:,2);
        DirectConnections_Random_WIGroup(:,executions+1) = best_performance_RANDOM_WIGroup(:,2);
        DirectConnections_Crowd_WIGroup_Modified(:,executions+1) = best_performance_CROWD_WIGroup_Modified(:,2);
        DirectConnections_Random_WIGroup_Modified(:,executions+1) = best_performance_RANDOM_WIGroup_Modified(:,2);
   end     
    
    
end

% Write to file
% direct = sprintf('DirectConnectionsCrowdScenario_KMeans.out');        
% fileNameOut = fullfile(pwd,'Users Data','Output Data',direct);        
% dlmwrite(fileNameOut,DirectConnections_Crowd_KMeans,'delimiter','\t','precision','%3d');
% 
% direct = sprintf('DirectConnectionsRandomScenario_KMeans.out');        
% fileNameOut = fullfile(pwd,'Users Data','Output Data',direct);        
% dlmwrite(fileNameOut,DirectConnections_Random_KMeans,'delimiter','\t','precision','%3d'); 

direct = sprintf('DirectConnectionsCrowdScenario_WIGroup.out');        
fileNameOut = fullfile(pwd,'Users Data','Output Data',direct);        
dlmwrite(fileNameOut,DirectConnections_Crowd_WIGroup,'delimiter','\t','precision','%3d'); 

direct = sprintf('DirectConnectionsRandomScenario_WIGroup.out');        
fileNameOut = fullfile(pwd,'Users Data','Output Data',direct);        
dlmwrite(fileNameOut,DirectConnections_Random_WIGroup,'delimiter','\t','precision','%3d'); 

direct = sprintf('DirectConnectionsCrowdScenario_WIGroup_Modified.out');        
fileNameOut = fullfile(pwd,'Users Data','Output Data',direct);        
dlmwrite(fileNameOut,DirectConnections_Crowd_WIGroup_Modified,'delimiter','\t','precision','%3d'); 

direct = sprintf('DirectConnectionsRandomScenario_WIGroup_Modified.out');        
fileNameOut = fullfile(pwd,'Users Data','Output Data',direct);        
dlmwrite(fileNameOut,DirectConnections_Random_WIGroup_Modified,'delimiter','\t','precision','%3d'); 


% Find the mean of executions
% DirectConnections_Crowd_KMeans(:,Number_of_simulations+2) = sum(DirectConnections_Crowd_KMeans(:,2:Number_of_simulations+1),2)./ Number_of_simulations;
% DirectConnections_Random_KMeans(:,Number_of_simulations+2) = sum(DirectConnections_Random_KMeans(:,2:Number_of_simulations+1),2)./ Number_of_simulations;
DirectConnections_Crowd_WIGroup(:,Number_of_simulations+2) = sum(DirectConnections_Crowd_WIGroup(:,2:Number_of_simulations+1),2)./ Number_of_simulations;
DirectConnections_Random_WIGroup(:,Number_of_simulations+2) = sum(DirectConnections_Random_WIGroup(:,2:Number_of_simulations+1),2)./ Number_of_simulations;
DirectConnections_Crowd_WIGroup_Modified(:,Number_of_simulations+2) = sum(DirectConnections_Crowd_WIGroup_Modified(:,2:Number_of_simulations+1),2)./ Number_of_simulations;
DirectConnections_Random_WIGroup_Modified(:,Number_of_simulations+2) = sum(DirectConnections_Random_WIGroup_Modified(:,2:Number_of_simulations+1),2)./ Number_of_simulations;

% Plot the Data
defaultX = 0 : 10 : 200;
defaultY = 0 : 10 : 200;

h(1) = figure;
% plot(defaultX,defaultY,'-..r',DirectConnections_Crowd_KMeans(:,1),DirectConnections_Crowd_KMeans(:,Number_of_simulations+2),'-..r',DirectConnections_Crowd_WIGroup(:,1),DirectConnections_Crowd_WIGroup(:,Number_of_simulations+2),'-..k',DirectConnections_Crowd_WIGroup_Modified(:,1),DirectConnections_Crowd_WIGroup_Modified(:,Number_of_simulations+2),'-..b');
plot(defaultX,defaultY,'-..r',DirectConnections_Crowd_WIGroup(:,1),DirectConnections_Crowd_WIGroup(:,Number_of_simulations+2),'-..k',DirectConnections_Crowd_WIGroup_Modified(:,1),DirectConnections_Crowd_WIGroup_Modified(:,Number_of_simulations+2),'-..b');
title('Crowded Sparse Scenario: Multiple files');
xlim([0 200]);
ylim([0 200]);
legend('Default','WI Group','WI Group Modified');
xlabel('# of devices');
ylabel('# of Direct Connections to Cellular Tower');

h(2) = figure;
% plot(defaultX,defaultY,'-..r',DirectConnections_Random_KMeans(:,1),DirectConnections_Random_KMeans(:,Number_of_simulations+2),'-..r',DirectConnections_Random_WIGroup(:,1),DirectConnections_Random_WIGroup(:,Number_of_simulations+2),'-..k',DirectConnections_Random_WIGroup_Modified(:,1),DirectConnections_Random_WIGroup_Modified(:,Number_of_simulations+2),'-..b');
plot(defaultX,defaultY,'-..r',DirectConnections_Random_WIGroup(:,1),DirectConnections_Random_WIGroup(:,Number_of_simulations+2),'-..k',DirectConnections_Random_WIGroup_Modified(:,1),DirectConnections_Random_WIGroup_Modified(:,Number_of_simulations+2),'-..b');
title('Random Scenario: Multiple Files');
xlim([0 200]);
ylim([0 200]);
legend('Default','WI Group','WI Group Modified');
xlabel('# of devices');
ylabel('# of Direct Connections to Cellular Tower');      

figName = sprintf('Performance Comparison-Multilple files.fig');
figNameOut = fullfile(pwd,'Users Data','Output Data',figName);
savefig(h,figNameOut);
close(h);