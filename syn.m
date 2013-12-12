clear all;close all;
%% initial settings
%addpath(genpath('SiftFu'))
addpath('estimateRT');
width = 3.5;
% [x,y,z] = sphere; 
%surface(10*x, 10*y, 10*z);
disp('Generating Synthetic Data.....')
v = randn(10000,3);
v = bsxfun(@rdivide,v,sqrt(sum(v.^2,2)));
% plot3(v(:,1),v(:,2),v(:,3),'.', 'MarkerSize', 2)

ini_x = 0; ini_y = 0; z = sqrt(100 - ini_x^2 - ini_y^2);
ini_angle = atan(z/ini_x);
ini_z = 0; R=10;
disp('Done..')
%% get points set
disp('Simulating the 3D to 2D projection....')
R_new = 2;
[pts rangeMat] = genVisPts(width, R_new, v); 
disp('Done....')
%% generte Camera locations
disp('Initialize the camera locations....');
[Rt, cc, normals, v_new]= genCamers(R, v, pts, ini_x, ini_y, ini_z, ini_angle);
%drawRt(ini_xx, ini_yy, ini_zz, Rt, v, pts);
%drawPoints(v, pts);  
disp('Done....')
%% verify the results
%if you wan to verify the results, please uncomment this. 
%drawVisibility(rangeMat);
% drawPts(Rt, v, pts);
%% points correspondence
disp('Simulating the matches between images....')
cam = genPtcorrespondence(pts, v, v_new);
disp('Done....')
%% generate Vmap
%Vmap = genVisMap(cam);
% Vmap = genVisMap(cam);
%drawErrorPts(cam, pts, v);
for i = 1:30
    Vmap(i, pts{i}) = 1:length(pts{i});
end

%% cost optimization
disp('Initialize the paramters in the optimization.....')
range_mat = 1:30;
low = 0.01; 
high = 0.5; 
range_mat = low + (high - low)*(range_mat - 1)/(30 - 1);
range_mat = repmat(range_mat, size(Vmap,1), 1); %.1*ones(1,30)
error{1} = range_mat * (2*rand(size(Vmap,1),3)-1); %zeros(size(Vmap,1),3);%
error{2} = range_mat * (2*rand(size(Vmap,1),3)-1); %zeros(size(Vmap,1),3);%


Rt_ini = genNoiseRt(error{1}, error{2}, Rt);
% set the option
opt.simple = 1; 
opt.Rt = Rt;
opt.gtPts = v;
opt.pt_size = size(v, 1);
opt.maxiter = 30;

[recPts, Rt_refine, idxSet] = estimatePointCloud(Vmap, Rt_ini, pts, v_new, opt);

%% register point cloud
gtPts = v((sum(Vmap, 1) > 0), :);
visrecPts = recPts((sum(Vmap, 1) > 0), :);
[Rt_delta, Eps] = estimateRigidTransform(gtPts', visrecPts');
newRec  = Rt_delta(1:3,1:3)*visrecPts' + repmat(Rt_delta(1:3,4), 1, size(visrecPts,1));
template = zeros(3, size(v,1));
template(:, sum(Vmap, 1) > 0) = newRec;
%template = newRec;

for j = 1:30
    idx1 = Vmap(j,:) > 0;
    temp = template(:,idx1); 
    [Rt_final{j}, Eps] = estimateRigidTransform(temp, v_new{j}); 
end

[RtErr_refine, TtError_refine, PtErr_rec] = calculateAllError(Rt, Rt_final, gtPts, newRec', 31);
disp('Display the results.....')
drawErrorPts(v_new, Rt_ini, Rt_final);

axis equal
