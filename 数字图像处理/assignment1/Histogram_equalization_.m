% function [output] = Histogram_equalization_(input_image)
% %first test the image is a RGB or gray image
% if numel(size(input_image)) == 3
%     %this is a RGB image
%     %here is just one method, if you have other ways to do the
%     %equalization, you can change the following code
%     % solution 1
%     r=input_image(:,:,1);
%     v=input_image(:,:,2);
%     b=input_image(:,:,3);
%     r1 = hist_equal(r);
%     v1 = hist_equal(v);
%     b1 = hist_equal(b);
%     output = cat(3,r1,v1,b1);
% else
%     %this is a gray image
%     [output] = hist_equal(input_image);
%     
% end
% 
%    
%     function [output2] = hist_equal(input_channel)
%     %为了配合hsi，选择高精度double，但太慢了;从实验结果来看差别不大，故用uint8存
%     %you should complete this sub-function 
%     input_channel = im2double(input_channel);
%     output2 = input_channel;
%     [data,x] = imhist(input_channel);
%     [length,t] = size(data);
%     for i=2:length
%         data(i) = data(i-1) + data(i);
%     end
%     [r,c] = size(input_channel);
%     for i = 1:r
%         for j = 1:c
%             temp = im2double(input_channel(i,j));
%             temp = find(x == temp);
%             output2(i,j) = data(temp) / (r*c);
%         end
%     end
%     end
% 
% end
function [output] = Histogram_equalization_(input_image)
%first test the image is a RGB or gray image
if numel(size(input_image)) == 3
    %this is a RGB image
    %here is just one method, if you have other ways to do the
    %equalization, you can change the following code
    
    photo=double(input_image);
    R=photo(:,:,1);
    G=photo(:,:,2);
    B=photo(:,:,3);
    [X,Y]=size(R);
    [S]=1-3.*(min(min(R,G),B))./(R+G+B);
    [I]=uint8((R+G+B)/3);
    C=acos(0.5.*((R-G)+(R-B))./(sqrt((R-G).^2+(R-B).*(G-B))));
    if (B>G)
        H=2*pi-C;
    else
        H=C;
    end    
%    for i=1:X
%        for j=1:Y
%            S(i,j)=1-3.*(min(min(R(i,j),G(i,j),B(i,j))))./(R(i,j)+G(i,j)+B(i,j));
%            I(i,j)=uint8(R(i,j)+G(i,j)+B(i.j)/3);
%        end
%    end
    HSI = cat(3, H, S, I);
    I=double(hist_equal(I));
    figure, imshow(I)
    for i=1:X
        for j=1:Y 
            if ((H(i,j)>=0)&&(H(i,j)<2*pi/3))
                B(i,j)=I(i,j).*(1-S(i,j));
                R(i,j)=I(i,j).*(1+S(i,j).*cos(H(i,j))./cos(pi/3-H(i,j)));
                G(i,j)=3*I(i,j)-(R(i,j)+B(i,j));
            else
                if ((H(i,j)>=2*pi/3)&&(H(i,j)<4*pi/3))
                    H(i,j)=H(i,j)-2*pi/3;
                    R(i,j)=I(i,j).*(1-S(i,j));
                    G(i,j)=I(i,j).*(1+S(i,j).*cos(H(i,j)-2*pi/3)./cos(pi-H(i,j)));
                    B(i,j)=3*I(i,j)-(R(i,j)+G(i,j));
                else    
                    if ((H(i,j)>=4*pi/3)&&(H(i,j)<2*pi))
                        H(i,j)=H(i,j)-4*pi/3;
                        G(i,j)=I(i,j).*(1-S(i,j));
                        B(i,j)=I(i,j).*(1+S(i,j).*cos(H(i,j)-4*pi/3)./cos(5*pi/3-H(i,j)));
                        R(i,j)=3*I(i,j)-(G(i,j)+B(i,j));
                    end
                end
            end    
        end
    end
    R=uint8(R);
    G=uint8(G);
    B=uint8(B);
    output = cat(3,R,G,B); 
    
%    r=input_image(:,:,1);
%    v=input_image(:,:,2);
%    b=input_image(:,:,3);
%    r1 = hist_equal(r);
%    v1 = hist_equal(v);
%    b1 = hist_equal(b);
%    output = cat(3,r1,v1,b1);    
else
    %this is a gray image
    [output] = hist_equal(input_image);
    
end
    function [output2] = hist_equal(input_channel)
        [x,y]=size(input_channel);
        [graylevel]=zeros(256,1);
        for i=1:x
            for j=1:y
                graylevel(input_channel(i,j)+1)=graylevel(input_channel(i,j)+1)+1;
            end
        end
        [output2]=uint8(zeros(x,y));
        for i=1:x
            for j=1:y
                m=0;
                for k=0:input_channel(i,j)
                    m=m+(1*(graylevel(k+1)));
                end
                output2(i,j)=round(255*(m/(x*y)));
            end
        end    
        %you should complete this sub-function
    end
end