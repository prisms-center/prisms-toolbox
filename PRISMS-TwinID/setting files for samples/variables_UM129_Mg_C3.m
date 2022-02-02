% setting file

working_dir = 'E:\zhec umich Drive\2021-09-03 UM129_Mg_C3 insitu EBSD';
sample_name = 'UM129_Mg_C3';
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
    24,21,72,119;
    22,26,74,123;
    22,26,70,119;
    24,27,79,134;
    25,28,81,135;
    24,27,72,125;
    22,27,72,122;
    22,23,71,121;
    23,27,72,122;
    26,28,78,126;
    24,27,75,127;
    25,29,78,128;
    23,27,72,122;
    21,24,70,119;
    ];

% ID_list{iB=iE+1}, grains need to be divided into two grains.
% tolerance_cell{iB}, the tolerance angle for these grains
% Note: if a grain needs to be divided into 3 grains, select it twice. The
% larger grain will keep the original grain ID.
ID_list{1} = [5,78]; 
tolerance_cell{1} = [5,5];
ID_list{2} = [56,62,62,101]; 
tolerance_cell{2} = [5,5,5,5];
ID_list{3} = [53,97,61,61,61]; 
tolerance_cell{3} = [5,5,5,5,5];
ID_list{4} = [72,72,5]; 
tolerance_cell{4} = [3,5,5];
ID_list{5} = [66,73,73,7];
tolerance_cell{5} = [5,4,5,5];
ID_list{6} = [57,101,65,65,65,65]; 
tolerance_cell{6} = [5,5,5,4,3,5];
ID_list{7} = [56,100,64,64];
tolerance_cell{7} = [5,5,3,5];
ID_list{8} = [60,60]; 
tolerance_cell{8} = [5,5];
ID_list{9} = [55,62,62]; 
tolerance_cell{9} = [5,5,5];
ID_list{10} = [19,104,70,70,70]; 
tolerance_cell{10} = [5,5,5,5,4];
ID_list{11} = [60,42,68,68,68, 68];
tolerance_cell{11} = [5,5,5,5,2.5, 5];
ID_list{12} = [71,71,71]; 
tolerance_cell{12} = [5,5,5];
ID_list{13} = [55,100,62,62];
tolerance_cell{13} = [5,5,5,5];
ID_list{14} = [4,76,105]; 
tolerance_cell{14} = [5,5,5];

% ID_merge_list{iB=iE+1} = [g1, g2; g3 g4; ...]
% merge g1 into g2, g3 into g4, ...
ID_merge_list{1} = [23,17; 53,38];
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



