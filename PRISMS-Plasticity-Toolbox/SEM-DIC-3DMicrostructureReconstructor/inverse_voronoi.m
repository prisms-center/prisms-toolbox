clear all
close all
load('input_data.mat');
n_grains=unique(kpoints);

convex_points=[];
grain_id=[];


hold on

null_grains=[];

for i=1:length(n_grains)
    
    test_points=vpoints((kpoints==n_grains(i)),:);
     try
  c_hull=convhulln(test_points);
     catch
       
      null_grains=[null_grains;i];
      continue
  end
    
    
    c_hull=c_hull(:,1);
    c_hull(size(c_hull,1)+1)=c_hull(1);
    
    convex_points=vertcat(convex_points,test_points(c_hull,:));
    grain_id=vertcat(grain_id,n_grains(i)*ones(length(c_hull),1));
    
    plot(test_points(c_hull,1),test_points(c_hull,2),'color',rand(1,3));
    
    
end


convex_points2=[];
grain_id2=[];


figure (2)

hold on

for i=length(n_grains):-1:1
    i
    if(find(i==null_grains))
        continue
    end
    
    test1=find((grain_id2==n_grains(i)));
    if(isempty(test1))
        test_points=convex_points((grain_id==n_grains(i)),:);
    else
        test_points=convex_points2((grain_id2==n_grains(i)),:);
    end
    
    for j=1:length(n_grains)
        
                 if(find(i==null_grains))
        break
    end
        
        
            if(find(j==null_grains))
        continue
    end
        
        
        if(j==i)
            continue;
        end
        test1=find((grain_id2==n_grains(j)));
        if(isempty(test1))
            test_points2=convex_points((grain_id==n_grains(j)),:);
        else
            test_points2=convex_points2((grain_id2==n_grains(j)),:);
        end
        [interior_points1, on]=inpolygon(test_points(:,1),test_points(:,2),test_points2(:,1),test_points2(:,2));
        interior_points1=interior_points1-on;
        in_points1=test_points((interior_points1==1),:);
        [interior_points2, on]=inpolygon(test_points2(:,1),test_points2(:,2),test_points(:,1),test_points(:,2));
        interior_points2=interior_points2-on;
        in_points2=test_points2((interior_points2==1),:);
%         if(sum([interior_points1;interior_points2])==0)
%             continue;
%         end
        
        %         [A1,b1,Aeq1,beq1]=vert2lcon(test_points);
        %         [A2,b2,Aeq2,beq2]=vert2lcon(test_points2);
        %         V_intersection=lcon2vert([A1;A2],[b1;b2],[Aeq1 Aeq2],[beq1 beq2]);
        
        P3.x=test_points(:,1);
        P3.y=test_points(:,2);
        P4.x=test_points2(:,1);
        P4.y=test_points2(:,2);
        P5=PolygonClip(P3,P4,1);
        
        V_intersection=[P5.x P5.y];
        
        if(isempty(V_intersection))
            continue
        end
        
        [in on1]=inpolygon(V_intersection(:,1),V_intersection(:,2), test_points(:,1), test_points(:,2));
        [in on2]=inpolygon(V_intersection(:,1),V_intersection(:,2), test_points2(:,1), test_points2(:,2));
        test_points(inpolygon(test_points(:,1), test_points(:,2),V_intersection(:,1),V_intersection(:,2)),:)=[];
        test_points2(inpolygon(test_points2(:,1), test_points2(:,2),V_intersection(:,1),V_intersection(:,2)),:)=[];
        
        new_points2=vertcat(test_points,V_intersection(on1&on2,:));
        new_points3=vertcat(test_points2,V_intersection(on1&on2,:));
        
         try
  c_hull=convhull(new_points2(:,1),new_points2(:,2));
     catch
       
      null_grains=[null_grains;i];
      continue
  end

        test_points=new_points2(c_hull,:);
        
                 try
          c_hull=convhull(new_points3(:,1),new_points3(:,2));
     catch
       
      null_grains=[null_grains;j];
      continue
  end
        
        
        

        test_points2=new_points3(c_hull,:);
        
        convex_points2((grain_id2==n_grains(j)),:)=[];
        grain_id2((grain_id2==n_grains(j)),:)=[];
        
        convex_points2((grain_id2==n_grains(i)),:)=[];
        
        grain_id2((grain_id2==n_grains(i)),:)=[];
        
        convex_points2=vertcat(convex_points2,test_points);
        grain_id2=vertcat(grain_id2,n_grains(i)*ones(length(test_points),1));
        
        convex_points2=vertcat(convex_points2,test_points2);
        grain_id2=vertcat(grain_id2,n_grains(j)*ones(length(test_points2),1));
        
        
        
    end
    plot(test_points(:,1),test_points(:,2),'color',rand(1,3));
    
 end



convex_points3=[];
grain_id3=[];
for i=1:length(n_grains)
        if(find(i==null_grains))
        continue
    end
    
    test_points=convex_points2((grain_id2==n_grains(i)),:);
    
    Ndecimals=7;
    f = 10.^Ndecimals ;
    test_points=round(f*test_points)/f;
    
    try
    c_hull=convhulln(test_points);
    catch
         null_grains=[null_grains;i];
      continue
  end
    
    
    c_hull=c_hull(:,1);
    c_hull(size(c_hull,1)+1)=c_hull(1);
    
    test_points4=test_points(c_hull,:);
    test_points4(size(test_points4,1),:)=[];
    
    convex_points3=vertcat(convex_points3,test_points4);
    grain_id3=vertcat(grain_id3,n_grains(i)*ones(size(test_points4,1),1));
    
    
end


Ndecimals=7;
f = 10.^Ndecimals ;
convex_points3=round(f*convex_points3)/f;



in_polygon=zeros(length(convex_points3),length(n_grains));
neighbors=zeros(length(convex_points3),2);

for i=1:length(n_grains)
    
      if(find(i==null_grains))
        continue
    end
    array=find(grain_id3==n_grains(i));
    neighbors(array,1)=circshift(array,1);
    neighbors(array,2)=circshift(array,-1);
    test_points=convex_points3(array,:);
    
    in_polygon(:,i)=inpolygon(convex_points3(:,1),convex_points3(:,2),test_points(:,1),test_points(:,2));
end

sum_in_polygon=sum(in_polygon')';

[points_unique indices_unique]=unique(convex_points3,'rows');

sum_in_polygon_unique=sum_in_polygon(indices_unique);
neighbors_unique=neighbors(indices_unique,:);

%%% 3 edge vertex

edge_3=find( sum_in_polygon_unique==3);

A_mat=[1 1 0;0 1 1;1 0 1];
inv_A_mat=inv(A_mat);
voronoi_points=[];

for i=1:length(edge_3)
    
    index=edge_3(i);
    
    point1=points_unique(index,:);
    
    points_neighbor=convex_points3(neighbors(ismember(convex_points3,point1,'rows'),1),:);
    points_neighbor=vertcat( points_neighbor,convex_points3(neighbors(ismember(convex_points3,point1,'rows'),1),:));
    points_neighbor=unique(points_neighbor,'rows');
    
    [l1 l2]=size( points_neighbor);
    
    if(l1~=3)
        continue
    end
    
    for j=1:3
        vectors(j,:)=points_neighbor(j,:)-point1;
        vectors(j,:)=vectors(j,:)/norm(vectors(j,:));
        
    end
    
    
    vectors2=circshift(vectors,[-1 0]);
    for j=1:3
        
        angles(j)=acos(dot(vectors(j,:),vectors2(j,:))/norm(vectors(j,:))/norm(vectors2(j,:)));
    end
 
    
    angles2=inv_A_mat*angles';
    radius=0.5;
    dist1=radius*cos(angles2);
    dist2=radius*sin(angles2);
    new_points1=[];
    
    for j=1:3
        
        new_points1(j,:)= point1+dist1(j)* vectors(j,:);
    end
    
    vectors3(:,1)=vectors(:,2);
    vectors3(:,2)=-vectors(:,1);
    
    new_points2=[];
    for j=1:3
        
        new_points2(j,:)= new_points1(j,:)+dist2(j)* vectors3(j,:);
    end
    
    voronoi_points=vertcat(voronoi_points,new_points2);
    
    
end
voronoi_points2=real(voronoi_points);
figure (2)
hold on
voronoi(voronoi_points2(:,1),voronoi_points2(:,2))
axis equal


 
figure(3)
voronoi(voronoi_points2(:,1),voronoi_points2(:,2))

axis equal


figure (3)


hold on


for i=1:length(n_grains)
     if(find(i==null_grains))
        continue
    end
    test_points=convex_points3((grain_id3==n_grains(i)),:);
    
    c_hull=convhulln(test_points);
    c_hull=c_hull(:,1);
    c_hull(size(c_hull,1)+1)=c_hull(1);
    
    plot(test_points(c_hull,1),test_points(c_hull,2),'color','k','linewidth',3);
    
    
end
load('grain_t5_fov4.mat');
figure (4)



voronoi(voronoi_points2(:,1),voronoi_points2(:,2))
axis equal


hold on

points7=[X(:) Y(:)];
grain_new7=zeros(length(points7),1);

for i=1:length(n_grains)
    i
    if(find(i==null_grains))
        continue
    end
    test_points=convex_points3((grain_id3==n_grains(i)),:);
    
    grain_new7(inhull(points7,test_points,[],10^-6))=n_grains(i);
    
    c_hull=convhulln(test_points);
    c_hull=c_hull(:,1);
    c_hull(size(c_hull,1)+1)=c_hull(1);
    
    plot(test_points(c_hull,1),test_points(c_hull,2),'color','k','linewidth',3);
    
    
end

xlim([0 75])
ylim([0 75])

error=length(find(grain_new7~=Grain2(:)))/length(Grain2(:))

surf(X,Y,-Grain2,'EdgeColor','None')
view(2)
% shading interp
grid off 
 colormap jet
colorbar
hold on


voronoi_point_id=zeros(length(voronoi_points2),1);
for i=1:length(n_grains)
    if(find(i==null_grains))
        continue
    end
    test_points=convex_points3((grain_id3==n_grains(i)),:);
    
    
    voronoi_point_id(inpolygon(voronoi_points2(:,1), voronoi_points2(:,2),test_points(:,1),test_points(:,2)))=n_grains(i);
 
       
    
end

save('voronoi_points.mat','voronoi_point_id','voronoi_points2');
