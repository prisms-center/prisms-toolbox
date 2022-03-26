

function [solution,index, mconn, solved] = five_coloring(mconn, index, solution)
% no index and solution is needed to run the function.
% but recursively, we need to pass index and solution
if ~exist('index','var')
    index = 0;
end
if ~exist('solution','var')
    solution = zeros(1,size(mconn,1));
end

N = size(mconn,1);
if index==N
    solved = true;
    return;
end

index = index + 1;

ind_connected = mconn(index,:) > 0;
color_used = solution(ind_connected);

% try 5-colors
for color = 1:5
    if ~ismember(color, color_used)
        solution(index) = color;
        [solution,index, mconn, solved] = five_coloring(mconn, index, solution);
        
        if solved==true
            return;
        end
    end
end
% if no colors can be used, return False
solved = false;
