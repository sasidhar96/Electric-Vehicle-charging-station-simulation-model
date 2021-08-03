function [EV_alreadyWaiting,EV_stillCharging,EV_toCharge,EVCS_state,EV_Profile,EV_toCharge_count...
    ,EV_alreadyWaiting_count ] = Get_nextEVCS(EV_alreadyWaiting,EV_stillCharging,EV_toCharge,...
    EVCS_state,EV_Profile,EV_stillCharging_count,nEVCS)

EV_toCharge_count = length(EV_toCharge{1,h}); % how many EVs are to be charged 


EV_alreadyWaiting_count =  length(EV_alreadyWaiting{1,h}); % how many are waiting 

if EV_stillCharging_count==2
    % there are already 2  EVs charging at the new EVCS
    % so assign update the state with those and move because you cannot
    % have any assignment for this EVCS
      EVCS_state{nEVCS,h} = EVCS_state{nEVCS,h-1};
end
if EV_stillCharging_count == 1
    % there is one EV that is charging at the new EVCS so assign the car
    % from waiting to the new EVCS state and update the variables 
    EVCS_state{nEVCS,h}(1,1) = EV_stillCharging{1,h}(1,1);
    EV_toCharge{1,h}(ind) = [];
    EV_toCharge_count = length(EV_toCharge{1,h});
    
    if EV_alreadyWaiting_count ==0
        if EV_toCharge_count>0
            EVCS_state{nEVCS,h}(2,1) = EV_toCharge{1,h}(1,1);
            
            % update the count and to charge variable
            EV_toCharge{1,h}(1) =[];
            EV_toCharge_count = length(EV_toCharge{1,h});
            
        end
    end
    if EV_alreadyWaiting_count >=1
        
        EVCS_state{nEVCS,h}(2,1) = EV_alreadyWaiting{1,h-1}(1,1);
        EV_alreadyWaiting{1,h-1}(1) = []; % epmty the assigned value
        EV_alreadyWaiting_count = length(EV_alreadyWaiting_count{1,h-1});      
    end
end

if EV_stillCharging_count == 0
   
    % the charging slots are free and can be filled by either waiting cars
    % or to be charged 
    if EV_alreadyWaiting_count ==0
         if EV_toCharge_count>0
             for c = 1:EV_toCharge_count
                 EVCS_state{nEVCS,h}(c,1) = EV_toCharge{1,h}(1,1);
                 EV_toCharge{1,h}(1) = [ ];
                 if c ==2
                     % add the function here that asigns the remaining
                     % ev to charge to second evcs
                     EV_toCharge_count = length(EV_toCharge_count{1,h});
                     break
                 end
             end
         end
    end
    
    if EV_alreadyWaiting_count >=1
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
    
    end
    
end
end