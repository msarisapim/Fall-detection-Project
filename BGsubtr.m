function [Ibw2,num,img2,img]=BGsubtr(img,IS,fBG,num)
global baseName vidName foldername3 foldername4 foldername6

        Imfall=abs(rgb2gray(IS)-rgb2gray(img));
        Wht=round(255/max(max(Imfall)));
        Imfall=Wht*Imfall;
        Tr=graythresh(Imfall); BWImg2=Imfall; %figure(1),imshow(BWImg2)
        BWImg2=im2bw(BWImg2,Tr);
%         BWImg2(BWImg2<120)=0; BWImg2(BWImg2>=120)=1; 
        BWImg2=imfill(BWImg2,'holes'); 
        se = strel('disk',1); BWImg2 = imerode(BWImg2,se);BWImg2 = imdilate(BWImg2,se);
        BWImg2=bwareaopen(BWImg2,40); %figure(2),imshow(BWImg2)
        Ibw2=BWImg2;
        img2=img;     
       lineIbw = edge(BWImg2,'Canny');
       for i = 1:size(lineIbw,1)
                for j = 1:size(lineIbw,2)
                    if lineIbw(i,j) == 1
                         img2(round(i,j),1) = 0;
                         img2(round(i),round(j),2) = 255;
                         img2(round(i),round(j),3) = 0;
                    end
                end
       end  
        
%       figure(1),subplot(1,2,1),imshow(img2)
%        hold on;
%        title('INPUT')
       figure(4),imshow(img2)
       imwrite(Imfall,[baseName '\' foldername3 '\' vidName '- Imfall'  num '.jpg'])
       imwrite(BWImg2,[baseName '\' foldername4 '\' vidName '- bwconv'  num '.jpg'])
       imwrite(img2,[baseName '\' foldername6 '\' vidName '- conv'  num '.jpg'])  
        

