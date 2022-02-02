% grow gb for 1 pixel thickness
% Zhe Chen, 2016-1-1

function gb = grow_boundary(gb)
gb(gb~=1)=0;
% gb = conv2(gb,[0 1 0; 1 1 1; 0 1 0],'same');
gb = conv2(gb,ones(3),'same');
gb(gb~=0)=1;
