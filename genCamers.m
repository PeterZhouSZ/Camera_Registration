function [Rt, cc, normals, v_new] = genCamers(R, v, pts, ini_x, ini_y, ini_z, ini_angle)
Rt = cell(1,30);
cc = zeros(30,3);
normals = zeros(30, 3);
v_new = cell(1,30);
%eplison = 0.001;
%% verify the results
% xc = 0; yc = 0; %center
% r =10; %radius
colors =  {'b.', 'g.', 'r.', 'c.', 'm.', 'y.', 'k.'};  
% th = 0:pi/50:2*pi;
% xunit = r * cos(th) + xc;
% yunit = r * sin(th) + yc;
% plot(xunit, yunit, 'lineWidth', 1); hold on;
%%
for i = 1:30
    theta = (i-1)* (2*pi/30);
    angle_curr = ini_angle - theta;   
    x_curr = R*cos(angle_curr);
    z_curr = R*sin(angle_curr);
    y_curr = 0;
    
    %plot(x_curr, z_curr, colors{mod(i,7) + 1}, 'MarkerSize', 20);hold on;
    %pause(2);
    normal = [x_curr y_curr z_curr];%[2*x, 2*y, 2*z];
    point = [x_curr y_curr z_curr];
    
    %d = -point*normal';
    
%     if atan(abs(x_curr/(z_curr + eplison))) <= pi/4
%         eps = width * cos(atan(abs(x_curr/z_curr)));
%         [xx,yy]=ndgrid(x_curr - eps:x_curr+eps, y_curr-width:y_curr+width);
%         zz = (-normal(1)*xx - normal(2)*yy - d)/normal(3);
%         epsZ = width * sin(atan(abs(x_curr/z_curr)));
%     else
%         epsZ = width * sin(atan(abs(x_curr/z_curr)));
%         [yy, zz]=ndgrid(y_curr-width:y_curr+width, z_curr-epsZ:z_curr+epsZ);
%         xx = (-normal(3)*zz - normal(2)*yy - d)/normal(1);
%         eps = width * cos(atan(abs(x_curr/z_curr)));
%     end
%     ini_z_new = 0;
    [Rt{i}, ptSet] = cordinateTrans(x_curr, y_curr, z_curr, ini_x, ini_y, ini_z);
    %curr_pts = [x_curr-eps, y_curr, z_curr; x_curr+eps, y_curr, z_curr; x_curr, y+2, z_curr];
    cc(i, :) = point;
    normals(i,:) = normal;
    %Rt{i} = calRT(eps, epsZ, x_curr, y_curr, z_curr, ini_pts);     
%     fprintf('Degree: %f\n', atan(abs(x_curr/z_curr)));
%     plot(ptSet(2:3, 1), ptSet(2:3, 3), colors{mod(i,7) + 1}, 'MarkerSize', 20); hold on;
%     pause(2);
    RR = Rt{i}(1:3,1:3); tt = Rt{i}(1:3,4);
    gtPts = v(pts{i},:);
%     testPts =  gtPts' - repmat(point', 1,  size(gtPts,1));
%     testPts([1 3],:) = -1.* testPts([1 3],:);
    v_new{i} =  RR'*( gtPts' - repmat(tt, 1, size(gtPts,1)));
    % - repmat(point', 1,  size(gtPts,1))
    plot3(v_new{i}(1,:),v_new{i}(2,:),v_new{i}(3,:),colors{mod(i,7)+1}, 'MarkerSize', 1);
    hold on;
    recPts = RR*v_new{i} + repmat(tt, 1, size(v_new{i},2));
    plot3(recPts(1,:), recPts(2,:), recPts(3,:), colors{mod(i,7)+1}, 'MarkerSize', 1);
    
    pause(2);
end
axis equal;
axis vis3d;