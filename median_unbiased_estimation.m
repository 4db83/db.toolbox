%% 3) Do Chow Break point test, by partitioning the data for every time period. 
function [Lambdas, stats, other_output] = median_unbiased_estimation(GY_tilde,LR_std_eta,CC)

SetDefaultValue(3,'CC',.15);
% set the absolute path to where the toolbox is
SW98_dir	= 'D:/matlab.tools/db.toolbox/SW98.inputs/';
% Note: they use a threshold of 15 percent for minium sample sizes in the two samples that are tested.
% CC	= .15;
T		= size(GY_tilde,1);
Tvec = (1:T)';
t0	= floor(T*CC);
t1	= T-t0;
%%% AS in HLW, but this is incorrect
% % t0 = 4;	
% % t1 = T-4;

% space for Fstat.
Fstat_0 = nan(T,1);
tstat_0 = nan(T,1);

% NOW LOOP TROUGHT T0 TO TT

% % for tt = t0:t1 % THIS IS THE RANGE USED IN HWL NOT THE percentile cut if like in SW98
% % for tt = 4:(T-4) % note it is 4:(T-4) as i in 4:(T-5) means that in R
for tt = t0:t1 % note it is 4:(T-4) as i in 4:(T-5) means that in R
 	ols_out		= fullols(GY_tilde,Tvec > tt);
	Fstat_0(tt) = ols_out.Fstat;				% same as tstat(end)^2
	tstat_0(tt) = ols_out.tstat(end);		% 
end

% Wald versions of the test
Fstat			= removenan(Fstat_0);
sup_Fstat = max(Fstat);
exp_Wald	= log(mean(exp(Fstat/2)));
mean_Fstat= mean(Fstat);

% Nyblom's test is simply: e_cumsum'e_cumsum/T divided by Var(e), where e = xfilt-mean(xfilt).
e			= demean(GY_tilde);
e_cs	= cumsum(e)/sqrt(T);
Lstat	= (e_cs'*e_cs/T)/var(GY_tilde); 

% Combine tests for printing later
stats.L  = Lstat; 
stats.MW = mean_Fstat; 
stats.EW = exp_Wald; 
stats.SW = sup_Fstat; % this is the QLR stat, here it is called the 

% ******************************************************************************************************
% TO GET THE MU ESTIMATOR LAMBDA VALUES, READ IN THE LOOKUP TABLE FROM THE GAUSS .OUT FILE
% READ IN THE DATA FROM 
% ******************************************************************************************************
lookup_table_name = [SW98_dir 'lookup_table_original_grid.out'];
% check if exists, otherwise load the .out file from GAUSS
if exist([SW98_dir 'SW1998_MUE_lookup_table.mat'],'file')
	load([SW98_dir 'SW1998_MUE_lookup_table.mat']);
else
	fid = fopen(lookup_table_name); 
	% this defines the read format '%[^\n\r]' this reads the last line and carrgie return
	frmt = [repmat('%q',1,6) '%[^\n\r]']; % include 'headerlines', 0, if you don't want to read the header
	scanned_data = textscan(fid, frmt, 'delimiter', ' ', 'MultipleDelimsAsOne', true, 'CollectOutput',1);
	fclose(fid);
	% now make a table object
	for ii = 1:size(scanned_data{1},2)
		lookup_tmp(:,ii) = str2double(scanned_data{1}(2:end,ii));
	end
	% make a lookup table 
	var_names = scanned_data{1}(1,:);
	var_names{1} = 'Lambda';
	var_names{5} = 'SW';
	
	lookup_table = array2table(lookup_tmp, 'VariableNames', var_names);
	save([SW98_dir 'SW1998_MUE_lookup_table.mat'], 'lookup_table');
end
% ------------------------------------------------------------------------------------------------------
% MAKE THE TEST CDF TABLE/STRUCTURE (201X199) FOR EACH TEST. THIS IS NEEDED FOR THE P-VALUES AND CIS.
% ------------------------------------------------------------------------------------------------------
if exist([SW98_dir 'SW1998_MUE_lookup_TSTCDF.mat'],'file')
	load([SW98_dir 'SW1998_MUE_lookup_TSTCDF.mat']);
else 
	TSTCDF.L  = xlsread([SW98_dir 'TSTCDF_Ltab.csv' ]);
	TSTCDF.MW = xlsread([SW98_dir 'TSTCDF_mwtab.csv']);
	TSTCDF.EW = xlsread([SW98_dir 'TSTCDF_ewtab.csv']);
	TSTCDF.SW = xlsread([SW98_dir 'TSTCDF_swtab.csv']);
	TSTCDF.pdvec = (0.005:0.005:0.995)';
	save([SW98_dir 'SW1998_MUE_lookup_TSTCDF.mat'], 'TSTCDF');
end
% ******************************************************************************************************

%% COMPUTE MUE LAMBDA HAT FROM
Lambdas.L	 	= lookup_table_mue(stats.L , lookup_table.Lambda, lookup_table.L );
Lambdas.MW  = lookup_table_mue(stats.MW, lookup_table.Lambda, lookup_table.MW);
Lambdas.EW  = lookup_table_mue(stats.EW, lookup_table.Lambda, lookup_table.EW);
Lambdas.SW  = lookup_table_mue(stats.SW, lookup_table.Lambda, lookup_table.SW);

% COMPUTE THE IMPLIED STDEV(DELTA_BETA) AS:
% inline function Sigma_{\Detla \beta} = Lambda/T*LRStdev(eps_t), called sv=stdc(ee)/(1-sumc(beta[1:nlag]));" in SW1998
get_sigma_D_beta = @(lambda) ( lambda./T *LR_std_eta );
sigma_D = structfun(get_sigma_D_beta, Lambdas ,'UniformOutput', false);

% COMPUTE THE P-VALUES
% inline function to find p-value
get_p_value = @(x) ( 1-TSTCDF.pdvec(x == min(x)) );
p_values.L	= get_p_value( abs((TSTCDF.L (1,:) - stats.L  )) );  
p_values.MW	= get_p_value( abs((TSTCDF.MW(1,:) - stats.MW )) );  
p_values.EW	= get_p_value( abs((TSTCDF.EW(1,:) - stats.EW )) );  
p_values.SW	= get_p_value( abs((TSTCDF.SW(1,:) - stats.SW )) );  

% COMPUTE THE LOWER CI BOUND ON LABMDA 90% CI
CI 	= .90;
TAR = (1-CI)/2;
% find columns corresponding to this target 
[~,Iup ] = min(abs( TSTCDF.pdvec - TAR ));
[~,Ilow] = min(abs( TSTCDF.pdvec - 1-TAR ));
%%
Lambda_up_CI.L	= lookup_table_mue(stats.L	, lookup_table.Lambda, TSTCDF.L	(:,Iup));
Lambda_up_CI.MW	= lookup_table_mue(stats.MW	, lookup_table.Lambda, TSTCDF.MW(:,Iup));
Lambda_up_CI.EW	= lookup_table_mue(stats.EW	, lookup_table.Lambda, TSTCDF.EW(:,Iup));
Lambda_up_CI.SW	= lookup_table_mue(stats.SW	, lookup_table.Lambda, TSTCDF.SW(:,Iup));

%%
Lambda_low_CI.L		= lookup_table_mue(stats.L	, lookup_table.Lambda, TSTCDF.L	(:,Ilow));
Lambda_low_CI.MW	= lookup_table_mue(stats.MW	, lookup_table.Lambda, TSTCDF.MW(:,Ilow));
Lambda_low_CI.EW	= lookup_table_mue(stats.EW	, lookup_table.Lambda, TSTCDF.EW(:,Ilow));
Lambda_low_CI.SW	= lookup_table_mue(stats.SW	, lookup_table.Lambda, TSTCDF.SW(:,Ilow));

% make the upper bound for Sigma_Delta_beta
up_sigma_D	= structfun(get_sigma_D_beta, Lambda_up_CI ,'UniformOutput', false);
low_sigma_D	= structfun(get_sigma_D_beta, Lambda_low_CI,'UniformOutput', false);

%% RENAME THE STRUCT ENTRY CELLS FROM SW TO QLR TO MAKE CONSISTENT WITH LATER STUFF
% p_values = cell2struct(struct2cell(p_values), {'L', 'MW', 'EW', 'QLR'})
p_values			= cell2struct(struct2cell(p_values			), {'L', 'MW', 'EW', 'QLR'});
Lambda_low_CI = cell2struct(struct2cell(Lambda_low_CI) , {'L', 'MW', 'EW', 'QLR'});
Lambda_up_CI	= cell2struct(struct2cell(Lambda_up_CI	), {'L', 'MW', 'EW', 'QLR'});
sigma_D			  = cell2struct(struct2cell(sigma_D			)  , {'L', 'MW', 'EW', 'QLR'});
up_sigma_D		= cell2struct(struct2cell(up_sigma_D		), {'L', 'MW', 'EW', 'QLR'});
low_sigma_D	  = cell2struct(struct2cell(low_sigma_D	)  , {'L', 'MW', 'EW', 'QLR'});

% now the lambdas last
Lambdas				= cell2struct(struct2cell(Lambdas			), {'L', 'MW', 'EW', 'QLR'});
stats					= cell2struct(struct2cell(stats				), {'L', 'MW', 'EW', 'QLR'});

% collect all output in other_output
other_output.p_values				= p_values;
other_output.Lambda_low_CI  = Lambda_low_CI;
other_output.Lambda_up_CI		= Lambda_up_CI;
other_output.sigma_D				= sigma_D;
other_output.up_sigma_D			= up_sigma_D;
other_output.low_sigma_D		= low_sigma_D;
























































%EOF




















