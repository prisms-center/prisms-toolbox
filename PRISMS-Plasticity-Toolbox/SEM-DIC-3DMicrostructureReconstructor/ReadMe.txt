This folder contains the data files and matlab scripts required to construct the 3D microstructure.


Set path to polygon_clipper


input is DIC data x,y data, orientation: Grain_data.mat
first two steps use geometry, third step includes euler angles

The procedure is as follows 

1) Run create_data.m
Creates all the pixels along the boundaries of grains from raw data
Input : Grain_data.mat -contains X,Y and GrainID
Output : input_data.mat -contains the boundary points of the grains

2) inverse_voronoi.m

Input : input_data.mat- -contains the boundary points of the grains
Output: voronoi_points.mat -contains the grain_id and voronoi points of convexified grains

3) generate_3d.m

Input : voronoi_points.mat -contains the grain_id and voronoi points of convexfied grains
	Surface_map_data.mat -contains the euler angles and grain ids of the surface grains
	Ebsd_data.mat -contains the euler angles and grain ids of the EBSD map

Output : 3d_grain_data.mat -contains the voxelated 3d microstructure, writes out a paraview file 'T5_hull_3_surf6.vtk'
eulerangledata.mat contains the euler angles for each grain id.

4)create_3d_hull.m
Rough convexification may have intersections
Input :3d_grain_data.mat -contains the voxelated 3d microstructure
Output: 3d_convex_hull.mat -contains the convex hull data of 3d microstructure

5)create_3d_convexmicrostructure.m
This file cleans up the intersections of convex hulls, if any, found in step 4

Input :3d_grain_data.mat and 3d_convex_hull.mat 
	3d_convex_hull.mat -contains the cleaned up convex hull data of 3d microstructure 

Output : 3d_convex_microstructure.mat -contains the 3d convexified microstructure, grain4 is the final microstructure

The size of the 3D image is given by the parameter "div" (eg. line 15 in generate_3d), change in all places where div is used.

The euler angles are assigned in 3d_grain_data.mat using grain IDs.


To compare DIC and 3D surface
load('Grain_data.mat')
surf(Grain2,'edgecolor','none');view(2)
figure
load('3d_convex_microstructure.mat')
surf(Grain4(:,:,1),'edgecolor','none');view(2)