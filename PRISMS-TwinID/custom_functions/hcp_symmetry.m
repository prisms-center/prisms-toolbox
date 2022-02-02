% chenzhe 2016-6-20
% output the hcp symmetry operator as quaternion S, and transformation
% matrix M{ii}
function [S, M] = hcp_symmetry()
S = [1, 0, 0, 0;
    sqrt(3)/2, 0, 0, 1/2;
    1/2, 0, 0, sqrt(3)/2;
    0, 0, 0, -1;
    1/2, 0, 0, -sqrt(3)/2;
    sqrt(3)/2, 0, 0, -1/2;
    0, 1, 0, 0;
    0, sqrt(3)/2, -1/2, 0;
    0, 1/2, -sqrt(3)/2, 0;
    0, 0, 1, 0;
    0, 1/2, sqrt(3)/2, 0;
    0, sqrt(3)/2, 1/2, 0];
for ii=1:12
   M(:,:,ii) = quat2dcm(S(ii,:)); 
end

end