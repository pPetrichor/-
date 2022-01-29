function output = my_edge(input_image)
%in this function, you should finish the edge detection utility.
%the input parameter is a matrix of a gray image
%the output parameter is a matrix contains the edge index using 0 and 1
%the entries with 1 in the matrix shows that point is on the edge of the
%image
%you can use different methods to complete the edge detection function
%the better the final result and the more methods you have used, you will get higher scores  

%考虑不同的sima保留共同的零交叉点实现边缘细化
    process_way = 'sobel';
    if strcmp(process_way,'Marr')%尝试高级边缘检测
        figure;subplot(1,3,1);imshow(input_image);title('原图'); 
        [X,Y] = size(input_image);
        myedge1 = zeros(X,Y);myedge2 = zeros(X,Y);
        %尝试不同的sigma
        for times = 1:3
            temp = zeros(X,Y);
            sigma = 0.5*times+0.5;
            f_size = ceil(sigma * 6);
            if mod(f_size,2) == 0
                f_size = f_size + 1;
            end
            %模板大小是大于等于6sigma的最小奇数
            %方法一：先高斯滤波，后拉普拉斯滤波
            my_filter = fspecial('gaussian',f_size,sigma);
            I = imfilter(input_image,my_filter,'conv','replicate','same');
            my_filter = fspecial('laplacian');
            I = imfilter(I,my_filter,'conv','replicate','same');
            data = imhist(I); %利用imhist函数得到各灰度值像素点的数目
            [length,~] = size(data);%得到data的长度length
            for i=2:length
                data(i) = data(i-1) + data(i); %累加，计算后data(i)表示灰度值小于等于i-1的像素点数总和
                if data(i) >= numel(I) * 0.97
                    high = i / length * max(max(I));
                    break;
                end
            end
            threshold = high * 2;
            for x=2:X-1
                for y=2:Y-1
                    if judge1(I,x,y,threshold) == 1
                        temp(x,y) = 1;
                    elseif I(x,y) == 0
                        if judge2(I,x,y,threshold) == 1
                            temp(x,y) = 1;
                        end
                    end
                end
            end
            if times == 1
                myedge1 = temp;
            else
                myedge1 = myedge1 .* temp; %保留共同的零交叉
            end
            %方法二：直接用log滤波器进行卷积
            temp = zeros(X,Y);
            my_filter = fspecial('log',f_size,sigma);
            my_filter = my_filter - sum(my_filter(:))/numel(my_filter);
            I = imfilter(input_image,my_filter,'conv','replicate','same');
            data = imhist(I); %利用imhist函数得到各灰度值像素点的数目
            [length,~] = size(data);%得到data的长度length
            for i=2:length
                data(i) = data(i-1) + data(i); %累加，计算后data(i)表示灰度值小于等于i-1的像素点数总和
                if data(i) >= numel(I) * 0.97
                    high = i / length * max(max(I));
                    break;
                end
            end
            threshold = high * 2;
            for x=2:X-1
                for y=2:Y-1
                    if judge1(I,x,y,threshold) == 1
                        temp(x,y) = 1;
                    elseif I(x,y) == 0
                        if judge2(I,x,y,threshold) == 1
                            temp(x,y) = 1;
                        end
                    end
                end
            end
            if times == 1
                myedge2 = temp;
            else
                myedge2 = myedge2 .* temp; %保留共同的零交叉
            end
        end
        subplot(1,3,2);imshow(myedge1);title('方法一');
        subplot(1,3,3);imshow(myedge2);title('方法二');
        myedge = myedge2;
    elseif strcmp(process_way,'Canny')
        sigma = 0.85;
        f_size = ceil(sigma * 6);
        if mod(f_size,2) == 0
            f_size = f_size + 1;
        end
        filter = fspecial('gaussian',f_size,sigma);
        I = imfilter(input_image, filter,'conv','replicate','same');
        I = NMS(I);
        data = imhist(I); %利用imhist函数得到各灰度值像素点的数目
        [length,~] = size(data);%得到data的长度length
        for i=2:length
            data(i) = data(i-1) + data(i); %累加，计算后data(i)表示灰度值小于等于i-1的像素点数总和
            if data(i) >= numel(I) * 0.97
                high = i / length * max(max(I));
                break;
            end
        end
        low_T = high * 0.3;
        myedge = process_ther(I,low_T);
    else
    %尝试基本边缘检测
        figure;subplot(1,3,1);imshow(input_image);title('原图'); 
        myedge = process(input_image,process_way,0);
        subplot(1,3,2);imshow(myedge);title('卷积结果(不预先平滑)');
        myedge = process(input_image,process_way,1);
        subplot(1,3,3);imshow(myedge);title('卷积结果(预先平滑)');
        [X,Y] = size(myedge);
        %在这里取97%后取max
        data = imhist(myedge); %利用imhist函数得到各灰度值像素点的数目
        [length,~] = size(data);%得到data的长度length
        for i=2:length
            data(i) = data(i-1) + data(i); %累加，计算后data(i)表示灰度值小于等于i-1的像素点数总和
            if data(i) >= numel(myedge) * 0.97
                high = i / length * max(max(myedge));
                break;
            end
        end
        switch process_way
            case 'sobel'
                threshold = high * 0.18;
            case 'lpls'
                threshold = high * 0.6;
            case 'roberts'
                threshold = high * 0.8;
            case 'prewitt'
                threshold = high * 0.28;
            case 'Frei-Chen'
                threshold = high * 0.6;
        end
        for x = 1:X
            for y = 1:Y
               if myedge(x,y) > threshold
                    myedge(x,y) = 1;
                else
                    myedge(x,y) = 0;
                end
            end
        end
        
%         switch process_way
%             case 'sobel'
%                 threshold = high * 0.05;%0.1 * high;
%             case 'lpls'
%                 threshold = high;%0.25 * high;
%             case 'roberts'
%                 threshold = high;%1.2 * high;
%             case 'prewitt'
%                 threshold = high;%0.3 * high;
%             case 'Frei-Chen'
%                 threshold = high;%0.35 * high;
%         end
%         myedge = process_ther(NMS(myedge),threshold);
    end
    output = double(myedge);
    
function [output] = process(I,operator,smooth)
    [X,Y] = size(I);
    output = zeros(X,Y); %算子卷积后的结果与原图像大小保持一致
    if smooth
        my_filter = fspecial('gaussian',3,2);
        I = imfilter(I,my_filter,'conv','replicate','same');
    end
    switch operator
        case 'sobel'
            op_x = [[1,0,-1];[2,0,-2];[1,0,-1]]; 
            op_y = [[1,2,1];[0,0,0];[-1,-2,-1]];%翻转180°后的结果
        case 'lpls'
            op = [[1,1,1];[1,-8,1];[1,1,1]]; %拉普拉斯算子对角线形式
        case 'roberts'
            op_x = [[0,0,0];[0,-1,0];[0,0,1]]; 
            op_y = [[0,0,0];[0,0,-1];[0,1,0]];%翻转180°后的结果，多的0行和0列是展位用的
        case 'prewitt'
            op_x = [[-1,0,1];[-1,0,1];[-1,0,1]]; 
            op_y = [[-1,-1,-1];[0,0,0];[1,1,1]];%翻转180°后的结果
        case 'Frei-Chen'
            op_x = [[1,sqrt(2),1];[0,0,0];[-1,-sqrt(2),-1]]/(2*sqrt(2)); 
            op_y = [[-1,0,1];[-sqrt(2),0,sqrt(2)];[-1,0,1]]/(2*sqrt(2));%翻转180°后的结果
    end
    I_padding = zeros(X+2,Y+2); %先复制外边界值做padding
    I_padding(2:X+1,2:Y+1) = I;
    I_padding(1,2:Y+1) = I(1,1:Y);
    I_padding(1:X+1,Y+2) = I_padding(1:X+1,Y+1);
    I_padding(X+2,2:Y+2) = I_padding(X+1,2:Y+2);
    I_padding(1:X+2,1) = I_padding(1:X+2,2);
    if strcmp(operator,'lpls')
        for i = 2:(X+1)
            for j = 2:(Y+1)
                current = I_padding((i-1):(i+1),(j-1):(j+1));
                output(i-1,j-1) = sum(sum(op .* current));
                
            end
        end
    else
        for i = 2:(X+1)
            for j = 2:(Y+1)
                current = I_padding((i-1):(i+1),(j-1):(j+1));
                dx = sum(sum(op_x .* current));
                dy = sum(sum(op_y .* current));
                output(i-1,j-1) = sqrt(dx^2 + dy^2);
            end
        end
    end
    
function [output] = NMS(I) %非最大抑制
    %首先求梯度
    [X,Y] = size(I);
    %M = zeros(X,Y);%记录梯度的大小
    %alpha = zeros(X,Y);%记录梯度的方向
    direct = zeros(X,Y);%记录每个像素点的与梯度最相近的方向
    sx = fspecial('sobel');
    sy = (sx)';
    Mx = imfilter(I,sx,'replicate','same');
    My = imfilter(I,sy,'replicate','same');
    M = sqrt(Mx.*Mx + My.*My);
    alpha = atand(My ./ Mx);
    for x=2:X-1
        for y=2:Y-1
%             gx = I(x+1,y) - I(x,y);
%             gy = I(x,y+1) - I(x,y);
            %M(x,y) = sqrt(gx^2 + gy^2);
            %alpha(x,y) = atand(gy/gx);
            if abs(alpha(x,y)) > 67.5
                direct(x,y) = 1;%水平方向
            elseif alpha(x,y) > 22.5
                direct(x,y) = 2;%-45°方向
            elseif alpha(x,y) > -22.5
                direct(x,y) = 3;%竖直方向
            else
                direct(x,y) = 4;%45°方向
            end
        end
    end
    output = zeros(X,Y);
    output(2:X-1,2:Y-1) = M(2:X-1,2:Y-1);
    for x=2:X-1%4:X-3 3:X-2
        for y=2:Y-1%4:Y-3 3:X-2
            switch direct(x,y)
                case 1
                    if M(x,y) < max(max(M(x,y-1:y+1)))%max(max(M(x,y-3:y+3)))max(max(M(x,y-2:y+2)))
                        output(x,y) = 0;
%                     else
%                         output(x,y-1) = 0;output(x,y+1) = 0;
                    end
                case 2
                    if M(x,y) < max(M(x-1,y-1),M(x+1,y+1))
                    %max(max(M(x-3,y-3),M(x-2,y-2)),M(x-1,y-1)) || M(x,y) < max(max(M(x+3,y+3),M(x+2,y+2)),M(x+1,y+1))
                    %max(M(x-2,y-2),M(x-1,y-1)) || M(x,y) < max(M(x+2,y+2),M(x+1,y+1))
                        output(x,y) = 0;
%                     else
%                         output(x-1,y-1) = 0;output(x+1,y+1) = 0;
                    end
                case 3
                    if M(x,y) < max(max(M(x-1:x+1,y)))%max(max(M(x-2:x+2,y)))%max(max(M(x-3:x+3,y)))
                        output(x,y) = 0;
%                     else
%                         output(x-1,y) = 0;output(x+1,y) = 0;
                    end
                case 4
                    if M(x,y) < max(M(x-1,y+1),M(x+1,y-1))
                    %max(max(M(x-3,y+3),M(x-2,y+2)),M(x-1,y+1)) || M(x,y) < max(max(M(x+3,y-3),M(x+2,y-2)),M(x+1,y-1))
                    %max(M(x-2,y+2),M(x-1,y+1)) || M(x,y) < max(M(x+2,y-2),M(x+1,y-1))
                        output(x,y) = 0;
%                     else
%                         output(x-1,y+1) = 0;output(x+1,y-1) = 0;
                    end
            end
        end
    end
    
    
function output = process_ther(I,low_ther)
    high_ther = low_ther * 2;
    [X,Y] = size(I);
    g_nh = zeros(X,Y);
    g_nl = zeros(X,Y);
    for x=1:X
        for y=1:Y
            if I(x,y) >= high_ther
                g_nh(x,y) = 1;
            elseif I(x,y) > low_ther
                g_nl(x,y) = 1;
            end
        end
    end
    for x=2:X-1
        for y=2:Y-1
            if g_nl(x,y) == 1
                current = g_nh(x-1:x+1,y-1:y+1);
                if sum(sum(current)) == 0
                    g_nl(x,y) = 0;
                end
            end
        end
    end
    output = g_nh + g_nl;
    
function output = judge1(I,x,y,threshold)
    f1 = ((I(x,y)<0 && I(x-1,y)>0)||(I(x,y)>0 && I(x-1,y)<0))&&(abs(I(x,y)-I(x-1,y))>threshold);
    %上
    f2 = ((I(x,y)<0 && I(x+1,y)>0)||(I(x,y)>0 && I(x+1,y)<0))&&(abs(I(x,y)-I(x+1,y))>threshold);
    %下
    f3 = ((I(x,y)<0 && I(x,y-1)>0)||(I(x,y)>0 && I(x,y-1)<0))&&(abs(I(x,y)-I(x,y-1))>threshold);
    %左
    f4 = ((I(x,y)<0 && I(x,y+1)>0)||(I(x,y)>0 && I(x,y+1)<0))&&(abs(I(x,y)-I(x,y+1))>threshold);
    %右
    f5 = ((I(x,y)<0 && I(x-1,y-1)>0)||(I(x,y)>0 && I(x-1,y-1)<0))&&(abs(I(x,y)-I(x-1,y-1))>threshold);
    %左上
    f6 = ((I(x,y)<0 && I(x+1,y-1)>0)||(I(x,y)>0 && I(x+1,y-1)<0))&&(abs(I(x,y)-I(x+1,y-1))>threshold);
    %左下
    f7 = ((I(x,y)<0 && I(x-1,y+1)>0)||(I(x,y)>0 && I(x-1,y+1)<0))&&(abs(I(x,y)-I(x-1,y+1))>threshold);
    %右上
    f8 = ((I(x,y)<0 && I(x+1,y+1)>0)||(I(x,y)>0 && I(x+1,y+1)<0))&&(abs(I(x,y)-I(x+1,y+1))>threshold);
    %右下
    if (f1||f2||f3||f4||f5||f6||f7||f8)
        output = 1;
    else
        output = 0;
    end
        
function output = judge2(I,x,y,threshold)
    f1 = ((I(x+1,y)<0 && I(x-1,y)>0)||(I(x+1,y)>0 && I(x-1,y)<0))&&(abs(I(x+1,y)-I(x-1,y))>2*threshold);
    %上下
    f2 = ((I(x,y+1)<0 && I(x,y-1)>0)||(I(x,y+1)>0 && I(x,y-1)<0))&&(abs(I(x,y+1)-I(x,y-1))>2*threshold);
    %左右
    f3 = ((I(x-1,y-1)<0 && I(x+1,y+1)>0)||(I(x-1,y-1)>0 && I(x+1,y+1)<0))&&(abs(I(x-1,y-1)-I(x+1,y+1))>2*threshold);
    %左上右下
    f4 = ((I(x+1,y-1)<0 && I(x-1,y+1)>0)||(I(x+1,y-1)>0 && I(x-1,y+1)<0))&&(abs(I(x+1,y-1)-I(x-1,y+1))>2*threshold);
    %左下右上
    if (f1||f2||f3||f4)
        output = 1;
    else
        output = 0;
    end