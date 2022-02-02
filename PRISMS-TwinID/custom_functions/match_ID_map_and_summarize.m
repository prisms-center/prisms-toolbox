% ID_temp is modified from ID_target by dividing selected grains into more
% grains. After this, for the affected grains, we update all the grain
% info, including gID, gCenterX, gCenterY, gArea, gEdge, gNeighbors,
% gNNeighbors, gPhi1, gPhi, gPhi2
% 
% data_in contains fields:
% data_in.umPerDp
% data_in.symmetry: 'hcp' for now
% data_in.ID_temp
% data_in.ID_target
% data_in.x
% data_in.y
% data_in.phi1
% data_in.phi
% data_in.phi2
% data_in.gID
% data_in.gPhi1
% data_in.gPhi
% data_in.gPhi2
%
% data_out contains fields:
% data_out.ID
% data_out.x
% data_out.y 
% data_out.gID
% data_out.gPhi1
% data_out.gPhi
% data_out.gPhi2 
% data_out.gCenterX
% data_out.gCenterY 
% data_out.gNNeighbors 
% data_out.gDiameter
% data_out.gArea 
% data_out.gEdge 
% data_out.gNeighbors 
%
% 2021-01-19
%
% add note 2021-03-02 
% If merge gA,gB -> gAA, then we have ID_temp include gAA, gTarget include
% [gA, gB], and link gAA->gA. In this code, the gEuler_gAA is directly
% copied from that of gEuler_gA.

function data_out = match_ID_map_and_summarize(data_in)

%% parse input data
symmetry = data_in.symmetry;
ID = data_in.ID_target;
ID_temp = data_in.ID_temp;
x = data_in.x;
y = data_in.y;
phi1 = data_in.phi1;
phi = data_in.phi;
phi2 = data_in.phi2;

gID = data_in.gID;
gPhi1 = data_in.gPhi1;
gPhi = data_in.gPhi;
gPhi2 = data_in.gPhi2;

try
    umPerDp = data_in.umPerDp;
catch
    umPerDp = y(2) - y(1);    % micron per data point in EBSD data
    warning(['warning: um per data point obtained from x y matrix = ',num2str(umPerDp),' um/dp']);
end

%% Process data: align ID, and make new ID, ID_temp is calculated form the new boundary map
% directly find gID, gCenterX, gCenterY, gArea, gDiameter, gEdge
[ID_more_gb, id_link_additional, id_link]  = hungarian_assign_ID_map(ID_temp, ID);

ids_1 = unique(ID_more_gb); % all ids
ids_2 = [unique(ID_more_gb(1,:)), unique(ID_more_gb(end,:))];
ids_3 = [unique(ID_more_gb(:,1)); unique(ID_more_gb(:,end))];
ids_4 = unique([ids_2(:);ids_3(:)]);    % ids on the border
ids_interior = ids_1(~ismember(ids_1,ids_4));    % adjusted ids that are not on the edge

[gID_more_gb, ~, IC] = unique(ID_more_gb);  % IC: each of gID_more_gb's index in ID_more_gb
accumNumPts = accumarray(IC,1);
accumX = accumarray(IC,x(:));
accumY = accumarray(IC,y(:));

gCenterX_more_gb = accumX./accumNumPts; % reculculate grain center directly from map
gCenterY_more_gb = accumY./accumNumPts;

gArea_more_gb = accumNumPts * umPerDp * umPerDp;
gDiameter_more_gb = (4 * gArea_more_gb / pi).^(0.5);    % correct, 2022-01-08

gEdge_more_gb = ones(size(gID_more_gb));
ind = ismember(gID_more_gb, ids_interior);      % index indicating interior grains
gEdge_more_gb(ind) = 0;

% copy gPhi1, gPhi, gPHi2. % --> If we want to calculate, think about how to treat grains with twins.
% First copy grains in id_link
for ii = 1:size(id_link,1)
    id_more_gb = id_link(ii,1);
    ind_more_gb = find(gID_more_gb == id_more_gb); % make ind the same as ID, this is the default convention
    
    id_on_template = id_link(ii,2);
    ind_template = find(gID == id_on_template);
    
    gPhi1_more_gb(ind_more_gb) = gPhi1(ind_template);
    gPhi_more_gb(ind_more_gb) = gPhi(ind_template);
    gPhi2_more_gb(ind_more_gb) = gPhi2(ind_template);
end
% Next, process grains in id_link_additional. [*** First, simply copy]
for ii = 1:size(id_link_additional,1)
    id_more_gb = id_link_additional(ii,1);
    ind_more_gb = find(gID_more_gb == id_more_gb); % make ind the same as ID, this is the default convention
    
    id_on_template = id_link_additional(ii,2);
    ind_template = find(gID == id_on_template);
    
    gPhi1_more_gb(ind_more_gb) = gPhi1(ind_template);
    gPhi_more_gb(ind_more_gb) = gPhi(ind_template);
    gPhi2_more_gb(ind_more_gb) = gPhi2(ind_template);
end
% Next, if target ID is in id_link_additional, reprocess the pair where
% the 2nd ID is this target ID
for ii = 1:size(id_link_additional,1)
    id_on_template = id_link_additional(ii,2);
    ind_template = find(gID == id_on_template);
    
    ind = find(id_link(:,2) == id_on_template);
    id_more_gb = id_link(ind,1);
    ind_more_gb = find(gID_more_gb == id_more_gb); % make ind the same as ID, this is the default convention
    
    try
        gPhi1_more_gb(ind_more_gb) = gPhi1(ind_template);
        gPhi_more_gb(ind_more_gb) = gPhi(ind_template);
        gPhi2_more_gb(ind_more_gb) = gPhi2(ind_template);
    catch
        disp('No need to recalculate for this pair');
    end
end
gPhi1_more_gb = reshape(gPhi1_more_gb,[],1);
gPhi_more_gb = reshape(gPhi_more_gb,[],1);
gPhi2_more_gb = reshape(gPhi2_more_gb,[],1);

[boundaryTF_more_gb, boundaryID_more_gb, neighborID_more_gb, ~, ~,] = find_one_boundary_from_ID_matrix(ID_more_gb);
pairs = unique([ID_more_gb(boundaryTF_more_gb==1), neighborID_more_gb(boundaryTF_more_gb==1)], 'rows');
min_valid_gID = 1;
ind = pairs(:,1)<min_valid_gID | pairs(:,2)<min_valid_gID;
pairs(ind,:) = [];
pairs = unique([pairs; fliplr(pairs)], 'rows');
clear gNNeighbors_more_gb gNeighbors_more_gb;
for ii = 1:length(gID_more_gb)
    % find number of neighbors
    inds = gID_more_gb(ii) == pairs(:,1);
    if ~isempty(inds)
        gNNeighbors_more_gb(ii) = sum(inds);
    else
        gNNeighbors_more_gb(ii) = 0;
    end
end
% find neighbors
gNeighbors_more_gb = zeros(size(gID_more_gb,1), max(gNNeighbors_more_gb));
for ii = 1:length(gID_more_gb)
    inds = gID_more_gb(ii) == pairs(:,1);
    if sum(inds)>0
        gNeighbors_more_gb(ii,1:sum(inds)) = reshape(pairs(inds,2),1,[]);
    end
end

%% Calculate gEuler for specific grains.
% [*** Second] If a grain in ID overlap more than one grain in ID_more_gb,
% these grains in ID_more_gb needs their gEuler recalculated.

% Find out which ids in ID_more_gb needs recalculate euler
ID_list = [];
uniqueID = unique(ID(:));
for ii = 1:length(uniqueID)
    ID_current = uniqueID(ii);
    inds = (ID==ID_current);
    ids = unique(ID_more_gb(inds));
    if length(ids)>1
        ID_list = [ID_list; ids(:)];
    end
end

% calculate the average of the dominant orientation of selected grains 
if ~strcmpi(symmetry, 'hcp')
    error('currently has to be hcp symmetry');
else  
    for ii = 1:length(ID_list)
        ID_current = ID_list(ii)
        
        inds = (ID_more_gb==ID_current);
        phi1_ = phi1(inds);
        phi_ = phi(inds);
        phi2_ = phi2(inds);
        
        euler_avg = calculate_average_dominant_euler_hcp([phi1_, phi_, phi2_]);
        
        ind = find(gID_more_gb==ID_current);
        gPhi1_more_gb(ind) = euler_avg(1);
        gPhi_more_gb(ind) = euler_avg(2);
        gPhi2_more_gb(ind) = euler_avg(3);
    end
end

%% construct out data
data_out.ID = ID_more_gb;
data_out.x = x;
data_out.y = y;

data_out.gID = gID_more_gb;
data_out.gPhi1 = gPhi1_more_gb;
data_out.gPhi = gPhi_more_gb;
data_out.gPhi2 = gPhi2_more_gb;
data_out.gCenterX = gCenterX_more_gb;
data_out.gCenterY = gCenterY_more_gb;
data_out.gNNeighbors = gNNeighbors_more_gb;
data_out.gDiameter = gDiameter_more_gb;
data_out.gArea = gArea_more_gb;
data_out.gEdge = gEdge_more_gb;
data_out.gNeighbors = gNeighbors_more_gb;

end
