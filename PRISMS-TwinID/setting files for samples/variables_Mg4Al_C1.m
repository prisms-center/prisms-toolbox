% setting file

working_dir = 'E:\zhec umich Drive\2020-10-23 Mg4Al_C1 insitu EBSD';
sample_name = 'Mg4Al_C1';
iE_max = 7;    % maximum iE
min_gs = 9;    % min grain size in pixels

% grain file format example:
% 'sample_name grain_file_type_1 iE=0.txt'

% inds of end of half cycles
% e.g., [4,8,11,14] means load step 1-4 = compression cycle 1, 4-8=tension
% cycle 1, 8-11=compression cycle 2, 11-14 = tension cycle 2, ...
inds_half_cycle = [4,8];

% strain gage reading of each load step
strain_sg = [0, -0.0075, -0.015, -0.025, ...
    -0.023, -0.017, -0.0075, 0];

% grain IDs of a few selected grains at each load step, used for alignment
grain_pair = [
    20,25,207,185;
    21,29,211,191;
    24,32,211,190;
    18,26,205,184;
    19,29,208,187;
    2,25,204,185;
    19,25,207,184;
    21,26,208,187;
    ];

% ID_list{iB=iE+1}, grains need to be divided into two grains.
% tolerance_cell{iB}, the tolerance angle for these grains
% Note: if a grain needs to be divided into 3 grains, select it twice. The
% larger grain will keep the original grain ID.
ID_list{1} = [120];
ID_list{2} = [195];
ID_list{3} = [97,142];
ID_list{4} = [69,134];
ID_list{5} = [75,107,122,138,181];
ID_list{6} = [67,87,118,136,177];
ID_list{7} = [67,120,139];
ID_list{8} = [85,122];

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



