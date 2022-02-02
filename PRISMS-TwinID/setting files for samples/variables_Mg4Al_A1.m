% setting file

working_dir = 'E:\zhec umich Drive\2021-10-28 Mg4Al_A1 insitu EBSD';
sample_name = 'Mg4Al_A1';
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
    27,18,211,205;
    25,18,214,207;
    25,18,212,204;
    27,20,212,205;
    27,20,214,206;
    26,18,210,201;
    27,18,207,200;
    27,18,210,205;
    27,18,211,204;
    25,18,211,203;
    25,20,210,202;
    26,18,207,200;
    27,18,207,200;
    26,18,212,206;
    ];

% ID_list{iB=iE+1}, grains need to be divided into two grains.
% tolerance_cell{iB}, the tolerance angle for these grains
% Note: if a grain needs to be divided into 3 grains, select it twice. The
% larger grain will keep the original grain ID.
ID_list{1} = [24,72,126]; 
tolerance_cell{1} = [3,3,5];
ID_list{2} = [24,74,72,127,200]; 
tolerance_cell{2} = [3,3,3,3,3];
ID_list{3} = [24,50,70,60,126, 187]; 
tolerance_cell{3} = [3,5,3,3,3, 3];
ID_list{4} = [24,43,72,70,107, 89,131,168,126,188, 99,61]; 
tolerance_cell{4} = [3,5,3,3,3, 3,3,3,3,3, 5,5];
ID_list{5} = [25,45,75,75,103, 110,74,64,93,128, 133,188];
tolerance_cell{5} = [3,5,5,5,5, 5,5,5,5,5, 5,5];
ID_list{6} = [24,73,59,108,89, 130,124,181]; 
tolerance_cell{6} = [5,5,5,5,5, 5,5,5];
ID_list{7} = [73,51,106,70,105, 88,123,179];
tolerance_cell{7} = [5,5,5,5,5, 5,5,5];
ID_list{8} = [24,75,92,72,89, 125,197]; 
tolerance_cell{8} = [5,5,5,3,5, 5,3];
ID_list{9} = [24,71,50,70,88, 124]; 
tolerance_cell{9} = [3,5,5,3,5, 5];
ID_list{10} = [24,32,50,125,59, 186,186]; 
tolerance_cell{10} = [5,5,5,5,5, 5,5];
ID_list{11} = [23,32,72,72,98, 70,90,129,61,184, 122];
tolerance_cell{11} = [3,5,5,5,5, 3,5,5,5,5, 5];
ID_list{12} = [24,73,125,108,71, 89,130,163,181,181, 60]; 
tolerance_cell{12} = [3,5,5,5,3, 5,5,5,5,5, 5];
ID_list{13} = [71,33,50,70,87, 124,129,181,181];
tolerance_cell{13} = [5,5,5,3,5, 5,5,3,3];
ID_list{14} = [24,74,73,127,197]; 
tolerance_cell{14} = [3,5,5,5,3];

% ID_merge_list{iB=iE+1} = [g1, g2; g3 g4; ...]
% merge g1 into g2, g3 into g4, ...
ID_merge_list{1} = [113,108]; % polishing induced twin 
ID_merge_list{2} = [114,107];
ID_merge_list{3} = [114,107];
ID_merge_list{4} = [112,106; 194,193];
ID_merge_list{5} = [114,109; 192,194];
ID_merge_list{6} = [112,105; 189,190];
ID_merge_list{7} = [110,103;];
ID_merge_list{8} = [112,105; 52,35];
ID_merge_list{9} = [111,104];
ID_merge_list{10} = [38,23;113,106];
ID_merge_list{11} = [110,104; 189,188];
ID_merge_list{12} = [112,107; 189,188];
ID_merge_list{13} = [111,104];
ID_merge_list{14} = [114,107; 57,35];



