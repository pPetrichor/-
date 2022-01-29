%DIP16 Assignment 2
%Edge Detection
%In this assignment, you should build your own edge detection and edge linking 
%function to detect the edges of a image.
%Please Note you cannot use the build-in matlab edge and bwtraceboundary function
%We supply four test images, and you can use others to show your results for edge
%detection, but you just need do edge linking for rubberband_cap.png.
clc; clear all;
% Load the test image
imgTest = im2double(imread('../image/rubberband_cap.png'));
imgTestGray = rgb2gray(imgTest);
%now call your function my_edge, you can use matlab edge function to see
%the last result as a reference first
img_edge = my_edge(imgTestGray);
% figure; clf;
% imshow(img_edge);
% img_edge = edge(imgTestGray);
%edge默认有边缘细化
figure; clf;
imshow(img_edge);
background = im2bw(imgTest, 1);
imshow(background);
% using imtool, you select a object boundary to trace, and choose
% an appropriate edge point as the start point 
imtool(img_edge);
% now call your function my_edgelinking, you can use matlab bwtraceboundary 
% function to see the last result as a reference first. please trace as many 
% different object boundaries as you can, and choose different start edge points.
% Bxpc = bwtraceboundary(img_edge, [126,229], 'N');
Bxpc = my_edgelinking(img_edge, 128, 203);
hold on
plot(Bxpc(:,2), Bxpc(:,1), 'w', 'LineWidth', 1);
Bxpc = my_edgelinking(img_edge, 282, 224);
plot(Bxpc(:,2), Bxpc(:,1), 'c', 'LineWidth', 1);
Bxpc = my_edgelinking(img_edge, 226, 88);
plot(Bxpc(:,2), Bxpc(:,1), 'c', 'LineWidth', 1);
Bxpc = my_edgelinking(img_edge, 156, 97);
plot(Bxpc(:,2), Bxpc(:,1), 'm', 'LineWidth', 1);
Bxpc = my_edgelinking(img_edge, 105, 388);
plot(Bxpc(:,2), Bxpc(:,1), 'g', 'LineWidth', 1);
Bxpc = my_edgelinking(img_edge, 141, 68);
plot(Bxpc(:,2), Bxpc(:,1), 'y', 'LineWidth', 1);
Bxpc = my_edgelinking(img_edge, 90, 292);
plot(Bxpc(:,2), Bxpc(:,1), 'm', 'LineWidth', 1);
Bxpc = my_edgelinking(img_edge, 93, 298);
plot(Bxpc(:,2), Bxpc(:,1), 'y', 'LineWidth', 1);
Bxpc = my_edgelinking(img_edge, 146, 396);
plot(Bxpc(:,2), Bxpc(:,1), 'c', 'LineWidth', 1);
Bxpc = my_edgelinking(img_edge, 134, 422);
plot(Bxpc(:,2), Bxpc(:,1), 'c', 'LineWidth', 1);
Bxpc = my_edgelinking(img_edge, 114, 418);
plot(Bxpc(:,2), Bxpc(:,1), 'c', 'LineWidth', 1);
Bxpc = my_edgelinking(img_edge, 189, 422);
plot(Bxpc(:,2), Bxpc(:,1), 'c', 'LineWidth', 1);
Bxpc = my_edgelinking(img_edge, 180, 441);
plot(Bxpc(:,2), Bxpc(:,1), 'c', 'LineWidth', 1);
Bxpc = my_edgelinking(img_edge, 175, 408);
plot(Bxpc(:,2), Bxpc(:,1), 'c', 'LineWidth', 1);
Bxpc = my_edgelinking(img_edge, 153, 392);
plot(Bxpc(:,2), Bxpc(:,1), 'g', 'LineWidth', 1);