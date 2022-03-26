% iteratively align two ID maps, starting from the center grain
% ID_0: ID map source
% ID: ID map target
% contro_IDs = 2-by-n matrix, control IDs on ID_0 map and ID map

function [tform, return_state] = align_ID_maps(ID_0, ID, control_IDs, x_0,y_0, x,y)

if ~exist('control_IDs','var')
    control_IDs = [];
end

boundary_0 = find_one_boundary_from_ID_matrix(ID_0);
% find gCenter positions
if ~exist('x','var')
    [x_0,y_0] = meshgrid(1:size(ID_0,2),1:size(ID_0,1));  % create coordinates
    [x,y] = meshgrid(1:size(ID,2),1:size(ID,1));  % create coordinates
end

gID_0 = accumarray(ID_0(:), ID_0(:))./accumarray(ID_0(:),1);
gCenterX_0 = accumarray(ID_0(:), x(:))./accumarray(ID_0(:),1);
gCenterY_0 = accumarray(ID_0(:), y(:))./accumarray(ID_0(:),1);
% (1) the gID might be 0, which is not what we want
% (2) the gIDs might not be continues, so the # of points=0, and position
% will be nan. We need to remove these rows, so the nRows equals nGrains
ind = (gID_0==0)|(isnan(gID_0)); 
gID_0(ind) = [];
gCenterX_0(ind) = [];
gCenterY_0(ind) = [];
a1 = unique(ID_0(1,:));
a2 = unique(ID_0(end,:));
a3 = unique(ID_0(:,1));
a4 = unique(ID_0(:,end));
gEdge_0 = unique([a1(:);a2(:);a3(:);a4(:)]);
gEdge_0 = ismember(gID_0,gEdge_0);

gID = accumarray(ID(:), ID(:))./accumarray(ID(:),1);
gCenterX = accumarray(ID(:), x(:))./accumarray(ID(:),1);
gCenterY = accumarray(ID(:), y(:))./accumarray(ID(:),1);
ind = (gID==0)|(isnan(gID)); 
gID(ind) = [];
gCenterX(ind) = [];
gCenterY(ind) = [];
a1 = unique(ID(1,:));
a2 = unique(ID(end,:));
a3 = unique(ID(:,1));
a4 = unique(ID(:,end));
gEdge = unique([a1(:);a2(:);a3(:);a4(:)]);
gEdge = ismember(gID,gEdge);

% find gNeighbors
[boundary, ~, neighborID, ~, ~, ~, ~]   = find_one_boundary_from_ID_matrix(ID);
id_nb_pair = unique([ID(:),neighborID(:)],'rows');
ind = id_nb_pair(:,1)==0|id_nb_pair(:,2)==0;    % remove ID=0
id_nb_pair(ind,:) = [];


% Method B: auto align algorithm:
% (1) find control grains (if any)
% (2) build transformation using control IDs
% (3) align and match ID map
% (4) update control IDs, using all old control IDs' neighbor
boundaryAccu = -boundary;
iLoop = 1;
while true
    if isempty(control_IDs)
        tform = fitgeotrans([0 0; 0 1; 1 0], [0 0; 0 1; 1 0], 'affine');
        % find grains closest to the cetner as initial control points
        midx = mean(x(:))/2;
        midy = mean(y(:))/2;
        [~,inds] = sort(pdist2([gCenterX,gCenterY],[midx,midy],'euclidean'));
        control_IDs(2,:) = gID(inds(1:3));
    else
        g_0 = control_IDs(1,:);    % ref at iE=0
        g_iE = control_IDs(2,:);    % iE > 0, considered as deformed
        [~, loc_0] = ismember(g_0, gID_0);
        [~, loc_iE] = ismember(g_iE, gID);
        cpFrom = [gCenterX_0(loc_0),gCenterY_0(loc_0)];     % cpFrom is from ref image (iE=0)
        cpTo = [gCenterX(loc_iE),gCenterY(loc_iE)];         % cpTo is from deformed image (iE>0)
        tform = fitgeotrans(cpFrom, cpTo, 'affine');    % [x_0, y_0, 1] * tform.T = [x_iE, y_iE, 1]
    end

    ID_0_to_iE = interp_data(x_0,y_0,ID_0, x,y,tform, 'interp', 'nearest');

    [ID_new, id_link_additional, id_link] = hungarian_assign_ID_map(ID_0_to_iE, ID);

    % [[remove]] '0's from linked ids
    ind_r = find(id_link(:,1)==0 | id_link(:,2)==0);
    id_link(ind_r,:) = [];

    % [[remove]] grains that are shown in BOTH the col_2 of id_link and col_2 of in_link_additional
    if ~isempty(id_link_additional)
        ind = ismember(id_link(:,2), id_link_additional(:,2));
        id_link(ind,:) = [];
    end
    % [[remove]] edge grains in id_link
    ind = ismember(id_link(:,1), gID_0(gEdge_0));
    id_link(ind,:) = [];
    ind = ismember(id_link(:,2), gID(gEdge));
    id_link(ind,:) = [];

    % update control IDs
    nb_list = [];
    for ii=1:length(control_IDs(2,:))
        id_2 = control_IDs(2,ii);
        ind = id_nb_pair(:,1)==id_2;
        nbs = id_nb_pair(ind,2);
        nb_list = [nb_list; nbs(:)];
    end
    id_2_list = control_IDs(2,:);
    id_2_list = [id_2_list(:);nb_list(:)];  % old control IDs + their nbs

    control_IDs_updated = [];
    for ii=1:length(id_2_list)
        id_2 = id_2_list(ii);
        ind = find(id_link(:,2)==id_2);
        id_1 = id_link(ind,1);
        if ~isempty(id_1)
            control_IDs_updated = [control_IDs_updated, [id_1; id_2]];
        end
    end
    control_IDs_updated = (unique(control_IDs_updated','rows'))';

    % accumulative boundary
    bd = find_one_boundary_from_ID_matrix(ID_new);
    boundaryAccu(bd>0) = iLoop * bd(bd>0);
    iLoop = iLoop + 1;

    % Exit criterion: if iLoop is very big, or if all IDs have been used for alignment
    if iLoop > 50
        return_state = false;
        break;
    else
        if numel(control_IDs(2,:))==numel(control_IDs_updated(2,:))
            return_state = true;
            break;
        else
            control_IDs = control_IDs_updated;
        end
    end
    % myplot(boundaryAccu);
end

if 0
    % Method compatible with old analysis, explicitly have control IDs, and do
    % the alignment only twice (coarse + fine)
    % match IDs
    g_0 = control_IDs(1,:);    % ref at iE=0
    g_iE = control_IDs(2,:);    % iE > 0, considered as deformed
    [~, loc_0] = ismember(g_0, gID_0);
    [~, loc_iE] = ismember(g_iE, gID);
    cpFrom = [gCenterX_0(loc_0),gCenterY_0(loc_0)];     % cpFrom is from ref image (iE=0)
    cpTo = [gCenterX(loc_iE),gCenterY(loc_iE)];         % cpTo is from deformed image (iE>0)

    % [1st] rough tform. The tform is to transform the [ref @ iE=0] to [deformed iE>0]
    tform = fitgeotrans(cpFrom, cpTo, 'affine');    % [x_0, y_0, 1] * tform.T = [x_iE, y_iE, 1]

    ID_0_to_iE = interp_data(x_0,y_0,ID_0, x,y, tform, 'interp', 'nearest');
    boundary_0_to_iE = find_boundary_from_ID_matrix(ID_0_to_iE);

    [ID_new, id_link_additional, id_link] = hungarian_assign_ID_map(ID_0_to_iE, ID);

    % [[remove]] '0's from linked ids
    ind_r = find(id_link(:,1)==0 | id_link(:,2)==0);
    id_link(ind_r,:) = [];
    inds = isnan(ID_0_to_iE)|(ID_new==0); % old ID is nan, or matched ID=0
    ID_new(inds) = nan;

    % [[remove]] edge grains in g_0 and g_iE
    g_0 = id_link(:,1);
    g_iE = id_link(:,2);
    [~, loc_0] = ismember(g_0, gID_0);
    [~, loc_iE] = ismember(g_iE, gID);
    ind = (gEdge_0(loc_0)==1) | (gEdge(loc_iE)==1);
    g_0(ind) = [];
    g_iE(ind) = [];

    % use cps to transform
    [~, loc_0] = ismember(g_0, gID_0);
    [~, loc_iE] = ismember(g_iE, gID);
    cpFrom = [gCenterX_0(loc_0),gCenterY_0(loc_0)]; % cpFrom is from deformed image (iE>0)
    cpTo = [gCenterX(loc_iE),gCenterY(loc_iE)];   % cpTo is from ref image (iE=0)

    % [2nd] fine tform.
    tform = fitgeotrans(cpFrom, cpTo, 'affine');    % [x_ref, y_ref, 1] * tform.T = [x_def, y_def, 1]
    return_state = true;
end


% illustrate the control grains
% boundary_0 = find_one_boundary_from_ID_matrix(ID_0);
% myplot(ismember(ID_0,g_0), boundary_0);
% boundary = find_one_boundary_from_ID_matrix(ID);
% myplot(ismember(ID,g_iE), boundary);
end


