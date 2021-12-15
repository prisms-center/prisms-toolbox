clear ; 
close all ;

%% Read orientation info
% Read orientations
ori_dat = dlmread('orientations.txt','',1,0) ;
% Assign grain ids
gr_ids = ori_dat(:,1) ;
% Assign Frank-Rodrigues vector
rvecs = ori_dat(:,2:4) ;
% Total number of grains 
grtot = size(gr_ids,1) ;

%% Microstructure information
% Voxels in x
grx = 60 ; 
% Voxels in x
gry = 60 ; 
% Voxels in x
grz = 60 ;
% Arrangement of grain ids in the voxelated geometry
micro_info = dlmread('grainID.txt','',[20 0 19+grx*gry grz-1]) ;
% Step size along x
dx = 6.9 ; 
% Step size along y
dy = 6.9 ; 
% Step size along z
dz = 6.9 ;

%% Read slip directions
slp_sys_all = load('slpsyscart_nopyram.txt') ;
slp_dirs = slp_sys_all(:,4:6) ;
slp_dirs = slp_dirs./vecnorm(slp_dirs,2,2) ;
slp_norms = slp_sys_all(:,1:3) ;
slp_norms = slp_norms./vecnorm(slp_norms,2,2) ;

%% Create matrix of grain boundary distances : Number of voxels x Number of
%% slip directions + 3 positions coordinates 
gbdist_all = zeros(grx*gry*grz,4*size(slp_dirs,1)+3) ;    

%% Step 1 : Separate interior and boundary grains 
% Method 2
flgz = zeros(grtot,1) ;
flgy = flgz ;
flgx = flgz ;
flg = flgz ;
% Initialize array of grain ids corresponding to interior grains 
inter_list = [] ; 
% Initialize array of grain ids corresponding to boundary grains 
bndry_list = [] ; 
fprintf("Step 1 : Separating interior and boundary grains. \n")
tic ;
for i=1:grtot
    % Find xy and z indices of voxels with grain id = i
    [idxy,idz] = find(micro_info==i) ;
    % Extract x and y indices from xy index
    idx = floor((idxy-1)/gry)+1 ; 
    idy = idxy - (idx-1)*gry ;
    % Max z index
    maxz = max(idz) ;
    % Max y index
    maxy = max(idy) ;
    % Max x index
    maxx = max(idx) ;
    % Min z index
    minz = min(idz) ;
    % Min y index
    miny = min(idy) ;
    % Min x index
    minx = min(idx) ;
  
    % Check if grain passes through z boundaries
    flgz(i,1) = (maxz==grz && minz==1) ;
    % Check if grain passes through y boundaries
    flgy(i,1) = (maxy==gry && miny==1) ;
    % Check if grain passes through x boundaries
    flgx(i,1) = (maxx==grx && minx==1) ;
    
    % Indicator if grain is a boundary or interior grain 
    % 1 : boundary grain 
    % 0 : interior grain 
    flg(i,1) = flgz(i,1)||flgy(i,1)||flgx(i,1) ;
   
    % Classify grain ids as boundary or interior
    if(~flg(i,1))
        inter_list = [inter_list ; i] ;
    else
        bndry_list = [bndry_list ; i] ;
    end   
end

time_classification = toc ;
fprintf("Step 1 complete. Time consumed = %f seconds\n",time_classification) ;

%% Step 3 : Analyze interior grains only 
% Total number of interior grains 
inter_grtot = size(inter_list,1) ;

tic ;
% Loop over interior grains
for i=1:inter_grtot
  % Obtain grain id  
  gr_id = inter_list(i) ;
  % Obtain corresponding Frank_rodrigues vector 
  ori_grain = rvecs(gr_id,:) ;
  % Rotation matrix from Frank-Rodriguez vector
  rmat = rodtorot(ori_grain') ;
  % Matrix of slip directions in crystal frame 
  slp_dirs_grain = slp_dirs ;
  % Slip directions rotated to sample frame
  slp_dirs_grain = (rmat*slp_dirs_grain')' ; 
  
  % Find all the xy and z indices of voxels with that grain id
  [idxy,idz] = find(micro_info==gr_id) ;
  idx = floor((idxy-1)/gry)+1 ; 
  idy = idxy - (idx-1)*gry ;
  
  % x,y,z ids for neighbors in +ve direction; periodicity considered
  idzplus = mod(idz,grz)+1 ;
  idyplus = mod(idy,gry)+1 ;
  idxplus = mod(idx,grx)+1 ;
  
  % x,y,z ids for neighbors in -ve direction; periodicity considered
  idzminus = mod(idz-2,grz)+1 ;
  idyminus = mod(idy-2,gry)+1 ;
  idxminus = mod(idx-2,grx)+1 ;
       
  % Initialize array of positions of grain boundary vertices 
  gbpos_list = [] ;
  
  %% Step 3 : Identify grain boundary patches 
  % Loop over all voxels 
  for j=1:size(idz,1)
  % x,y,z ids in +ve and -ve direcions     
  idzp = idzplus(j,1) ;
  idzm = idzminus(j,1) ;
  idyp = idyplus(j,1) ;
  idym = idyminus(j,1) ;
  idxp = idxplus(j,1) ;
  idxm = idxminus(j,1) ;
  % x,y,z ids for center voxel
  idzc = idz(j,1) ;
  idyc = idy(j,1) ;
  idxc = idx(j,1) ;
  
  % Check 6 neighboring voxels 
  % z+ 
  vxl_xy = (idxc-1)*gry+idyc ;
  vxl_z = idzp ;
  gr_id_chck = micro_info(vxl_xy,vxl_z) ;
  
  pos_list = [idxc+0.5 , idyc+0.5 , idzc+0.5 ,idxc-0.5 , idyc-0.5 , idzc+0.5 , 3, gr_id_chck ] ;
          
  if(gr_id~=gr_id_chck)
      gbpos_list = [gbpos_list ; pos_list ] ;
  end
  
  % z- 
  vxl_xy = (idxc-1)*gry+idyc ;
  vxl_z = idzm ;
  gr_id_chck = micro_info(vxl_xy,vxl_z) ;
  
  pos_list = [idxc+0.5 , idyc+0.5 , idzc-0.5 , idxc-0.5 , idyc-0.5 , idzc-0.5 , 3, gr_id_chck] ;
          
  if(gr_id~=gr_id_chck)
      gbpos_list = [gbpos_list ; pos_list ] ;
  end
  
  % x+ 
  vxl_xy = (idxp-1)*gry+idyc ;
  vxl_z = idzc ;
  gr_id_chck = micro_info(vxl_xy,vxl_z) ;
  
  pos_list = [idxc+0.5 , idyc+0.5 , idzc+0.5 , idxc+0.5 , idyc-0.5 , idzc-0.5 ,  1, gr_id_chck] ;
          
  if(gr_id~=gr_id_chck)
      gbpos_list = [gbpos_list ; pos_list ] ;
  end
  
  % x- 
  vxl_xy = (idxm-1)*gry+idyc ;
  vxl_z = idzc ;
  gr_id_chck = micro_info(vxl_xy,vxl_z) ;
  
  pos_list = [idxc-0.5 , idyc+0.5 , idzc+0.5 , idxc-0.5 , idyc-0.5 , idzc-0.5 ,  1, gr_id_chck] ;
          
  if(gr_id~=gr_id_chck)
      gbpos_list = [gbpos_list ; pos_list ] ;
  end
  
  % y+ 
  vxl_xy = (idxc-1)*gry+idyp ;
  vxl_z = idzc ;
  gr_id_chck = micro_info(vxl_xy,vxl_z) ;
  
  pos_list = [idxc+0.5 , idyc+0.5 , idzc+0.5 , idxc-0.5 , idyc+0.5 , idzc-0.5 , 2, gr_id_chck] ;
          
  if(gr_id~=gr_id_chck)
      gbpos_list = [gbpos_list ; pos_list ] ;
  end
  
  % y- 
  vxl_xy = (idxc-1)*gry+idym ;
  vxl_z = idzc ;
  gr_id_chck = micro_info(vxl_xy,vxl_z) ;
  
  pos_list = [idxc+0.5 , idyc-0.5 , idzc+0.5 , idxc-0.5 , idyc-0.5 , idzc-0.5 ,  2, gr_id_chck] ;
          
  if(gr_id~=gr_id_chck)
      gbpos_list = [gbpos_list ; pos_list ] ;
  end
  
  end
  
  gbposits = gbpos_list ;
  gbposits(:,1:6) = gbposits(:,1:6)-0.5 ;
  gbposits(:,[1 4]) = gbposits(:,[1 4])*dx ;
  gbposits(:,[2 5]) = gbposits(:,[2 5])*dy ;
  gbposits(:,[3 6]) = gbposits(:,[3 6])*dz ;
  
  
  %% Step 4 : Compute the gb distance for all slip systems for each point in the grain 
  for k=1:size(slp_dirs,1)
    singdir = slp_dirs_grain(k,:) ;  
    
    for j=1:size(idz,1)
     idzc = idz(j,1) ;
     idyc = idy(j,1) ;
     idxc = idx(j,1) ;
     
     vector_indx = (idxc-1)*gry*grz + (idyc-1)*grz + idzc ;
     posvec = [(idxc-0.5)*dx , (idyc-0.5)*dy , (idzc-0.5)*dz ] ;
     gbdist_all(vector_indx,end-2:end) = posvec ;
     gbdist1 = 10^5 ;
     gbdist2 = 10^5 ;
     
     for gbnum=1:size(gbposits,1)
         % x plane GB
         if(gbposits(gbnum,7)==1)
             if(abs(singdir(1,1))>0)
                 tval = (gbposits(gbnum,1)-posvec(1,1))/singdir(1,1) ;
             else
                 tval = 10^12 ;
             end
             
             y_tval = posvec(1,2) + tval*singdir(1,2) ;
             z_tval = posvec(1,3) + tval*singdir(1,3) ;
             
             if(y_tval<=gbposits(gbnum,2) && y_tval>=gbposits(gbnum,5) && z_tval<=gbposits(gbnum,3) && z_tval>=gbposits(gbnum,6) && tval >= 0 )
                 gbdist1 = min(gbdist1,abs(tval)) ;
                 if(gbdist1>=abs(tval))
                     nghbr1 = gbposits(gbnum,8) ;
                 end
                        
             elseif(y_tval<=gbposits(gbnum,2) && y_tval>=gbposits(gbnum,5) && z_tval<=gbposits(gbnum,3) && z_tval>=gbposits(gbnum,6) && tval < 0 )
                 gbdist2 = min(gbdist2,abs(tval)) ;
                 if(gbdist2>=abs(tval))
                     nghbr2 = gbposits(gbnum,8) ;
                 end
             end
             
         end
         
             % y plane GB
         if(gbposits(gbnum,7)==2)
             
             if(abs(singdir(1,2))>0)
                 tval = (gbposits(gbnum,2)-posvec(1,2))/singdir(1,2) ;
             else
                 tval = 10^12 ;
             end
             x_tval = posvec(1,1) + tval*singdir(1,1) ;
             z_tval = posvec(1,3) + tval*singdir(1,3) ;
             
             if(x_tval<=gbposits(gbnum,1) && x_tval>=gbposits(gbnum,4) && z_tval<=gbposits(gbnum,3) && z_tval>=gbposits(gbnum,6) && tval >= 0 )
                 gbdist1 = min(gbdist1,abs(tval)) ;
                 if(gbdist1>=abs(tval))
                     nghbr1 = gbposits(gbnum,8) ;
                 end
             elseif(x_tval<=gbposits(gbnum,1) && x_tval>=gbposits(gbnum,4) && z_tval<=gbposits(gbnum,3) && z_tval>=gbposits(gbnum,6) && tval < 0 )
                 gbdist2 = min(gbdist2,abs(tval)) ;
                 if(gbdist2>=abs(tval))
                     nghbr2 = gbposits(gbnum,8) ;
                 end
             end
             
          end
         
             % z plane GB
         if(gbposits(gbnum,7)==3)
             
             if(abs(singdir(1,3))>0)
                 tval = (gbposits(gbnum,3)-posvec(1,3))/singdir(1,3) ;
             else
                 tval = 10^12 ;
             end
             x_tval = posvec(1,1) + tval*singdir(1,1) ;
             y_tval = posvec(1,2) + tval*singdir(1,2) ;
             
             if(x_tval<=gbposits(gbnum,1) && x_tval>=gbposits(gbnum,4) && y_tval<=gbposits(gbnum,2) && y_tval>=gbposits(gbnum,5) && tval >= 0 )
                 gbdist1 = min(gbdist1,abs(tval)) ;
                 if(gbdist1>=abs(tval))
                     nghbr1 = gbposits(gbnum,8) ;
                 end
             elseif(x_tval<=gbposits(gbnum,1) && x_tval>=gbposits(gbnum,4) && y_tval<=gbposits(gbnum,2) && y_tval>=gbposits(gbnum,5) && tval < 0 )
                 gbdist2 = min(gbdist2,abs(tval)) ;
                 if(gbdist2>=abs(tval))
                     nghbr2 = gbposits(gbnum,8) ;
                 end
             end
             
         end
               
     end
     
     gbdist_all(vector_indx,k) = gbdist1 ;
     gbdist_all(vector_indx,k+size(slp_dirs,1)) = nghbr1 ;
     gbdist_all(vector_indx,k+2*size(slp_dirs,1)) = gbdist2 ;
     gbdist_all(vector_indx,k+3*size(slp_dirs,1)) = nghbr2 ;
     
    end
    
  end
 
end


time_interior = toc ;
fprintf("Step 2 complete. Time consumed = %f seconds\n",time_interior) ;

%% Analyze boundary grains 
bndry_grtot = size(bndry_list,1) ;

tic ;
for i=1:bndry_grtot
  % Consider a particular grain id
  gr_id = bndry_list(i,1) ;
  % Obtain corresponding Frank_rodriguez vector 
  ori_grain = rvecs(gr_id,:) ;
  % Rotation matrix from Frank-Rodriguez vector
  rmat = rodtorot(ori_grain') ;
  % Matrix of slip directions in crystal frame 
  slp_dirs_grain = slp_dirs./vecnorm(slp_dirs,2,2) ;
  
  % Slip directions rotated to sample frame
  slp_dirs_grain = (rmat*slp_dirs_grain')' ;
  
  % Find all the xy and z indices of voxels with that grain id
  [idxy,idz] = find(micro_info==gr_id) ;
  idx = floor((idxy-1)/gry)+1 ; 
  idy = idxy - (idx-1)*gry ;
  
  % x,y,z ids for neighbors in +ve direction
  idzplus = mod(idz,grz)+1 ;
  idyplus = mod(idy,gry)+1 ;
  idxplus = mod(idx,grx)+1 ;
  
  % x,y,z ids for neighbors in -ve direction
  idzminus = mod(idz-2,grz)+1 ;
  idyminus = mod(idy-2,gry)+1 ;
  idxminus = mod(idx-2,grx)+1 ;
       
  % Initialize array of positions of grain boundary vertices 
  gbpos_list = [] ;
  
  % Loop over all voxels 
  for j=1:size(idz,1)
  % x,y,z ids in +ve and -ve direcions     
  idzp = idzplus(j,1) ;
  idzm = idzminus(j,1) ;
  idyp = idyplus(j,1) ;
  idym = idyminus(j,1) ;
  idxp = idxplus(j,1) ;
  idxm = idxminus(j,1) ;
  % x,y,z ids for center voxel
  idzc = idz(j,1) ;
  idyc = idy(j,1) ;
  idxc = idx(j,1) ;
  
    
  %% Check 6 neighboring voxels 
  
  % z+ 
  vxl_xy = (idxc-1)*gry+idyc ;
  vxl_z = idzp ;
  gr_id_chck = micro_info(vxl_xy,vxl_z) ;
  
  pos_list = [idxc+0.5 , idyc+0.5 , idzc+0.5 , idxc-0.5 , idyc-0.5 , idzc+0.5 , 3, gr_id_chck ] ;
          
  if(gr_id~=gr_id_chck)
      gbpos_list = [gbpos_list ; pos_list ] ;
  end
  
  % z- 
  vxl_xy = (idxc-1)*gry+idyc ;
  vxl_z = idzm ;
  gr_id_chck = micro_info(vxl_xy,vxl_z) ;
  
  pos_list = [idxc+0.5 , idyc+0.5 , idzc-0.5 , idxc-0.5 , idyc-0.5 , idzc-0.5 , 3, gr_id_chck] ;
          
  if(gr_id~=gr_id_chck)
      gbpos_list = [gbpos_list ; pos_list ] ;
  end
  
  % x+ 
  vxl_xy = (idxp-1)*gry+idyc ;
  vxl_z = idzc ;
  gr_id_chck = micro_info(vxl_xy,vxl_z) ;
  
  pos_list = [idxc+0.5 , idyc+0.5 , idzc+0.5 , idxc+0.5 , idyc-0.5 , idzc-0.5 ,  1, gr_id_chck] ;
          
  if(gr_id~=gr_id_chck)
      gbpos_list = [gbpos_list ; pos_list ] ;
  end
  
  % x- 
  vxl_xy = (idxm-1)*gry+idyc ;
  vxl_z = idzc ;
  gr_id_chck = micro_info(vxl_xy,vxl_z) ;
  
  pos_list = [idxc-0.5 , idyc+0.5 , idzc+0.5 , idxc-0.5 , idyc-0.5 , idzc-0.5 ,  1, gr_id_chck] ;
          
  if(gr_id~=gr_id_chck)
      gbpos_list = [gbpos_list ; pos_list ] ;
  end
  
  % y+ 
  vxl_xy = (idxc-1)*gry+idyp ;
  vxl_z = idzc ;
  gr_id_chck = micro_info(vxl_xy,vxl_z) ;
  
  pos_list = [idxc+0.5 , idyc+0.5 , idzc+0.5 , idxc-0.5 , idyc+0.5 , idzc-0.5 , 2, gr_id_chck] ;
          
  if(gr_id~=gr_id_chck)
      gbpos_list = [gbpos_list ; pos_list ] ;
  end
  
  % y- 
  vxl_xy = (idxc-1)*gry+idym ;
  vxl_z = idzc ;
  gr_id_chck = micro_info(vxl_xy,vxl_z) ;
  
  pos_list = [idxc+0.5 , idyc-0.5 , idzc+0.5 , idxc-0.5 , idyc-0.5 , idzc-0.5 ,  2, gr_id_chck] ;
          
  if(gr_id~=gr_id_chck)
      gbpos_list = [gbpos_list ; pos_list ] ;
  end
  
  
  end
  
  gbposits = gbpos_list ;
  gbposits(:,1:6) = gbposits(:,1:6)-0.5 ;
  gbposits(:,[1 4]) = gbposits(:,[1 4])*dx ;
  gbposits(:,[2 5]) = gbposits(:,[2 5])*dy ;
  gbposits(:,[3 6]) = gbposits(:,[3 6])*dz ;
  
%   if(i==bndry_grtot)
%       bnd_x = [gbposits(:,1) ; gbposits(:,4) ; gbposits(:,7) ; gbposits(:,10) ];
%       bnd_y = [gbposits(:,2) ; gbposits(:,5) ; gbposits(:,8) ; gbposits(:,11) ];
%       bnd_z = [gbposits(:,3) ; gbposits(:,6) ; gbposits(:,9) ; gbposits(:,12) ];
%       
%       figure ;
%       scatter3(bnd_x,bnd_y,bnd_z,40,'r','filled') ;
%   end
 
  % Shift positions based on which part of microstructure wraps around 
  
  flg_x = flgx(gr_id,1)&(max(gbposits(:,[1 4 ]),[],2)<=grx*dx/2) ;
  flg_y = flgy(gr_id,1)&(max(gbposits(:,[2 5 ]),[],2)<=gry*dy/2) ;
  flg_z = flgz(gr_id,1)&(max(gbposits(:,[3 6 ]),[],2)<=grz*dz/2) ;
  
  
  gbposits_mod = gbposits ; 
  gbposits_mod(:,[1 4 ]) = gbposits(:,[1 4 ]) + flg_x*grx*dx ;
  gbposits_mod(:,[2 5 ]) = gbposits(:,[2 5 ]) + flg_y*gry*dy ;
  gbposits_mod(:,[3 6 ]) = gbposits(:,[3 6 ]) + flg_z*grz*dz ;
  
 
  %% Compute the gb distance for all slip systems for each point in the grain 
  for k=1:size(slp_dirs,1)
    singdir = slp_dirs_grain(k,:) ;  
    
    for j=1:size(idz,1)
     idzc = idz(j,1) ;
     idyc = idy(j,1) ;
     idxc = idx(j,1) ;
     
     vector_indx = (idxc-1)*gry*grz + (idyc-1)*grz + idzc ;
        
     
     posvec = [(idxc-0.5)*dx , (idyc-0.5)*dy , (idzc-0.5)*dz ] ;
     gbdist_all(vector_indx,end-2:end) = posvec ;
         
     flg_xc = 0 ;
     flg_yc = 0 ;
     flg_zc = 0 ;
     
     
     if(flgx(gr_id,1) && (posvec(1,1)<=grx*dx/2))
     flg_xc = 1 ;
     end 
     
     if(flgy(gr_id,1) && (posvec(1,2)<=gry*dy/2))
     flg_yc = 1 ;
     end
     
     if(flgz(gr_id,1) && (posvec(1,3)<=grz*dz/2))
     flg_zc = 1 ;
     end
     
     posvec = [(idxc-0.5)*dx + flg_xc*grx*dx , (idyc-0.5)*dy + flg_yc*gry*dy , (idzc-0.5)*dz + flg_zc*grz*dz ] ;
     gbdist1 = 10^5 ;
     gbdist2 = 10^5 ;
     
     for grnum=1:size(gbposits_mod,1)
         % x plane GB
         if(gbposits_mod(grnum,7)==1)
             
             if(abs(singdir(1,1))>0)
                 tval = (gbposits_mod(grnum,1)-posvec(1,1))/singdir(1,1) ;
             else
                 tval = 10^12 ;
             end
             y_tval = posvec(1,2) + tval*singdir(1,2) ;
             z_tval = posvec(1,3) + tval*singdir(1,3) ;
             
             if(y_tval<=gbposits_mod(grnum,2) && y_tval>=gbposits_mod(grnum,5) && z_tval<=gbposits_mod(grnum,3) && z_tval>=gbposits_mod(grnum,6) && tval >= 0 )
                 gbdist1 = min(gbdist1,abs(tval)) ;
                 if(gbdist1>=abs(tval))
                     nghbr1 = gbposits_mod(grnum,8) ;
                 end
                 
             elseif(y_tval<=gbposits_mod(grnum,2) && y_tval>=gbposits_mod(grnum,5) && z_tval<=gbposits_mod(grnum,3) && z_tval>=gbposits_mod(grnum,6) && tval < 0 )
                 gbdist2 = min(gbdist2,abs(tval)) ;
                 if(gbdist2>=abs(tval))
                     nghbr2 = gbposits_mod(grnum,8) ;
                 end
             end
             
             end
         
             % y plane GB
         if(gbposits_mod(grnum,7)==2)
             
             if(abs(singdir(1,2))>0)
                 tval = (gbposits_mod(grnum,2)-posvec(1,2))/singdir(1,2) ;
             else
                 tval = 10^12 ;
             end
             x_tval = posvec(1,1) + tval*singdir(1,1) ;
             z_tval = posvec(1,3) + tval*singdir(1,3) ;
             
             if(x_tval<=gbposits_mod(grnum,1) && x_tval>=gbposits_mod(grnum,4) && z_tval<=gbposits_mod(grnum,3) && z_tval>=gbposits_mod(grnum,6) && tval >= 0 )
                 gbdist1 = min(gbdist1,abs(tval)) ;
                 if(gbdist1>=abs(tval))
                     nghbr1 = gbposits_mod(grnum,8) ;
                 end
             elseif(x_tval<=gbposits_mod(grnum,1) && x_tval>=gbposits_mod(grnum,4) && z_tval<=gbposits_mod(grnum,3) && z_tval>=gbposits_mod(grnum,6) && tval < 0 )
                 gbdist2 = min(gbdist2,abs(tval)) ;
                 if(gbdist2>=abs(tval))
                     nghbr2 = gbposits_mod(grnum,8) ;
                 end
             end
             
             end
         
             % z plane GB
         if(gbposits_mod(grnum,7)==3)
             
             if(abs(singdir(1,3))>0)
                 tval = (gbposits_mod(grnum,3)-posvec(1,3))/singdir(1,3) ;
             else
                 tval = 10^12 ;
             end
             x_tval = posvec(1,1) + tval*singdir(1,1) ;
             y_tval = posvec(1,2) + tval*singdir(1,2) ;
             
             if(x_tval<=gbposits_mod(grnum,1) && x_tval>=gbposits_mod(grnum,4) && y_tval<=gbposits_mod(grnum,2) && y_tval>=gbposits_mod(grnum,5) && tval >= 0 )
                 gbdist1 = min(gbdist1,abs(tval)) ;
                 if(gbdist1>=abs(tval))
                     nghbr1 = gbposits_mod(grnum,8) ;
                 end
             elseif(x_tval<=gbposits_mod(grnum,1) && x_tval>=gbposits_mod(grnum,4) && y_tval<=gbposits_mod(grnum,2) && y_tval>=gbposits_mod(grnum,5) && tval < 0 )
                 gbdist2 = min(gbdist2,abs(tval)) ;
                 if(gbdist2>=abs(tval))
                     nghbr2 = gbposits_mod(grnum,8) ;
                 end
             end
             
         end
               
     end
      
     gbdist_all(vector_indx,k) = gbdist1 ;
     gbdist_all(vector_indx,k+size(slp_dirs,1)) = nghbr1 ;
     gbdist_all(vector_indx,k+2*size(slp_dirs,1)) = gbdist2 ;
     gbdist_all(vector_indx,k+3*size(slp_dirs,1)) = nghbr2 ;
    end
    
  end
    
end
time_boundary = toc ;
fprintf("Step 3 complete. Time consumed = %f seconds\n",time_boundary) ;


%% Single grain plot
% bndry_grnum = 1 ;
% figure ;
% gr_id_choice = bndry_list(bndry_grnum,1)  ;
% slip_choice = 2 ;
% [gr_id_choice_xy,gr_id_choice_z] = find(micro_info==gr_id_choice) ;
%  
% gr_id_choice_x = floor((gr_id_choice_xy-1)/gry)+1 ;
% gr_id_choice_y = gr_id_choice_xy - (gr_id_choice_x-1)*gry ;
% vector_id = (gr_id_choice_xy - 1)*grz + gr_id_choice_z ;
% gbdist_choice = gbdist_all(vector_id,slip_choice) ;
% 
% xdist_choice = (gr_id_choice_x - 0.5)*dx ;
% ydist_choice = (gr_id_choice_y - 0.5)*dy ;
% zdist_choice = (gr_id_choice_z - 0.5)*dz ;
% 
% 
% scatter3(xdist_choice,ydist_choice,zdist_choice,40,gbdist_choice,'filled') ;

%% Plot gb distance
% slip_choice = 18 ;
% figure ;
% scatter3(gbdist_all(:,end-2),gbdist_all(:,end-1),gbdist_all(:,end),100,gbdist_all(:,slip_choice),'filled') ;
% axis([ 0 grx*dx 0 gry*dy 0 grz*dz ]) ;
% 
% colorbar ;
% xlabel('$x (\mu m) \rightarrow$','interpreter','latex') ;
% ylabel('$y (\mu m)\rightarrow$','interpreter','latex') ;
% zlabel('$z (\mu m)\rightarrow$','interpreter','latex') ;
% 
% slip_choice = 1 ;
% figure ;
% scatter3(gbdist_all(:,end-2),gbdist_all(:,end-1),gbdist_all(:,end),100,gbdist_all(:,slip_choice),'filled') ;
% axis([ 0 grx*dx 0 gry*dy 0 grz*dz ]) ;
% 
% colorbar ;
% xlabel('x') ;
% ylabel('y') ;
% zlabel('z') ;


%% Compute micro HP multiplier
voxel_tot = size(gbdist_all,1) ;
slipnums = size(slp_dirs,1) ;
mhp_mult = zeros(voxel_tot,slipnums) ;
micro_info_vect = reshape(micro_info',voxel_tot,1) ;
c_exp_basal = 0.6 ;
c_exp_prismatic = 1.07 ;
tic ; 

for i=1:voxel_tot
    
    rodvec = rvecs(micro_info_vect(i,1),:) ;
    rotmat = rodtorot(rodvec') ;
    
    for j=1:slipnums
        
        
        dist1 = gbdist_all(i,j) ;
        rodvec1 = rvecs(gbdist_all(i,j+slipnums),:) ;
        dist2 = gbdist_all(i,j+2*slipnums) ;
        rodvec2 = rvecs(gbdist_all(i,j+3*slipnums),:) ; 
        
        rotmat1 = rodtorot(rodvec1') ;
        rotmat2 = rodtorot(rodvec2') ;
        
        slp_dirs1 = (rotmat1*slp_dirs')' ;
        slp_dirs2 = (rotmat2*slp_dirs')' ;
        
               
        slp_norms1 = (rotmat1*slp_norms')' ;
        slp_norms2 = (rotmat2*slp_norms')' ;
        
        
        slp_dirs_voxel = (rotmat*slp_dirs(j,:)')' ;
        
        slp_norms_voxel = (rotmat*slp_norms(j,:)')' ;
        
        
        m1 = slp_dirs_voxel*(slp_dirs1)' ;
        n1 = slp_norms_voxel*(slp_norms1)' ;
        % Corrected bug
        mprime_1 = max(abs(m1.*n1)) ;

        m2 = slp_dirs_voxel*(slp_dirs2)' ;
        n2 = slp_norms_voxel*(slp_norms2)' ;
        
        % Corrected bug
        mprime_2 = max(abs(m2.*n2)) ;
        
        % Choose maximum of both compatibility factors - Prof. Qi's
        % suggestion
        mprime_final = max(mprime_1,mprime_2) ;
        
        if j<4 
            mhp_mult(i,j) = 1/sqrt(dist1 + dist2)*(1-mprime_final)^c_exp_basal ;
        elseif j>3 && j<7
            mhp_mult(i,j) = 1/sqrt(dist1 + dist2)*(1-mprime_final)^c_exp_prismatic ;
        else
            mhp_mult(i,j) = 0 ;
        end          
       
    end
        
end

time_mhp = toc ;
fprintf("Step 4 complete. Time consumed = %f seconds\n",time_mhp) ;

%% Setup output file 
fl_ori = fopen('orientations_modified.txt','w') ;
voxelnums = linspace(1,grx*gry*grz,grx*gry*grz)'; 
fprintf(fl_ori,"Orientations and micro-Hall-Petch multipliers \n") ;
combined_data = [voxelnums,rvecs(micro_info_vect,:),mhp_mult,micro_info_vect] ;

fl_format = '%d \t ' ;

for i=1:(3+slipnums)
    fl_format = [fl_format,'%f \t'] ;
end

fl_format = [fl_format , '%d \n'] ;

fprintf(fl_ori,fl_format,combined_data') ;



fclose(fl_ori) ;

fl_gids = fopen('grainID_modified.txt','w') ;
voxelnums = linspace(1,grx*gry*grz,grx*gry*grz)'; 
voxel_order = reshape(voxelnums,grz,grx*gry) ;
fprintf(fl_gids,"Grains : %d x %d x %d \n",grx,gry,grz) ;
fl_format = '%d ' ;
for i=1:grz-1
    fl_format = [fl_format,'\t %d'] ;
end

fl_format = [fl_format,'\n'] ;
fprintf(fl_gids,fl_format,voxel_order) ;
fclose(fl_gids) ;
