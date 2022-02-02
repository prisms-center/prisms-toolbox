% Dt = interp_data(xf,yf,Df,xt,yt,tform_fwd,method, interpMethod)
% interpolate data using 'fit' or 'interp2' method
% 
% output = Dt: data matrix interp to
% 
% inputs:
% xf: x coordinate matrix interp from
% yf: y coordinate matrix interp from
% Df: data matrix interp from
% xt: x coordinate matrix interp to
% yt: y coordinate matrix interp to
% tform_fwd: this can have two forms:
%   (1) structure from 'maketform'
%   (2) object from 'fitgeotrans'
%   If empty [], no transform, just interp
% method:  'interp' = use function 'interp2', 'fit' = use function scatteredInterplant 
% interpMethod: interp method in function such as 'nearest' or 'linear'
%
% chenzhe, 2020-12-31 organized note
%
% chenzhe, 2017-05-31
% chenzhe, 2018-05-25, update to solve possible problems with EBSD
% wrapping unwrapping. Use with caution.

function Dt = interp_data(xf,yf,Df,xt,yt,tform_fwd,method,interpMethod)
% correct EBSD unwrapping related issue. Use with caution.
for iR = size(xf,1):-1:1
    if ~isequal(xf(iR,:),xf(1,:),'rows')
        xf(iR,:) = xf(1,:);
    end
end
yStep = yf(2)-yf(1);
for iR = 3:size(yf,1)
   if length(unique(yf(iR,:))>1)
      yf(iR,:) = yf(iR-1,:)+yStep; 
   end
end
    
if isempty(tform_fwd)
    tform_fwd = maketform('projective',diag([1 1 1]));
end
% get tform type. It can be a result of old version 'maketform', or can be
% a result of 'fitgeotrans'
tform_type = class(tform_fwd);
switch tform_type
    case 'affine2d'
        tform_fwd =  maketform('affine', tform_fwd.T);
    case'projective2d'
        tform_fwd = maketform('projective', tform_fwd.T);
end

switch method
    case {'interp','Interp'}
        [xt_bwd, yt_bwd] = tforminv(tform_fwd,xt,yt);
        Dt = interp2(xf,yf,Df,xt_bwd,yt_bwd,interpMethod);
    case {'fit','Fit'}
        [xf_fwd, yf_fwd] = tformfwd(tform_fwd,[xf(:),yf(:)]);
        F = scatteredInterpolant(xf_fwd, yf_fwd, Df(:),interpMethod);
        Dt = F(xt,yt);
end
end