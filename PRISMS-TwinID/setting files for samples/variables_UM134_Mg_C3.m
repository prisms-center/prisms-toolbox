% setting file

working_dir = 'E:\zhec umich Drive\2021-01-29 UM134_Mg_C3 insitu EBSD';
sample_name = 'UM134_Mg_C3';
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
    43,40,275,250;
    39,34,275,249;
    40,35,275,250;
    42,36,287,262;
    44,39,287,261;
    43,38,272,248;
    42,38,266,242;
    41,38,266,241;
    39,36,259,236;
    39,36,261,239;
    40,35,268,244;
    42,37,267,243;
    43,39,262,238;
    43,40,268,244;
    ];

% ID_list{iB=iE+1}, grains need to be divided into two grains.
% tolerance_cell{iB}, the tolerance angle for these grains
% Note: if a grain needs to be divided into 3 grains, select it twice. The
% larger grain will keep the original grain ID.
ID_list{1} = [13,13,15,131,122, 66];
tolerance_cell{1} = [3,3,3,3,3, 5];
ID_list{2} = [4,16,16,60,72, 72,129,152,152,152, 174,221,279,178];
tolerance_cell{2} = [3,3,3,3,2, 3,3,3,3,3, 2,3,3,3];
ID_list{3} = [4,15,15,59,71, 76,81,133,151,151, 151,170,214,271,176];
tolerance_cell{3} = [3,3,3,3,3, 3,3,3,3,3, 3,3,2,3,3];
ID_list{4} = [15,81,65,77,91, 142,161,161,161,181, 187,223];
tolerance_cell{4} = [3,3,3,3,3, 2,3,3,3,3, 3,3];
ID_list{5} = [35,66,83,96,125, 144,162,162,162,180, 187,224,15,137];
tolerance_cell{5} = [3,3,3,3,3, 3,3,3,3,1.5, 3,3,3,3];
ID_list{6} = [15,63,75,75,80, 85,118,132,170,152, 152,152,172,177,212, 134];
tolerance_cell{6} = [3,3,3,3,3, 3,3,3,2,3, 3,3,3,3,3, 3];
ID_list{7} = [15,15,16,41,54, 75,63,84,114,127, 149,168,176,217,262];
tolerance_cell{7} = [3,2,3,3,3, 3,3,3,3,2, 3,3,3,3,3];
ID_list{8} = [13,13,23,31,74, 82,63,100,116,115, 127,217,210,264,261];
tolerance_cell{8} = [2,2,3,3,3, 3,3,3,3,3, 2,3,2,3,3];
ID_list{9} = [4,15,15,40,51, 60,73,87,121,125, 162,145,145,145,201, 202,210,257,263,256, 169];
tolerance_cell{9} = [3,2,2,3,3, 3,3,3,3,3, 3,3,3,3,3, 3,3,3,1,3, 3];
ID_list{10} = [15,16,40,74,120, 61,70,70,86,111, 143,143,143,159,203, 211,233,265,125,166, 128,269];
tolerance_cell{10} = [3,3,3,3,3, 3,3,3,3,3, 3,3,3,2,3, 3,3,1,3,3, 3,3];
ID_list{11} = [4,17,18,61,76, 38,81,86,112,75, 75,129,146,146,146, 164,170,258,205,264];
tolerance_cell{11} = [3,3,3,3,3, 3,3,3,3,3, 3,3,3,3,2, 2,3,3,3,3];
ID_list{12} = [15,15,40,61,79, 74,88,114,165,148, 148,148,131,206,214, 171,262,134];
tolerance_cell{12} = [2,2,3,3,3, 3,3,3,2,3, 3,3,3,3,3, 3,3,3];
ID_list{13} = [14,14,42,53,83, 84,91,113,129,165, 148,148,148,171,213, 205,207,260,258,63, 75];
tolerance_cell{13} = [2,2,3,3,3, 3,3,3,2,3, 3,3,3,3,3, 2,3,3,3,3, 3];
ID_list{14} = [13,13,16,44,44, 76,76,126,90,114, 64,211,263];
tolerance_cell{14} = [2,2,3,3,3, 3,3,2,3,3, 3,3,3];


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



