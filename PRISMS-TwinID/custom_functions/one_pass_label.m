% chenzhe, 2018-02-17
% add note: this code can generate a unique 'grain ID' to continues areas
% on a map 'PM' that has a number of continuous regions, and each region
% has a unique value in the 'PM' matrix.
%
% chenzhe, 2018-05-16, correct an error on checking last row.
% chenzhe, 2018-05-16, have another method which seems faster

function labels = one_pass_label(M)

M = padarray(M,[1,1],'pre');
M = padarray(M,[1,1],'post');

[nR,nC] = size(M);

labels = ones(nR,nC);
labels(2:end-1,2:end-1) = 0;

offSets = [-1, nR, 1, -nR]; % row vector

currentLabel = 0;
for iR = 2:nR-1
    for iC = 2:nC-1
        % if not labeled
        if 0==labels(iR,iC)
            currentPhase = M(iR,iC);
            currentLabel = currentLabel + 1;
            ind = (iC-1)*nR + iR;   % colomn vector
            labels(ind) = currentLabel;
            while ~isempty(ind)
                ind_nb = bsxfun(@plus, ind, offSets);
                ind_nb = unique(ind_nb(:));
                ind = ind_nb((M(ind_nb)==currentPhase)&(labels(ind_nb)==0));
                labels(ind) = currentLabel;
            end
        end
    end
end

labels = labels(2:end-1,2:end-1);


% % This is the old version
% M = M';
% labels = zeros(size(M));
% ind = 1;
% currentLabel = 0;
% currentPhase = M(ind);
% ind_max = length(M(:));
% [nR,nC] = size(M);
% myQ = [];
% 
% while ind <= ind_max
%     currentPhase = M(ind);
%     if (labels(ind)==0)&&(M(ind)==currentPhase)
%         currentLabel = currentLabel + 1;
%         labels(ind) = currentLabel;
%         myQ = [myQ, ind];
%         while ~isempty(myQ)
%             ind_pop = myQ(1);
%             myQ(1) = [];
%             % check ind_pop's neighbor
%             if (rem(ind_pop-1,nR)<nR-1)&&(labels(ind_pop+1)==0)&&(M(ind_pop+1)==currentPhase)  % not the last row
%                 myQ = [myQ, ind_pop+1];
%                 labels(ind_pop+1) = currentLabel;
%             end
%             if (rem(ind_pop-1,nR)>0)&&(labels(ind_pop-1)==0)&&(M(ind_pop-1)==currentPhase) % not the first row
%                 myQ = [myQ, ind_pop-1];
%                 labels(ind_pop-1) = currentLabel;
%             end
%             if (floor((ind_pop-1)/nR)>0)&&(labels(ind_pop-nR)==0)&&(M(ind_pop-nR)==currentPhase)  % not the first colomn
%                 myQ = [myQ, ind_pop-nR];
%                 labels(ind_pop-nR) = currentLabel;
%             end
%             if (floor((ind_pop-1)/nR)<nC-1)&&(labels(ind_pop+nR)==0)&&(M(ind_pop+nR)==currentPhase)   % not the last colomn
%                 myQ = [myQ, ind_pop+nR];
%                 labels(ind_pop+nR) = currentLabel;
%             end
%             %             [length(myQ), currentLabel];
%         end
%     else
%         ind = ind + 1;
%     end
% end
% 
% labels = labels';
    
end

