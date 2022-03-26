% create unique color map

function map = auto_grain(ID)

% If ID has nan:
% change nan to NN for analysis
% Change the color to nan for output.
NN = max(ID(:)) + 1;
ID(isnan(ID)) = NN;

% build connectivity matrix
[nR,nC] = size(ID);
gID = unique(ID(:));
nGrains = numel(gID);
mconn = zeros(nGrains,nGrains);

for ii = 1:nGrains
    ID_current = gID(ii);
    ind = find(ID==ID_current);
    % find adjacent indices
    inds = [ind-1; ind+1; ind-nR; ind+nR];
    inds(inds<1) = [];
    inds(inds>nR*nC) = [];
    % find neighbor grains' IDs
    ID_nb = unique(ID(inds));
    ID_nb(ID_nb==ID_current) = [];
    indc = ismember(gID, ID_nb);
    mconn(ii, indc) = 1;
end

% solve the 5-coloring problem
[solution,index, mconn, solved] = five_coloring(mconn);

% assign color (1:5) to map
map = zeros(size(ID));
for ii = 1:nGrains
    ID_current = gID(ii);
    map(ismember(ID,ID_current)) = solution(ii);
end

map(ID==NN) = nan;

end