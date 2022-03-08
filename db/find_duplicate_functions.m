clear;clc;
% list all the files with duplicate function names in the path foler_name.
% to list all dir locations of a particular file, call the which function as:
% which filename -all
% the file that is not used on the path will have a %% shadowed after it.
%
% NOTE: matlabs function precedence order is as follows:
%				1) files in curren folder
%				2) files in subfilders of the curren folder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TO FIND ALL THE LOCAL FUNCTIONS BEING CALLED EXECUTE THIS SCRIPT.
% fList = matlab.codetools.requiredFilesAndProducts('get_swedish_bank_data_bloomberg_updated.m')'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% folder to be analyzed
folder_name = 'D:\matlab.tools\db.toolbox';			

% get all file names/path in the current folder and all subfolders.
[ success files id ] = fileattrib([folder_name filesep '*']); 

[fullNames{1:numel(files)}] = deal(files.Name);

isMFile		= cellfun(@(s) all(s(end-1:end)=='.m'), fullNames);
% keep only m-files
fullNames = fullNames(isMFile);   
F			= numel(fullNames);
start = cellfun(@(s) find(s==filesep,1,'last'), fullNames);
% get file names
names = arrayfun(@(k) fullNames{k}(start(k)+1:end), 1:F, 'uni', 0); 
% generate all pairs
[ii jj] = ndgrid(1:F); 

% test each pair of files
equal = arrayfun(@(n) strcmp(names{ii(n)},names{jj(n)}), 1:F^2); 

% take out the diagnoal ones,  equality with oneself doesn't count
equal = reshape(equal,F,F) - eye(F); 
% it is a duplicate if it has some equal file, --> isDupliate == 1
isDuplicate = any(equal); 

% now list the functions and their paths that are duplicate. 
disp(fullNames(isDuplicate)');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% duplicates	= fullNames(isDuplicate); %// cell array with full names of duplicates
% % P='D:\matlab.tools\db.toolbox';
% % P=strsplit(P, pathsep());
% % % mydir='/home/myusername/matlabdir';
% % mydir = 'D:\matlab.tools\db.toolbox'
% % 
% % P=P(strncmpi(mydir,P,length(mydir)));
% % P=cellfun(@(x) what(x),P,'UniformOutput',false);
% % P=vertcat(P{:});
% % Q=arrayfun(@(x) x.m,P,'UniformOutput',false); % Q is a cell of cells of strings
% % Q=vertcat(Q{:});
% % R=arrayfun(@(x) repmat({x.path},size(x.m)),P,'UniformOutput',false); % R is a cell of cell of strings
% % R=vertcat(R{:});
% % [C,ia,ic]=unique(Q);
% % for c=1:numel(C)
% %     ind=strcmpi(C{c},Q);
% %    if sum(ind)>1
% %        fprintf('duplicate %s at paths\n\t',C{c});
% %        fprintf('%s\n\t',R{ind});
% %        fprintf('\n');
% %    end
% % end

