% Function for WI Group Algorithm

function best_performance = WIGroup_Algorithm(fileName)
    fprintf('\t Function: WIGroup Algorithm %sScenario \n',fileName); 
    count_Scenarios = numel(10:10:200); 
    num_Executions = 50;
    connection_threshold = 6;
    bandwidth_utilization = 0.4;
    Scenario = cell(count_Scenarios,2);    
    GO_t = cell(count_Scenarios,2);
    GM_t = cell(count_Scenarios,2);
    NonGMGO_t = cell(count_Scenarios,2);
    GM_Candidates_t = cell(count_Scenarios,1);
    best_performance = zeros(count_Scenarios,2);

    for users = 10 : 10 : 200
        fprintf('\t %d Users \n',users);
        current_cell = users/10;
        % Import datas
        FileNameIN = sprintf('%sScenario_%d_Users.out',fileName,users);
        fileNameFolder = sprintf('%s Scenario',fileName);
        FileNameIN = fullfile(pwd,'Users Data',fileNameFolder,FileNameIN);        
        Scenario{current_cell,1} = importdata(FileNameIN);
        
        % Update Tables
        % GOt : All GOs at epoch t
        GO_t{current_cell,1} = Scenario{current_cell,1}(Scenario{current_cell,1}(:,7) == 1,:);
        % NonGMGOt : All Non GO/GMs at epoch t
        NonGMGO_t{current_cell,1} = Scenario{current_cell,1}(Scenario{current_cell,1}(:,7) == 0,:);
        
        % Compute Overall bandwidth requirement TR_t
        TR_t = sum(GO_t{current_cell,1}(:,6)) + sum(NonGMGO_t{current_cell,1}(:,6));
        
        % Estimating Overall bandwidth requirement
        total_capacity_GO = sum(GO_t{current_cell,1}(:,5));
        TR_t = TR_t - total_capacity_GO;        
       
        % sort NonGMGO device according to their RSSI
        NonGMGO_t{current_cell,1} = sortrows(NonGMGO_t{current_cell,1},[-4]);        
        k = numel(GO_t{current_cell,1}(:,1));
        
        % selecting more Go devices
        copyNonGMGO_t = NonGMGO_t{current_cell,1};
       
        for go = 1:numel(NonGMGO_t{current_cell,1}(:,1))
            if TR_t > 0 
                if NonGMGO_t{current_cell,1}(go,6) < (bandwidth_utilization * NonGMGO_t{current_cell,1}(go,5))
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
        copyNonGMGO_t(copyNonGMGO_t(:,1) == 0,:) = [];
        NonGMGO_t{current_cell,1} = copyNonGMGO_t;
        %remove users from NON GMGO
        
        
        best_performance(users/10,:) = [users numel(GO_t{current_cell,1}(:,1))+numel(NonGMGO_t{current_cell,1}(:,1))];

    end



end