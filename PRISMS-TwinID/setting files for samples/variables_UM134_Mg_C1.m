% setting file

working_dir = 'E:\zhec umich Drive\2020-12-05 UM134_Mg_C1 insitu EBSD';
sample_name = 'UM134_Mg_C1';
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
    42,34,266,270;
    33,30,252,268;
    32,33,253,273;
    37,38,261,280;
    36,33,253,264;
    40,36,255,266;
    45,36,257,263;
    44,39,256,266;
    37,34,248,263;
    29,32,241,259;
    26,31,239,262;
    33,34,243,260;
    37,34,243,260;
    42,36,251,261;
    ];

% ID_list{iB=iE+1}, grains need to be divided into two grains.
% tolerance_cell{iB}, the tolerance angle for these grains
% Note: if a grain needs to be divided into 3 grains, select it twice. The
% larger grain will keep the original grain ID.
ID_list{1} = [10,186,268];
tolerance_cell{1} = [3,3,3];
ID_list{2} = [56,78,131,131,225, 9];
tolerance_cell{2} = [3,3,3,3,3, 3];
ID_list{3} = [57,77,83,135,135, 227,258,9,293];
tolerance_cell{3} = [3,3,3,3,3, 3,3,3,3];
ID_list{4} = [10,62,88,141,141, 176,265];
tolerance_cell{4} = [2,3,3,3,3, 3,3];
ID_list{5} = [9,58,79,130,130, 199,227];
tolerance_cell{5} = [3,3,3,3,3, 3,3];
ID_list{6} = [10,63,84,134,134, 177,231,259,295];
tolerance_cell{6} = [2,3,3,3,3, 3,3,3,3];
ID_list{7} = [10,183,242,234,260, 255];
tolerance_cell{7} = [2,3,3,3,3, 3];
ID_list{8} = [10,139,139,179,234, 261];
tolerance_cell{8} = [2,3,3,3,3, 3];
ID_list{9} = [9,133,133,173,226, 254,177];
tolerance_cell{9} = [3,3,3,3,3, 3,3];
ID_list{10} = [9,81,129,129,167, 217,246,280];
tolerance_cell{10} = [3,3,3,3,3, 3,3,3];
ID_list{11} = [8,82,129,129,244];
tolerance_cell{11} = [2,3,3,3,3];
ID_list{12} = [10,82,132,132,171, 220,249,];
tolerance_cell{12} = [2,3,3,3,3, 3,3];
ID_list{13} = [9,139,171,168,231, 223,248];
tolerance_cell{13} = [2,3,3,3,3, 3,3];
ID_list{14} = [11,14,141,176,173, 174,236];
tolerance_cell{14} = [2,3,3,3,3, 3,3];

% ID_merge_list{iB=iE+1} = [g1, g2; g3 g4; ...]
% merge g1 into g2, g3 into g4, ...
ID_merge_list{1} = [];
ID_merge_list{2} = [];
ID_merge_list{3} = [100,77; 68,57; 91,82];
ID_merge_list{4} = [73,62; 97,86];
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



