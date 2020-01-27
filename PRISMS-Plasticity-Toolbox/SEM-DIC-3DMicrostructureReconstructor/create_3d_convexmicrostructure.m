clear all
close all
tic
load('3d_convex_hull.mat')
load('3d_grain_data.mat');

total_dist=74.2188;
%No. of divisions
div=50;

[X Y Z]=meshgrid(0:total_dist/div:total_dist-total_dist/div);



L1=total_dist;
L2=total_dist;
L3=total_dist;
points1=[X(:) Y(:) Z(:)];

test_plot=zeros(length(points1),1);


grain_test=Grain2(:);
figure (1)
for k=1:length(n_grains)

  k
  k2=find(grain_id==n_grains(k));
  test_points1=convex_points(k2,:);
  try
      
  test_plot=test_plot+double(inhull(points1,test_points1,[],10^-6));
  
  catch
      continue
  end
  
  c_hull=convhulln( test_points1);
  c_hull2=c_hull(:);
  
%   if(k==10 ||  k == 15 || k==20 || k==24)
      
   trisurf(c_hull,test_points1(:,1),test_points1(:,2),test_points1(:,3),'FaceColor',rand(1,3),'FaceAlpha',1)
     hold on
     
%   end
    
end

% test_plot2=test_plot';

x2=find((test_plot)==1);
x4=find(test_plot~=1);

x5=find(test_plot==0);

grain_new=zeros(length(test_plot),1);


points_new=[];
point_id_new=[];

 test_plot_x4=zeros(length(x4),length(n_grains));
for k=1:length(n_grains)

  k
  k2=find(grain_id==n_grains(k));
  test_points1=convex_points(k2,:);
  try
  test_plot_x4(:,k)=inhull(points1(x4,:),test_points1,[],10^-6);
  catch
      k
      continue
  end
  
     
end


figure (2)
for k=1:length(n_grains)
    
    
    k2=find(grain_id==n_grains(k));
  test_points1=convex_points(k2,:);
  x1=[];
       try
    x1=find(inhull(points1,test_points1,[],10^-6)==1);
     catch
         continue
     end
  
         x3=intersect(x1,x2);
%      if(k~=10 && k ~= 15 && k~=20 && k~=24)
     test_points1=points1(x3,:);
     c_hull=[];
     try
     c_hull=convhulln(points1(x3,:));
     catch
         continue
     end
     c_hull2=c_hull(:);
        
     k3=unique(c_hull2);
     points_new=vertcat(points_new,test_points1(k3,:));
     point_id_new=vertcat(point_id_new,n_grains(k)*ones(length(k3),1));
     trisurf(c_hull,test_points1(:,1),test_points1(:,2),test_points1(:,3),'FaceColor',rand(1,3),'FaceAlpha',1)
     hold on
%      end
    
end





for i=1:length(points1)
    
    if(find(x2==i))
        grain_new(i)=grain_test(i);
    else if(find(x5==i))
            
            dist=L1*L2*L3*ones(length(n_grains),1);
            i
            
            temp=mod(i,div*div);
            if(temp==0)
                temp=div*div;
            end
            
            i1=mod(temp,div);
            if(i1==0)
                i1=div;
            end
            k1=ceil(i/(div*div));
            j1=ceil(temp/div);
            
            divisor=20;
            i1_l=max(1,round(i1-div/divisor));
            i1_u=min(div,round(i1+div/divisor));
            j1_l=max(1,round(j1-div/divisor));
            j1_u=min(div,round(j1+div/divisor));
            k1_l=max(1,round(k1-div/divisor));
            k1_u=min(div,round(k1+div/divisor));
            
            temp_grain=Grain2(i1_l:i1_u,j1_l:j1_u,k1_l:k1_u);
            unique_grain=unique(temp_grain);
            
            
            for k3=1:length(unique_grain)
                k=find(n_grains==unique_grain(k3));
%                 if(k~=10 && k ~= 15 && k~=20 && k~=24)
             k2=find(point_id_new==n_grains(k));
             test_points1=points_new(k2,:);
            try
             [A,b,Aeq,beq]=vert2lcon(test_points1);
            catch
                continue
            end
             dist(k) = norm(lsqlin(eye(3),(points1(i,:))',A,b)-(points1(i,:))');
%                 end
            end
            [min1 min_index]=min(dist);
            
            grain_new(i)=n_grains(min_index(1));
            

            
            
        else
            dist=L1*L2*L3*ones(length(n_grains),1);
            idx=find(test_plot_x4(find(x4==i),:)==1);
            i
            for k3=1:length(idx)
                k=idx(k3);
%                 if(k~=10 && k ~= 15 && k~=20 && k~=24)
             k2=find(point_id_new==n_grains(k));
             
             test_points1=points_new(k2,:);
             try
             [A,b,Aeq,beq]=vert2lcon(test_points1);
             catch
                 continue
             end
             dist(k) = norm(lsqlin(eye(3),(points1(i,:))',A,b)-(points1(i,:))');
%                 end
            end
            [min1 min_index]=min(dist);
            
            grain_new(i)=n_grains(min_index(1));
            
            for  k3=1:length(idx)
                k=idx(k3);
                k2=find(point_id_new==n_grains(k));
              test_points1=points_new(k2,:);
              test_inhull=0;
            try
             test_inhull=inhull(points1(i,:),test_points1,[],10^-6);
             catch
                 continue
            end
            if(test_inhull==1)
             grain_new(i)=n_grains(k);

             break;
            end
            end
            
        end
    end
    
        if(i>max(x4))
        break;
    end
end

grain_new(i:length(points1))=grain_test(i:length(points1));


 toc

Grain4=reshape(grain_new,[l2, l1, l3]);
a1=find(Grain4~=Grain2);
save('3d_convex_microstructure.mat')
writeoutput(X,Y,Z,X,X,X,Grain4,Grain4);
              


    
    
    
    
    
    
    


