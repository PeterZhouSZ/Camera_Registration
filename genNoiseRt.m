function Rt_ini = genNoiseRt(omega, trans, Rt)
    for i = 1:30
        rr = injectNoise(omega(i,:));
        tt = trans(i, :);
        R = Rt{i}(1:3,1:3)*rr; 
        T = Rt{i}(1:3,4) + tt'; 
        Rt_ini{i} = [R T];
    end
end

function RR = injectNoise(omega)
    
    RR = eye(3); 
    RR(1,2) = -omega(1); RR(2,1) = omega(1);
    RR(1,3) = omega(2); RR(3,1) = -omega(1);
    RR(2,3) = -omega(3); RR(3,2) = omega(3);
end