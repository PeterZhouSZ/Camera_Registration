function drawVisibility(rangeMat)
xc = 0; yc = 0; %center
r =1; %radius
colors =  {'b.', 'g.', 'r.', 'c.', 'm.', 'y.', 'k.'};  
th = 0:pi/50:2*pi;
xunit = r * cos(th) + xc;
yunit = r * sin(th) + yc;
plot(xunit, yunit, 'lineWidth', 1); hold on;
for i = 1:length(rangeMat)
    %plot(rangeMat{i}(1,:), rangeMat{i}(2,:),colors{mod(i,7) + 1}, 'MarkerSize', 20); 
    idX = (xunit >= min(rangeMat{i}(1,:))) &  (xunit <= max(rangeMat{i}(1,:)));
    idZ = (yunit >= min(rangeMat{i}(2,:))) & (yunit <= max(rangeMat{i}(2,:)));
    id = idX & idZ;
    plot(xunit(id), yunit(id), colors{mod(i, length(colors)) + 1}, 'MarkerSize', 20); %'lineWidth', 3 
    pause(2);
end