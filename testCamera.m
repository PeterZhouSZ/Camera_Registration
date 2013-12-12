colors =  {'b.', 'g.', 'r.', 'c.', 'm.', 'y.', 'k.'}; 
load param
for i = 1:10
    load(sprintf('data/XYZ_sep/left/XYZ_%02d.mat', i));
    xCor = XYZ_L(:,:,1);
    yCor = XYZ_L(:,:,2);
    zCor = XYZ_L(:,:,3);
    id = XYZ_L(:,:,4);
    x = xCor(id > 0);
    y = yCor(id >0 );
    z = zCor(id >0 );
    plot3(x, y ,z, colors{mod(i, 7) + 1}, 'MarkerSize', .1); hold on; 
    ptCloud = [x';y';z'];
    ptGT = R'*(ptCloud  - repmat(T, 1, size(ptCloud,2)));
    plot3(ptGT(1,:), ptGT(2,:), ptGT(3,:), 'r.', 'MarkerSize', .1);  
end