function misorientation_max = calculate_max_local_misorientation_hcp(phi1_local, phi_local, phi2_local)

% shift matrix to the right, to calculate each pixel's misorientation with the left-side pixel (boarder has error) 
p1 = circshift(phi1_local,1,2);
p2 = circshift(phi_local,1,2);
p3 = circshift(phi2_local,1,2);
m1 = arrayfun(@(x,y,z,xx,yy,zz) calculate_misorientation_euler_d([x,y,z], [xx,yy,zz], 'HCP'), phi1_local, phi_local, phi2_local, p1, p2, p3);
m2 = circshift(m1,-1,2);

% shift down
p1 = circshift(phi1_local,1,1);
p2 = circshift(phi_local,1,1);
p3 = circshift(phi2_local,1,1);
m3 = arrayfun(@(x,y,z,xx,yy,zz) calculate_misorientation_euler_d([x,y,z], [xx,yy,zz], 'HCP'), phi1_local, phi_local, phi2_local, p1, p2, p3);
m4 = circshift(m3,-1,1);

misorientation_max = max(cat(3,m1,m2,m3,m4),[],3);

% % Pixel-by-pixel calculation: for each pixel, find max misorientation within its four neighbors
% [nR,nC] = size(phi1_local);
% misorientation_max = zeros(nR,nC);
% for iR = 1:nR
%     for iC = 1:nC
%         neighbor_orientation = [];
%         % add upper neighbor, bottom neighbor, left neighbor, right neighbor
%         if iR>1
%             neighbor_orientation = [neighbor_orientation; phi1_local(iR-1,iC), phi_local(iR-1,iC), phi2_local(iR-1,iC)];
%         end
%         if iR<nR
%             neighbor_orientation = [neighbor_orientation; phi1_local(iR+1,iC), phi_local(iR+1,iC), phi2_local(iR+1,iC)];
%         end
%         if iC>1
%             neighbor_orientation = [neighbor_orientation; phi1_local(iR,iC-1), phi_local(iR,iC-1), phi2_local(iR,iC-1)];
%         end
%         if iC<nC
%             neighbor_orientation = [neighbor_orientation; phi1_local(iR,iC+1), phi_local(iR,iC+1), phi2_local(iR,iC+1)];
%         end
% 
%         euler_current = [phi1_local(iR,iC), phi_local(iR,iC), phi2_local(iR,iC)];
% 
%         misorientation = [];
%         for ii = 1:size(neighbor_orientation,1)
%             misorientation(ii) = calculate_misorientation_euler_d(euler_current, neighbor_orientation(ii,:), 'HCP');
%         end
%         misorientation_max(iR,iC) = max(misorientation);
%     end
% end

end