% 
% use euler angle, crystal symmetry, to calculate misorientation angle
% 
% chenzhe, 2017
%
% chenzhe, 2019-04-02, modify to use my_quat2axang()
% chenzhe, 2020-11-03, use try catch to either use my_quat2axang or built-in  

function [theta_d, theta_r] = calculate_misorientation_euler_d(euler1_d, euler2_d, CS)
    switch CS
        case {'HCP','hcp','Hcp'}
            [S, ~] = hcp_symmetry();
        case {'FCC','fcc','Fcc'}
            [S, ~] = fcc_symmetry();
    end
    
    euler1_r = euler1_d/180*pi;
    euler2_r = euler2_d/180*pi;
    
    q = angle2quat(euler1_r(1), euler1_r(2), euler1_r(3),'zxz');
    Q = angle2quat(euler2_r(1), euler2_r(2), euler2_r(3),'zxz');
    
    delta = quatmultiply(quatconj(q),Q);
    
    for ii = 1:length(S)
        try
            theta_r(ii,:) = quat2axang(quatmultiply(delta,S(ii,:)));        % using function from robotics...ToolBox
        catch
            theta_r(ii,:) = my_quat2axang(quatmultiply(delta,S(ii,:)));
        end
        % Double check if they are the same
        % theta_r_built(ii,:)  = quat2axang(quatmultiply(delta,S(ii,:)));
        % theta_r(ii,:) - theta_r_built(ii,:)
        % theta_r(ii,:) + theta_r_built(ii,:)

    end
    theta_r = theta_r(:,4);
    
    theta_r = min(abs(theta_r));
    theta_d = theta_r/pi*180;

end