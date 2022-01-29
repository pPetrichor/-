function [output] = low_pass_fliter(type,X,Y,D_0)
    distance = d_2_center(X,Y);
    switch type
        case 1 %理想低通滤波器
            output = (distance <= D_0);
        case 2 %巴特沃斯低通滤波器
            output = 1 ./ (1 + ((distance / D_0).^4));
        case 3 %高斯低通滤波器
            output = exp(-(distance.^2)/(2*D_0*D_0));
    end


    function [distance] = d_2_center(X,Y) %用于计算频率矩阵中任意一点到中心的距离，X、Y表示矩阵大小
        distance = zeros(X,Y);
        center_x = floor(X/2) + 1;
        center_y = floor(Y/2) + 1;
        for i = 1:X
            for j = 1:Y
                distance(i,j) = hypot((i - center_x),(j - center_y));
            end
        end