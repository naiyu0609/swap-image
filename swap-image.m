clc,clear;
%initial
disp('initial')
tic%計時開始
im_ori=imread('ArtGallery.jpg');%讀原圖
im_temp=im_ori;
point_L=[41 104 342 123 342 427 41 447];%左圖4個頂點
point_R=[686 121 956 70 956 517 686 454];%右圖4個頂點
temp_L2R=[point_L(1) point_L(2) 1 0 0 0 -point_R(1)*point_L(1) -point_R(1)*point_L(2);
          0 0 0 point_L(1) point_L(2) 1 -point_R(2)*point_L(1) -point_R(2)*point_L(2);
          point_L(3) point_L(4) 1 0 0 0 -point_R(3)*point_L(3) -point_R(3)*point_L(4);
          0 0 0 point_L(3) point_L(4) 1 -point_R(4)*point_L(3) -point_R(4)*point_L(4);
          point_L(5) point_L(6) 1 0 0 0 -point_R(5)*point_L(5) -point_R(5)*point_L(6);
          0 0 0 point_L(5) point_L(6) 1 -point_R(6)*point_L(5) -point_R(6)*point_L(6);
          point_L(7) point_L(8) 1 0 0 0 -point_R(7)*point_L(7) -point_R(7)*point_L(8);
          0 0 0 point_L(7) point_L(8) 1 -point_R(8)*point_L(7) -point_R(8)*point_L(8)];%計算左到右方程式所需矩陣(inverse前)
temp_R2L=[point_R(1) point_R(2) 1 0 0 0 -point_L(1)*point_R(1) -point_L(1)*point_R(2);
          0 0 0 point_R(1) point_R(2) 1 -point_L(2)*point_R(1) -point_L(2)*point_R(2);
          point_R(3) point_R(4) 1 0 0 0 -point_L(3)*point_R(3) -point_L(3)*point_R(4);
          0 0 0 point_R(3) point_R(4) 1 -point_L(4)*point_R(3) -point_L(4)*point_R(4);
          point_R(5) point_R(6) 1 0 0 0 -point_L(5)*point_R(5) -point_L(5)*point_R(6);
          0 0 0 point_R(5) point_R(6) 1 -point_L(6)*point_R(5) -point_L(6)*point_R(6);
          point_R(7) point_R(8) 1 0 0 0 -point_L(7)*point_R(7) -point_L(7)*point_R(8);
          0 0 0 point_R(7) point_R(8) 1 -point_L(8)*point_R(7) -point_L(8)*point_R(8)];%計算右到左方程式所需矩陣(inverse前)
%%
%calculate
disp('calculate')
temp_h_L2R=inv(temp_L2R)*transpose(point_R);%計算左到右的H矩陣(直線排列,8 unknown)
temp_h_R2L=inv(temp_R2L)*transpose(point_L);%計算右到左的H矩陣(直線排列,8 unknown)
h_L2R=[transpose(temp_h_L2R(1:3));
       transpose(temp_h_L2R(4:6));
       transpose(temp_h_L2R(7:8)) 1];%將左到右H矩陣排列還原
h_R2L=[transpose(temp_h_R2L(1:3));
       transpose(temp_h_R2L(4:6));
       transpose(temp_h_R2L(7:8)) 1];%將右到左H矩陣排列還原
   
y_begin=point_L(2);%y方向起點
y_end=point_L(8);%y方向終點
check=1;%修改y起終點用
for x=point_L(1):point_L(3)
    for y=y_begin:y_end
        postion_L2R=h_L2R*transpose([x y 1]);%計算出正歸化前座標
        postion_L2R=round(postion_L2R/postion_L2R(3));%正歸化
        im_temp(y,x,:)=im_ori(postion_L2R(2),postion_L2R(1),:);%轉換
    end
    check=check+1;
    if rem(check,16)==15 && y_begin<=point_L(4)%斜率問題要改變y起點
        y_begin=y_begin+1;
    end
    if rem(check,15)==14 && y_end>=point_L(6)%斜率問題要改變y終點
        y_end=y_end-1;
    end
end

%與上面相同
y_begin=point_R(2);
y_end=point_R(8);
check=1;
for x=point_R(1):point_R(3)
    for y=y_begin:y_end
        postion_R2L=h_R2L*transpose([x y 1]);
        postion_R2L=round(postion_R2L/postion_R2L(3));
        im_temp(y,x,:)=im_ori(postion_R2L(2),postion_R2L(1),:);
    end
    check=check+1;
    if rem(check,5)==4 && y_begin>=point_R(4)
        y_begin=y_begin-1;
    end
    if rem(check,4)==3 && y_end<=point_R(6)
        y_end=y_end+1;
    end
end
%%
%finish
disp('finish')
imwrite(im_temp,'B10607044.jpg');%寫入新照片檔
toc
figure
imshow(im_ori)
title('original')
figure
imshow(im_temp)
title('change')