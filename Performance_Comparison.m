% Performance Comparison Between the Two algorithms

function best_performance = Performance_Comparison(fileName)

    fprintf('\t Function: Performance Comparison %sScenario KMeans \n',fileName); 
    best_performance = zeros(numel(10:10:200),2);       
    
    for users = 10 : 10 : 200    
            fprintf('\t %d Users \n',users);
            Scenario = cell(users,1);            
            performance = zeros(users,5);           

            for k = 2 : users
                fileNameIn = sprintf('%sScenario_%d_Users.out',fileName,users);
                fileNameFolder = sprintf('%s Scenario',fileName);
                fileNameIn = fullfile(pwd,'Users Data',fileNameFolder,fileNameIn);
                Scenario{k} = importdata(fileNameIn);                

                Data = Scenario{k}(:,1:3);
                
                % Implement the Kmeans Algorithm here
                head = cell(k,1);
                cluster = cell(k+1,1);

                cluster{1} = Data(:,1:3);            
                head{1} = cluster{1}(1,1:3);
                cluster{1}(:,4:5) = ones(users,2);

                for L = 1:1:(k-1)
                    h = 0;   
                    V_i = 0;
                    clus_No = 0;
                    for j = 1:L
                        W = sqrt(((cluster{j}(:,2) - head{j}(2)).^2) + ((cluster{j}(:,3) - head{j}(3)).^2));
                        % Add distance to the head in the last column(4)
                        cluster{j}(:,4) = W;

                        [M,I] = max(cluster{j}(:,4));
                        [I_row,~] = ind2sub(size(cluster{j}(:,4)),I);
                        if h < M
                            h = M;
                            V_i = cluster{j}(I_row,1);
                            clus_No = j;
                        end                

                    end
                    if clus_No ~= 0
                        %Move V_i to cluster_CROWD{L+1}
                        cluster{L+1} = cluster{clus_No}(cluster{clus_No}(:,1) == V_i,:);
                        cluster{L+1}(:,5) = (L+1);


                    % V_i is head_CROWD{L+1} 
                    head{L+1} = cluster{clus_No}(cluster{clus_No}(:,1) == V_i,:);
                    head{L+1}(:,5) = (L+1);
                    cluster{clus_No}(cluster{clus_No}(:,1) == V_i,:) = [];
                    %Edit the distance to the head
                    cluster{L+1}(1,4) = sqrt( (cluster{L+1}(1,2) - head{L+1}(2)).^2 + (cluster{L+1}(1,3) - head{L+1}(3)).^2 );                
                    else 
                        head{L+1} = zeros(1,5);
                    end              

                    for j = 1:L                    
                        W = sqrt(((cluster{j}(:,2) - head{L+1}(2)).^2) + ((cluster{j}(:,3) - head{L+1}(3)).^2)); 
                        % greater = cluster_CROWD{j}( (cluster_CROWD{j}(:,4) > W) & (W < 100),:);
                        % compute greater elements by for loop
                        [g_row,~] = size(cluster{j}(:,1));
                        greater = zeros(g_row,5);
                        count = 1;
                            for g = 1:g_row
                                if ((cluster{j}(g,4) > W(g)) && (W(g) < 100))
                                   greater(count,:) = cluster{j}(g,:);
                                   greater(count,4) = W(g);
                                   count = count + 1;
                                end
                            end

                            greater(count:end,:) = [];
                            greater(:,5) = L+1;
                        % move greater to cluster L+1
                        cluster{L+1} =[cluster{L+1} ; greater];

                        % Remove elements from original cluster
                        cluster{j}( (cluster{j}(:,4) > W) & (W < 100),:) = [];

                    end

                end
                cluster{k+1} = cluster{1}(cluster{1}(:,4) > 100,:);
                cluster{1}(cluster{1}(:,4) > 100,:) = []; 
                cluster{k+1}(:,5) = 0;

                Data_OUT = cell(3,1);
                cluster_count = 1;
                for u = 1:k
                    [c_row,~] = size(cluster{u});
                    if c_row > 1
                       cluster{u}(:,5) = cluster_count;
                       Data_OUT{1} = [Data_OUT{1}; cluster{u}(1,:)];
                       Data_OUT{2} = [Data_OUT{2}; cluster{u}(2:end,:)];
                       cluster_count = cluster_count + 1;
                    else
                       cluster{u}(:,5) = 0; 
                       Data_OUT{3} = [Data_OUT{3}; cluster{u}(:,:)];
                    end
                end

                Data_OUT{3} = [Data_OUT{3}; cluster{k+1}];

                Scenario_OUT = [Data_OUT{1} ; Data_OUT{2};Data_OUT{3}];
                Scenario_OUT = sortrows(Scenario_OUT,1);
          

                [row,~] = size(Data_OUT{1});
                Number_GO = row;
                [row,~] = size(Data_OUT{2});
                Number_GM = row;
                [row,~] = size(Data_OUT{3});
                Number_Non_GO_GM = row;

                performance(k,1) =  k;
                performance(k,2) = Number_GO/users * 100;
                performance(k,3) = Number_GO;
                performance(k,4) = Number_GM;
                performance(k,5) = Number_Non_GO_GM;

            end
             [~,I] = max(performance(:,2));
             [I_row,~] = ind2sub(size(performance(:,2)),I);
             best_performance(users/10,:) = [users performance(I_row,3)+performance(I_row,5)];

    end

end