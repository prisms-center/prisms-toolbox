function M = eul2mat(axeul)

phi = axeul(1,1) ;
theta = axeul(1,2) ;
psi = axeul(1,3) ;

M1 = [cos(phi)  sin(phi)  0 ;
      -sin(phi) cos(phi)  0  ;
          0        0      1] ;
      
M2 = [    1        0        0 ;
          0     cos(theta)  sin(theta) ;
          0     -sin(theta) cos(theta)]  ;
             
M3 = [cos(psi)  sin(psi)  0 ;
      -sin(psi) cos(psi)  0  ;
          0        0      1] ;      
M = M3*M2*M1 ;
      
end