% function ID = find_ID_map_from_boundary_map(gb_target)
% 
% Given a boundary map with 0 and 1 s, output an ID map
%
% chenzhe, 2018-05-15

function ID = find_ID_map_from_boundary_map(gb_target)

ID = one_pass_label(gb_target);
ID(gb_target==1) = 0;

count = 0;
while sum(ID(:)==0)>0
    nb = ID;   % gb's left neighbor
    nb(:,2:end) = nb(:,1:end-1);
    ID(ID==0) = nb(ID==0);
    
    nb = ID;   % gb's top neighbor
    nb(2:end,:) = nb(1:end-1,:);
    ID(ID==0) = nb(ID==0);
    
    nb = ID;   % gb's bottom neighbor
    nb(:,1:end-1) = nb(:,2:end);
    ID(ID==0) = nb(ID==0);
    
    nb = ID;   % gb's right neighbor
    nb(1:end-1,:) = nb(2:end,:);
    ID(ID==0) = nb(ID==0);
    
    count = count + 1;
    if count > 10 && rem(count,10)==1
        disp(['many iterations, now @ iter = ', num2str(count), ', remaining points: ',num2str(sum(ID(:)==0))]);
    end

end

% make ID smaller
[~,~,IC] = unique(ID(:));
ID(:) = IC;