function euler_avg = calculate_average_dominant_euler_hcp(euler_input_nby3, threshold_angle)
% find the average of the dominant orientation of the input euler angle.
% Now only works for hcp symmetry
% chenzhe, 2021-01-24
%
% added threshold_angle. Orientations within threshold_angle difference of
% an orientation are considered to represent the dominant orientation, and
% are used to calculate the average orientation. So, set it to 9999 if just
% want to calculate the average, regardless of if truely 'dominant'.

if ~exist('threshold_angle', 'var')
    threshold_angle = 10;
end

[~,q0,q1,q2,q3] = euler_to_quaternion(euler_input_nby3(:,1), euler_input_nby3(:,2), euler_input_nby3(:,3));

N = size(euler_input_nby3,1);
diffs = 100 * ones(N,1);    % difference(misorientation) between a quaternion and ther reference quaternion

% index of initial reference orientation. reset seed to gaurantee repeatability. 
rng(1);
ind_ref = randi(N);

counts = 0;
critical_pct = 0.5;
while true
    qs = [q0,q1,q2,q3];
    q_ref = qs(ind_ref,:);
    
    % find closest qs and update
    for jj = 1:size(qs,1)
        [q_out, val_min] = find_closest_quaternion_hcp(qs(jj,:), q_ref);
        qs(jj,:) = q_out;
        diffs(jj) = val_min;
    end
    
    inds = diffs < threshold_angle;
    % if more than 50% of the angle difference is smaller than 5 degree,
    % that means the reference pixel is representative of the average orientation
    if sum(inds) >= N * critical_pct
        qavg = calculate_avg_quat(qs(inds,:));
        break;
    else
        % if still cannot find solution, reduce the requirement by 1% of pts  
        counts = counts + 1;
        if counts > 50
            critical_pct = critical_pct - 0.01;
            counts = 0;
        end
        ind_ref = randi(N);
    end
end
m = quat2dcm(qavg);
[a,b,c] = dcm2angle(m,'zxz');

euler_avg = [a,b,c];
euler_avg = euler_avg/pi*180;

end