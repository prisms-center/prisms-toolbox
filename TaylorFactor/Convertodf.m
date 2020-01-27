function ODFinput = Convertodf(type,filename,angleformat)
%Main function Author : Prof Veera Sundararaghavan
% Acknowledgments for the rest of the functions in this code: ODFPF code by Donald Boyce and Prof Paul Dawson
%%%%USE Examples
%%%%%ODF = Convertodf('hexagonal','Foil1EBSD.txt','radians') 
%%%%%ODF = Convertodf('cubic','eulerangles.txt','degrees') 
%%%%%%%NOTE: REMOVE THE HEADERLINES IN THE EULER ANGLE FILE. SEE EXAMPLE
%%%%%%%FILE IN 'Foil1EBSD.txt' FOR INPUT EULER ANGLE DATA FORMAT. FIRST
%%%%%%%THREE COLUMNS MUST BE THE EULER ANGLES in bunge format.

if type(1) == 'c'
   load Cubicdata
end

if type(1) == 'h'
   load Hexagonaldata
end

Nel = length(ws.frmesh.con);
fileID = fopen(filename);

Aint = zeros(Nel,1);
k = 0;
Nlines = 25000;
while ~feof(fileID)

    D = textscan(fileID,'%f %f %f %*[^\n]',Nlines,'Delimiter','\t');%read block of 1000 at a time
    euler = [D{1} D{2} D{3}];
    
    % convert euler to rodrigues
    odf = RMatOfBunge(euler', angleformat);
    quat = QuatOfRMat(odf);
    rod  = ToFundamentalRegion(quat, ws.frmesh.symmetries);
    
    %convert to ODF
    [elem, ecrd] = MeshCoordinates(ws.frmesh, rod);
    Aint = Aint + histc(elem,1:Nel);
    k = k+1;
    linesread = k*Nlines
    
end
fclose(fileID);
Aint = Aint./(volumefractionint*Aint);
Anode = ODFtoNode*Aint;
ODFinput = ToAllNodes(Anode,ws.frmesh.eqv);

%PlotFR(ws.frmesh, Anode, 'Symmetries', type);
%fid = fopen('tecplot_odf.plt','w');writetecplot(fid,ws.frmesh.crd',ws.frmesh.con',ODFinput);fclose(fid);
end

function rmat = RMatOfBunge(bunge, units)
% RMatOfBunge - Rotation matrix from Bunge angles.
%
%   USAGE:
%
%   rmat = RMatOfBunge(bunge, units)
%
%   INPUT:
%
%   bunge is 3 x n,
%         the array of Bunge parameters
%   units is a string,
%         either 'degrees' or 'radians'
%       
%   OUTPUT:
%
%   rmat is 3 x 3 x n,
%        the corresponding rotation matrices
%   
if (nargin < 2)
  error('need second argument, units:  ''degrees'' or ''radians''')
end
%
if (strcmp(units, 'degrees'))
  %
  indeg = 1;
  bunge = bunge*(pi/180);
  %
elseif (strcmp(units, 'radians'))
  indeg = 0;
else
  error('angle units need to be specified:  ''degrees'' or ''radians''')
end
%
n    = size(bunge, 2);
cbun = cos(bunge);
sbun = sin(bunge);
%
rmat = [
     cbun(1, :).*cbun(3, :) - sbun(1, :).*cbun(2, :).*sbun(3, :);
     sbun(1, :).*cbun(3, :) + cbun(1, :).*cbun(2, :).*sbun(3, :);
     sbun(2, :).*sbun(3, :);
    -cbun(1, :).*sbun(3, :) - sbun(1, :).*cbun(2, :).*cbun(3, :);
    -sbun(1, :).*sbun(3, :) + cbun(1, :).*cbun(2, :).*cbun(3, :);
     sbun(2, :).*cbun(3, :);
     sbun(1, :).*sbun(2, :);
    -cbun(1, :).*sbun(2, :);
     cbun(2, :)
    ];
rmat = reshape(rmat, [3 3 n]);
%
%  From MPS:  pxutils.f
%
%        mat(1, 1) =  c1*c3 - s1*c2*s3
%        mat(2, 1) =  s1*c3 + c1*c2*s3
%        mat(3, 1) =  s2*s3
%        mat(1, 2) = -c1*s3 - s1*c2*c3
%        mat(2, 2) = -s1*s3 + c1*c2*c3
%        mat(3, 2) =  s2*c3
%        mat(1, 3) =  s1*s2
%        mat(2, 3) = -c1*s2
%        mat(3, 3) =  c2
end

function quat = QuatOfRMat(rmat)
% QuatOfRMat - Quaternion from rotation matrix
%   
%   USAGE:
%
%   quat = QuatOfRMat(rmat)
%
%   INPUT:
%
%   rmat is 3 x 3 x n,
%        an array of rotation matrices
%
%   OUTPUT:
%
%   quat is 4 x n,
%        the quaternion representation of `rmat'

% 
%  Find angle of rotation.
%
ca = 0.5*(rmat(1, 1, :) + rmat(2, 2, :) + rmat(3, 3, :) - 1);
ca = min(ca, +1);
ca = max(ca, -1);
angle = squeeze(acos(ca))';
%
%  Three cases for the angle:  
%  
%  *   near zero -- matrix is effectively the identity
%  *   near pi   -- binary rotation; need to find axis
%  *   neither   -- general case; can use skew part
%
tol = 1.0e-4;
anear0 = (angle < tol);
nnear0 = length(anear0);
angle(anear0) = 0;

raxis = [rmat(3, 2, :) - rmat(2, 3, :);
	rmat(1, 3, :) - rmat(3, 1, :);
	rmat(2, 1, :) - rmat(1, 2, :)];
raxis = squeeze(raxis);
raxis(:, anear0) = 1;
%
special = angle > pi - tol;
nspec   = sum(special);
if (nspec > 0)
  %disp(['special: ', num2str(nspec)]);
  sangle = repmat(pi, [1, nspec]);
  tmp = rmat(:, :, special) + repmat(eye(3), [1, 1, nspec]);
  tmpr = reshape(tmp, [3, 3*nspec]);
  tmpnrm = reshape(dot(tmpr, tmpr), [3, nspec]);
  [junk, ind] = max(tmpnrm);
  ind = ind + (0:3:(3*nspec-1));
  saxis = squeeze(tmpr(:, ind));
  raxis(:, special) = saxis;
end
%debug.angle = angle;
%debug.raxis = raxis;
quat = QuatOfAngleAxis(angle, raxis);

end

function rod = ToFundamentalRegion(quat, qsym)
% ToFundamentalRegion - Put rotation in fundamental region.
%   
%   USAGE:
%
%   rod = ToFundamentalRegion(quat, qsym)
%
%   INPUT:
%
%   quat is 4 x n, 
%        an array of n quaternions
%   qsym is 4 x m, 
%        an array of m quaternions representing the symmetry group
%
%   OUTPUT:
%
%   rod is 3 x n, 
%       the array of Rodrigues vectors lying in the fundamental 
%       region for the symmetry group in question
%
%   NOTES:  
%
%   *  This routine is very memory intensive since it 
%      applies all symmetries to each input quaternion.
%
q   = ToFundamentalRegionQ(quat, qsym);
rod = RodOfQuat(q);

end

function q = ToFundamentalRegionQ(quat, qsym)
% ToFundamentalRegionQ - To quaternion fundamental region.
%   
%   USAGE:
%
%   q = ToFundamentalRegionQ(quat, qsym)
%
%   INPUT:
%
%   quat is 4 x n, 
%        an array of n quaternions
%   qsym is 4 x m, 
%        an array of m quaternions representing the symmetry group
%
%   OUTPUT:
%
%   q is 4 x n, the array of quaternions lying in the
%               fundamental region for the symmetry group 
%               in question
%
%   NOTES:  
%
%   *  This routine is very memory intensive since it 
%      applies all symmetries to each input quaternion.
%
n = size(quat, 2); % number of points
m = size(qsym, 2); % number of symmetries
%
%  Apply all symmetries to each member of quat.
%  
qeqv = QuatProd(...
    reshape(repmat(quat, m, 1), 4, m*n), ...
    repmat(qsym, 1, n));
%
%  Calculate max cosine and select corresponding element.
%
[qmax, imax] = max(abs(reshape(qeqv(1, :), m, n)), [], 1);
indices = (0:n-1)*m + imax;
q = qeqv(:, indices);

end

function qp = QuatProd(q2, q1)
% QuatProd - Product of two unit quaternions.
%   
%   USAGE:
%
%    qp = QuatProd(q2, q1)
%
%   INPUT:
%
%    q2, q1 are 4 x n, 
%           arrays whose columns are quaternion parameters
%
%   OUTPUT:
%
%    qp is 4 x n, 
%       the array whose columns are the quaternion parameters of 
%       the product; the first component of qp is nonnegative
%
%    NOTES:
%
%    *  If R(q) is the rotation corresponding to the
%       quaternion parameters q, then 
%       
%       R(qp) = R(q2) R(q1)
%
a = q2(1, :); a3 = repmat(a, [3, 1]);
b = q1(1, :); b3 = repmat(b, [3, 1]);
%
avec = q2(2:4, :);
bvec = q1(2:4, :);
%
qp = [...
    a.*b - dot(avec, bvec);                ...
    a3.*bvec + b3.*avec + cross(avec, bvec)...
    ];
%
q1negative = (qp(1,:) < 0 );
qp(:, q1negative) = -1*qp(:, q1negative);

end

function [els, crds] = MeshCoordinates(mesh, pts)
% MeshCoordinates - find elements and barycentric coordinates of points
%   
%   USAGE:
%
%   [els, crds] = MeshCoordinates(mesh, pts)
%
%   INPUT:
%
%   mesh is a MeshStructure,
%        it should be Delaunay, but it may be okay anyway if it is
%        not too irregular
%   pts  is m x n,
%        a list of n m-dimensional points
%
%   OUTPUT:
%
%   els is an n-vector, (integers)
%       the list of element numbers containing each point
%   crds is (m+1) x n,  
%       the barycentric coordinates of each point
%
%   NOTES:
%
%   *  The call to the matlab builtin `tsearchn' can fail if 
%      the mesh is not Delaunay.
%
MYNAME = 'MeshCoordinates';
%
crd = mesh.crd;
con = mesh.con;
%
[m, n] = size(pts);
%
%  This section requires some error checking since 
%  tsearchn may fail to produce the barycentric coordinates.
%  
[tmpele, tmpcrd] = tsearchn(crd', con', pts');
%
failed = isnan(tmpele);
%
if (any(failed))       % Retry.  This can work because a different
                       % algorithm is used for large point sets.
  warning([MYNAME, ':SearchFailed'], ...
	  'Search failed for %d points.  Retrying.', sum(failed))
  [tmpele(failed), tmpcrd(failed, :)] = ...
      tsearchn(crd', con', pts(:, failed)');
  if (any(isnan(tmpele)))
    error('Failed to find fiber coordinates.')
  end
end
%
els  = tmpele;
%
%  This is to handle matlab inconsistency in tsearchn.
%
if (n == 1) 
  crds = tmpcrd;
else
  crds = tmpcrd';
end

end


function quat = QuatOfAngleAxis(angle, raxis)
% QuatOfAngleAxis - Quaternion of angle/axis pair.
%
%   USAGE:
%
%   quat = QuatOfAngleAxis(angle, rotaxis)
%
%   INPUT:
%
%   angle is an n-vector, 
%         the list of rotation angles
%   raxis is 3 x n, 
%         the list of rotation axes, which need not
%         be normalized (e.g. [1 1 1]'), but must be nonzero
%
%   OUTPUT:
%
%   quat is 4 x n, 
%        the quaternion representations of the given
%        rotations.  The first component of quat is nonnegative.
%   
halfangle = 0.5*angle(:)';
cphiby2   = cos(halfangle);
sphiby2   = sin(halfangle);
%
rescale = sphiby2 ./sqrt(dot(raxis, raxis, 1));
%
quat = [cphiby2; repmat(rescale, [3 1]) .* raxis ] ;
%
q1negative = (quat(1,:) < 0);
quat(:, q1negative) = -1*quat(:, q1negative);
end

function rod = RodOfQuat(quat)
% RodOfQuat - Rodrigues parameterization from quaternion.
%   
%   USAGE:
%
%   rod = RodOfQuat(quat)
%
%   INPUT:
%
%   quat is 4 x n, 
%        an array whose columns are quaternion paramters; 
%        it is assumed that there are no binary rotations 
%        (through 180 degrees) represented in the input list
%
%   OUTPUT:
%
%  rod is 3 x n, 
%      an array whose columns form the Rodrigues parameterization 
%      of the same rotations as quat
% 
rod = quat(2:4, :)./repmat(quat(1,:), [3 1]);
end

function all = ToAllNodes(red, eqv)
% ToAllNodes - Spread array at independent nodes to all nodes.
%   
%   USAGE:
%
%   all = ToAllNodes(red, eqv)
%
%   INPUT:
%
%   red is m x n, 
%       a list of n m-vectors at the independent nodes of a mesh
%
%   eqv is 2 x l, (integer)
%       the list of node equivalences (new #, old #)
%
%   OUTPUT:
%
%   all is m x k, 
%       the array at all nodes of the mesh; k = n + l
%
if (isempty(eqv))
  all = red;
  return
end
%
%  If the input is simply a vector, then preserve shape on output.
%
[m n] = size(red);
if (n == 1) 
  transpose = 1;
  red = red';
  [m n] = size(red);
else
  transpose = 0;
end
%
eqvmax = max(eqv(1, :)); 
eqvmin = min(eqv(1, :)); 
%
if ( (n+1) ~= eqvmin)
  error('Data array does not match equivalence array')
end
%
nall = eqvmax;
%
all               = zeros(m, nall);    % allocate odf
all(:, 1:n)       = red;
all(:, eqv(1, :)) = red(eqv(2, :));
%
if (transpose)       % return vector of same type (row/col)
  all = all'; 
end
end
















