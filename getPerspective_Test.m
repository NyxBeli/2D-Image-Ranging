%% prepare
img = rgb2gray(imread('./images/myexample_01.jpg'));
width = size(img,2);
height = size(img,1);
figure;imshow(img)
% moving_points = [0,0;
%                 100,50;
%                 0,50;
%                 50,100];
moving_points = ginput(4);
hold on ; plot(moving_points(:,1),moving_points(:,2),'ro');
% fixed_points = [0,0;
%     100,0;
%     0,200;
%     100,200];
fixed_points = [0,0;
    100,0;
    0,100;
    100,100];


%% method 1,use matlab function
tfom = fitgeotrans(moving_points,fixed_points,'projective');
X = moving_points(:,1);
Y = moving_points(:,2);
[x,y] = transformPointsForward(tfom,X(:),Y(:));
figure;plot(x,y,'ro');title('验证坐标点对齐')
grid on
tic;
dst_img = imwarp(img,tfom);
t_sys = toc;
figure;imshow(dst_img);title(['图像仿射变换后（系统函数），耗时(s)：',num2str(t_sys)])

%% method 2, get perspective matrix
perspective_mat = getPerspective(moving_points,fixed_points);
A = perspective_mat;
X = [1;width;1;width]; % 原图片的四个角点x坐标
Y = [1;1;height;height]; % 原图片的四个角点y坐标
moving_points_mat = [X(:)';Y(:)';ones(1,size(X(:),1))];
dst_points = A*moving_points_mat;
for i = 1:size(dst_points,2)
    dst_points(1:2,i) = dst_points(1:2,i)/dst_points(3,i);
end
figure;plot(dst_points(1,:),dst_points(2,:),'bo');title('原图像仿射变换后的坐标范围')
grid on;

%% 仿射变换后图像逐像素进行插值赋值
min_x = min(dst_points(1,:));
max_x = max(dst_points(1,:));
min_y = min(dst_points(2,:));
max_y = max(dst_points(2,:));
W = round(max_x - min_x);
H = round(max_y -min_y);
wrapImg = zeros(H,W);
tic;
for i = 1:H
    for j = 1:W
        x = min_x+j; % 使得x，y的范围在原坐标范围内
        y = min_y+i;
        moving_point = A\[x;y;1];
        temp_point = [moving_point(1);moving_point(2)]./moving_point(3);
        if temp_point(1)>=1&&temp_point(1)<width&& ...
                temp_point(2)>=1&&temp_point(2)<height
            wrapImg(i,j) = img(round(temp_point(2)),round(temp_point(1)));
        end
    end
end
t_manual = toc;
figure;
imshow(uint8(wrapImg));title(['图像仿射变换后（手写函数），耗时(s)：',num2str(t_manual)])