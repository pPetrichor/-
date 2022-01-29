function output = my_edgelinking(binary_image, row, col)
%in this function, you should finish the edge linking utility.
%the input parameters are a matrix of a binary image containing the edge
%information and coordinates of one of the edge points of a obeject
%boundary, you should run this function multiple times to find different
%object boundaries
%the output parameter is a Q-by-2 matrix, where Q is the number of boundary 
%pixels. B holds the row and column coordinates of the boundary pixels.
%you can use different methods to complete the edge linking function
%the better the quality of object boundary and the more the object boundaries, you will get higher scores   
%     temp = trace(binary_image,row,col,8);%利用4或8连通进行追踪
%     myoutput = zeros(size(temp));
%     [length,~] = size(temp);
%     x = length + 1;
%     for i=2:length
%         if (temp(i-1,1)-temp(i,1))^2 + (temp(i-1,2)-temp(i,2))^2 > 200
%             x = i-1;
%             break;
%         end
%     end
%     if (temp(1,1)-temp(length,1))^2 + (temp(1,2)-temp(length,2))^2 > 200
%         x = length;
%     end
%     if x ~= length + 1
%         for i = x+1:length
%             myoutput(i-x,1) = temp(i,1);
%             myoutput(i-x,2) = temp(i,2);
%             myoutput(i-x,3) = i-x;
%         end
%         for i = 1:x
%             myoutput(length-x+i,1) = temp(i,1);
%             myoutput(length-x+i,2) = temp(i,2);
%             myoutput(length-x+i,3) = length-x+i;
%         end
%        output = myoutput;
%        output = process(output,0);
%     else %是闭合曲线
% %         output = temp;
% %         length = size(output);
% %         output(length + 1,1) = output(1,1);output(length + 1,2) = output(1,2);
%         output = process(temp,1);
%     end
%     
    global dfs_res;
    global dfs_current;
    global I;
    dfs_res = [];
    dfs_current = 1;
    I = binary_image;
    dfs(row,col);
    output = dfs_res;
 
function dfs(row,col)
    global dfs_res;
    global dfs_current;
    global I;
    [X,Y] = size(I);
    dfs_res(dfs_current,1) = row;
    dfs_res(dfs_current,2) = col;
    dfs_current = dfs_current + 1;
    I(row,col) = 0;
    for x=row-1:row+1
        for y=col-1:col+1
            if x>0 && x<=X && y>0 && y<=Y
                if I(x,y) == 1
                    dfs(x,y);
                end
            end
        end
    end
    dfs_res(dfs_current,1) = row;
    dfs_res(dfs_current,2) = col;
    dfs_current = dfs_current + 1;

function output = trace(input,row,col,n)
    center_x=0;center_y=0;%记录中心点的坐标
    res = []; %res用于存放追踪到的边缘
    queue = {}; %基于队列实现基本的边缘追踪，初始元素为手动定位点
    [X,Y] = size(input);
    queue_head = 1;
    queue_tail = 2;
    queue{1} = [row,col];
    current = 1;
    while queue_head < queue_tail
        r = queue{queue_head}(1,1);
        c = queue{queue_head}(1,2);
        res(current,1) = r;
        res(current,2) = c;
        center_x = center_x + r;
        center_y = center_y +c;
        current = current + 1;
        queue_head = queue_head + 1;
        if n == 4
            candidate = {[-1,0],[0,1],[1,0],[0,-1]};
        elseif n == 8
            candidate = {[-1,0],[-1,1],[0,1],[1,1],[1,0],[1,-1],[0,-1],[-1,-1]};
        end
        for i=1:n
            current_r = r + candidate{i}(1,1);
            current_c = c + candidate{i}(1,2);
            if  current_r > 0 && current_r <= X && current_c > 0 && current_c <= Y && input(current_r,current_c) == 1
                queue{queue_tail} = [current_r,current_c];
                %queue{queue_tail};
                queue_tail = queue_tail + 1;
                input(current_r,current_c) = 0;
            end
        end
    end
    center_x = center_x / (current - 1);
    center_y = center_y / (current - 1);
    for i = 1:(current - 1)
        res(i,3) = res(i,1) - center_x;
        res(i,4) = res(i,2) - center_y;
    end
    [theta,~] = cart2pol(res(:,3),res(:,4)); %求极坐标
    res(:,5) = theta;
    res = sortrows(res,5); %按极坐标排序
    length = size(res);
    output = [];
    for i = 1:length
        output(i,1) = res(i,1);
        output(i,2) = res(i,2);
        output(i,3) = i; %为点进行编号
    end
        
function x = max_distance(points,a,b) %返回points中离直线ab距离最远的点
    length = size(points);
    distance = [];
    for i = 1:length
        distance(i) = abs((a(1,1)-points(i,1)).*(b(1,2)-points(i,2))-(b(1,1)-points(i,1)).*(a(1,2)-points(i,2)))./sqrt((a(1,1)-b(1,1))^2+(a(1,2)-b(1,2))^2);
    end
    threshold = 1;
    dmax = max(distance);
    if dmax >= threshold
        x = find(distance == dmax);
        [~,s] = size(x);
        if s > 1
            x = x(1);
        end
    else
        x = -1;
    end
    
function output = process(input,if_close) %input为n*3的矩阵，已经排序
    myopen = [];
    myclose = [];
    already = [];%记录已经放入到open中过的点
    already_num = 1;
    [le,~] = size(input);
    if if_close==1
        myopen(1,1) = input(1,1);myopen(1,2) = input(1,2);myopen(1,3) = input(1,3); %取第一个点B作为起始点
        myopen(2,1) = input(le,1);myopen(2,2) = input(le,2);myopen(2,3) = input(le,3);%取最后一个点A作为起始点
        open_head = 2;
        already(1) = 1;
        already(2) = le;
        already_num = 3;
    else
        myopen(1,1) = input(le,1);myopen(1,2) = input(le,2);myopen(1,3) = input(le,3);
        open_head = 1;
        already(1) = le;
        already_num = 2;
    end
    myclose(1,1) = input(1,1);myclose(1,2) = input(1,2);myclose(1,3) = input(1,3); 
    close_head = 1;
    A = zeros(1,2);B = zeros(1,2);
    while open_head ~= 0
        A(1,1) = myopen(open_head,1);
        A(1,2) = myopen(open_head,2);
        B(1,1) = myclose(close_head,1);
        B(1,2) = myclose(close_head,2);
        up = max(myopen(open_head,3),myclose(close_head,3));
        down = min(myopen(open_head,3),myclose(close_head,3));
        points =[];
        for i = down+1:up-1
            points(i - down, 1) = input(i,1);
            points(i - down, 2) = input(i,2);
        end
        x = max_distance(points,A,B);
        y = find(already == x + down);
        if x ~= -1 && isempty(y)
            open_head = open_head + 1;
            myopen(open_head,1) = points(x,1);
            myopen(open_head,2) = points(x,2);
            myopen(open_head,3) = x + down;
            already(already_num) = x + down;
            already_num = already_num + 1;
        else
            close_head = close_head + 1;
            myclose(close_head,1) = myopen(open_head,1);
            myclose(close_head,2) = myopen(open_head,2);
            myclose(close_head,3) = myopen(open_head,3);
            open_head = open_head - 1;
        end
    end
    length = size(myclose);
    output = [];
    for i = 1:length
        output(i,1) = myclose(i,1);
        output(i,2) = myclose(i,2);
    end


    