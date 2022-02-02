% setting file

working_dir = '';
sample_name = '';
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

    ];

% ID_list{iB=iE+1}, grains need to be divided into two grains.
% tolerance_cell{iB}, the tolerance angle for these grains
% Note: if a grain needs to be divided into 3 grains, select it twice. The
% larger grain will keep the original grain ID.
ID_list{1} = []; 
tolerance_cell{1} = [];
ID_list{2} = []; 
tolerance_cell{2} = [];
ID_list{3} = []; 
tolerance_cell{3} = [];
ID_list{4} = []; 
tolerance_cell{4} = [];
ID_list{5} = []; 
tolerance_cell{5} = [];
ID_list{6} = []; 
tolerance_cell{6} = [];
ID_list{7} = []; 
tolerance_cell{7} = [];
ID_list{8} = []; 
tolerance_cell{8} = [];
ID_list{9} = []; 
tolerance_cell{9} = [];
ID_list{10} = []; 
tolerance_cell{10} = [];
ID_list{11} = []; 
tolerance_cell{11} = [];
ID_list{12} = []; 
tolerance_cell{12} = [];
ID_list{13} = []; 
tolerance_cell{13} = [];
ID_list{14} = []; 
tolerance_cell{14} = [];

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



