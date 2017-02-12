% Function for WI Group Algorithm

function best_performance = WIGroup_Algorithm_Modified(fileName)
    fprintf('\t Function:  Modified WIGroup Algorithm %sScenario \n',fileName); 
    
    count_Scenarios = numel(10:10:200);     
    connection_threshold = 4;
    bandwidth_utilization = 0.7;
    Minimum_Acceptable_RSSI = 40;
    epoch_interval = 10;
    Scenario = cell(count_Scenarios,1);    
    GO_t = cell(count_Scenarios,1);
    GM_t = cell(count_Scenarios,1);
    NonGMGO_t = cell(count_Scenarios,1);    
    best_performance = zeros(count_Scenarios,2);

    for users = 10 : 10 : 200
        fprintf('\t %d Users \n',users);
        current_cell = users/10;
        
        % Import datas
        FileNameIN = sprintf('%sScenario_%d_Users.out',fileName,users);
        fileNameFolder = sprintf('%s Scenario',fileName);
        FileNameIN = fullfile(pwd,'Users Data',fileNameFolder,FileNameIN);        
        Scenario{current_cell,1} = importdata(FileNameIN);
        
        % 1. GOt : All GOs at start of epoch 
        GO_t{current_cell,1} = Scenario{current_cell,1}(Scenario{current_cell,1}(:,7) == 1,:);
        % 2. NonGMGOt : All Non GO/GMs at epoch t
        NonGMGO_t{current_cell,1} = Scenario{current_cell,1}(Scenario{current_cell,1}(:,7) == 0,:);
        % 3, GMt : All GMs at epoch t
        GM_t{current_cell,1} = Scenario{current_cell,1}(Scenario{current_cell,1}(:,7) == -1,:);

        Files_Access_List = unique(NonGMGO_t{current_cell,1}(:,9));
        Number_Unique_Files = numel(Files_Access_List);
        Unique_Files = cell(Number_Unique_Files,1);
        
        for file = 1:Number_Unique_Files
           Unique_Files{Files_Access_List(file)} = NonGMGO_t{current_cell,1}(NonGMGO_t{current_cell,1}(:,9) == Files_Access_List(file),:);
           
        end
        
        
        for epoch = 1 : epoch_interval
            % Update Tables
            % Take care of situations where devices leave the group, exit
            % connection
            
           
            % Compute Overall bandwidth requirement TR_t
            TR_t = sum(GO_t{current_cell,1}(:,6)) + sum(NonGMGO_t{current_cell,1}(:,6));

            % Estimating Overall bandwidth requirement
            total_capacity_GO = sum(GO_t{current_cell,1}(:,5));
            TR_t = TR_t - total_capacity_GO;        

            % sort NonGMGO device according to their RSSI
            NonGMGO_t{current_cell,1} = sortrows(NonGMGO_t{current_cell,1},4);        
            k = numel(GO_t{current_cell,1}(:,1));

            % selecting more Go devices
            copyNonGMGO_t = NonGMGO_t{current_cell,1};

            for go = 1:numel(NonGMGO_t{current_cell,1}(:,1))
                if TR_t > 0 
                    if (NonGMGO_t{current_cell,1}(go,4) < Minimum_Acceptable_RSSI) && (NonGMGO_t{current_cell,1}(go,6) < (bandwidth_utilization * NonGMGO_t{current_cell,1}(go,5))) && (NonGMGO_t{current_cell,1}(go,8) > connection_threshold)
                        % Each Go device selected must be compared with the
                        % existing GO devices and if they are within same
                        % zone merge them together and the new GO device
                        % will act as GM device
                        file_Candidate = NonGMGO_t{current_cell,1}(go,9);
                        get_GOs_SameFile = GO_t{current_cell,1}(GO_t{current_cell,1}(:,9) == file_Candidate,:);
                        [row,~] = size(get_GOs_SameFile);
                        if row > 0
                            distance_Between_GOs = sqrt( (get_GOs_SameFile(:,2) - NonGMGO_t{current_cell,1}(go,2)).^2 + (get_GOs_SameFile(:,3) - NonGMGO_t{current_cell,1}(go,3)).^2);
                            [M,I] = min(distance_Between_GOs);
                            if M < 100
                               % Add this GO as a GM device
                               NonGMGO_t{current_cell,1}(go,7) = -1;
                               NonGMGO_t{current_cell,1}(go,10) = get_GOs_SameFile(I,1);
                                if numel(GM_t{current_cell,1}(:,1)) == 0
                                    GM_t{current_cell,1} = NonGMGO_t{current_cell,1}(go,:);
                                else
                                    GM_t{current_cell,1} = [GM_t{current_cell,1} ; NonGMGO_t{current_cell,1}(go,:)];
                                end
                                copyNonGMGO_t(go,:) = zeros(1,10);
                                continue;
                            end
                        end
                        
                        NonGMGO_t{current_cell,1}(go,7) = 1;
                        if numel(GO_t{current_cell,1}(:,1)) == 0
                            GO_t{current_cell,1} = NonGMGO_t{current_cell,1}(go,:);
                        else
                        GO_t{current_cell,1} = [GO_t{current_cell,1} ; NonGMGO_t{current_cell,1}(go,:)];
                        end
                        TR_t = TR_t - NonGMGO_t{current_cell,1}(go,5);
                        copyNonGMGO_t(go,:) = zeros(1,10);                    
                        k = k + 1;
                    end

                else
                    break;
                end

            end

            %remove users from NON GMGO
            copyNonGMGO_t(copyNonGMGO_t(:,1) == 0,:) = [];
            NonGMGO_t{current_cell,1} = copyNonGMGO_t;

            Number_GO = numel(GO_t{current_cell,1}(:,1));
            Number_NonGMGO = numel(NonGMGO_t{current_cell,1}(:,1));
            Number_GM = numel(GM_t{current_cell,1}(:,1));

            % Selection of GM Candidates
            if Number_GO > 0
                % 1. Common Files of GO
                Unique_Files_GO = unique(GO_t{current_cell,1}(:,9));
                Number_Unique_Files = numel(Unique_Files_GO);

                File_List = cell(Number_Unique_Files,1);
                for file = 1:Number_Unique_Files
                   File_List{Unique_Files_GO(file)} = GO_t{current_cell,1}(GO_t{current_cell,1}(:,9) == Unique_Files_GO(file),:); 
                end

                % 2. Send Notification to the GM Candidates in NonGMGO_t

                copyNonGMGO_t = NonGMGO_t{current_cell,1};
                
                for gm_c = 1:Number_NonGMGO
                    row = 0;
                    if (NonGMGO_t{current_cell,1}(gm_c,9) <= numel(File_List))
                        Search_GOs = File_List{NonGMGO_t{current_cell,1}(gm_c,9)};
                        [row,~] = size(Search_GOs);
                    end
                    
                    if row > 0
                        % NonGMGO will determine the distance between each GO and try
                        % to connect to them
                        distance = sqrt( (Search_GOs(:,2) - NonGMGO_t{current_cell,1}(gm_c,2)).^2 + (Search_GOs(:,3) - NonGMGO_t{current_cell,1}(gm_c,3)) .^2);
                        [M,~] = min(distance);
                        if M < 100
                           % Connect to the GO device and add device to the GM list and
                           % remove from NonGMGO list
                           NonGMGO_t{current_cell,1}(gm_c,7) = -1;
                           if numel(GM_t{current_cell,1}(:,1)) == 0
                               GM_t{current_cell,1} = NonGMGO_t{current_cell,1}(gm_c,:);
                           else
                               GM_t{current_cell,1} = [GM_t{current_cell,1} ; NonGMGO_t{current_cell,1}(gm_c,:)];
                           end
                           copyNonGMGO_t(gm_c,:) = zeros(1,10);              

                        end
                    end
                        
                end
                %remove users from NON GMGO
                copyNonGMGO_t(copyNonGMGO_t(:,1) == 0,:) = [];
                NonGMGO_t{current_cell,1} = copyNonGMGO_t;

                Number_GO = numel(GO_t{current_cell,1}(:,1));
                Number_NonGMGO = numel(NonGMGO_t{current_cell,1}(:,1));
                Number_GM = numel(GM_t{current_cell,1}(:,1));    

            end
            
            % Increase the connecton duraton of every devices by 1
            GO_t{current_cell,1}(:,8) = GO_t{current_cell,1}(:,8) + 1;
            GM_t{current_cell,1}(:,8) = GM_t{current_cell,1}(:,8) + 1;
            NonGMGO_t{current_cell,1}(:,8) = NonGMGO_t{current_cell,1}(:,8) + 1;

        end
        best_performance(users/10,:) = [users Number_GO+Number_NonGMGO];

    end   


end