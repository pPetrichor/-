%test histeqs
I = imread('color.jpg');
[J] = Histogram_equalization(I);
%figure, imhist(I)
figure, imshow(I)
%figure, imhist(J)
figure, imshow(J)