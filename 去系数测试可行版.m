%% Room configuration
room.length = 5;
room.width = 5;
room.height = 3;%change

img.length = 0.012;
img.width = 0.012;
img.halflength = 0.006;
img.halfwidth = 0.006;

f = 0.005;

%% LED Lamps configuration
led.half_angle = 65;  %degree
led.lambert_index = -1/log2(cos(led.half_angle*pi/180));
led.minFC = 100;  %minimal forward current, mA
led.maxFC = 1000; %maximal forward current, mA
led.current_flux_polynomial_coeff = [1 1 1 1];

led.fc = 700;  %forward current, mA
led.flux = 500000;   %lumen, at some FC current
led.power = led.flux/683; %watt, approximately

%f of the LED light
led1.flux = [0 1 1 0 0 0 0 0 ];%%%频率改一改
led2.flux = [0 1 1 1 1 0 0 0 ];%10
led3.flux = [0 1 1 1 1 1 1 0 ];%12
%led4.flux = [0 1 1 1 1 1 1 1 0 0 0 0 0 0 ];


%% LEDs scenario configuration
%% configuration 1
%(1.25,1.25)(3.75,3.75)...灯具位置
 led.position_z = room.height;%灯在天花板上
 led.position_x1 = 3.5;
 led.position_y1 = 2;
 
 led.position_x2 = 2;
 led.position_y2 = 3;
 
 led.position_x3 = 3;
 led.position_y3 = 4;
 
 %%%%%%%%none
 led.position_x4 = 3;
 led.position_y4 = 2;
 
 led.step=0.03;%发光区域大小//筒灯半径
 NUM = 400;%离散灯具发光点数量
% end

% position of person
PX = 2.5;
PY = 2.5;

%%img info
receiver_height=1;%height of the camera/z of the img sensor
axis=3000;% 分的块数——应该用下方数据
incre_space =img.length/axis;


%light1 1.25+-0.03 后离散为400*400 小块
position_matrix_x1 = zeros(NUM,NUM);
position_matrix_y1 = zeros(NUM,NUM);
for i = 1:NUM
    position_matrix_x1(i,:) = linspace(led.position_x1-led.step,led.position_x1+led.step,NUM);
end
for j = 1:NUM
    position_matrix_y1(:,j) = linspace(led.position_y1-led.step,led.position_y1+led.step,NUM);
end

%light2
position_matrix_x2= zeros(NUM,NUM);
position_matrix_y2 = zeros(NUM,NUM);
for i = 1:NUM
    position_matrix_x2(i,:) = linspace(led.position_x2-led.step,led.position_x2+led.step,NUM);
end
for j = 1:NUM
    position_matrix_y2(:,j) = linspace(led.position_y2-led.step,led.position_y2+led.step,NUM);
end

%light3
position_matrix_x3= zeros(NUM,NUM);
position_matrix_y3 = zeros(NUM,NUM);
for i = 1:NUM
    position_matrix_x3(i,:) = linspace(led.position_x3-led.step,led.position_x3+led.step,NUM);
end
for j = 1:NUM
    position_matrix_y3(:,j) = linspace(led.position_y3-led.step,led.position_y3+led.step,NUM);
end


%light4
position_matrix_x4= zeros(NUM,NUM);
position_matrix_y4 = zeros(NUM,NUM);
for i = 1:NUM
    position_matrix_x4(i,:) = linspace(led.position_x4-led.step,led.position_x4+led.step,NUM);
end
for j = 1:NUM
    position_matrix_y4(:,j) = linspace(led.position_y4-led.step,led.position_y4+led.step,NUM);
end



led.position_matrix_x= [position_matrix_x1,position_matrix_x2;position_matrix_x3,position_matrix_x4];
led.position_matrix_y= [position_matrix_y1,position_matrix_y2;position_matrix_y3,position_matrix_y4];


[X, Y] = meshgrid(0:incre_space:img.length, 0:incre_space:img.width);%分矩阵单位
[r,c] = size(X);

illumination1 = zeros(r,c);
%% Luminous distribution calculation%投影过程
m = NUM*2;
n = NUM*2;

%%    FIRST LIGHT
        illumination = zeros(r,c);
        for k = 1:NUM
            for l = 1:NUM
                i = 0;
                j = 0;
                i = floor(((PX - led.position_matrix_x(k,l))*f/(room.height-receiver_height) + img.halflength)/incre_space);
                j = floor(((PY - led.position_matrix_y(k,l))*f/(room.height-receiver_height) + img.halfwidth)/incre_space);
       
	   %几何成像计算坐标点
                if  0<=i&&i<=(axis+1) && 0<=j&&j<=(axis+1)                  
                vector_A  = [PX-led.position_matrix_x(k,l), PY-led.position_matrix_y(k,l), receiver_height-room.height];
                cos_theta = abs(vector_A(3))/norm(vector_A);
                cos_yita = cos_theta;
                gain = (led.lambert_index+1)/2/pi*cos_theta^(led.lambert_index)*cos_yita/norm(vector_A)^2;
                               
                gain = gain / ( (k-NUM/2-0.5)^2 + (l-NUM/2-0.5)^2 ); %需要调整的发光模型，这里使得图像边缘模糊与距离成反比
%           
                illumination(i,j) = illumination(i,j) + led.flux*gain;%点
                
                end
            end    
        end

        for c = 1:(axis+1)
        c1 = rem(c, length(led1.flux)) + 1;
        illumination1(c,:) = illumination(c,:)*led1.flux(c1);
        end
        
 %%  SECOND LIGHT
        illumination = zeros(r,c);
        for k = NUM+1:m%灯的位置存储在矩阵不同位置
            for l = 1:NUM
                i = 0;
                j = 0;
                i = floor(((PX - led.position_matrix_x(k,l))*f/(room.height-receiver_height) + img.halflength)/incre_space);
                j = floor(((PY - led.position_matrix_y(k,l))*f/(room.height-receiver_height) + img.halfwidth)/incre_space);
       
                if  0<=i&&i<=(axis+1) && 0<=j&&j<=(axis+1)                  
                vector_A  = [PX-led.position_matrix_x(k,l), PY-led.position_matrix_y(k,l), receiver_height-room.height];
                cos_theta = abs(vector_A(3))/norm(vector_A);
                cos_yita = cos_theta;
                gain = (led.lambert_index+1)/2/pi*cos_theta^(led.lambert_index)*cos_yita/norm(vector_A)^2;
                
                  gain = gain / ( (k-NUM-NUM/2-0.5)^2 + (l-NUM/2-0.5)^2);
  
                illumination(i,j) = illumination(i,j) + led.flux*gain;

                end
            end    
        end

        for c = 1:(axis+1)
        c1 = rem(c, length(led2.flux)) + 1;
        illumination2(c,:) = illumination(c,:)*led2.flux(c1);
        end
        
 %%  THIRD LIGHT
     illumination = zeros(r,c);
        for k = 1:NUM
            for l = NUM+1:n
                i = 0;
                j = 0;
                i = floor(((PX - led.position_matrix_x(k,l))*f/(room.height-receiver_height) + img.halflength)/incre_space);
                j = floor(((PY - led.position_matrix_y(k,l))*f/(room.height-receiver_height) + img.halfwidth)/incre_space);
       
                if  0<=i&&i<=(axis+1) && 0<=j&&j<=(axis+1)                  
                vector_A  = [PX-led.position_matrix_x(k,l), PY-led.position_matrix_y(k,l), receiver_height-room.height];
                cos_theta = abs(vector_A(3))/norm(vector_A);
                cos_yita = cos_theta;
                gain = (led.lambert_index+1)/2/pi*cos_theta^(led.lambert_index)*cos_yita/norm(vector_A)^2;
                
                      gain = gain / ( (k-NUM/2-0.5)^2 + (l-NUM-NUM/2-0.5)^2);

                illumination(i,j) = illumination(i,j) + led.flux*gain;
 
                end
            end    
        end

        for c = 1:(axis+1)
        c1 = rem(c, length(led3.flux)) + 1;
        illumination3(c,:) = illumination(c,:)*led3.flux(c1);
        end
        
illuminationtotal = illumination1 + illumination2 + illumination3;


image(illuminationtotal)
colormap copper
colorbar
