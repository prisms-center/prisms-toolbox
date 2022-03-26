% try to divide grain into more grains, using grain boundary under mask
%
% Algorithm:
% (1) First, check if can use mask + parent ID + child ID map:
%  The mask seperate the parent grain into two grains A and B
%  Find all child grains of the parent grain,
%  if each child grain overlaps with only one of A or B, then seperate the
%  parent grain depending on child grain groups.
% (2) Else iteratively divide the parent grain, using misorientation_max
% under mask and > threshold as additional grain boundary
%  if not able to divide, reduce threshould by 0.5
%
% data needed:
% mask;
% misorientation_max;
% ID_local;
% ID_c_local;
% ID_to_assign;    % ID number to assign to newly divided ID

function [ID_local, need_to_redraw, need_to_use_misorientation_max] = divide_grain(ID_local, ID_c_local, mask, misorientation_max, ID_to_assign)

% initialize, assume child_grains are enought to seperate
need_to_use_misorientation_max = 0;
need_to_redraw = 0;

% determine the parent grain of interest using mode (majority of pixels
% covered by mask on the ID_local map)
id_p = mode(ID_local(mask>0));

% try to divide the parent grain into gA and gB
ID_AB = ID_local;
ID_AB(ID_AB~=id_p) = 0;
ID_AB(mask==1) = 0;
ID_temp = one_pass_label(ID_AB);
g_list = unique(ID_temp(ID_AB~=0));
if length(g_list)~=2
    % error, the mask does not seperate the parent grain into 2 areas
    % most likely, the mask is not enough to seperate the parent grain
    % but sometimes, it divides the parent grain into >2 areas (under
    % 4-connectivity)
    need_to_redraw = 1;
    return;
else
    for ii = 1:2
        ID_AB(ID_temp==g_list(ii)) = ii;
    end
end

% We need to temporarily modify 'ID_c_local', so that ID_c outside of id_p
% area will be assigned to something differnet. The purpose is to make it
% as if ID_c is immediately modified after a parent grain is modified, so
% that each child grain always belongt only one parent grain.
ID_c_local(ID_local~=id_p) = nan;

% child grains that overlap with the parent grain
id_c_list = unique(ID_c_local(ismember(ID_local, id_p)));
groupA = [];
groupB = [];

for ii=1:length(id_c_list)
    id_c = id_c_list(ii);
    ind = ismember(ID_c_local, id_c);
    gid = unique(ID_AB(ind));
    gid(gid==0)=[]; % remove '0' from overlaped grain ID

    if length(gid)==0
        % error, this child grain overlaps with neither gA nor gB, possibly
        % the mask covers this child grain
        need_to_redraw = 2;
        return;
    elseif length(gid)==1
        % assign each child grain into groupA or groupB
        if gid==1
            groupA = [groupA, id_c];
        elseif gid==2
            groupB = [groupB, id_c];
        else
            need_to_redraw = 3; % error, this should not happen
            return;
        end
    elseif length(gid)==2
        % If the mask (un-intentionally) seperate a child grain into 2, but
        % the majority of this child grain belong to gA, then assign to gA.
        nA = sum((ID_c_local(:)==id_c) & (ID_AB(:)==1));
        nB = sum((ID_c_local(:)==id_c) & (ID_AB(:)==2));
        if nA/(nA+nB) > 0.95
            groupA = [groupA, id_c];
        elseif nB/(nA+nB) > 0.95
            groupB = [groupB, id_c];
        else
            % the child grian also needs to be divided into 2 grains
            % In this case, we should try misorientation_max
            need_to_use_misorientation_max = 1;
            break;
        end
    end
end

if need_to_use_misorientation_max==0
    area_A = sum(ismember(ID_c_local(:), groupA));
    area_B = sum(ismember(ID_c_local(:), groupB));
    % update ID local
    if area_A>=area_B
        ID_local(ismember(ID_c_local(:), groupB)) = ID_to_assign;
    else
        ID_local(ismember(ID_c_local(:), groupA)) = ID_to_assign;
    end
    return;
else
    tolerance = 5; % initial tolerance
    while true
        boundary_local_new = (misorientation_max > tolerance)&(mask==1);
        boundary_local_new = double(ID_local~=id_p | boundary_local_new);
        ID_local_temp = find_ID_map_from_boundary_map(boundary_local_new);
        
        % We want 2 grains, but need another check: new grains cannot be
        % fully located under mask, otherwise it is formed by a local
        % boundary hole
        
        if length(unique(ID_local_temp(:))) == 2   
            new_grains_valid = true;    % initialize
            for jj=1:2
                % size of new grain
                grain_temp = (ID_local_temp==jj)&(ID_local==id_p);   % copy grain 
                grain_temp(boundary_local_new==1)=0; % remove boundary pts
                sz_grain = sum(grain_temp(:)); % size of grain
                sz_under_mask = sum(grain_temp(:)==1 & mask(:)==1);  % size of grain under mask
                if sz_grain==sz_under_mask
                    % not a valid grain
                    new_grains_valid = false;
                end
            end
        else
            new_grains_valid = false;
        end
        
        if new_grains_valid
            break;  
        elseif tolerance>0.5
            tolerance = tolerance - 0.5;
        else
            need_to_redraw = 4; % mask does not cover a good boundary to divide the grain  
            return;
        end
    end

    % Let the larger grain keep the grain ID, update ID_local
    ID_local_temp(ID_local~=id_p) = 0;
    if sum(ID_local_temp(:)==1)/sum(ID_local(:)==id_p) >= 0.5
        ind = ID_local_temp==2;
        ID_local(ind) = ID_to_assign;
    else
        ind = ID_local_temp==1;
        ID_local(ind) = ID_to_assign;
    end
end

end

