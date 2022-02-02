% setting file

working_dir = 'E:\zhec umich Drive\2021-01-15 UM134_Mg_C2 insitu EBSD';
sample_name = 'UM134_Mg_C2';
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
    61,55,384,387;
    59,54,384,387;
    59,58,402,406;
    57,60,406,411;
    60,61,403,407;
    59,60,393,396;
    59,57,388,391;
    59,55,381,384;
    59,58,387,391;
    57,58,390,394;
    56,60,400,405;
    59,61,393,399;
    57,58,382,386;
    60,57,378,381;
    ];

% ID_list{iB=iE+1}, grains need to be divided into two grains.
% tolerance_cell{iB}, the tolerance angle for these grains
% Note: if a grain needs to be divided into 3 grains, select it twice. The
% larger grain will keep the original grain ID.
ID_list{1} = [270,333,212,67,179, 73,251];
tolerance_cell{1} = [3,3,3, 3,3, 3,3];
ID_list{2} = [71,152,177,248,269,335, 176];
tolerance_cell{2} = [5,3,5,5,3,3, 3];
ID_list{3} = [184,260,279, 66,157,14];
tolerance_cell{3} = [5,5,3, 3,3,3];
ID_list{4} = [19,76,189,265,284,410, 15,125,244];
tolerance_cell{4} = [5,5,5,5,3,5, 3,3,3];
ID_list{5} = [25,79,126,189,263,283, 243];
tolerance_cell{5} = [5,5,3,5,5,3, 3];
ID_list{6} = [24,183,257,276,218, 15,67,179];
tolerance_cell{6} = [4,5,5,3,3, 3,3,3];
ID_list{7} = [72,255,275, 178];
tolerance_cell{7} = [4,4,3, 3];
ID_list{8} = [14,14,71,79,100,104,249,269,327, 64,174];
tolerance_cell{8} = [3,3,3,3,3,3,3,3,3, 3,3];
ID_list{9} = [50,72,255,273,340, 15,176];
tolerance_cell{9} = [3,3,3,3,3, 3,3];
ID_list{10} = [72,106,180,254,273, 15,176];
tolerance_cell{10} = [5,3,5,5,3, 3,3];
ID_list{11} = [73,105,182,260,280,403, 105,177];
tolerance_cell{11} = [5,5,5,5,3,5, 3,3];
ID_list{12} = [76,110,259,276,369,349, 17,178,182];
tolerance_cell{12} = [5,3,5,5,3,3, 3,3,3];
ID_list{13} = [24,48,70,251,333,333, 173];
tolerance_cell{13} = [5,5,5,5,3,5, 3];
ID_list{14} = [52,71,244,265,208, 172,204];
tolerance_cell{14} = [3,5,5,3,3, 3,3];

% ID_merge_list{iB=iE+1} = [g1, g2; g3 g4; ...]
% merge g1 into g2, g3 into g4, ...
ID_merge_list{1} = [];
ID_merge_list{2} = [];
ID_merge_list{3} = [];
ID_merge_list{4} = [91,79];
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



