function bw_img = img_binary(path)
    % 读取图像文件
    img = imread(path);

    % 将图像转换为灰度图像
    gray_img = rgb2gray(img);

    % 对灰度图像进行二值化
    threshold = graythresh(gray_img);
    bw_img = imbinarize(gray_img, threshold);

    % 使用Canny算子进行边缘检测
    %edge_img = edge(bw_img, 'canny');

    % 显示处理结果
    figure;
    subplot(1,2,1); imshow(img); title('Original Image');
    subplot(1,2,2); imshow(bw_img); title('BW Image');
end