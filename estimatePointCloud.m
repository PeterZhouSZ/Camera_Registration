function [recPts, Rt_refine, idxSet] = estimatePointCloud(Vmap, Rt_ini, pts, v_new, opt)

%omega = 0.02 * (2*rand(size(Vmap,1),3)-1); %zeros(size(Vmap,1),3);%
%trans = 0.05 * (2*rand(size(Vmap,1),3)-1); %zeros(size(Vmap,1),3);%
% omega = error{1};
% trans = error{2};
% Rt_ini = genNoiseRt(omega, trans, Rt);

writerObj = VideoWriter('camera_align.avi');
writerObj.FrameRate = 1; 
open(writerObj);
%figure(2);clf
% drawCams(Rt_ini);
% title('Initial Cameras Location');
%% vanilla
if (opt.simple == 1)
    Rt_temp = Rt_ini;
    for iter = 1:opt.maxiter
        [recPts  matchedId idxSet] = opt_l2(Vmap, pts, v_new, Rt_temp, opt);
        Rt_refine = estimateRT(pts, matchedId, v_new, recPts);
        %Rt_refine = registerRT(Rt_refine, opt);
        [RtErr_refine, PtErr_rec] = calculateAllError(opt.Rt, Rt_refine, opt.gtPts, recPts, idxSet);
        fprintf('Rt mean error: iter %d || %f  \n', iter, mean(RtErr_refine));
        fprintf('Point location error: iter %d || %f  \n', iter, PtErr_rec);
        disp('--------------------------------------------------');
        h = figure(3); clf;
        set(h,'Units','Normalized','OuterPosition',[0 0 1 1]);
        set(gcf,'Color',[0 0 0]);
        h1 = subplot(2,2,1); drawCams(opt.Rt);
        text(.3, .25,'Ground Truth','BackgroundColor',[1 1 1]);
        set(h1, 'OuterPosition', [0 .5 .5 .5]); 
        
        h2 = subplot(2,2,3);
        drawCams(Rt_ini);
        text(.3, .85,'Initial Camera Locations','BackgroundColor',[1 1 1]);
        set(h2, 'OuterPosition', [0 0 .5 .5]); 
        
        h3 = subplot(2,2,2);
        drawCams(Rt_refine);
        text(.75, .5, sprintf('Refined iteration %d', iter),'BackgroundColor',[1 1 1]);
        set(h3, 'OuterPosition', [0.5 0 .5 1]); 
        
        f = getframe(h);
        writeVideo(writerObj,f.cdata(30:750, 100:1520, :));       
        Rt_temp = Rt_refine;
    end
    close(writerObj);
end
return;
%% L1-norm
if (opt == 3)
    tic;
    [recPts matchedId] = l1_opt(Vmap, pts, v_new, Rt_ini, opt);
    fprintf('l1 done in %f\n', toc);
end

% keyboard;

%keyboard;

%% demo 
figure(1);
drawCams(Rt);
figure(2)
drawCams(Rt_ini);
figure(3)
drawCams(Rt_refine);
%% Mahalanobis distance
% 


end


function drawCams(Rt)
dX = 10;
IP = [1 1 10; 1 -1 10; -1 -1 10; -1 1 10; 1 1 10]';
BASE = [0 0 11; 1 0 11; 0 0 0; 0 1 11; 0 0 0; 0 0 12]';
IP = reshape([IP;BASE(:,1)*ones(1,5);IP],3,15);
POS = [[6*dX;0;0] [0;6*dX;0] [-dX;0;5*dX] [-dX;-dX;-dX] [0;0;-dX]];
plotCamera(BASE, IP, POS, 1); hold on;
% % colors =  {'b.', 'g.', 'r.', 'c.', 'm.', 'y.', 'k.'};  
% % plot3(v(:,1), v(:,2), v(:,3), 'r.', 'MarkerSize', 0.1); hold on;
%xlabel('x-axis'); ylabel('y-axis'); zlabel('z-axis');
R_base = Rt{1}(1:3,1:3); t_base = Rt{1}(1:3,4);
BASE_ORI = R_base*BASE + repmat(t_base, 1, size(BASE,2));
IP_ORI = R_base*IP + repmat(t_base,1, size(IP,2));
POS_ORI = R_base*POS + repmat(t_base,1, size(POS,2));
for j = 2:30
    R = Rt{j}(1:3,1:3);
    t = Rt{j}(1:3,4);
%     ref = R'*(v' - repmat(t, 1, size(v,1)));
%     plot3(ref(1,:), ref(2,:), ref(3,:), colors{mod(j,7) + 1}, 'MarkerSize', 0.1);
    BASE = R' * (BASE_ORI - repmat(t, 1, size(BASE,2)));
    IP = R' * (IP_ORI - repmat(t, 1, size(IP,2)));
    POS = R'* (POS_ORI - repmat(t, 1, size(POS,2)));
    plotCamera(BASE, IP, POS, j);hold on;
end
axis equal
end

function plotCamera(BASE, IP, POS,depth)
    p1 = struct('vertices',IP','faces',[1 4 2;2 4 7;2 7 10;2 10 1]);
    h1 = patch(p1);
    set(h1,'facecolor',[52 217 160]/255,'EdgeColor', 'r');
    p2 = struct('vertices',IP','faces',[1 10 7;7 4 1]);
    h2 = patch(p2);
    %set(h2,'facecolor',[236 171 76]/255,'EdgeColor', 'none');
    set(h2,'facecolor',[247 239 7]/255,'EdgeColor', 'none');
    %plot3(BASE(1,:),BASE(2,:),BASE(3,:),'b-','linewidth',1');
    plot3(IP(1,:),IP(2,:),IP(3,:),'r-','linewidth',1);
    %text(POS(1,5),POS(2,5),POS(3,5),num2str(depth),'fontsize',10,'color','k','FontWeight','bold');
end

function [recPts, matchedId, idxSet] = opt_l2(Vmap, pts, v_new, Rt_ini, opt)
    recPts = zeros(opt.pt_size,3); 
    matchedId = cell(1,30);
    idxSet = [];
    for ptId = 1:size(Vmap, 2)
        idx = find(Vmap(:,ptId) > 0);
        ptNumber = length(idx);
        if (ptNumber > 2)
            ptCloud = 0;
            index = pts{idx(1)}( Vmap(idx(1), ptId));
            idxSet = [idxSet index];
            for i = 1: ptNumber
                temp = v_new{idx(i)}(:,Vmap(idx(i), ptId));%cam{idx(i)}.pts(:,Vmap(idx(i), ptId));
                R = Rt_ini{idx(i)}(1:3,1:3); 
                T = Rt_ini{idx(i)}(1:3,4); 
                ptCloud = ptCloud + R * temp + repmat(T, 1, size(temp,2));
                tempV = matchedId{idx(i)};
                tempV = [tempV Vmap(idx(i), ptId)];
                matchedId{idx(i)} = tempV;
            end
            ptCloud = ptCloud/ptNumber;
            recPts(index, :) = ptCloud;
        end       
    end
%     matchedId = findMatch(Vmap);
%     idxSet = find3Dpts(matchedId, pts);
end 

function [recPts, matchedId, idxSet] = l1_opt(Vmap, pts, v_new, Rt_ini, opt)
    recPts = zeros(opt.pt_size,3); 
    matchedId = cell(1,30);
    idxSet = [];
    %tol = 1e-2;
    for ptId = 1:size(Vmap, 2)
       idx = find(Vmap(:,ptId) > 0);
       ptNumber = length(idx);
       if (ptNumber > 2)
        ptCloud = [];
        index = pts{idx(1)}( Vmap(idx(1), ptId));
        idxSet = [idxSet index];
        for i = 1: ptNumber
            temp = v_new{idx(i)}(:,Vmap(idx(i), ptId));%cam{idx(i)}.pts(:,Vmap(idx(i), ptId));
            R = Rt_ini{idx(i)}(1:3,1:3);
            T = Rt_ini{idx(i)}(1:3,4);
            ptCloud(:,i) = R * temp + repmat(T, 1, size(temp,2));
            tempV = matchedId{idx(i)};
            tempV = [tempV Vmap(idx(i), ptId)];
            matchedId{idx(i)} = tempV;
        end
        K = size(ptCloud, 2);
        cvx_begin
            variable x1(3);
            minimize ( sum(norms(x1*ones(1,K) - ptCloud,1) )); % 
%         subject to
%             sum(sum(norms(x1*ones(1,K) - ptCloud,2))) < tol;
        cvx_end
        
        recPts(index, :) = x1;
        %diff = (v(index,:) - recPts(index,:)).^2;
        %Eps(recNumber) = sum(diff,2);
       end

    end  
end

function Rt_refine = estimateRT(pts, matchedId, v_new, recPts)
    Rt_refine = cell(1,30);
%     keyboard;
    for i = 1:30
        id = pts{i};
        recId = matchedId{i}; 
        %fprintf('Finished %d...\n',i);
        gtPts = v_new{i}(:,recId);
        rfPts = recPts(id(recId), :);
        [Rt_refine{i}, Eps] = estimateRigidTransform(rfPts',  gtPts);
    end
end

function Rt = registerRT(Rt_refine, opt)
    Rdelta = Rt_refine{1}(1:3,1:3)';
    %Rt_refine{1}(1:3,1:3)';
    %Rt_refine{1}(1:3,1:3);
    %
    Tdelta = -opt.Rt{1}(1:3,4) - Rdelta*Rt_refine{1}(1:3,4);
    %opt.Rt{1}(1:3,4) - Rdelta*Rt_refine{1}(1:3,4);
    % Rt_refine{1}(1:3,4) - Rdelta*opt.Rt{1}(1:3,4);
    for i = 1:30
        Rt{i}(1:3,1:3) = Rdelta*Rt_refine{i}(1:3,1:3);
        %Rt_refine{i}(1:3,1:3)*Rdelta';
        
        Rt{i}(1:3,4) = Rdelta * Rt_refine{i}(1:3, 4) + Tdelta; 
        % 
        %Rdelta'*(Rt_refine{i}(1:3, 4) - Tdelta);
    end
end

% function matchedId = findMatch(Vmap)
%     matchedId = cell(1,30);
%     for id = 1:30
%         index = find(Vmap(id, :) > 0);
%         counter = 0;
%         testId = [];
%         for i = 1:length(index)    
%             idx = find(Vmap(:, index(i)) > 0);
%             if ( length(idx) > 2)
%                 counter = counter + 1;
%                 testId(counter) = Vmap(id, index(i));
%             end
%         end
%         matchedId{id} = testId;
%     end
% end
% 
% function idxSet = find3Dpts(matchedId, pts)
%     idxSet = [];
%     for i = 1:30
%         idxSet = [idxSet pts{i}(matchedId{i})'];
%     end
% end
