function [] = bytes(variable_name)

tmp_ = whos('variable_name');

% size in MB and GB
size_mb = tmp_.bytes/(2^20);
size_gb = tmp_.bytes/(2^30);

fprintf('	Variable size is: %4.0fMB or %4.2fGB \n', [size_mb size_gb]);

