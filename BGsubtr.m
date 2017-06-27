function [Ibw2_3,num,img2,img]=BGsubtr(img,IS,fBG,num,closedFrameBW)
global baseName vidName foldername3 foldername4

        Imfall=abs(IS-img);   
       Imfall=rgb2gray(Imfall);    
%        Imfall=abs(rgb2gray(IS)-rgb2gray(img));
%         Wht=round(255/mean(mean(Imfall)));
%         Wht=round(255/max(max(Imfall)));
%         Imfall=Wht.*Imfall;  %figure(3),imshow(Imfall) 
        BWImg2=Imfall;
        
        Tr=graythresh(Imfall);  
        BWImg2=im2bw(BWImg2,Tr);
%          BWImg2(BWImg2<90)=0; BWImg2(BWImg2>=90)=1; 
%         figure(2),imshow(BWImg2)
        BWImg2=imfill(BWImg2,'holes'); 
        se = strel('disk',1); BWImg2 = imerode(BWImg2,se);
        BWImg2 = imdilate(BWImg2,se);
%         BWImg2=bwareaopen(BWImg2,40); 
%         Ibw2=BWImg2;
         Ibw2=logical(BWImg2+closedFrameBW); figure(2),imshow(Ibw2)
        
        img2=img;   se2 = strel('disk',2);   
        Ibw2 = imdilate(Ibw2,se2); Ibw2 = imfill(Ibw2,'holes');
        Ibw2 = imerode(Ibw2,se2); Ibw2=bwareaopen(Ibw2,40); 
        
        stats_ch = regionprops(Ibw2,'Area','BoundingBox'); Area_bbch = [stats_ch.Area]; 
        BC = find(Area_bbch==max(Area_bbch)); BB_bbch = [stats_ch.BoundingBox];
        BBox=BB_bbch((4*BC)-3:4*BC); 
         if size(size(Area_bbch))>0
              Ibw2_3=Ibw2;
              Ibw2_3(:,1:BBox(1),:)=0; Ibw2_3(:,BBox(1)+BBox(3):size(img,2),:)=0;
              Ibw2_3(1:BBox(2),:,:)=0; Ibw2_3(BBox(2)+BBox(4):size(img,1),:,:)=0; 
         end
        
       lineIbw = edge(Ibw2_3,'Canny');
       for i = 1:size(lineIbw,1)
                for j = 1:size(lineIbw,2)
                    if lineIbw(i,j) == 1
                         img2(round(i,j),1) = 0;
                         img2(round(i),round(j),2) = 255;
                         img2(round(i),round(j),3) = 0;
                    end
                end
       end  
%         
%       figure(1),subplot(1,2,1),imshow(img2)
%        hold on;
%        title('INPUT')
%         figure(4),imshow(img2)
        imwrite(Imfall,[baseName '\' foldername3 '\' vidName '- Imfall'  num '.jpg'])
         imwrite(BWImg2,[baseName '\' foldername4 '\' vidName '- bwsubtr_meanfilter'  num '.jpg'])
%         imwrite(img2,[baseName '\' foldername6 '\' vidName '- conv'  num '.jpg'])  
        

