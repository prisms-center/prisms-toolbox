% setting file

working_dir = 'E:\zhec umich Drive\2021-06-29 UM129_Mg_C1 insitu EBSD';
sample_name = 'UM129_Mg_C1';
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
    32,20,72,92;
    33,20,73,94;
    34,23,77,100;
    36,24,76,99;
    39,29,84,106;
    35,24,77,100;
    33,21,75,98;
    32,20,70,92;
    33,22,73,95;
    39,27,79,101;
    38,28,85,110;
    37,26,82,104;
    37,25,81,104;
    30,20,68,91;
    ];

% ID_list{iB=iE+1}, grains need to be divided into two grains.
% tolerance_cell{iB}, the tolerance angle for these grains
% Note: if a grain needs to be divided into 3 grains, select it twice. The
% larger grain will keep the original grain ID.
ID_list{1} = [78]; 
tolerance_cell{1} = [5];
ID_list{2} = [51,81]; 
tolerance_cell{2} = [5,5];
ID_list{3} = [53,84,84]; 
tolerance_cell{3} = [5,5,5];
ID_list{4} = [17,70,55,85,72]; 
tolerance_cell{4} = [5,5,5,5,5];
ID_list{5} = [60,92,77];
tolerance_cell{5} = [5,5,5];
ID_list{6} = [55,84,76]; 
tolerance_cell{6} = [5,5,5];
ID_list{7} = [53,83];
tolerance_cell{7} = [5,5];
ID_list{8} = [49,78]; 
tolerance_cell{8} = [5,5];
ID_list{9} = [50,81]; 
tolerance_cell{9} = [5,5];
ID_list{10} = [57,87]; 
tolerance_cell{10} = [5,5];
ID_list{11} = [62,101];
tolerance_cell{11} = [5,5];
ID_list{12} = [59,90]; 
tolerance_cell{12} = [5,5];
ID_list{13} = [58,89];
tolerance_cell{13} = [5,5];
ID_list{14} = [46,76]; 
tolerance_cell{14} = [5,5];

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



