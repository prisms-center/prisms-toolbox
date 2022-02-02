% qavg = calculate_avg_quat(Q)
% Q is nx4 matrix of quaternions
%
% Zhe Chen 2015-08-24 revised.

function qavg = calculate_avg_quat(Q)
    Q = sum(Q,1);
    qavg = Q/quatmod(Q);
end