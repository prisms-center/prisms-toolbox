%% Compute the Rotation matrix from the Rodrigues vector 
function rmat = rodtorot(rvec)

% Angle 

theta = 2*atan(norm(rvec)) ;

if(theta <= 1.0e-06)
    rmat = eye(3) ;
else 
    uvec = rvec/norm(rvec) ;
    ux = [0 -uvec(3) uvec(2) ; uvec(3) 0 -uvec(1) ; -uvec(2) uvec(1) 0] ;
    rmat = eye(3)*cos(theta) + uvec*uvec'*(1-cos(theta)) + ux*sin(theta) ; 
end
end
