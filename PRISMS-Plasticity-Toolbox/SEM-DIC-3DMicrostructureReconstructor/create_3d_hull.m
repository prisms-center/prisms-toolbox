clear all
close all
%This script generates the 3d convex hull for the microstructure
load('3d_grain_data.mat');
%No. of divisions
div=50;

Grain2=Grain_new_hull;

grain1=Grain2(:);
[l1 l2 l3]=size(Grain2);
Grain2=Grain2(1:l1,1:l2,1:l3);
grain1=Grain2(:);
total_dist=74.2188;


[X Y Z]=meshgrid(0:total_dist/div:total_dist-total_dist/div);

 vpoints=[];
kpoints=grain1;
n_grains=unique(kpoints);

points=[X(:) Y(:) Z(:)];

convex_points=[];
grain_id=[];
figure (1)

for k=1:length(n_grains)
    
       x3=find(kpoints==n_grains(k));    
      test_points1=points(x3,:);
     
      try
      c_hull=convhulln(points(x3,:));
      catch
          k
          continue
      end
      c_hull2=c_hull(:);
        
     k3=unique(c_hull2);
     convex_points=vertcat(convex_points,test_points1(k3,:));
     grain_id=vertcat(grain_id,n_grains(k)*ones(length(k3),1));
       trisurf(c_hull,test_points1(:,1),test_points1(:,2),test_points1(:,3),'FaceColor',rand(1,3),'FaceAlpha',1)
       hold on

end
save('3d_convex_hull.mat','convex_points','grain_id','l1','l2','l3','n_grains','X','Y','Z','Grain2')