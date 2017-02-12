function GenerateUsers( ~ )
% GenerateUsers_WIGroup 
% Genrates the users list with details for synthetic scenarios : Random and Crowd scenario
% Device_ID X_i Y_i RSSI Bandwidth_Capacity BandwidthUsage_t_1
% Curent_Status Connection_Length FileAccessed

% Input Arguments :
    X0 = -1000;
    Y0 = -1000;
    width = 2000;
    height = 2000;
    
for numUsers = 10 : 10 : 200   
        
        %Random Scenario
        X_Random = randi([-1000,1000],numUsers,1);
        Y_Random = randi([-1000,1000],numUsers,1);

        %Crowded Sparse Scenario

            % Create a random set of coordinates in a circle.
            % First define parameters that define the number of points and the circle.

        % 1 st crowd
        % centered between X [-750 and 0] and Y [-250 and 750] 
        n_0 = round(numUsers*2/5);
        R_0 = round(100 + (150 * rand));
        x_0 = round(-750 + (750 * rand)) ; % Center of the circle in the x direction.
        y_0 = round(-600 + (1350 * rand)); % Center of the circle in the y direction.

        % Now create the set of points.
        t = 2*pi*rand(n_0,1);
        r_0 = R_0*sqrt(rand(n_0,1));
        X0 = round(x_0 + r_0.*cos(t));
        Y0 = round(y_0 + r_0.*sin(t));

        %2nd crowd
        n_1 = round(numUsers*2/5);
        R_1 = round(150  + (50 * rand));
        x_1 = round(300 + (600 * rand));
        y_1 = round(-800 + (1600 * rand));

        t = 2*pi*rand(n_1,1);
        r_1 = R_1*sqrt(rand(n_1,1));
        X1 = round(x_1 + r_1.*cos(t));
        Y1 = round(y_1 + r_1.*sin(t));

        % 3rd crowd
        n_2 = numUsers - (n_1 + n_0);
        R_2 = round(500 + (100 * rand));
        x_2 = round(300 * rand);
        y_2 = round(-300 + (500 * rand));

        t = 2*pi*rand(n_2,1);
        r_2 = R_2 *sqrt(rand(n_2,1));
        X2 = round(x_2 + r_2.*cos(t));
        Y2 = round(y_2 + r_2.*sin(t));


        X_Crowd = [X0 ;X1;X2];
        Y_Crowd = [Y0 ;Y1;Y2];

        % Generate Device ID for each user
        userID = (linspace(1,numUsers,numUsers))';

        %compute the RSSI of each user in Random scenario
        D_Random = sqrt(X_Random.^2 + Y_Random.^2);
        RSSI_pathLoss_Random = (20.*log10(D_Random)) + (20 .* log10(2.4 * (10e9))) + (20 .* log10(4*pi/(3* (10e8))));
        RSSI_pathLoss_Random = RSSI_pathLoss_Random .* (0.1 + (0.7).*rand(numUsers,1));
        
        % maximum Chanel Capacity B Random Scenario
        baseChannelCapacity_Random = 2;
        B_rand = rand(numUsers,1);
        B_Random = baseChannelCapacity_Random + B_rand;
    
        % data rate of each user : Random
        % Generate data rate between 0.5 and 1.5  
        data_rate_Random = (1 .* rand(numUsers,1)) + 0.5;
    
        %compute the RSSI of each user in Crowd Sparse scenario
        D_Crowd = sqrt(X_Crowd.^2 + Y_Crowd.^2);
        RSSI_pathLoss_Crowd = (20.*log10(D_Crowd)) + (20 .* log10(2.4 * (10e9))) + (20 .* log10(4*pi/(3* (10e8))));
        RSSI_pathLoss_Crowd = RSSI_pathLoss_Crowd .* (0.1 + (0.7).*rand(numUsers,1));
    
        % maximum Chanel Capacity B Crowd Scenario
        baseChannelCapacity_Crowd = 2;
        B_crowd = rand(numUsers,1);
        B_Crowd = baseChannelCapacity_Crowd + B_crowd;
        
        %data Rate of each user : crowd
        data_rate_Crowd = (1 .* rand(numUsers,1)) + 0.5;   
        
        
        % Connection Length : between 0 and 10
        connection_Length_Random = randi([0 10],numUsers,1);
        connection_Length_Crowd = randi([0 10],numUsers,1);
%         connection_Length_Random = zeros(numUsers,1);
%         connection_Length_Crowd = zeros(numUsers,1);
        
        % Current_status of devices : GO - 1| GM - -1 | NonGMGO ie BS - 0 |
        status_Random = zeros(numUsers,1);
        status_Crowd = zeros(numUsers,1);
        
%         % If the Connection length is more than 8 then make it GO , if 4 <
%         % connection_length < 7 , then make it GM else make it BS
        status_Random(connection_Length_Random(:,1) >= 9) = 1;
        status_Random(connection_Length_Random(:,1) >= 4 & connection_Length_Random(:,1) <= 8) = -1;
        status_Crowd(connection_Length_Crowd(:,1) >= 9) = 1;
        status_Crowd(connection_Length_Crowd(:,1) >= 4 & connection_Length_Crowd(:,1) <= 8) = -1; 
        
        % File accessed by each user : random files [1 2]
%         FileAccess_Random = randi([1 2],numUsers,1);
%         FileAccess_Crowd = randi([1 2],numUsers,1);
        FileAccess_Random = ones(numUsers,1);
        FileAccess_Crowd = ones(numUsers,1);
        
        % Direct Connection Status : 0 - Base Station  else user ID of
        % device which is the GO for the particular GM
        
        direct_Connection_Crowd = zeros(numUsers,1);
        direct_Connection_Random = zeros(numUsers,1);
    
        %Accumulating Data
        randData = [userID X_Random Y_Random RSSI_pathLoss_Random B_Random data_rate_Random status_Random connection_Length_Random FileAccess_Random direct_Connection_Random];
        crowdData = [userID X_Crowd Y_Crowd RSSI_pathLoss_Crowd B_Crowd data_rate_Crowd status_Crowd connection_Length_Crowd FileAccess_Crowd direct_Connection_Crowd];

        %writing the data to Output folder : Random
        RandomScenario = sprintf('RandomScenario_%d_Users.out',numUsers);
        fileNameOut = fullfile(pwd,'Users Data','Random Scenario',RandomScenario);
        fileID = fopen(fileNameOut,'w'); 
        formatspec = '%3d  %+4.3f  %+4.3f  %+3.3f  %+2.3f  %+2.3f %1d %2d %2d %2d\r\n';
        [nrows,~] = size(randData);
        for row = 1:nrows
            fprintf(fileID,formatspec,randData(row,:));
        end   
        fclose(fileID);
   
        % Crowd Scenario
        CrowdScenario = sprintf('CrowdScenario_%d_Users.out',numUsers);
        fileNameOut = fullfile(pwd,'Users Data','Crowd Scenario',CrowdScenario);
        fileID = fopen(fileNameOut,'w'); 
        formatspec = '%3d  %+4.3f  %+4.3f  %+3.3f  %+2.3f  %+2.3f %1d %2d %2d %2d\r\n';
        [nrows,~] = size(crowdData);
        for row = 1:nrows
            fprintf(fileID,formatspec,crowdData(row,:));
        end   
        fclose(fileID);

        %Plot the data and save it to figures
        X_BS = 0;
        Y_BS = 0;
        h(1) = figure;
        scatter(X_Crowd,Y_Crowd);
        hold on;
        scatter(X_BS,Y_BS,'x');
        str = ['Crowded Sparse Scenario : ',num2str(numUsers)];
        title(str);
        xlim([-1000 1000]);
        ylim([-1000 1000]);
        hold off;
        figName = sprintf('CrowdedScenario_%d_Users.jpg',numUsers);
        figNameOut = fullfile(pwd,'Users Data','Figures',figName);
        saveas(gcf,figNameOut)

        h(2) = figure;
        scatter(X_Random,Y_Random);
        hold on;
        scatter(X_BS,Y_BS,'x');
        str = ['Random Scenario : ',num2str(numUsers)];
        title(str);
        xlim([-1000 1000]);
        ylim([-1000 1000]);
        hold off;
        figName = sprintf('RandomScenario_%d_Users.jpg',numUsers);
        figNameOut = fullfile(pwd,'Users Data','Figures',figName);
        saveas(gcf,figNameOut)

%         figName = sprintf('Scenario_%d_Users.jpg',numUsers);
%         figNameOut = fullfile(pwd,'Users Data','Figures',figName);
%         savefig(h,figNameOut);
        
        close(h);    
end




end

