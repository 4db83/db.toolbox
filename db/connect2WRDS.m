% THESE ARE THE FILES FROM WRDS TO CONNECT TO THEM.
% clear java;
path2_SASconnect2WRDS = 'D:\matlab.tools\db.toolbox\SASconnect2WRDS\';

% DEFINE PATH TO SAS JAVA FILES
% if these are not on the path alread, extract them to the folder listed above with the files in 
% SAS-JDBC-Drivers.

javaaddpath([path2_SASconnect2WRDS 'sas.core.jar']);
javaaddpath([path2_SASconnect2WRDS 'sas.intrnet.javatools.jar']);

% SAS encrypted file for matlab from the UNIX log into WRDS and SAS execution of commands
% described in 'Preparing your Matlab Envrionment'
% {SAS002}6BB3412229610A8104DDFAC859C14EA234EC5DA4
% 
% Type the following: win+putty (does not work on Bash or powershell!)
% IN PUTTY, dbuncic@wrds-cloud.wharton.upenn.edu in SSH then connect with the PW
% then Zico_10!
%		qrsh
%		sas -nodms
%		proc pwencode in='Zico_10!'; run;
%
%		to return something like: 
%		{SAS002}4FA9941A09BF26D650A759C10565F770
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

user_name = 'dbuncic';
pass_word = '{SAS002}4FA9941A09BF26D650A759C10565F770';

% now establish the connection
WRDS = database('',user_name, pass_word,'com.sas.net.sharenet.ShareNetDriver', ...
									'jdbc:sharenet://wrds-cloud.wharton.upenn.edu:8551/');

% test of the connection is working or not by printing a list of databases
% listout = schemas(WRDS)';
