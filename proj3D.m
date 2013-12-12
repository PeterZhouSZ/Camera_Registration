function proj = proj3D(ptCloud, pts, cc, normals)
proj = cell(1,30);
for frame = 1:30
    idx = pts{frame};
    P = ptCloud(idx, :);
    Q = cc(frame,:);
    N = normals(frame,:);
    N = N/norm(N);
    N2 = N.'*N;
    P0 = P*(eye(3)-N2)+repmat(Q*N2,length(idx),1);
    proj{frame} = P0;
end

end