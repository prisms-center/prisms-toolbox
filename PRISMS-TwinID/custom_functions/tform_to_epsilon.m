% convert 2d affine transformation to strain tensor
% varInput can be 
% (1) the tform from maketform('affine',cpFrom,cpTo)
% (2) the tform from fitgeotrans(cpFrom, cpTo, 'affine')
% (3) or the matrix A for transformation, where cpTo_3x1 = A * cpFrom_3x1
% output: T=translation, R=rotation matrix, Z=zoom, S=shear
% chenzhe, 2021-03-10

function epsilon = tform_to_epsilon(varInput)

if isnumeric(varInput)
    % if input is the transformation matrix M, where cpTo_nBy1 = M*cpFrom_nBy1  
    A2 = varInput;
elseif isobject(varInput)
    % if input is an object, such as tform = fitgeotrans(cpFrom, cpTo, 'affine')
    A2 = varInput.T';
elseif isstruct(varInput)
    % if input is a structure, such as: tform = maketform('affine', cpFrom, cpTo) 
    A2 = varInput.tdata.T';
else
    error('unknown data type');
end

% If similar to 2D-DIC, we want to have an F=dx/dX=du/dX+I that has the relationship: x = F*X  
% according to the definition of deformation gradient:
% dx/dX = M(1,1), dx/dY = M(1,2)
% dy/dX = M(2,1), dy/dY = M(2,2)
% F = M(1:2,1:2)
M = A2;
F = M(1:2,1:2);
epsilon = (F'*F-eye(2))/2;

end