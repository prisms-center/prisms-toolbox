% [boundaryTF, boundaryID, neighborID, tripleTF, tripleID, indTriple, triIDs]  
% = find_one_boundary_from_ID_matrix(ID)
% Find a boundary depending on the right and bottom pixel. If the pixel to
% the right/bottom belongs to another grain, it is a grain boundary point.
%
% Something important to remember is that there could be nan's in ID.
% And these should not be considered as G.B.
% Note that currently, I need to make nan IDs into 0 or something. -- Need
% to improve, mabe.
% chenzhe, 2018-05-14
%
% chenzhe, note 2018-09-08. Note currently, looks like if neighbor's ID is
% 0, then it is not considered as a grain boundary.
% This might be a useful feature.  But also, if you want to consider a
% point that has a neighbor pixel with ID=0, you need to first change all
% ID=0 to ID=some unique number. !!!
%
% chenzhe, update to correct 2018-09-08 note.
% The problem WAS: grains with ID=0 cannot get grain boundary due to
% defects of the algorithm.  So, first change ID=0 to another ID_special,
% to treat this problem.  After finding boundaries/neighborID/tripleID,
% change it back.
%
% chenzhe, 2019-08-27, add:
% indTriple = linear index of triple points
% triIDs = nx3 matrix, each row is a set of 3 grain IDs related to a
% triple point.

function [boundaryTF, boundaryID, neighborID, tripleTF, tripleID, indTriple, triIDs] = find_one_boundary_from_ID_matrix(ID)

% this is to treat initial ID=0
ID_input = ID;
ID_special = max(ID(:)) + 1;
if any(ID(:)==0)
    ID(ID==0) = ID_special;
    disp('Caution: ID matrix has values equal to 0. Be careful when using boundaryID, neighborID and tripleID.');
end

boundaryTF = zeros(size(ID,1),size(ID,2));      % if pixel is on grain boundary, then this value will be 1
boundaryID = zeros(size(ID,1),size(ID,2));      % this indicate the grain ID of the grain which the grain boundary belongs to
neighborID = zeros(size(ID,1),size(ID,2));      % for grain boundary points, this is the grain ID of the neighboring grain
tripleTF = zeros(size(ID,1),size(ID,2));        % if pixel is on triple point, then this value will be 1
tripleID = zeros(size(ID,1),size(ID,2));        % this indicate the grain ID of the grain which the triple point belongs to

nb_r = ID;
nb_r(:,1:end-1) = nb_r(:,2:end);  % shift left / right neighbor
nb_b = ID;
nb_b(1:end-1,:) = nb_b(2:end,:);  % shift up / bottom neighbor
nb_br = ID;
nb_br(1:end-1,1:end-1) = nb_br(2:end,2:end);    % shift up-left / bottom-right neighbor

nb_r(nb_r == ID) = 0;   % only allowed if neighbor is from a different grain
nb_b(nb_b == ID) = 0;
nb_br(nb_br == ID) = 0;

boundaryTF = nb_r | nb_b;
tripleTF = ((nb_r~=nb_b)&(nb_r>0)&(nb_b>0)) | ((nb_r~=nb_br)&(nb_r>0)&(nb_br>0)) | ((nb_b~=nb_br)&(nb_b>0)&(nb_br>0)) ;

% fill neighborID, priority right>bottom
neighborID(boundaryTF) = nb_r(boundaryTF);
ind = (boundaryTF>0)&(neighborID==0);
neighborID(ind) = nb_b(ind);    % this should be enough. Otherwise, code might be wrong.
if any(neighborID(:)==ID_special)
    neighborID(neighborID==ID_special) = 0;
    disp('change ID_special back to ID');
end

boundaryID(boundaryTF) = ID_input(boundaryTF);
tripleID(tripleTF) = ID_input(tripleTF);
boundaryTF = double(boundaryTF);
tripleTF = double(tripleTF);

% disp('found one-pixel width boundaryTF and tripleTF');

indTriple = find(tripleTF(:)==1);
triIDs = zeros(length(indTriple),3);
for ii = 1:size(triIDs,1)
    ids = unique([ID(indTriple(ii)), nb_r(indTriple(ii)), nb_b(indTriple(ii)), nb_br(indTriple(ii))]);
    ids(ids==0) = [];
    triIDs(ii,:) = ids(1:3);
end


%% check by plotting gb and triple point
% close all;
% gb = [];
% tp = [];
% for ir=1:901
%     for ic = 1:901
%        if boundaryTF(ir,ic) > 0
%            gb = [gb;ir,ic];
%        end
%        if tripleTF(ir,ic) > 0
%            tp = [tp; ir,ic];
%        end
%         
%     end 
% end
% figure; hold on;
% plot(gb(:,1),gb(:,2),'.r');
% plot(tp(:,1),tp(:,2),'xb','markersize', 12);
% set(gca,'ydir','reverse');

