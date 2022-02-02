% hungarian_assign algorithm, naive
% m = cost_of(worker,job)
% output is the job that each worker should do.  
% Workers were sorted ascending, so worker is omitted in default output.
%
% chenzhe, 2018-03-02
%
% chenzhe, 2018-06-23
% rewrite based on reference, to improve speed and reduce bugs
% http://csclab.murraystate.edu/~bob.pilgrim/445/munkres.html

function [worker, job, worker_full, job_full] = hungarian_assign(M)

% step-0: matrix cost(i,j) = worker(i), job(j). Rotate so that nC>=nR
if size(M,1)>size(M,2)
    M = M';
    switched = 1;
else
    switched = 0;
end
M_in = M;

[nR,nC] = size(M);  % k = min(nR,nC);

done = false;
step = 1;

% mask matrix, 1=starred, 2=primed
STAR = 1;
PRIME = 2;
mask = zeros(nR,nC);

while(~done)
    switch step
        case 1            
            % step-1: for each row, find smallest element and subtract it form the row
            val = min(M,[],2);
            M = M - val;
            step = 2;
            
        case 2
            % step-2: find a zero in the matrix. If there is no starred zero in its row or column, [star] it by making mask(i,j) = 1  
            coverR = zeros(nR,1);
            coverC = zeros(1,nC);
            for iR=1:nR
%                for iC=1:nC
%                   if(M(iR,iC)==0)&&(coverR(iR)==0)&&(coverC(iC)==0)
%                       mask(iR,iC) = 1;
%                       coverR(iR) = 1;
%                       coverC(iC) = 1;
%                   end
%                end
               iC = find((~M(iR,:))&(~coverC),1,'first');
               if ~isempty(iC)
                   mask(iR,iC) = STAR;
                   coverR(iR) = 1;
                   coverC(iC) = 1;
               end
            end
            step = 3;
            
        case 3
            % step-3: [cover] each column containing a [starred] zero. If k columns are [covered],done. Otherwise, go to step 4  
            % reset first. coverC is effectively the same as after step-2
            coverR = zeros(nR,1);
            coverC = zeros(1,nC);
            coverC = sum(mask==1,1)>0;
            if sum(coverC,2)>=nR
                step = 7;
            else
                step = 4;
            end
            
        case 4
            % step-4: find a [un-coverred] zero and [prime] it. 
            % If there is no [starred] zero in that row, go to step-5. 
            % Otherwise, [cover] this row and [un-cover] the column containing the [starred] zero. 
            % Continue until there are no [un-covered] zeros left. 
            % Save the smallest [un-coverred] value and go to step-6. %
            while 1
                % (*) find an [un-coverred] zero
                [iR,iC] = find((M==0)&(~((coverR)|(coverC))), 1, 'first');
                if isempty(iR)
                    % (*) not found
                    step = 6;
                    % record the smallest uncoverred value
%                     smallest = M(logical((double(~coverR))*(double(~coverC))));
                    smallest = M((~((coverR)|(coverC))));
                    smallest = min(smallest(:));
                    break;
                else
                    % (*) found
                    % [prime] it
                    mask(iR,iC) = 2;
                    % (**) find a [starred] zero in that row, i.e., iR
                    iC_starred = find((M(iR,:)==0)&(mask(iR,:)==STAR), 1, 'first');
                    if isempty(iC_starred)
                        % (**) not found
                       step = 5; 
                       break;
                    else
                        % (**) found
                        coverR(iR) = 1;
                        coverC(iC_starred) = 0;
                    end
                end
                
            end
            
        case 5
            % construct a series of alternation [primed and starred] zeros:  
            % z0 = [un-coverred primed] zero in step-4  
            % z1 = [starred] zero in the column of z0 (if any)  
            % z2 = [primed] zero in the row of z1  
            % continue until terminates at a [primed] zero that has no [starred] zero in its column 
            % [un-star] each [starred] zero of the series, [star] each [primed] zero of the series, erease all [primes] and [un-cover] every line in the matrix
            % return to step-3 
            
            % record path
            path = [iR,iC];
            while 1
                % (***) find z1, the row# of [starred] zero in cTemp
                cTemp = path(end,2);
                iR_starred_zero = find( (M(:,cTemp)==0)&(mask(:,cTemp)==STAR), 1, 'first');
                
                if ~isempty(iR_starred_zero)
                    % (***) found
                    path = [path; iR_starred_zero, cTemp];
                else
                    % (***) not found, done
                    break;
                end
                
                % (****) find z2, the col# of [primed] zero in rTemp
                rTemp = path(end,1);
                iC_primed_zero = find( (M(rTemp,:)==0)&(mask(rTemp,:)==PRIME) , 1, 'first');
                path = [path; rTemp, iC_primed_zero];

            end
            
            % [un-star] each [starred] zero of the series, [star] each [primed] zero of the series,
            for ii = 1:size(path,1)
               rTemp = path(ii,1);
               cTemp = path(ii,2);
               if mask(rTemp,cTemp) == STAR
                   mask(rTemp,cTemp) = 0;
               else
                   mask(rTemp,cTemp) = STAR;
               end
            end
            % erease all [primes] and [un-cover] every line in the matrix
            mask(mask==PRIME) = 0;
            coverR = coverR * 0;
            coverC = coverC * 0;
            % go to step-3
            step = 3;
            
            
        case 6
            % add the value found in step-4 to every element of each [coverred row], and subtract it from every element of each [uncoverred column]  r
            M = M + double(coverR)*smallest;
            M = M - double(~coverC)*smallest;
            step = 4;
            
        case 7
            % find the [starred] zero, which indicates the assignment
            worker = [];
            job = [];
            worker_full = [];
            job_full = [];
            
            for iJob = 1:nC
                iWorker = find(mask(:,iJob)==STAR);
                if ~isempty(iWorker)
                    worker = [worker;iWorker];
                    job = [job;iJob];
                    worker_full = [worker_full;iWorker];
                    job_full = [job_full;iJob];
                else
                    [~,iWorker] = min(M_in(:,iJob));
                    worker_full = [worker_full;iWorker];
                    job_full = [job_full;iJob];
                end
            end
            if switched==1
                t = worker;
                worker = job;
                job = t;
                
                t = worker_full;
                worker_full = job_full;
                job_full = t;
            end
            % sort and rotate to row vector
            wj = sortrows([worker,job]);
            worker = wj(:,1)';
            job = wj(:,2)';
            
            wj = sortrows([worker_full,job_full]);
            worker_full = wj(:,1)';
            job_full = wj(:,2)';
            
            done = true;
    end
end

end


% The following are the old codes, it works most of the time, but slow, and
% can sometimes generate error.
% It was based on wikipedia, but the algorithm was not well-described. So I
% tried several things, but maybe there are things that were not
% well-considered.
% chenzhe, add note 2018-06-23

% function [worker, job, worker_full, job_full] = hungarian_assign(M)
% 
% if ~exist('M','var')
%     n = 5;
%     disp('worst case example for 10x10 matrix: ');
%     M = [1:n]'.*[1:n]
% end
% 
% M0 = M;
% [nR,nC] = size(M);
% if nR<nC
%     M(nR+1:nC,:) = 0;
% elseif nR>nC
%     M(:,nC+1:nR) = 0;
% end
% 
% tf = false;
% nLoops = 0;
% while ~tf
%     nLoops = nLoops + 1;
%     % (1) try to assign by optimizing each row.
%     M = M - min(M,[],2);
%     [tf, worker, job] = check_assignment(M);
%     
%     % (2) If does not work, try to assign by optimizing each col.
%     if tf
%         break;
%     else
%         M = M - min(M,[],1);
%         [tf, worker, job] = check_assignment(M);
%     end
%     
%     % (3) if not solved, keep going.
%     % Cover lines with 0's with as few rows/cols as possible. One way of doing it:
%     if tf
%         break;
%     else
%         assigned = false(size(M));
%         crossed = false(size(M));
%         marked = false(size(M));
%         lined = false(size(M));
%         % [1] First, Assign as many tasks as possible. (Already did in check_assignment) 
%         % and cross all other 0s within the same row and col
%         for ii = 1:length(worker)
%             iR = worker(ii);
%             iC = job(ii);
%             assigned(iR,iC) = true;
%             crossed(iR,(0==M(iR,:))&(~assigned(iR,:)))=true;
%             crossed((0==M(:,iC))&(~assigned(:,iC)),iC)=true;
%         end
%         
%         % [2] Now, to the drawing part
%         marked((0==sum(assigned,2)),:) = true;  % mark all rows having no assigment
%         
%         cols = sum((0==M)&(marked),1)>0;    % mark all (unmarked) columns having zeros in 'newly marked' rows (so, used 'marked' in index)
%         cols_old = [];
%         while ~isequal(cols,cols_old)
%             marked(:,cols) = true; 
%             marked(sum((assigned)&(marked),2)>0,:) = true; % mark all rows having assignments in newly marked columns
%             cols_old = cols;
%             cols = sum((0==M)&(marked),1)>0;
%         end
%         % Repeat for all new rows with 0s, until no more cols need to be marked 
%         
%         % draw lines through all makred columns and unmarked rows
%         lined(:,size(marked,1)==sum(marked,1)) = true;
%         lined(size(marked,2)~=sum(marked,2),:) = true;
%         
%         % From the elements that are left, find the lowest value.
%         % Subtract this from every unmarked element and add it to every element covered by two lines.
%         lowest = min(M(~lined));
%         M(~lined) = M(~lined) - lowest;
%         M(size(lined,2)==sum(lined,2), size(lined,1)==sum(lined,1)) = ...
%             M(size(lined,2)==sum(lined,2), size(lined,1)==sum(lined,1)) + lowest;
%     end
%     
% end
% 
% worker_full = worker;
% job_full = job;
% 
% % if have virtual worker, the job can be done by some real worker
% % if nR<nC
% for ii = 1:length(worker_full)
%     if worker_full(ii)>nR
%         worker(ii) = 0;
%         [~,worker_full(ii)] = min(M0(1:nR,job_full(ii)));
%     end
% end
% 
% % if have virtual job, the worker can do some real job
% % (if nR>nC)
% for ii = 1:length(worker_full)
%     if(job_full(ii)>nC)
%         job(ii) = 0;
%         [~,job_full(ii)] = min(M0(worker_full(ii),1:nC));
%     end
% end
% 
% 
% end
% 
% 
% function [tf, worker, job] = check_assignment(M)
% 
% if ~isempty(M)
%     % try to reduce one row and one col
%     zeros_in_col = sum(0==M,1);
%     if any(zeros_in_col)
%         zeros_in_col(0==zeros_in_col) = inf;    % prevent from finding
%         [~,indc] = min(zeros_in_col);     % find the col with least 0's
%     else
%         worker = [];
%         job = [];
%         tf = false;
%         return;
%     end
%     indrs = find(M(:,indc)==0);    % find a row with least 0's in the col
%     [~,ind] = min(sum(0==M(indrs,:),2));
%     indr = indrs(ind);  % !!!
%     M(:,indc) = [];  % mark col
%     M(indr,:) = [];  % mark row
%     
%     if isempty(indr)
%         tf = false;
%         return;
%     end
%     [tf, worker, job] = check_assignment(M);  % find assignment in sub matrix
%     % for index larger than the marked row/column, add index by 1
%     worker(worker>=indr) = worker(worker>=indr) + 1;
%     job(job>=indc) = job(job>=indc) + 1;
%     % append the assignment in sub matrix to the current assignment in this iteration
%     worker = [indr,worker];
%     job = [indc,job];
%     % sort ascend
%     wj = sortrows([worker(:),job(:)]);
%     wj = wj';
%     worker = wj(1,:);
%     job = wj(2,:);
% else
%     worker = [];
%     job = [];
%     tf = true;
% end
% 
% end

