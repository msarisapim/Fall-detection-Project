function [Ibw,num,img2,img]=BGsubtr(img,IS,fBG,num)
global baseName vidName foldername3 foldername4 foldername6

        Imfall=6*abs(rgb2gray(IS)-rgb2gray(img)); 
      
%       figure(1),subplot(1,2,1),imshow(img)
%       title('INPUT')
        Tr=graythresh(Imfall); BWImg2=Imfall;
         BWImg2(BWImg2<1)=0; BWImg2(BWImg2==1)=1; 
%         BWImg2=im2bw(Imfall,Tr); 
        BWImg2=bwareaopen(BWImg2,10); %figure(2),imshow(BWImg2)
        BWImg=BWImg2 ; Ibw=BWImg; 
        Ibw_x=sum(Ibw,1); Ibw_y=sum(Ibw,2);
        posIbw_x=find(Ibw_x>0); posIbw_y= find(Ibw_y>0);
        stIbw_x=min(posIbw_x); enIbw_x=max(posIbw_x); %%% human position x
        stIbw_y=min(posIbw_y); enIbw_y=max(posIbw_y); %%% human position y
        cropped_img=img;  cropped_IS=IS; g_img=Imfall;
        cropped_img(:,1:stIbw_x,:)=0;cropped_img(:,enIbw_x:size(img,2),:)=0;
        cropped_img(1:stIbw_y,:,:)=0;cropped_img(enIbw_y:size(img,1),:,:)=0;
        cropped_IS(:,1:stIbw_x,:)=0;cropped_IS(:,enIbw_x:size(img,2),:)=0;
        cropped_IS(1:stIbw_y,:,:)=0;cropped_IS(enIbw_y:size(img,1),:,:)=0; 
%         figure(2),imshow(cropped_img)
%         figure(3),imshow(cropped_IS)
        subbg_img=abs(rgb2gray(cropped_IS)-rgb2gray(cropped_img)); 
        summ_img =  g_img+subbg_img ; 
        
imwrite(Imfall,[baseName '\' foldername3 '\' vidName '- GrayImg'  num '-1.jpg'])
imwrite(summ_img,[baseName '\' foldername3 '\' vidName '- GrayImg'  num '-r.jpg'])
        
        Ibw2=im2bw(summ_img,graythresh(summ_img)+0.1); Ibw2=bwareaopen(Ibw2,5);
%       Ibw2=im2bw(subbg_img,graythresh(subbg_img)+0.05);
        se = strel('diamond',10); se2 = strel('disk',5);
        Ibw2 = imerode(Ibw2,se2); Ibw2 = imdilate(Ibw2,se); 
        Ibw2=imfill(Ibw2,'holes'); 
%         figure(3),imshow(summ_img)
%         figure(2),imshow(Ibw2)
        
        Ibw2_ch = imdilate(Ibw2,se);
        Ibw2_ch = bwconvhull(Ibw2_ch,'objects'); Ibw2_ch = imdilate(Ibw2_ch,se); 
        Ibw2_ch=imfill(Ibw2_ch,'holes'); Ibw2=bwareaopen(Ibw2_ch,5);
        Ibw2_ch = bwconvhull(Ibw2_ch,'objects'); 
        Ibw2_ch = imerode(Ibw2_ch,se2);
        stats_ch = regionprops(Ibw2_ch,'Area','BoundingBox'); Area_bbch = [stats_ch.Area]; 
        maxp_bbch = find(Area_bbch==max(Area_bbch));
        if size(maxp_bbch)>0
             Ibw2_3=summ_img;
             Ibw2_3(:,1:stIbw_x,:)=0;Ibw2_3(:,enIbw_x:size(img,2),:)=0;
             Ibw2_3(1:stIbw_y,:,:)=0;Ibw2_3(enIbw_y:size(img,1),:,:)=0; 
             Ibw2_3(find(Ibw2_3<150))=0; Ibw2_3=bwareaopen(Ibw2_3,5);
             Ibw2_3=imfill(Ibw2_3,'holes'); Ibw2_3=bwareaopen(Ibw2_3,20);
             se3 = strel('disk',1);
             Ibw2_3 = imerode(Ibw2_3,se3); Ibw2_3 = imdilate(Ibw2_3,se3);
             Ibw2_3=bwareaopen(Ibw2_3,20);
             figure(2),imshow(Ibw2_3)            
        else
            Ibw2_3=Ibw2;    
        end
             img2=img;
           
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
                
      
       figure(4),imshow(img2)
       imwrite(Ibw2_3,[baseName '\' foldername4 '\' vidName '- bwconv'  num '.jpg'])
       imwrite(img2,[baseName '\' foldername6 '\' vidName '- conv'  num '.jpg'])  
        

%         Ibw=bwconvhull(Ibw,'objects');
%         imwrite(BWImg2,['D:\Fall Detection\results\BWImg\' vidName '-GreyThresh' num '.jpg']) 
%         se = strel('disk',4); se2 = strel('disk',4); 
%         Ibw = imerode(Ibw,se2);  Ibw = imdilate(Ibw,se); 
%         Ibw = imdilate(Ibw,se);  Ibw = imerode(Ibw,se);
        %Ibw=bwconvhull(Ibw,'union');
        