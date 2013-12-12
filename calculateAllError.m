function [RtErr_refine, TtError_refine, PtErr_rec] = calculateAllError(Rt, Rt_refine, gtPts, recPts, iter)

for i = 1:length(Rt)
    [RtErr_refine(i), TtError_refine(i)] = calculateCameraError(Rt{i}(1:3, :), Rt_refine{i}(1:3, :));
    %RtErr_ini(i) = calculateError(Rt, Rt_ini);
end
%PtErr_ini = calculateError(gtPts(index, :), iniPts);
%template = repmat([0 0 20], size(recPts,1), 1);
PtErr_rec = calculateError(gtPts, recPts);
fprintf('Rotation mean error: iter %d || %f  \n', iter, mean(RtErr_refine));
fprintf('Translation mean error: iter %d || %f  \n', iter, mean(TtError_refine));
fprintf('Point location error: iter %d || %f  \n', iter, PtErr_rec);
disp('--------------------------------------------------');

end


function error = calculateError(gt, rec)
    error = norm(vec(gt - rec), 2)/ norm(vec(gt), 2) ;
end

function [Rerror, Terror] = calculateCameraError(P0, P1)
R0 = P0(1:3, 1:3); R1 = P1(1:3, 1:3);
Rerror = norm(logm(R0'*R1),'fro');
Terror = norm(P1(:, 4)-P0(:, 4))/norm(P0(:, 4));
end