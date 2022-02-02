% setting file

working_dir = 'E:\zhec umich Drive\2021-11-05 Mg4Al_A2 insitu EBSD';
sample_name = 'Mg4Al_A2';
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
    27,23,223,218;
    26,23,217,214;
    25,22,220,217;
    28,23,227,224;
    27,20,231,226;
    27,19,227,219;
    25,19,221,212;
    27,21,223,216;
    27,22,223,217;
    24,22,220,217;
    27,23,220,217;
    27,20,223,216;
    25,19,219,212;
    27,21,220,213;
    ];

% ID_list{iB=iE+1}, grains need to be divided into two grains.
% tolerance_cell{iB}, the tolerance angle for these grains
% Note: if a grain needs to be divided into 3 grains, select it twice. The
% larger grain will keep the original grain ID.
ID_list{1} = [152,209, 209, 43,74,153]; 
tolerance_cell{1} = [3,2, 2, 5,5,5];
ID_list{2} = [43,55,74,154,140, 152,153,205,205]; 
tolerance_cell{2} = [5,5,5,5,5, 5,3,5,1];
ID_list{3} = [43,75,142,154,156, 179,207,207]; 
tolerance_cell{3} = [5,5,5,5,5, 4,5,2];
ID_list{4} = [31,44,164,188,162, 163,215,215,197,235]; 
tolerance_cell{4} = [5,5,3,3,5, 3,5,2,5,5];
ID_list{5} = [30,44,149,158,163, 188,216,216,244,244];
tolerance_cell{5} = [5,5,5,5,2, 5,5,2,3,5];
ID_list{6} = [28,42,74,158,155, 156,181,209,209,229, 229]; 
tolerance_cell{6} = [5,5,5,3,5, 3,3,5,2,5, 5];
ID_list{7} = [41,72,152,139,149, 150,203,203,223];
tolerance_cell{7} = [5,5,5,5,5, 5,5,2,3];
ID_list{8} = [43,74,153,151,178, 207,207,226]; 
tolerance_cell{8} = [5,5,5,5,3, 5,1.5,5];
ID_list{9} = [43,74,154,208,208, 229]; 
tolerance_cell{9} = [5,5,5,5,1.5, 5];
ID_list{10} = [43,74,156,141,154, 155,178,208,208,]; 
tolerance_cell{10} = [5,5,5,5,5, 3,5,5,2];
ID_list{11} = [30,44,76,159,146, 157,160,182,208,208, 191,195];
tolerance_cell{11} = [5,5,5,3,5, 5,3,5,5,2, 2,5];
ID_list{12} = [29,43,75,83,157, 144,154,155,181,207, 207,227,242]; 
tolerance_cell{12} = [5,5,5,5,3, 5,5,5,3,5, 2,5,5];
ID_list{13} = [41,72,138,149,148, 175,203,203];
tolerance_cell{13} = [5,5,5,5,3, 3,5,2];
ID_list{14} = [43,74,139,151,149, 175,204,204,223]; 
tolerance_cell{14} = [5,5,3,5,3, 3,5,2,3];

% ID_merge_list{iB=iE+1} = [g1, g2; g3 g4; ...]
% merge g1 into g2, g3 into g4, ...
ID_merge_list{1} = []; 
ID_merge_list{2} = [252,249; 57,50];
ID_merge_list{3} = [216,198; 57,50];
ID_merge_list{4} = [142,136; 145,136; 57,51];
ID_merge_list{5} = [143,136; 145,136; 58,51];
ID_merge_list{6} = [137,131; 139,131; 218,197; 55,49];
ID_merge_list{7} = [214,206; 248,245];
ID_merge_list{8} = [];
ID_merge_list{9} = [];
ID_merge_list{10} = [242,227; 250,230];
ID_merge_list{11} = [58,51];
ID_merge_list{12} = [247,230; 243,230; 218,196; 56,50];
ID_merge_list{13} = [];
ID_merge_list{14} = [];



