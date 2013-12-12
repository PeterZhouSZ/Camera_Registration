index = find(Vmap(1, :) > 0);
counter = 0;
testId = [];
for i = 1:length(index)    
    idx = find(Vmap(:, index(i)) > 0);
    if ( length(idx) > 2)
        counter = counter + 1;
         testId(counter) = idx(i);
    end
end

colors =  {'b.', 'g.', 'r.', 'c.', 'm.', 'y.', 'k.'};  
for i = 1:30
    
    ori = Rt{i}(1:3,1:3)*v_new{i} + repmat(Rt{i}(1:3,4), 1, size(v_new{i},2));
%     subplot(2,1,1);
    plot3(ori(1,:),ori(2,:),ori(3,:), colors{mod(i,7) + 1}, 'MarkerSize', .1); hold on;
    
%     new = Rt_ini{i}(1:3,1:3)*v_new{i} + repmat(Rt_ini{i}(1:3,4), 1, size(v_new{i},2));
%     new = new - repmat([0; 0; 20], 1, size(new, 2));
%     subplot(2,1,2);
%     plot3(new(1,:),new(2,:),new(3,:), colors{mod(i,7) + 1}, 'MarkerSize', .1); hold on;
    pause(5);
end