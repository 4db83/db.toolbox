function [Xsumstats,Xnames] = sumstats(X,XvarName,prnt2xls,prntformat,onsreen_display,SPCE_XLS)
% Call as sumstats(X,XvarName,prnt2xls,prntformat,onsreen_display,SPCE_XLS)
% Function to compute summarary statistics and print them to excel if needed
% prnt2xls can be 1,0 or string with xls name for output file (default = 0)
% Xselnames is a cell string with variable name (default = []).
% db 
% --------------------------------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % clear all
% % X = randn(5,5);
% % Xselnames 			= [];                                                       
% % prnt2xls  			= 1;                                                        
% % prntformat 			= '%10.4f';                                                 
% % onsreen_display = 1;					
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Nr,Nc] = size(X);

XvarName_default = cellstr(num2str((1:Nc)'));

SetDefaultValue(2,'XvarName'				,XvarName_default);
SetDefaultValue(3,'prnt2xls'				,0 );
SetDefaultValue(4,'prntformat'			,'%10.4f');
SetDefaultValue(5,'onsreen_display'	,1);					% Default 1=on, set to zero if not needed.
SetDefaultValue(6,'SPCE_XLS'				,1);					% Default 1=on, set to zero if not needed.

% summary stats
% Xsel	= [dyout(:,1) Xsel];											% adding the copper returns to it.

for ii = 1:Nc
	ACF0(:,ii)		= autocorr(removenan(X(:,ii)),3);
	PACF0(:,ii)		= parcorr(removenan(X(:,ii)),3);
end;

ACF		= ACF0(2:end,:);
PACF	= PACF0(2:end,:);
% note skewness adn kurtosis is based on nanmeans so need to call nan function
Xsumstats	= [nanmean(X)' nanmedian(X)' nanstd(X)' skewness(X)' kurtosis(X)' nanmin(X)' nanmax(X)' ACF' PACF'];
% Print results in table
sep(160)
% clear mpp

Xnames		 = {'{Mean}','{Median}','{Std.Dev}',...
							'{Skew}','{Kurt}','{Min}','{Max}',...
							'{ACF(1)}','{ACF(2)}','{ACF(3)}',... 
							'{PACF(1)}','{PACF(2)}','{PACF(3)}'};

% Empty column if needed for formatting
C0 	= '  ';

Xnames_xls = {'{Mean}','{Median}','{Std.Dev}',...
							'{Skew}','{Kurt}','{Min}','{Max}',...
							C0, ...
							'{ACF(1)}','{ACF(2)}','{ACF(3)}',... 
							C0, ...
							'{PACF(1)}','{PACF(2)}','{PACF(3)}'};
% NAN Vector
N0 = nan(size(Xsumstats,1),1);
% ADJUST Xsumstats for NAN entries
Xsumstats_xls = [Xsumstats(:,1:3) Xsumstats(:,4:7) N0 Xsumstats(:,8:10) N0 Xsumstats(:,11:end)];
%%
mpp.cnames = char(Xnames); 

[Nr,Nc] = size(XvarName);

if Nc > Nr
	XvarName = XvarName';
end

								
if isempty(XvarName)
%mpp.rnames	= char(['Variable' Xselnames]);
	tmp_				= cellstr(repmat(' ',Nc,1));
	mpp.rnames	= ['{Variable}' tmp_'];
else
	mpp.rnames	= ['{Variable}' ; XvarName];
end;

% set up printing structure
% mp.fid		= FIDout;
% mpp.fmt		= '%10.4f';
mpp.width				= 160;
mpp.fmt					= prntformat;
mpp_xls					= mpp;
mpp_xls.cnames	= char(Xnames_xls); 

% print to screen
if onsreen_display == 1;
	myprint(Xsumstats,mpp);
	sep(160)
end;		

if isnumeric(prnt2xls)
	if prnt2xls == 1;
		if SPCE_XLS == 1
			myprint2xls('summary_stats.xls',Xsumstats_xls,mpp_xls);
		else
			myprint2xls('summary_stats.xls',Xsumstats,mpp);
		end;
	end
else
	if SPCE_XLS == 1
		myprint2xls(prnt2xls,Xsumstats_xls,mpp_xls);
	else
		myprint2xls(prnt2xls,Xsumstats,mpp);
	end
end
































