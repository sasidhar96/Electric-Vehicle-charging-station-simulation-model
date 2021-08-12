load('EV_data.mat');
nEVs = 100;
nEVCS_max = 6;
Horizon = 8760;
[EVCS_state,waiting_time]=getSimulationvalues(nEVs,nEVCS_max,EV_behaviour.EV_LP,Horizon);

