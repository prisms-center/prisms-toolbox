% setting file

working_dir = 'E:\zhec umich Drive\2021-12-02 Mg4Al_B1 insitu EBSD';
sample_name = 'Mg4Al_B1';
iE_max = 13;    % maximum iE
min_gs = 16;    % min grain size in pixels

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
    23,17,65,79;
    26,20,69,82;
    23,17,68,80;
    22,17,69,82;
    22,18,70,83;
    20,17,66,79;
    23,17,67,80;
    23,17,66,79;
    23,17,67,80;
    25,19,68,82;
    22,17,67,82;
    21,17,67,80;
    22,17,65,78;
    22,16,64,78;
    ];

% ID_list{iB=iE+1}, grains need to be divided into two grains.
% tolerance_cell{iB}, the tolerance angle for these grains
% Note: if a grain needs to be divided into 3 grains, select it twice. The
% larger grain will keep the original grain ID.
ID_list{1} = [1]; 
ID_list{2} = [14,28]; 
ID_list{3} = [1,11,59]; 
ID_list{4} = [11,26,19]; 
ID_list{5} = [19]; 
ID_list{6} = [8,11,18,45]; 
ID_list{7} = [1]; 
ID_list{8} = [1]; 
ID_list{9} = [1]; 
ID_list{10} = [28]; 
ID_list{11} = [26]; 
ID_list{12} = [7]; 
ID_list{13} = [7,26]; 
ID_list{14} = [1]; 

% ID_merge_list{iB=iE+1} = [g1, g2; g3 g4; ...]
% merge g1 into g2, g3 into g4, ...
ID_merge_list{1} = [];
ID_merge_list{2} = [104,101];
ID_merge_list{3} = [];
ID_merge_list{4} = [18,3];
ID_merge_list{5} = [];
ID_merge_list{6} = [];
ID_merge_list{7} = [];
ID_merge_list{8} = [70,61];
ID_merge_list{9} = [];
ID_merge_list{10} = [];
ID_merge_list{11} = [];
ID_merge_list{12} = [];
ID_merge_list{13} = [55,44];
ID_merge_list{14} = [54,44;68,60];



