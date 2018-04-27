% input A(x1,y1,z1)，B()，C,  a(a1,b1,c1),b,c
%output P(x,y.z)
%model1 Performance_improvement_of_indoor_positioning
%%%%补充已知信息
img.length = 0.012;
img.width = 0.012;
img.halflength = 0.006;
img.halfwidth = 0.006;
f = 0.005;
led.step=0.03;%发光区域大小//筒灯半径
receiver_height=1;%height of the camera/z of the img sensor
axis=3000;% 分的块数——应该用下方数据
incre_space =img.length/axis;


 %输出图片----做成多输出几何到主函数
  imwrite(illuminationtotal,'f1.bmp','bmp');
 
  %%%求高度------%h=led.position_z-receiver_height;%2
  h=2*led.step*f/abs(incre_space*img.position_p1-incre_space*img.position_p2);
  
  %——————————求h的过程中的误差h小了一点1.9737？？？？导致整体偏大
  
  
%%%model1 ——————————————————————————————
 x1=h/f*(img.position_u1*incre_space-img.halflength)+led.position_x1;%incre_space*axis/2=img.halflength
 x2=h/f*(img.position_u2*incre_space-img.halflength)+led.position_x2;
 x3=h/f*(img.position_u3*incre_space-img.halflength)+led.position_x3;

 
y1=h/f*(img.position_w1*incre_space-img.halflength)+led.position_y1;
y2=h/f*(img.position_w2*incre_space-img.halflength)+led.position_y2;
y3=h/f*(img.position_w3*incre_space-img.halflength)+led.position_y3;
 
 P=[(x1+x2+x3)/3,(y1+y2+y3)/3]
%————————————————————————————————
  

 
%model2————————————————————————————————
a1=incre_space*sqrt( (axis/2-img.position_w1)^2 +(axis/2-img.position_u1)^2 )/f;
a2=incre_space*sqrt( (axis/2-img.position_w2)^2 +(axis/2-img.position_u2)^2 )/f;
a3=incre_space*sqrt( (axis/2-img.position_w3)^2 +(axis/2-img.position_u3)^2 )/f;

M=[led.position_x2-led.position_x1,led.position_y2-led.position_y1;
   led.position_x3-led.position_x1,led.position_y3-led.position_y1];

z=h;
D=[ ( (a1^2-a2^2)*h^2-(led.position_x1^2+led.position_y1^2-led.position_x2^2-led.position_y2^2) ),
    ( (a1^2-a3^2)*h^2-(led.position_x1^2+led.position_y1^2-led.position_x3^2-led.position_y3^2) ) ];

X=0.5 * M^-1 *D
%————————————————————



%{

%错误的模型
c1=(f+h)/f*sqrt(  (led.position_x1-img.position_u1)^2+ (led.position_y1-img.position_w1)^2 +(h+f)^2 );
c2=(f+h)/f*sqrt(  (led.position_x2-img.position_u2)^2+ (led.position_y2-img.position_w2)^2 +(h+f)^2 );
c3=(f+h)/f*sqrt(  (led.position_x3-img.position_u3)^2+ (led.position_y3-img.position_w3)^2 +(h+f)^2 );
a1=sqrt((c1/f)^2-1);
a2=sqrt((c2/f)^2-1);
a3=sqrt((c3/f)^2-1);



%设置位置T1————储存的数据似乎1,3反了
 img.position_u3=945; img.position_u2=1685; img.position_u1=2426;
 img.position_w3=1684; img.position_w2=941; img.position_w1=2424;
 
 %设置位置T2——灯和人一条垂直线上
 img.position_u1=1500; img.position_u2=563; img.position_u3=1187;
 img.position_w1=1500 img.position_w2=1187; img.position_w3=1810;
 
 
 %设置位置T3——(2.5,2.5) （3.5，2）(2,3)(3,4)
 img.position_u1=875; img.position_u2=1812; img.position_u3=1187;
 img.position_w1=1812; img.position_w2=1187; img.position_w3=562;
 
 %实际单点的位置————计算在本上相差0.5
  
%}


