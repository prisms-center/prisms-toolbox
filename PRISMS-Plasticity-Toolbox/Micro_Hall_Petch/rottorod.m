%% Compute the Rodrigues vector from the rotation matrix 
function [angs,rvec] = rottorod(rmat)

rhomat = 1/2*(rmat - rmat') ;
mag = norm([ rhomat(2,1) ; rhomat(3,1) ; rhomat(3,2) ]) ;

  yval = mag ;
  xval = 1/2*(trace(rmat) - 1) ;
  k1 = atan2(yval,xval) ;
  if(k1 <= 1.0e-06)
      rvec = [ 0 ; 0 ; 0 ] ;
      angs = 0 ;
  elseif((pi - k1) <= 1.0e-06)
      uut = 1/2*(rmat + eye(3)) ;
      magu(1,1) = norm(uut(:,1)) ;
      magu(2,1) = norm(uut(:,2)) ;
      magu(3,1) = norm(uut(:,3)) ;
      
      [~,indx] = max(magu) ;
      clear mval ;
      rvec = uut(:,indx) ;
      angs = pi ;
      
  else 
      angs = atan2(yval,xval) ;
     rhomat = 1/2*(rmat - rmat') ;
     rvec(1,1) = rhomat(3,2) ;
     rvec(2,1) = rhomat(1,3) ;
     rvec(3,1) = rhomat(2,1) ;
     
     rvec = rvec/norm(rvec) ;
    
  end


end