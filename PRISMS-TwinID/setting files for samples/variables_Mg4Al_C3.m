% setting file

working_dir = 'E:\zhec umich Drive\2020-12-23 Mg4Al_C3 insitu EBSD';
sample_name = 'Mg4Al_C3';
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
    12,13,139,133;
    13,14,139,134;
    12,13,143,138;
    12,15,146,141;
    12,15,145,139;
    12,14,145,140;
    12,13,137,132;
    12,13,139,134;
    12,13,138,133;
    12,13,135,130;
    12,15,142,136;
    12,13,136,131;
    13,14,163,157;
    12,13,136,131;
    ];

% ID_list{iB=iE+1}, grains need to be divided into two grains.
% tolerance_cell{iB}, the tolerance angle for these grains
% Note: if a grain needs to be divided into 3 grains, select it twice. The
% larger grain will keep the original grain ID.
ID_list{1} = [116,128];
tolerance_cell{1} = [5,5];
ID_list{2} = [57,103,117,129];
tolerance_cell{2} = [5,5,5,5];
ID_list{3} = [56,71,86,104,122,129,133];
tolerance_cell{3} = [5,5,5,5,5,5,5];
ID_list{4} = [60,68,77,91,109,126,132,132,133,136];
tolerance_cell{4} = [5,5,5,5,4,5,5,4,5,5];
ID_list{5} = [61,66,75,89,106,123,130,134];
tolerance_cell{5} = [5,5,5,5,5,5,5,5];
ID_list{6} = [61,75,91,107,124,130,131,135];
tolerance_cell{6} = [5,5,5,5,5,3,5,5];
ID_list{7} = [32,54,66,99,115,127];
tolerance_cell{7} = [5,5,5,5,5,5];
ID_list{8} = [31,54,117,129];
tolerance_cell{8} = [5,5,5,5];
ID_list{9} = [32,53,116,128];
tolerance_cell{9} = [5,5,5,5];
ID_list{10} = [30,51,66,98,114,121,125];
tolerance_cell{10} = [5,5,5,5,5,5,5,5,5];
ID_list{11} = [57,63,72,87,93,105,120,127,131];
tolerance_cell{11} = [5,5,4,5,5,5,5,5,5];
ID_list{12} = [57,65,82,87,100,114,126];
tolerance_cell{12} = [5,5,5,5,5,5,5];
ID_list{13} = [32,56,114,134,150];
tolerance_cell{13} = [5,5,5,5,5]; 
ID_list{14} = [29,114,126];
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



