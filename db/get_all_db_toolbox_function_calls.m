function [] = get_all_db_toolbox_function_calls(dirname, storename)
% gets all functions that are called from the db.toolbox and puts them in the folder storename.
% CALL AS:	get_all_db_toolbox_function_calls(dirname, storename), where:
% 			
% 	dirname:		is the directory with the matlab scripts to be shared
% 	storename:	is the name of the folder. 
% 
% 	SIMPLEST WAY TO CALL IS:
%  execute function from within the matlab folder with the code to be shared, without any function inputs.
% ------------------------------------------------------------------------------------------------------
% db (12.07.2017)						
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SetDefaultValue(1, 'dirname'	, pwd);
SetDefaultValue(2, 'storename', './utility.Functions/');

% get list of all files in directory
allfileNames= what(dirname);
% find all the mfiles
mfileNames = allfileNames.m;

% make initial space
allfunctcalls = {};

% loop through all mfile names
for jj = 1:length(mfileNames)
% 	char( mfileNames{jj} )
% 	full_file_name_jj = [pwd '\' dirname '\' char( mfileNames{jj} )]
	full_file_name_jj = [dirname '\' char( mfileNames{jj} )];
	allfunctcalls = [allfunctcalls;	matlab.codetools.requiredFilesAndProducts(full_file_name_jj)']; %#ok
	fprintf('Creating function list %d of %d in total \n',[jj length(mfileNames)]);
end

% define which directory calls to remove (remaining are in) if needed otherwise leave as is
% namedir2remove	= 'D:\_research\_current';
% Idir2remove			= contains(allfunctcalls,namedir2remove);

% define which to keep
namedir2keep	= 'D:\matlab.tools\db.toolbox';
Idir2keep			= contains(allfunctcalls,namedir2keep);

% TO REMOVE
% function_calls_all	= allfunctcalls(~Idir2remove);

% LIST ALL TO KEEP
function_calls_all	= allfunctcalls(Idir2keep);
function_calls			= unique(function_calls_all);

folder_name = storename;

% make folder if it does not exist
if ~(exist(folder_name)==7); mkdir(folder_name); end

% now loop through all to keep and copy to folder
for ii = 1:length(function_calls)
	copyfile(char(function_calls(ii)),folder_name);
end

% UNCOMMENT TO ALSO ZIP UP AND STORE IF NEEDED
% zip('utility_zipped_up', folder_name)
	





