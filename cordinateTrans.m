function [Rt ptSet] = cordinateTrans(x_curr, y_curr, z_curr, ini_x, ini_y, ini_z)

unitX = (atan(abs(x_curr/z_curr)));
unitY = 1;
unitZ = (atan(abs(x_curr/z_curr)));

if z_curr >= 0
   if x_curr >= 0
       X_delta_1 = cos(unitX);  
       X_delta_2 = -sin(unitZ);
       
       Z_delta_1 = -sin(unitX); %-sin(unitX);
       Z_delta_2 = -cos(unitZ); %-cos(unitZ);
   else
       X_delta_1 = cos(unitX);  
       X_delta_2 = sin(unitZ);
       
       Z_delta_1 = sin(unitZ);%sin(unitX);
       Z_delta_2 = -cos(unitZ);%-cos(unitZ); 
   end
elseif z_curr < 0 
    if x_curr >= 0
       X_delta_1 = -cos(unitX);  
       X_delta_2 = -sin(unitZ);
       
       Z_delta_1 = -sin(unitX); % -sin(unitX);
       Z_delta_2 = cos(unitZ); % cos(unitZ); 
   else
       X_delta_1 = -cos(unitX);  
       X_delta_2 = sin(unitZ);
       
       Z_delta_1 = sin(unitX); % sin(unitX);
       Z_delta_2 = cos(unitZ); % cos(unitZ); 
   end
end
% deltaX = -unitX; deltaZ = -unitZ; 
deltaY = unitY;
ptSet(1, :) = [x_curr, y_curr, z_curr];
ptSet(2, :) = [x_curr + X_delta_1, y_curr, z_curr + X_delta_2];
ptSet(3, :) = [x_curr + Z_delta_1, y_curr, z_curr + Z_delta_2];

% ptSet(4, :) = [x_curr - X_delta_1, y_curr, z_curr - X_delta_2];
% ptSet(4, :) = [x_curr, y_curr + deltaY, z_curr];
% ptSet(5, :) = [x_curr, y_curr - deltaY, z_curr];
% ptSet(4, :) = [x_curr , y_curr, z_curr + deltaZ];
% ptSet(5, :) = [x_curr - Z_delta_1, y_curr, z_curr - Z_delta_2];
% ptSet(6, :) = [x_curr + X_delta_1 + Z_delta_1, y_curr + 1, z_curr + X_delta_2 + Z_delta_2];
% ptSet(7, :) = [x_curr - X_delta_1 - Z_delta_1, y_curr - 1, z_curr - X_delta_2 - Z_delta_2];

refSet(1, :) = [ini_x, ini_y, ini_z];
refSet(2, :) = [ini_x + 1, ini_y, ini_z];
refSet(3, :) = [ini_x, ini_y, ini_z + 1];

% refSet(4, :) = [ini_x - 1, ini_y, ini_z];
% % refSet(4, :) = [ini_x, ini_y + 1, ini_z];
% % refSet(5, :) = [ini_x, ini_y - 1, ini_z];
% %refSet(5, :) = [ini_x, ini_y, ini_z + 1];
% refSet(5, :) = [ini_x, ini_y, ini_z + 1];
% refSet(6, :) = [ini_x + 1, ini_y + 1, ini_z - 1];
% refSet(7, :) = [ini_x - 1, ini_y - 1, ini_z + 1];

[Rt, Eps] = estimateRigidTransform(refSet', ptSet');

end