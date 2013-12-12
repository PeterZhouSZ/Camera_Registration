function drawPoints(gtPts, visId)
    colors =  {'b.', 'g.', 'r.', 'c.', 'm.', 'y.', 'k.'};        
    for i = 1:length(visId)
        figure(i)
        plot3(gtPts(visId{i}, 1), gtPts(visId{i},2), gtPts(visId{i},3), colors{mod(i, 7) + 1});
        hold on;
        pause(2);
    end
end