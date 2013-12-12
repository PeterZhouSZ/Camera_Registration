function v_new = drawPtsCams(R, width,ini_angle, pts, v, Rt)
colors =  {'b.', 'g.', 'r.', 'c.', 'm.', 'y.', 'k.'};  
eplison = 0.001;
% rotate 36 degree
for i = 1:30
    theta = (i-1)* (2*pi/30);
    angle_curr = ini_angle - theta;
   
    
    x_curr = R*cos(angle_curr);
    z_curr = R*sin(angle_curr);
    y_curr = 0;
   
    normal = [x_curr y_curr z_curr];%[2*x, 2*y, 2*z];
    point = [x_curr y_curr z_curr];
    d = -point*normal';
    
    if atan(abs(x_curr/(z_curr + eplison))) <= pi/4
        eps = width * cos(atan(abs(x_curr/z_curr)));
        [xx,yy]=ndgrid(x_curr - eps:x_curr+eps, y_curr-2:y_curr+2);
        zz = (-normal(1)*xx - normal(2)*yy - d)/normal(3);
        epsZ = width * sin(atan(abs(x_curr/z_curr)));
    else
        epsZ = width * sin(atan(abs(x_curr/z_curr)));
        [yy, zz]=ndgrid(y_curr-2:y_curr+2, z_curr-epsZ:z_curr+epsZ);
        xx = (-normal(3)*zz - normal(2)*yy - d)/normal(1);
        eps = width * cos(atan(abs(x_curr/z_curr)));
    end
    %curr_pts = [x_curr-eps, y_curr, z_curr; x_curr+eps, y_curr, z_curr; x_curr, y+2, z_curr];
    
    gtPts = v(pts{i},:); %refPts = proj{i};
    %[Rt{i} Eps] = estimateRigidTransform(gtPts', refPts');
    RR = Rt{i}(1:3,1:3); tt = Rt{i}(1:3,4);
    v_new{i} = RR'*(gtPts' - repmat(tt, 1, size(gtPts,1)));
    plot3(v_new{i}(1,:),v_new{i}(2,:),v_new{i}(3,:),colors{mod(i,7)+1}, 'MarkerSize', 1);
    hold on;   
    plot3(gtPts(:,1), gtPts(:,2), gtPts(:,3), colors{mod(i,7)+1}, 'MarkerSize', 1);
    pause(2);
    %surface(xx,yy,zz)
end
axis equal;
axis vis3d;