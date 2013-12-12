function drawErrorPts(v_new, Rt_ini, Rt_refine)
colors =  {'b.', 'g.', 'r.', 'c.', 'm.', 'y.', 'k.'};  

for frame = 1:30
    gtPts = v_new{frame};
    refPts = Rt_ini{frame}(1:3,1:3) * gtPts + repmat(Rt_ini{frame}(1:3, 4), 1, size(gtPts, 2));%cam{frame}.pts';
    recPts = Rt_refine{frame}(1:3,1:3) * gtPts + repmat(Rt_refine{frame}(1:3, 4), 1, size(gtPts, 2));
    %plot3(gtPts(:,1), gtPts(:,2), gtPts(:,3), colors{mod(frame,7) + 1}); 
    %     subplot(1,2,2); hold on;
    %recPts = recPts - repmat([0;0;20], 1, size(recPts, 2));
    subplot(1,2, 1); hold on; title('Reconstrcuted points based on camera alignment');
    plot3(recPts(1,:), recPts(2,:), recPts(3,:), colors{mod(frame,7) + 1}, 'MarkerSize', .1); hold on;
    subplot(1,2,2); hold on; title('Reconstrcuted points without alignment');
    plot3(refPts(1,:), refPts(2,:), refPts(3,:), colors{mod(frame,7) + 1}, 'MarkerSize', .1);
   % pause(2);
%sum(abs(gtPts - refPts), 1)/size(gtPts, 1)
end
axis equal; 
