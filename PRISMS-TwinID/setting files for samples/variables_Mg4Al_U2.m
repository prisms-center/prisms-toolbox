% setting file

working_dir = 'E:\zhec umich Drive\2021-02-26 Mg4Al_U2 EBSD';
sample_name = 'Mg4Al_U2';
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
    18,31,107,119;
    17,31,105,116;
    18,29,96,110;
    19,31,98,112;
    20,33,103,117;
    19,31,95,109;
    18,33,102,116;
    18,30,99,113;
    18,32,101,114;
    18,30,99,112;
    19,30,100,114;
    19,30,101,113;
    18,31,101,114;
    18,30,100,112;
    ];

% ID_list{iB=iE+1}, grains need to be divided into two grains.
% tolerance_cell{iB}, the tolerance angle for these grains
% Note: if a grain needs to be divided into 3 grains, select it twice. The
% larger grain will keep the original grain ID.
ID_list{1} = [61,10,17,131]; 
tolerance_cell{1} = [3,3,5,5];
ID_list{2} = [2,16,50,87,127]; 
tolerance_cell{2} = [3,3,3,3,3];
ID_list{3} = [2,15,47,52,45, 25,80,117,116,121, 115,43,9]; 
tolerance_cell{3} = [3,3,3,3,3, 3,3,3,3,3, 3,3,3];
ID_list{4} = [16,49,53,85,27, 46,77,124,110]; 
tolerance_cell{4} = [3,3,3,3,3, 2,3,3,3];
ID_list{5} = [17,52,49,81,85, 115,125,129];
tolerance_cell{5} = [3,3,3,3,3, 3,3,3];
ID_list{6} = [10,16,47,50,54, 57,69,78,80,83, 121]; 
tolerance_cell{6} = [3,3,3,3,3, 3,3,2,3,3, 3];
ID_list{7} = [17,49,51,85,121, 126];
tolerance_cell{7} = [3,3,3,3,3, 3];
ID_list{8} = [2,9,17,47,52, 59,83,121,124]; 
tolerance_cell{8} = [3,3,3,3,2, 3,3,3,3];
ID_list{9} = [17,48,51,55,85, 122,125]; 
tolerance_cell{9} = [3,3,3,3,3, 3,3];
ID_list{10} = [2,16,47,50,54, 83,86,117,123]; 
tolerance_cell{10} = [3,3,3,3,3, 3,3,3,3];
ID_list{11} = [17,49,52,56,59, 81,84,112,125];
tolerance_cell{11} = [3,3,3,3,3, 3,3,3,3];
ID_list{12} = [10,16,47,52,54, 83,118,124]; 
tolerance_cell{12} = [3,3,3,3,3, 3,3,3];
ID_list{13} = [2,17,49,54,55, 83,118,119,124];
tolerance_cell{13} = [3,3,3,3,3, 3,3,3,3];
ID_list{14} = [10,17,46,51,83, 117,120,123]; 
tolerance_cell{14} = [3,3,3,3,3, 3,3,3];

% ID_merge_list{iB=iE+1} = [g1, g2; g3 g4; ...]
% merge g1 into g2, g3 into g4, ...
ID_merge_list{1} = [];
ID_merge_list{2} = [];
ID_merge_list{3} = [];
ID_merge_list{4} = [84,85];
ID_merge_list{5} = [87,88];
ID_merge_list{6} = [];
ID_merge_list{7} = [];
ID_merge_list{8} = [];
ID_merge_list{9} = [];
ID_merge_list{10} = [];
ID_merge_list{11} = [];
ID_merge_list{12} = [];
ID_merge_list{13} = [];
ID_merge_list{14} = [];



