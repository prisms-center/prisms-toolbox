% [boundaryTF, boundaryID, neighborID, tripleTF, tripleID] = find_boundary_from_ID_matrix(ID)
%
% input ID is a matrix of IDs, return matrix of same dimension
% boundaryTF, tripleTF: matrix, use 1 or 0 to indicate
% neighborID: the smallest ID of neighbor grain
% boundaryID, tripleID: ID of the current grain, if pixel is on boundary/triple point
%
% Something important to remember is that there could be nan's in ID.
% And these should not be considered as G.B.

% Zhe Chen, 2015-08-07 revised.

function [boundaryTF, boundaryID, neighborID, tripleTF, tripleID] = find_boundary_from_ID_matrix(ID)

boundaryTF = zeros(size(ID,1),size(ID,2));      % if pixel is on grain boundary, then this value will be 1
boundaryID = zeros(size(ID,1),size(ID,2));      % this indicate the grain ID of the grain which the grain boundary belongs to
neighborID = zeros(size(ID,1),size(ID,2));      % for grain boundary points, this is the grain ID of the neighboring grain
tripleTF = zeros(size(ID,1),size(ID,2));        % if pixel is on triple point, then this value will be 1
tripleID = zeros(size(ID,1),size(ID,2));        % this indicate the grain ID of the grain which the triple point belongs to

a = repmat(ID,1,1,9);           % shift ID matrix to find G.B/T.P
a(:,1:end-1,2) = a(:,2:end,2);  % shift left
a(:,2:end,3) = a(:,1:end-1,3);  % shift right
a(1:end-1,:,4) = a(2:end,:,4);  % shift up
a(2:end,:,5) = a(1:end-1,:,5);  % shift down
a(1:end-1,1:end-1,6) = a(2:end,2:end,6);    % shift up-left
a(2:end,2:end,7) = a(1:end-1,1:end-1,7);    % shift down-right
a(1:end-1,2:end,8) = a(2:end,1:end-1,8);    % shift up-right
a(2:end,1:end-1,9) = a(1:end-1,2:end,9);    % shift down-left

for ii=2:9
    shiftedA = a(:,:,ii);
    
    thisBoundaryTF = (ID~=shiftedA)&(~isnan(ID))&(~isnan(shiftedA));    % it is a boundary based on info from this layer.  Have to be a number to be considered as g.b.
    boundaryTF = boundaryTF | thisBoundaryTF;   % update boundaryTF using OR relationship
    
    thisNeighborID = shiftedA .* thisBoundaryTF;    % neighborID based on info from this layer
    thisNeighborID(isnan(thisNeighborID)) = 0;
    
    thisTripleTF = (thisNeighborID~=0)&(neighborID~=0)&(thisNeighborID~=neighborID)&(~isnan(ID))&(~isnan(shiftedA));   % if neighborID based on current layer info is different from existing one
    tripleTF = tripleTF | thisTripleTF; % update tripleTF using OR relationship
    
    useNew = ((neighborID==0)&(thisNeighborID~=0)) | ((neighborID>0) & (0<thisNeighborID) & (thisNeighborID<neighborID)); % (old==0)and(new~=0)  OR  (old>0)and(0<new<old)
    neighborID = neighborID.*(1-useNew) + thisNeighborID .* useNew;    
end
boundaryID_2 = ID .* boundaryTF; 
boundaryID(~isnan(ID))=boundaryID_2(~isnan(ID));    % take ~nan values
tripleID_2 = ID .* tripleTF; 
tripleID(~isnan(ID))=tripleID_2(~isnan(ID));    % take ~nan values
boundaryTF = double(boundaryTF);
tripleTF = double(tripleTF);
display('found boundaryTF and tripleTF');
display(datestr(now));
end