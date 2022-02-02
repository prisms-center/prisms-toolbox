% setting file

working_dir = 'E:\zhec umich Drive\2021-08-20 UM129_Mg_C2 insitu EBSD';
sample_name = 'UM129_Mg_C2';
iE_max = 13;    % maximum iE

% grain file format example:
% 'sample_name grain_file_type_1 iE=0.txt'

% inds of end of half cycles
% e.g., [4,8,11,14] means load step 1-4 = compression cycle 1, 4-8=tension
% cycle 1, 8-11=compression cycle 2, 11-14 = tension cycle 2, ...
inds_half_cycle = [4,8,11,14];

% strain gage reading of each load step
strain_sg = [0, -0.0075, -0.015, -0.025, ...
    -0.023, -0.017, -0.0075, 0.002, ...
    -0.0075, -0.015, -0.025, ...
    -0.017, -0.0075, 0];

% grain IDs of a few selected grains at each load step, used for alignment
grain_pair = [
    20,14,77,81;
    22,16,79,83;
    25,16,81,84;
    25,17,87,91;
    27,17,92,96;
    21,15,82,86;
    22,16,80,84;
    20,15,80,84;
    21,15,81,85;
    24,19,83,87;
    25,17,88,93;
    24,18,86,90;
    21,16,80,83;
    20,15,79,83;
    ];

% ID_list{iB=iE+1}, grains need to be divided into two grains.
% tolerance_cell{iB}, the tolerance angle for these grains
% Note: if a grain needs to be divided into 3 grains, select it twice. The
% larger grain will keep the original grain ID.
ID_list{1} = [86,30]; 
tolerance_cell{1} = [5,5];
ID_list{2} = [86,66,54,78,32]; 
tolerance_cell{2} = [5,5,5,5,5];
ID_list{3} = [80,88,70,57,34]; 
tolerance_cell{3} = [5,5,5,5,5];
ID_list{4} = [86,96,75,61,37]; 
tolerance_cell{4} = [5,5,5,5,5];
ID_list{5} = [91,100,80,66,41];
tolerance_cell{5} = [5,5,5,5,5];
ID_list{6} = [81,91,71,58,34]; 
tolerance_cell{6} = [5,5,5,5,5];
ID_list{7} = [79,88,54,32];
tolerance_cell{7} = [5,5,5,5];
ID_list{8} = [62,89]; 
tolerance_cell{8} = [5,5];
ID_list{9} = [80,88,55]; 
tolerance_cell{9} = [5,5,5];
ID_list{10} = [82,91,58,35]; 
tolerance_cell{10} = [5,5,5,5];
ID_list{11} = [97,76,62,38];
tolerance_cell{11} = [5,5,5,5];
ID_list{12} = [85,94,74,61,38]; 
tolerance_cell{12} = [5,5,5,5,5];
ID_list{13} = [79,87,55];
tolerance_cell{13} = [5,5,5];
ID_list{14} = [88,61,30]; 
tolerance_cell{14} = [5,5,5];

% ID_merge_list{iB=iE+1} = [g1, g2; g3 g4; ...]
% merge g1 into g2, g3 into g4, ...
ID_merge_list{1} = [];
ID_merge_list{2} = [];
ID_merge_list{3} = [];
ID_merge_list{4} = [];
ID_merge_list{5} = [];
ID_merge_list{6} = [];
ID_merge_list{7} = [];
ID_merge_list{8} = [];
ID_merge_list{9} = [];
ID_merge_list{10} = [];
ID_merge_list{11} = [];
ID_merge_list{12} = [];
ID_merge_list{13} = [];
ID_merge_list{14} = [];



