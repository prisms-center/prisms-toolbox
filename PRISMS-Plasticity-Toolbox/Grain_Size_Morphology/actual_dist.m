% Clear memory
clear  ;
% Close figures
close all ;

% Load file containing Axes Euler angles and Semi-axes lengths
fname1 = 'ellipse_data.txt' ;
file1 = dlmread(fname1,'',1,0) ;

% Column 1 : Grain ID
gids = file1(:,1) ;

% Column 2-4 : Axes Euler angles
axeul = file1(:,2:4) ;

% Column 5-7 : Axes lengths 
axlens = file1(:,5:7) ;

% Load file containing grain IDs and crystal orientations 
% Crystal orientations represented as 3 components of a Rodrigues vector 
fname2 = 'orientations.txt' ;
file2 = dlmread(fname2,'',1,0) ;

% Slip directions
fname3 = 'slipDirections.input' ;
dirlist = load(fname3) ;

% Slip normals
fname4 = 'slipNormals.input' ;
normlist = load(fname4) ;


% Column 2-4 : Crystal orientations 
orrod = file1(:,2:4) ;

% Initialize matrix of slip system-level distances 
davrg=zeros(size(orrod,1),size(dirlist,1)) ;

% Slip directions in crystal reference frame 
slpdir = dirlist ;
% Normalize slip directions 
slpdir = slpdir./vecnorm(slpdir')' ;
% Slip plane normals in crystal reference frame
slpnorm = normlist ;
% Normalize slip plane normal
slpnorm = slpnorm./vecnorm(slpnorm')' ;
% Crystallographic direction perpendicular to slip direction and 
% slip plane normal. 
slpline = cross(slpdir,slpnorm) ;

for datnum=1:size(orrod,1)
    % Axis rotation matrix from Euler angles
    rotmat = eul2mat(axeul(datnum,:)) ;

    % Crystallographic rotation matrix from Rodrigues vector
    crmat = rodtorot(orrod(datnum,:)') ;

    % Slip direction in Axis frame
    totalrot = rotmat*crmat ;
    totalrot = totalrot/det(totalrot) ;

    % Slip direction in ellipsoid principal reference frame
    slpdir_mod = (totalrot*slpdir')' ;
    % Slip line in ellipsoid principal reference frame
    slpline_mod = (totalrot*slpline')' ;

    % Ellipsoid semi-axes lengths
    lns = axlens(datnum,:);
    % Semi-distance averaged along slip direction
    d_dir = 2.0/3.0*1.0./sqrt(sum((slpdir_mod.*slpdir_mod)'./(lns'.*lns'),1)) ;
    % Semi-distance averaged along slip line
    d_line = 2.0/3.0*1.0./sqrt(sum((slpline_mod.*slpline_mod)'./(lns'.*lns'),1)) ;
    
    % Compute slip system-level grain size using shape factor expression
    s_eff = pi*d_dir.*d_line ;
    h_eff = (d_dir - d_line)./(d_dir + d_line).*(d_dir - d_line)./(d_dir + d_line) ;
    c_eff = pi*(d_dir + d_line).*(1 + 3*h_eff./(10 + sqrt(4 - 3*h_eff))) ;
    v_eff = 4/3*pi*lns(1)*lns(2)*lns(3) ;
    davrg(datnum,:) = ((4*s_eff./c_eff).^2)/(v_eff^(1.0/3)) ;
end

% Create string to format file output 
outputstr = '%d\t%f\t%f\t%f\t' ;
for i=1:size(dirlist,1)
    outputstr = [outputstr,'%f \t '] ;
end
outputstr = [outputstr,'\n'] ;

% Create new file with crystal orientations and slip system-level grain
% size for all slip systems
fname = 'orientations_sizes.txt';
fileID = fopen(fname,'w') ;
% File header
fprintf(fileID,'# \n') ;
% Write output to file
fprintf(fileID,outputstr,[file2, davrg]') ;
fclose(fileID) ;

