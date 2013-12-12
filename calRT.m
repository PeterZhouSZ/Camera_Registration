function Rt = calRT(epsX, epsZ, x_curr, y_curr, z_curr, ini_pts)

rangeX_low = -sign(z_curr)*abs(epsX);
rangeX_high = sign(z_curr)*abs(epsX);

rangeZ_low = sign(x_curr)*abs(epsZ);
rangeZ_high = -sign(x_curr)*abs(epsZ);

curr_pts(1,:) = [x_curr+rangeX_low, y_curr+2, z_curr+rangeZ_low];

curr_pts(2,:) = [x_curr, y_curr+2, z_curr];

curr_pts(3,:) = [x_curr+rangeX_high, y_curr+2, z_curr+rangeZ_high];

curr_pts(4,:) = [x_curr+rangeX_low, y_curr, z_curr+rangeZ_low];

curr_pts(5,:) = [x_curr, y_curr, z_curr];

curr_pts(6,:) = [x_curr+rangeX_high, y_curr, z_curr+rangeZ_high];

curr_pts(7,:) = [x_curr+rangeX_low, y_curr-2, z_curr+rangeZ_low];

curr_pts(8,:) = [x_curr, y_curr-2, z_curr];

curr_pts(9,:) = [x_curr+rangeX_high, y_curr-2, z_curr+rangeZ_high];

[Rt Eps] = estimateRigidTransform(ini_pts', curr_pts');

end