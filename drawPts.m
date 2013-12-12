function drawPts(Rt, v, pts)
T = [0; 0; 10];
colors =  {'b.', 'g.', 'r.', 'c.', 'm.', 'y.', 'k.'};  
figure(1)
for frame = 1:30
    idx = pts{frame};
    RR = Rt{frame}(1:3,:); tt = RR'*T - RR'*Rt{frame}(1:3,4);
    temp = v(idx,:)'; 
    v_new{frame} = RR'*temp + repmat(tt, 1, size(v(idx,:),1));
    plot3(v_new{frame}(1,:),v_new{frame}(2,:),v_new{frame}(3,:),colors{mod(frame,7)+1}, 'MarkerSize', 5); hold on;
    %cam{frame}.pts = v(pts{frame},:) + repmat(tt, length(idx), 1);
end
axis equal;
hold off;
figure(2)
for frame = 1:30
    idx = pts{frame};
    RR = Rt{frame}(1:3,:); tt = RR'*T - RR'*Rt{frame}(1:3,4); 
    temp = RR*(v_new{frame} - repmat(tt, 1, size(v(idx,:),1)));
    plot3(temp(1,:),temp(2,:),temp(3,:),colors{mod(frame,7)+1}, 'MarkerSize', 5); hold on;
    %cam{frame}.pts = v(pts{frame},:) + repmat(tt, length(idx), 1);
end
hold off;