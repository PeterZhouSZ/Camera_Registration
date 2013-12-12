function drawRt(xx, yy, zz, Rt, gtPts, visId) 
colors =  {'b.', 'g.', 'r.', 'c.', 'm.', 'y.', 'k.'};  
for i = 1:12
   x = xx(:,1)'; y = yy(1,:);
   z = zz(1,:);
   plane = [x; y; z];
   R = Rt{i}(1:3, 1:3)';
   T = Rt{i}(1:3,4);
   planeN = R*plane - repmat(T, 1, size(plane,2));
   x1 = planeN(1, :); x1 = repmat(x1',1, size(x1,2));
   y1 = planeN(2, :); y1 = repmat(y1,size(y1,2), 1);
   z1 = planeN(3, :); z1 = repmat(z1',1, size(z1,2));hold on;
   %surface(x1, y1, z1);hold on;
   temp = gtPts(visId{i},:)';
   visPts = R*temp - repmat(T, 1, size(temp, 2));
   plot3(visPts(1,:), visPts(2,:), visPts(3,:), 'g.'); %colors{mod(i, 7) + 1} 
   %plot3(gtPts(visId{i}, 1), gtPts(visId{i},2), gtPts(visId{i},3), colors{mod(i, 7) + 1});
   
   xlabel('x-axis'); ylabel('y-axis'); zlabel('z-axis');
   pause(2)
end
axis equal

plot3(gtPts(:,1), gtPts(:,2), gtPts(:,3), 'r.')
end