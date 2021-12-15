clear ; 
close all ;

ori_list = dlmread('orientations.txt','',1,0) ;
rvec = ori_list(:,2:4) ;

angs_list = linspace(0,2*pi,100) ;
rd = 1 ;
figure ;
% Plot unit circle
plot(rd*cos(angs_list),rd*sin(angs_list),'k','LineWidth',1.3) ;
hold on ;

pf_vec = [0 0 1] ;

for i=1:size(ori_list,1) 
    rotmat = rodtorot(rvec(i,:)') ;
    pf_vec_rot = (rotmat*pf_vec')' ;
    pf_vec_rot = pf_vec_rot*sign(pf_vec_rot(3))*-1 ;
    scatter(pf_vec_rot(1)/(1 - pf_vec_rot(3)),pf_vec_rot(2)/(1 - pf_vec_rot(3)),...
            [],'r','filled') ;
end
hold off ;
axis equal tight;



