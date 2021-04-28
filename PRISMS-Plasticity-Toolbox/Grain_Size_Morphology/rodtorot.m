%% Compute the orientation matrix from the Rodrigues vector 
function rmat = rodtorot(rvec)

% Angle 

theta = 2*atan(norm(rvec)) ;

if(theta <= 1.0e-06)
    rmat = eye(3) ;
else 
    uvec = rvec/norm(rvec) ;
    ux = [0 -uvec(3,1) uvec(2,1) ; uvec(3,1) 0 -uvec(1,1) ; -uvec(2,1) uvec(1,1) 0] ;
    rmat = eye(3)*cos(theta) + uvec*uvec'*(1-cos(theta)) + ux*sin(theta) ; 
end
end
