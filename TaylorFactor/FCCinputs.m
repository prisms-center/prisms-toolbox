function [m,n,ntwin,crss] = FCCsystems

ntwin = 0;

q1 = 1/sqrt(2);
q2 = 1/sqrt(3);

%slip directions
m = [  0  	    q1    -q1  
 -q1     0.0       q1  
  q1    -q1     0.0    
  0 	   -q1    -q1  
  q1     0.0       q1
 -q1     q1     0.0    
  0  	    q1    -q1  
  q1     0.0       q1  
 -q1    -q1     0.0    
  0 	   -q1    -q1  
 -q1     0.0       q1  
  q1     q1     0.0    
];

%slip normals
n = [ q2	 q2	 q2
 q2	 q2	 q2
 q2	 q2	 q2
-q2	-q2	 q2
-q2	-q2	 q2
-q2	-q2	 q2
-q2	 q2	 q2
-q2	 q2	 q2
-q2	 q2	 q2
 q2	-q2	 q2
 q2	-q2	 q2
 q2	-q2	 q2];

crss = ones(size(m,1),1); 