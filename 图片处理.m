


%%%输出图片
imwrite(illuminationtotal,'f1.bmp','bmp');




imge = imread('f1.bmp');
imge = im2bw(imge);%（图像分割）转化为二值图
%%%%%添加噪声处理，平滑处理开运算
figure,imshow(imge);
[B,L] = bwboundaries(imge);%边界数组------能否读出边界两点的值
%L = bwlabel(imge,4);

stats = regionprops(L,'basic');%读出
area=cat(1,stats.Area);
centroid=cat(1,stats.Centroid);%提取结构体数据

Bcell1=cat(1,B{1,1} );

%%%%%------提取-----------------x，y搞反了，点也反了
%计算H时用的数据
 img.position_p1=Bcell1( 1+length(B{1,1}) );
 for i=1:(2*length(B{1,1})-1)
	if( Bcell1(i)~= Bcell1(1) )
	img.position_p2=Bcell1( i+length(B{1,1}) );break;
	end
end

t=0;m=0;n=0;%%%可行
for i=1:15
	if  (area(i)<=100)
		t=t+centroid(i);
		m=m+1;
		n=n+centroid(i+15);	
		img.position_w1=t/m;img.position_u1=n/m;
	end
end
t=0;m=0;n=0;
for i=1:15
	if  (area(i)>100&&area(i)<=200)
		t=t+centroid(i);
		m=m+1;
		n=n+centroid(i+15);	
		img.position_w3=t/m;img.position_u3=n/m;
	end
end
t=0;m=0;n=0;
for i=1:15
	if  (area(i)>200&&area(i)<=300)
		t=t+centroid(i);
		m=m+1;
		n=n+centroid(i+15);	
		img.position_w2=t/m;img.position_u2=n/m;
	end
end	
%%%%%------提取---------------
	
	
	
	


	
	

	
%{

%%%%可行-----暂时用不到
	ip1=zeros(1,15);
for i=1:15
	if  (area(i)<=100)
	ip1(i)=i;%ip1=00000000000/11/12/13..
	end
end


 img.position_u2=563; 
 img.position_u3=1187;
 img.position_w1=873; 
 img.position_w2=1187;
 img.position_w3=1810;
 
 

imshow(img)%显示原图像
h=imrect;%鼠标变成十字，用来选取感兴趣区域
pos=getPosition(h);%pos有四个值，分别是矩形框的左下角点的坐标xy和框的宽度和高度
imCp = imcrop( img, pos ); %拷贝选取图片
figure(2)
imshow(imCp);
 
 
img2 = bwmorph(img,'bridge');%全域连通
figure,imshow(img2);

%}











%%%%有问题
%{
	t=0;m=0;n=0;h=0;
for i=1:15
	if  (area(i)<=100)
	t=t+centroid(i);
	m=m+1;
	n=n+centroid(i+15);
	h=h+1;	
	img.position_u1=t/m;img.position_w1=n/h;
	
	else if  (area(i)<=200)
	t=t+centroid(i);
	m=m+1;
	n=n+centroid(i+15);
	h=h+1;	
	img.position_u2=t/m;img.position_w2=n/h;
	
	else (area(i)<=300)
	t=t+centroid(i);
	m=m+1;
	n=n+centroid(i+15);
	h=h+1;	
	img.position_u3=t/m;img.position_w3=n/h;
	end
end



%wrong
for i=1:15
	if  (area(i)<=100)
		fprintf('Value of a is 1' );
	else if  (area(i)>100 && area(i)<=200)
		fprintf('Value of a is 2' );
	else 
		fprintf('Value of a is 3' );
	end
end



%}