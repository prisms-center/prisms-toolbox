

function [phi1_d,phi_d,phi2_d]=align_euler_to_sample(phi1_d,phi_d,phi2_d,method,p1,pp,p2)

% [phi1_d,phi_d,phi2_d]=align_euler_to_sample(phi1_d,phi_d,phi2_d,method,p1,pp,pb)
% input should be in degree
% [p1,pp,pb] are the additional rotations. For MSU-Tescan, UMich-Tescan, it
% is [90, 180, 0].  For UCSB-Teneo and UCSB-Tribeam, it is [-90,180,0].
% method == 'mtex' or 1 requires the mtex toolbox
% method == 0 requires my functions
%
% chenzhe, 2017-06-05
%
% chenzhe, 2017-09-20
% note that it seems like currently, no symmetry considered, so the angle
% is not regulated
% 
% chenzhe, 2021-08-22, replace waitbar with updated line in command window

switch method
    case {'mtex',1}
        rot = rotation('Euler',p1*degree,pp*degree,p2*degree);
        % h = waitbar(0,'rotating data...');
        nN = length(phi1_d(:));
        fprintf('rotationg data:      ');
        for ii = 1:nN
            rotOld = rotation('Euler',phi1_d(ii)*degree,phi_d(ii)*degree,phi2_d(ii)*degree);
            rotNew = rot * rotOld;
            phi1_d(ii) = rotNew.phi1/pi*180;
            phi_d(ii) = rotNew.Phi/pi*180;
            phi2_d(ii) = rotNew.phi2/pi*180;
            if rem(ii, 10000)==1
                try
                    % waitbar(ii/nN, h);
                    fprintf('\b\b\b\b\b %2.0f %%',ii/nN * 100);
                end
            end
        end
        fprintf(newline);
    otherwise
        M = angle2dcm(p1/180*pi,pp/180*pi,p2/180*pi,'zxz');
        % h = waitbar(0,'rotating data...');
        nN = length(phi1_d(:));
        fprintf('rotationg data:      ');
        for ii = 1:nN
            m = angle2dcm(phi1_d(ii)/180*pi,phi_d(ii)/180*pi,phi2_d(ii)/180*pi,'zxz');
            m = m*M;
            [a,b,c] = dcm2angle(m,'zxz');
            phi1_d(ii) = a/pi*180;
            phi_d(ii) = b/pi*180;
            phi2_d(ii) = c/pi*180;
            if rem(ii,10000)==1
                try
                    % waitbar(ii/nN, h);
                    fprintf('\b\b\b\b\b %2.0f %%',ii/nN * 100);
                end
            end
        end
        fprintf(newline);
end
try
    close(h);
end
disp(['num of points rotated: ',num2str(ii)]);
end

