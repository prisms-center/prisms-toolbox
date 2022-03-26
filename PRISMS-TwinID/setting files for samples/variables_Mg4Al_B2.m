% setting file

working_dir = 'E:\zhec umich Drive\2021-12-04 Mg4Al_B2 insitu EBSD';
sample_name = 'Mg4Al_B2';
iE_max = 13;    % maximum iE
min_gs = 16;    % min grain size in pixels

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
    23,19,82,87;
    28,24,86,91;
    27,24,86,92;
    21,18,78,85;
    22,18,79,85;
    28,24,85,91;
    29,25,87,92;
    27,23,85,91;
    32,27,90,96;
    29,26,85,91;
    23,20,84,90;
    23,20,81,87;
    27,23,86,92;
    25,21,84,89;
    ];

% ID_list{iB=iE+1}, grains need to be divided into two grains.
% tolerance_cell{iB}, the tolerance angle for these grains
% Note: if a grain needs to be divided into 3 grains, select it twice. The
% larger grain will keep the original grain ID.
ID_list{1} = [77,99,88]; 
ID_list{2} = [32,81,92]; 
ID_list{3} = [25,94]; 
ID_list{4} = [12,20,5,25,61,87]; 
ID_list{5} = [4,26,62,21,87]; 
ID_list{6} = [27,15,5,32,93]; 
ID_list{7} = [25,83,93]; 
ID_list{8} = [23,103,92]; 
ID_list{9} = [27,108,97]; 
ID_list{10} = [28,33,68,103,92]; 
ID_list{11} = [22,13,5,65,92]; 
ID_list{12} = [22,13,27,62,89]; 
ID_list{13} = [13,93]; 
ID_list{14} = [80,101,90]; 

% ID_merge_list{iB=iE+1} = [g1, g2; g3 g4; ...]
% merge g1 into g2, g3 into g4, ...
ID_merge_list{1} = [];
ID_merge_list{2} = [15,9; 16,9; 18,9];
ID_merge_list{3} = [21,9; 16,9; 17,10; 13,3; 93,88];
ID_merge_list{4} = [83,77; 86,82; 88,82];
ID_merge_list{5} = [86,83; 88,83];
ID_merge_list{6} = [14,3; 13,10; 12,9; 16,9; 19,9; 21,9; 22,9; 92,89];
ID_merge_list{7} = [15,10; 12,9; 14,9; 18,9; 19,9; 22,9];
ID_merge_list{8} = [13,9; 16,9; 17,9; 21,9];
ID_merge_list{9} = [17,10; 11,9; 14,9; 18,9; 19,9; 20,9; 21,9; 22,9];
ID_merge_list{10} = [11,9; 20,9; 16,9; 18,9; 17,9; 23,9];
ID_merge_list{11} = [11,9; 14,9; 45,27; 91,88; 93,88];
ID_merge_list{12} = [88,84; 90,84; 10,8; 17,8];
ID_merge_list{13} = [10,8; 14,8; 19,8; 15,8; 16,8; 20,8];
ID_merge_list{14} = [13,9; 16,9; 17,9];



