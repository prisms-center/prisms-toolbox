clear all 
close all

%Load voronoi points and euler angles of surface data

load('voronoi_points.mat');
load('Surface_map_data.mat');


% Random number generator 
s=rng;
rng(1)

%No. of divisions
div=50;

%size of the microstructure
total_dist= 74.2188;

voronoi_points2(:,3)=(rand(length(voronoi_points2),1)-0.5)*2*0.5;

point_mean(:,3)=0;
sig=7; %0.5*average grain size
grain_unique_new=voronoi_point_id;
v_point_new=voronoi_points2;
grain_euler_new=grain_euler;
v_point_new(find(grain_unique_new==0),:)=[];
grain_unique_new(find(grain_unique_new==0))=[];

grain_euler_3d(grain_unique,:)=grain_euler;


%EBSD data contains grain centroids and grain euler angles
load('Ebsd_data.mat')

point_mean_t5_ebsd=point_mean;
grain_unique_t5_ebsd=grain_unique;
grain_euler_t5_ebsd=grain_euler;


x_init=50;
y_init=50;

grain_id=find(inhull(point_mean_t5_ebsd,[ x_init x_init+total_dist x_init x_init+total_dist;y_init y_init y_init+total_dist y_init+total_dist]')==1);

point_mean=point_mean_t5_ebsd(grain_id,:)-ones(length(grain_id),1)*[x_init y_init];
grain_euler=grain_euler_t5_ebsd(grain_id,:);


rng(2)

point_mean(:,3)=13*ones(length(point_mean),1)+sig*(2*(rand(length(point_mean),1)-0.5));
grain_unique=max(grain_unique_new)+(1:length(grain_id));
grain_unique_new=vertcat(grain_unique_new,grain_unique');
grain_euler_new=vertcat(grain_euler_new,grain_euler);

grain_euler_3d=vertcat(grain_euler_3d,grain_euler);

v_point_new=vertcat(v_point_new,point_mean);


rng(3)

x_init=200;
y_init=200;

grain_id=find(inhull(point_mean_t5_ebsd,[ x_init x_init+total_dist x_init x_init+total_dist;y_init y_init y_init+total_dist y_init+total_dist]')==1);

point_mean=point_mean_t5_ebsd(grain_id,:)-ones(length(grain_id),1)*[x_init y_init];
grain_euler=grain_euler_t5_ebsd(grain_id,:);

point_mean(:,3)=26*ones(length(point_mean),1)+sig*(2*(rand(length(point_mean),1)-0.5));
grain_unique=max(grain_unique_new)+(1:length(grain_id));
grain_unique_new=vertcat(grain_unique_new,grain_unique');
grain_euler_new=vertcat(grain_euler_new,grain_euler);
grain_euler_3d=vertcat(grain_euler_3d,grain_euler);

v_point_new=vertcat(v_point_new,point_mean);

rng(4)

x_init=300;
y_init=300;

grain_id=find(inhull(point_mean_t5_ebsd,[ x_init x_init+total_dist x_init x_init+total_dist;y_init y_init y_init+total_dist y_init+total_dist]')==1);

point_mean=point_mean_t5_ebsd(grain_id,:)-ones(length(grain_id),1)*[x_init y_init];
grain_euler=grain_euler_t5_ebsd(grain_id,:);

point_mean(:,3)=39*ones(length(point_mean),1)+sig*(2*(rand(length(point_mean),1)-0.5));
grain_unique=max(grain_unique_new)+(1:length(grain_id));
grain_unique_new=vertcat(grain_unique_new,grain_unique');
grain_euler_new=vertcat(grain_euler_new,grain_euler);
grain_euler_3d=vertcat(grain_euler_3d,grain_euler);

v_point_new=vertcat(v_point_new,point_mean);

rng(5)

x_init=400;
y_init=400;

grain_id=find(inhull(point_mean_t5_ebsd,[ x_init x_init+total_dist x_init x_init+total_dist;y_init y_init y_init+total_dist y_init+total_dist]')==1);

point_mean=point_mean_t5_ebsd(grain_id,:)-ones(length(grain_id),1)*[x_init y_init];
grain_euler=grain_euler_t5_ebsd(grain_id,:);

point_mean(:,3)=52*ones(length(point_mean),1)+sig*(2*(rand(length(point_mean),1)-0.5));
grain_unique=max(grain_unique_new)+(1:length(grain_id));
grain_unique_new=vertcat(grain_unique_new,grain_unique');
grain_euler_new=vertcat(grain_euler_new,grain_euler);
grain_euler_3d=vertcat(grain_euler_3d,grain_euler);

v_point_new=vertcat(v_point_new,point_mean);

rng(6)

x_init=500;
y_init=500;

grain_id=find(inhull(point_mean_t5_ebsd,[ x_init x_init+total_dist x_init x_init+total_dist;y_init y_init y_init+total_dist y_init+total_dist]')==1);

point_mean=point_mean_t5_ebsd(grain_id,:)-ones(length(grain_id),1)*[x_init y_init];
grain_euler=grain_euler_t5_ebsd(grain_id,:);

point_mean(:,3)=65*ones(length(point_mean),1)+sig*(2*(rand(length(point_mean),1)-0.5));
grain_unique=max(grain_unique_new)+(1:length(grain_id));
grain_unique_new=vertcat(grain_unique_new,grain_unique');
grain_euler_new=vertcat(grain_euler_new,grain_euler);
grain_euler_3d=vertcat(grain_euler_3d,grain_euler);

v_point_new=vertcat(v_point_new,point_mean);



[X1 Y1 Z1]=meshgrid(0:total_dist/div:total_dist-total_dist/div,0:total_dist/div:total_dist-total_dist/div,0:total_dist/div:total_dist-total_dist/div);

[y_dim x_dim z_dim]= size(X1);

for i=1:x_dim
    i
    for j=1:y_dim
        for k=1:z_dim
        
        coord=ones(length(grain_unique_new),1)*[X1(j,i,k),Y1(j,i,k),Z1(j,i,k)];
        [ min_dist g_id]=min(sum((coord-v_point_new)'.*(coord-v_point_new)'));
        Grain_new_hull(j,i,k)=grain_unique_new(g_id);
     end
    end
end

rng(7)
new_perm=randperm(max(grain_unique_new));

Grain_new_hull2=new_perm(Grain_new_hull);
writeoutput(X1,Y1,Z1,X1,X1,X1,Grain_new_hull,Grain_new_hull2)
save('3d_grain_data.mat','Grain_new_hull');

save('eulerangledata.mat','grain_euler_3d');




