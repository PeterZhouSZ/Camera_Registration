function [pts, rangeMat] = genVisPts(width, R, v)    
    %colors =  {'b.', 'g.', 'r.', 'c.', 'm.', 'y.', 'k.'};  
    ini_angle = atan(width/R);
    angle_step = 2*pi/30;
    rangeMat = cell(1,30);
    pts = cell(1,30);
    for j = 1:30
        angle_low = pi/2 - angle_step*(j-1) + ini_angle;
        angle_high = pi/2 - angle_step*(j-1) - ini_angle;
        x_low = cos(angle_low);
        z_low = sin(angle_low);
        x_high = cos(angle_high);
        z_high = sin(angle_high);
        if (angle_low > 0) && (angle_high < 0)
             x_low = min(x_low, x_high);
             x_high = 1;
        elseif (angle_low > -pi) && (angle_high < -pi)
             x_high = max(x_low, x_high);
             x_low = -1;
        elseif (angle_low > -2*pi) && (angle_high < -2*pi)
             x_low = min(x_low, x_high);
             x_high = 1;            
        end
        
        if (angle_low > pi/2) && (angle_high < pi/2)
             z_low = min(z_low, z_high);
             z_high = 1;
        elseif (angle_low > -pi/2) && (angle_high < -pi/2)
             z_high = max(z_low, z_high);
             z_low = -1;        
        elseif (angle_low > -3*pi/2) && (angle_high < -3*pi/2)
             z_low = min(z_low, z_high);
             z_high = 1;           
        end
        
        
        
%         if (abs(x_low - x_high)<=  0.001 || (z_low*z_high < 0))
%             if x_low < 0
%                 x_high = max(x_low, x_high);
%                 x_low = -1;
%             elseif (x_low >= 0)
%                 x_low = min(x_low, x_high);
%                 x_high = 1;
%             end
%         end
% 
%         if (abs(z_low - z_high) <= 0.001 || (x_low*x_high<0) )
%             if z_low < 0
%                 z_high = max(z_low, z_high);
%                 z_low = -1;
%             elseif (z_low >= 0)
%                 z_low = min(z_low, z_high);
%                 z_high = 1;
%             end
%         end
        rangeMat{j} = [x_low, x_high; z_low, z_high];
        y_low = - sin(ini_angle);
        y_high = sin(ini_angle);
        idX =  (v(:,1) <= max(x_high, x_low)) & (v(:,1) >= min(x_high, x_low));
        idY =  (v(:,2) <= max(y_high, y_low)) & (v(:,2) >= min(y_high, y_low));
        idZ =  (v(:,3) <= max(z_high, z_low)) & (v(:,3) >= min(z_high, z_low));
        id = idX & idY & idZ;   
        pts{j} = find(id == 1);
        %plot3(v(id, 1), v(id, 2), v(id, 3), colors{mod(j,7)+1}, 'MarkerSize', 1); hold on;
        %pause(2);
    end
    
    
end