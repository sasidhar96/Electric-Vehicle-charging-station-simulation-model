load('EV_data.mat');

 EV_P = EV_behaviour.EV_LP;
Horizon = 8760;
EV_P = int16(EV_P(:,1:Horizon)./8.0667);
 nEVs = 10;
 rise_rate = 0.3;
EV_number = zeros(1,10);
iter = 10;
waiting_time = zeros(iter,Horizon);
EVCS_state_iter = cell(iter,Horizon);

for i = 1:iter
    disp('Running simulation for EVs')
    nEVs = ceil(nEVs+(rise_rate*nEVs));
    if nEVs >100
        break
    end
   EV_number(1,i)= nEVs;
    disp(nEVs)
EV_Profile = EV_P(1:nEVs,:);

nEVCS = 1;
%% variables that describe the state 

EVCS_state = cell(nEVCS,Horizon); % this is important to know which cars are charging 
EV_toCharge = cell(1,Horizon);
EV_stillCharging = cell(1,Horizon);
EV_alreadyWaiting =cell(1,Horizon); % this is important to kno which cars are waiting


waiting = 0;
EV_state = zeros(nEVs,Horizon); 

% if EV state = 1 then it is waiting 
% if EVstate = 0 then it is charging
% if EVstate = -1 then it is driving

%% for the first time step

EV_toCharge{1,1} = find(EV_Profile(:,1)==1);
EV_toCharge_count = length(EV_toCharge{1,1});

if EV_toCharge_count ==0
    EVCS_state{nEVCS,1} = [];
elseif EV_toCharge ==1
    EVCS_state{nEVCS,1}(1,1) = EV_toCharge{1,1}(1,1);
    EV_toCharge{1,1}(1) = [];
elseif EV_toCharge ==2
    EVCS_state{nEVCS,1}(1,1) = EV_toCharge{1,1}(1,1);
    EV_toCharge{1,1}(1) = [];
    EVCS_state{nEVCS,1}(2,1) = EV_toCharge{1,1}(2,1);
    EV_toCharge{1,1}(2)=[];
else
    EVCS_state{nEVCS,1}(1,1) = EV_toCharge{1,1}(1,1);
    EV_toCharge{1,1}(1) = [];
    EVCS_state{nEVCS,1}(2,1) = EV_toCharge{1,1}(2,1);
    EV_toCharge{1,1}(2)=[];
end
    EV_alreadyWaiting{1,1} = EV_toCharge{1,1};
%% for remaining time step

for h = 2: Horizon
    
    % how many Evs are to be charged 
    EV_toCharge{1,h} = find(EV_Profile(:,h)==1);
    
    % length of it 
    EV_toCharge_count = length(EV_toCharge{1,h});
    
    [two_hourCharge,index]  = intersect(EV_toCharge{1,h},EV_alreadyWaiting{1,h-1});
    % If there is a waiting EV that needs to be charged for 2 hours then
    % change the next time step to 1 for that EV 
    for a = 1 : length(index)

        temp_ind =EV_toCharge{1,h}(index(a,1)); 
        EV_Profile(temp_ind,h+1) = 1;
        EV_Profile(temp_ind,h) = 0;
    end
    EV_toCharge{1,h} = find(EV_Profile(:,h)==1);
    EV_toCharge_count = length(EV_toCharge{1,h});
    % how many EVs are still charging from the previous time step by
    % comparing EVCS state and EVs to be charged the index of the EV that
    % is charging will be hold in ind variable w.r.t EV to charge variable
     [C,ind]= intersect(EV_toCharge{1,h}, EVCS_state{1,h-1});
     EV_stillCharging{1,h} = C;
    % length of it
    EV_stillCharging_count = length(EV_stillCharging{1,h});
    
    % Number of EVs alreadfy waiting from the previous time step
    EV_alreadyWaiting_count =  length(EV_alreadyWaiting{1,h-1});
    
    
    %% case where the EVCS slot is full 
    if EV_stillCharging_count==2
        
%          [EV_alreadyWaiting,EV_stillCharging,EV_toCharge,EVCS_state,EV_Profile] = ...
%     Get_nextEVCS(EV_alreadyWaiting,EV_stillCharging,EV_toCharge,EVCS_state,EV_Profile,Horizon);
        
        % The EVs that are charging in the previous time step will continue
        % to charge
        EVCS_state{nEVCS,h} = EVCS_state{1,h-1};
        EV_toCharge{1,h}(ind(1,1)) = [];
        EV_toCharge{1,h}(ind(2,1)-1) = [];
        EV_toCharge_count = length(EV_toCharge{1,h});
        if EV_alreadyWaiting_count ==0
            % no EVs are waiting from the previous timestep
            % however there are EVs to be charged but no charging slot
            % hence assign the EVs to be charged in that time step to EVs
            % alread waiting variable
            % also update the EV profile for the next time step for these
            % waiting cars with 1
            if EV_toCharge_count>0
                
                % put one here assign to 2 evcs if there are naz left to
                % charge evs assign it to waiting variable
            for c = 1: EV_toCharge_count
                EV_alreadyWaiting{1,h}(c,1) = EV_toCharge{1,h}(c,1);
%                 EV_Profile(EV_toCharge{1,h}(c,1),h+1) = 1;
                % do we need to update the value at that time step by 0
            end
            end
        else
            % already there are waiting cars from the previous timstep
            % add the EVs to be charged for that time step to the already
            % waiting cars variable, already waiting cars will take
            % priority
            
            % put the funciton here and assign the waiting cars to the
            % second evcs and the remaining from to charge and if there are
            EV_alreadyWaiting{1,h} = EV_alreadyWaiting{1,h-1};
            EV_alreadyWaiting_count = length(EV_alreadyWaiting{1,h});
            % any assign it to waiting cars 
            if EV_toCharge_count>0
            for c = 1: EV_toCharge_count
                EV_alreadyWaiting{1,h}(c+EV_alreadyWaiting_count,1) = EV_toCharge{1,h}(c,1);
%                 EV_Profile(EV_toCharge{1,h}(c,1),h+1) = 1;
            end
            end
        end
              
    end
    
    %% case where one EVCS slot is free
    if EV_stillCharging_count == 1
        %It means that one EV still needs to be charged from the previous
        %timestep
        % Since there is one charge slot left to be assigned we assign that
        % to the waiting cars variable first or if there are not any
        % waiting EVs we assign that from EVs to be charged variable
        
        EVCS_state{nEVCS,h}(1,1) = EV_stillCharging{1,h}(1,1);
        
        % remove the assigned EV from the to be charged variable and update
        % count 
        EV_toCharge{1,h}(ind) = [];
        EV_toCharge_count = length(EV_toCharge{1,h});
        
        % now follow the same process where we first check waiting and to
        % be charged profile and assign accordingly
        
        if EV_alreadyWaiting_count ==0
            % no EVs are waiting from the previous timestep
            % however there are EVs to be charged and one charging slot
            % available 
            % hence assign the EVs to be charged in that time step to
            % EVCS_state
            % also update the EV profile for the next time step for these
            % waiting cars with 1
            if EV_toCharge_count>0
            EVCS_state{nEVCS,h}(2,1) = EV_toCharge{1,h}(1,1);
            
            % update the count and to charge variable
            EV_toCharge{1,h}(1) =[];
            EV_toCharge_count = length(EV_toCharge{1,h});
            
            % after assigning the one slot with to be charged EV assign
            % remaining EV to waiting profile
            if EV_toCharge_count >0
                % put the functzion here and assign the if any to charge
                % evs to second evcs and the reamaining to charge are
                % sassigned to waiting variable
            for c = 1: EV_toCharge_count
                EV_alreadyWaiting{1,h}(c,1) = EV_toCharge{1,h}(c,1);
%                 EV_Profile(EV_toCharge{1,h}(c,1),h+1) =1;
            end
            end
            end
        end
         
        
        if EV_alreadyWaiting_count >=1
            % There is 1 or more than 1 waiting cars but  there is only one
            % charging slot hence the first waiting car is assigned to the
            % charging state and the remaining to be charged EVs are added
            % at the end of waitring cars
            EVCS_state{nEVCS,h}(2,1) = EV_alreadyWaiting{1,h-1}(1,1);
            
            EV_alreadyWaiting{1,h-1}(1) = []; % epmty the assigned value
            
            % remaining waiting EVs are again wait for next time step 
            % seethis

            
            if EV_alreadyWaiting_count>0
                % put the function here to assign remaining waiting cars to
                % second evcs and the reamining ev to charge to second evcs
                % if there are any left agin assign it to waiting variable
            end
            if EV_alreadyWaiting_count>0
                % if there are any left waiting cars after assigning it to
                % second evcs then assign these to that time step waiting
                % variable
                EV_alreadyWaiting{1,h} = EV_alreadyWaiting{1,h-1};
                EV_alreadyWaiting_count = length(EV_alreadyWaiting{1,h});
            end
            % add the EVs to be charged at that time step at the end of
            % reamaining waiting cars
            if EV_toCharge_count>0
            for c = 1: EV_toCharge_count
                EV_alreadyWaiting{1,h}(c+EV_alreadyWaiting_count,1) = EV_toCharge{1,h}(c,1);
%                 EV_Profile(EV_toCharge{1,h}(c,1),h+1) =1;
            end  
            end
        end     
    end
    
    
    %% case where EVCS is free for two EVs
    if EV_stillCharging_count==0
        % since both the slots are open for charging first check the
        % waiting variable  and then to be charged profile to change the
        % charging state of EVCS 
        
        if EV_alreadyWaiting_count ==0
            % no EVs are waiting from the previous timestep
            % however there are EVs to be charged and two charging slots
            % are available
            % hence assign the EVs to be charged in that time step to
            % EVCS_state
            % also update the EV profile for the next time step for these
            % waiting cars with 1
            if EV_toCharge_count>0
            for c = 1:EV_toCharge_count
                     EVCS_state{nEVCS,h}(c,1) = EV_toCharge{1,h}(1,1);
                     EV_toCharge{1,h}(1) = [ ];
                     if c ==2 
                         % add the function here that asigns the remaining
                         % ev to charge to second evcs 
                         break
                     end
            end
            end
            EV_toCharge_count = length(EV_toCharge{1,h});
%             EV_toCharge_count = length(EV_toCharge{1,h});
            if EV_toCharge_count>0
                % If there are still EVs to be charged then assign them to
                % waiting cars variable
                EV_alreadyWaiting{1,h} = EV_toCharge{1,h};
            end
        end
        
        if EV_alreadyWaiting_count >=1
            
            % There are some EVs waiting and the charging slots are 2 first
            % assign charging to waiting cars and then to to be charged
            % variable 
            
            % add the waiting cars to the state 
            
%             
            for c = 1:EV_alreadyWaiting_count
                
                EVCS_state{nEVCS,h}(c,1) = EV_alreadyWaiting{1,h-1}(1,1);
                 EV_alreadyWaiting{1,h-1}(1) = [];

                 if c == 2
                     % add the function here that assigns the remaining
                     % waiting cars to second evcs and other ev to charge
                     % to second evcs 
                     break 
                 end
            end
            EV_alreadyWaiting_count = length(EV_alreadyWaiting{1,h-1});
            
            % after assigning the waiting cars and updating the variable if
            % there are any waiting cars then they are carried to the next
            % time step
            if EV_alreadyWaiting_count>0
                EV_alreadyWaiting{1,h} = EV_alreadyWaiting{1,h-1};
            elseif EV_toCharge_count>0 && length(EVCS_state{1,h}) == 1
                % one slot is empty to charge the EV to be charged variable
                EVCS_state{nEVCS,h}(2,1) = EV_toCharge{1,h}(1,1);
                EV_toCharge{1,h}(1) = [];
                EV_toCharge_count = length(EV_toCharge{1,h});
            end
            
            % If there any EV to be charged left for that time step then
            % they are added to the end of already waiting variable
            if EV_toCharge_count>0
            for c = 1:EV_toCharge_count
                EV_alreadyWaiting{1,h}(EV_alreadyWaiting_count+c,1) = EV_toCharge{1,h}(c,1);
            end           
            end
        end    
    end
    EV_alreadyWaiting_count = length(EV_alreadyWaiting{1,h});
    
    if EV_alreadyWaiting_count == 0 
        waiting = 0;
    else
        waiting =  EV_alreadyWaiting_count;
    end
    waiting_time(i,h) = waiting;    
    
    EVCS_state_iter(i,:) = EVCS_state(:,:);
    
    % getting the EV profile for that state 
    charging_car_indices = EVCS_state{1,h};
    charging_car_indices_count = length(charging_car_indices); 
    for j = 1:charging_car_indices_count
        
        EV_state(charging_car_indices(j,1),h) =-1;
    end
    
    waiting_car_indices = EV_alreadyWaiting{1,h};
    waiting_car_indices_count = length(waiting_car_indices);
    
    for j = 1:waiting_car_indices_count
        EV_state(waiting_car_indices(j,1),h) = 1;
    end

end
EVCS_state_iter(i,:) = EVCS_state;
end

max_waiting_time_forEVRise = max(waiting_time,[],2);
%% dummy 

% EVCS_decision = intvar(1,1);
% EVCS_cost = 10000;
% Objective = EVCS_cost+EVCS_decision*EVCS_cost;
% 
% CS = [];
% 
% for h = 1: Horizon
%     
%     CS = [CS,waiting_time(1,h)-5<=2*EVCS_decision];
% end
% 
% sol = optimize(CS,Objective);
% total_EVCS = 1+value(EVCS_decision);