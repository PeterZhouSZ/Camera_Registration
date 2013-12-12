function cam= genPtcorrespondence(pts, v, v_new)  
    for frame = 1: 30 
        if frame == 30
            idxCurr = pts{1};
        else
            idxCurr = pts{frame+1};
        end
        
        idx = pts{frame};
        
        cam{frame}.pts = v_new{frame};%(R_Gt*RR)' * (gtPts' - repmat(tt_Gt + tt', 1, size(gtPts,1)));
        cam{frame}.match = cell(1,30);
        template = zeros(1, size(v,1));
        template(idx) = 1;
        
        for iter =  frame +1: 30
            index = [];
            indexCurr = [];
            idxCurr = pts{iter};
            temp = template;
            temp(idxCurr) = temp(idxCurr) + 1;
            matchId = find(temp == 2);
            for ll = 1:length(matchId)
                index(ll) = find(idx == matchId(ll));
                indexCurr(ll) = find(idxCurr == matchId(ll));
                
            end
            
            if length(index) > 0
                cam{frame}.match{iter}(1,:) = index;
                cam{frame}.match{iter}(2,:)= indexCurr;
            end
        end
    end
    
%     omega = 0.03 * rand(1,3);
%     tt = 0.03*rand(1,3);
%     RR = eye(3);%zeros(3,3);
%     RR(1,2) = -omega(1); RR(2,1) = omega(1);
%     RR(1,3) = omega(2); RR(3,1) = -omega(1);
%     RR(2,3) = -omega(3); RR(3,2) = omega(3);
%     %tt = [0 0 0];
% 
%     R_Gt = Rt{30}(1:3,1:3);
%     tt_Gt = Rt{30}(1:3,4);