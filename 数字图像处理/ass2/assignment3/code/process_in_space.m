function [output] = process_in_space(I,operator)
    I = im2double(im2gray(I));
    [X,Y] = size(I);
    output = zeros(X,Y); %算子卷积后的结果与原图像大小保持一致
    switch operator
        case 'sobel'
            op = [[1,0,-1];[2,0,-2];[1,0,-1]]; %翻转180°后的结果
        case 'sobel_2'
            op_x = [[1,0,-1];[2,0,-2];[1,0,-1]]; 
            op_y = [[1,2,1];[0,0,0];[-1,-2,-1]];%翻转180°后的结果
         case 'lpls'
            op = [[1,1,1];[1,-8,1];[1,1,1]]; %拉普拉斯算子对角线形式
        case 'average'
            op = 1/9 * [[1,1,1];[1,1,1];[1,1,1]]; %均值滤波器算子
        case 'weight'
            op = 1/16 * [[1,2,1];[2,4,2];[1,2,1]]; %加权线性滤波器算子      
    end
    I_zero_padding = zeros(X+2,Y+2); %先做0-padding
    I_zero_padding(2:X+1,2:Y+1) = I;
    if strcmp(operator,'sobel_2')
        for i = 2:(X+1)
            for j = 2:(Y+1)
                current = I_zero_padding((i-1):(i+1),(j-1):(j+1));
                dx = sum(sum(op_x .* current));
                dy = sum(sum(op_y .* current));
                output(i-1,j-1) = sqrt(dx^2 + dy^2);
            end
        end
    else
        for i = 2:(X+1)
            for j = 2:(Y+1)
                current = I_zero_padding((i-1):(i+1),(j-1):(j+1));
                output(i-1,j-1) = sum(sum(op .* current));
            end
        end
    end