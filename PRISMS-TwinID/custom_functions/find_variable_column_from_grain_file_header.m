% columnIndex = find_variable_column_from_CSV_grain_file(EBSDfilePath2, EBSDfileName2, varList)
% EBSDfile is csv file.  Currently at most 30 variables in EBSDfile
% varList = 1 x n cell.  Each cell is the name of one 'variable'. E.g.,
% {'grain-DI','phi1-r'}
% Zhe Chen 20150804 revised.
%
% chenzhe, 2017-08-31. Based on find_variable_column_from_CSV_grain_file().
% Directly use the header which is output by grain_file_read(), to find the
% variable name's position.

function columnIndex = find_variable_column_from_grain_file_header(header, varList)

nVariable = size(varList,2);

columnIndex = zeros(nVariable,1);

for iVariable=1:nVariable
    columnIndex(iVariable) = find(strcmpi(header,varList{iVariable}));
end
% display('found variable column index from header cell array');
% display(datestr(now));
end