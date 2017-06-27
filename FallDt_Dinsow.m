clc
clear
global baseName vidName foldername0 foldername1 foldername2 foldername3 foldername4 foldername5 foldername6 
baseName = 'D:\Fall Detection\dataset\dinsowLog\3' ;    VDO=1;  %change path name/ Input type 
%create results folder..
foldername0 = 'Results'; mkdir(baseName,foldername0);
% %INPUT
vidObj=VideoReader([baseName '\12-06-2017_06-05-05\thermal.avi']);
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
vidName=vidObj.Name;
vidName=vidName(1,1:double(max(size(vidName)))-4);
s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);
k = 1;
while hasFrame(vidObj)
    s(k).cdata = readFrame(vidObj);
    k = k+1;
end
set(gcf,'position',[350 350 vidObj.Width vidObj.Height]);
set(gca,'units','pixels');
set(gca,'position',[0 0 vidObj.Width vidObj.Height]);
% % movie(s,1,vidObj.FrameRate);%%showing each frame continuously
close
% %create folder..
	CreateFD;
%         
set(gcf,'position',[240 320 vidWidth vidHeight]);
set(gca,'units','pixels');
set(gca,'position',[0 0 vidWidth vidHeight]);
close
cd(baseName)
cd(foldername2)

Kk=0; Ort1=0; Asp1=0; Ctx1=0; Cty1=0;countvid=0;
Loop=k;
for i=1:k-1
%for i=1995:k-1
        countIP=i
        num=int2str(i);
        imwrite(s(i).cdata,[vidName '-' num '.jpg'])
        img=s(i).cdata;
        
        [x1 y1 z1]=size(img);
% %         Imfall=imresize(img,[320 240]);
% %         IS=imresize(s(1).cdata,[320 240]);
        Imfall=imresize(img,[5*x1 5*y1]);
        figure(1),subplot(3,3,1),imshow(Imfall)
%         Imfall=rgb2gray(Imfall);
%         Imfall=Imfall-rgb2gray(IS);
        title('INPUT')
        imwrite(Imfall,[baseName '\' foldername3 '\' vidName '- Imfall'  num '.jpg'])
        Tr2=graythresh(Imfall);
        BWImg2=im2bw(Imfall,Tr2-0.2); 
        BWImg2=imcomplement(BWImg2); %thermal
        stats = regionprops(BWImg2,'Area','BoundingBox'); Area = [stats.Area]; 
        BC = find(Area==max(Area)); BB = [stats.BoundingBox];
        Box=BB((4*BC)-3:4*BC); 
         if size(size(Area))>0
              
              BWImg2(:,1:Box(1),:)=0; BWImg2(:,Box(1)+Box(3):size(img,2),:)=0;
              BWImg2(1:Box(2),:,:)=0; BWImg2(Box(2)+Box(4):size(img,1),:,:)=0; 
         end
        Ibw=BWImg2; 
        imgHSV = rgb2hsv(Imfall); %thermal
        BWImg = imgHSV(:,:,2) > 0.25; %thermal
        imwrite(BWImg,[baseName '\' foldername4 '\' vidName '-HSVThresh' num '.jpg']) %thermal
        imwrite(BWImg2,[baseName '\' foldername4 '\' vidName '-GreyThresh' num '.jpg']) 
         Ibw=or(BWImg,BWImg2); %thermal
%        Ibw=BWImg;
%         Ibw=imfill(Ibw,'hole');   %thermal
        Ibw=bwareaopen(Ibw,4000); %thermal
%         Ibw = imfill(Ibw,'holes');
%         stats_ch = regionprops(Ibw,'Area','BoundingBox'); Area_bbch = [stats_ch.Area]; 
%         BC = find(Area_bbch==max(Area_bbch)); BB_bbch = [stats_ch.BoundingBox];
%         BBox=BB_bbch((4*BC)-3:4*BC); 
%          if size(size(Area_bbch))>0
%               
%               Ibw(:,1:BBox(1),:)=0; Ibw(:,BBox(1)+BBox(3):size(img,2),:)=0;
%               Ibw(1:BBox(2),:,:)=0; Ibw(BBox(2)+BBox(4):size(img,1),:,:)=0; 
%          end
        imwrite(Ibw,[baseName '\' foldername4 '\' vidName '-OR' num '.jpg']) %thermal
        se = strel('disk',10); %thermal
        Ibw = imerode(Ibw,se); %thermal
        Ibw = imdilate(Ibw,se); %thermal
        %end %%% %thermal
        stat = regionprops(logical(Ibw),'Centroid'); %thermal
        PrCt=struct2cell(stat); %thermal
        PrArea=regionprops(logical(Ibw),'Area'); %thermal
        PrArea=struct2cell(PrArea);%thermal
        PrArea=cell2mat(PrArea);%thermal
        PrArea(:); IbwCheck=0;%thermal
                
        if(max(size(PrArea))>1)%thermal
            for PrI=1:max(size(PrArea))%thermal
                if(PrArea(PrI)~=max(PrArea))%thermal
                Ibw=bwareaopen(Ibw,PrArea(PrI)+5);%thermal
              
                end       %thermal
            end %thermal

        end %thermal
%         Ibw = imfill(Ibw,'holes'); %thermal
        imwrite(Ibw,[baseName '\' foldername4 '\' vidName '-' num '.jpg'])
        % %Centroid %thermal
        %%figure(2),imshow(Ibw); hold on; %thermal
        %%figure(2),plot(stat.Centroid(1),stat.Centroid(2),'ro'); %thermal
        %%saveas(figure(2),['D:\Fall Detection\results\Centroid\Centroid' num '.jpg']) %thermal

    %%%%PCA
    figure(3),imshow(Ibw); hold on; 
    n=1;
    [x1,y1]=size(Ibw);
    Pt_x=0;
    for J=1:y1
        for I=1:x1
            if Ibw(I,J)==1
                Pt_x(n,1)=I;
                Pt_x(n,2)=J;
                n=n+1;
            end
        end
    end

    [Rows, Columns] = size(Pt_x);
    MeanPt=mean(Pt_x);
    if(MeanPt>0)
        X0=MeanPt(1);
        Y0=MeanPt(2);
        Pt_y = Pt_x - ones(size(Pt_x, 1), 1) * MeanPt;
        Pt_cov = cov(Pt_y);
        [eigenvec, eigenval] = eig(Pt_cov);%%V is eigen vector , D is Value

        % Get the index of the largest eigenvector
        largest_eigenvec = eigenvec(:, 2);
        largest_eigenval = eigenval(2,2);
        smallest_eigenvec = eigenvec(:, 1);
        smallest_eigenval = eigenval(1,1);

        % Plot the eigenvectors
        hold on;
        quiver(Y0, X0, -abs(double(largest_eigenvec(2)*sqrt(largest_eigenval))), -abs(double(largest_eigenvec(1)*sqrt(largest_eigenval))), '-r', 'LineWidth',1);
                quiver(Y0, X0, -abs(smallest_eigenvec(2)*sqrt(smallest_eigenval)), abs(smallest_eigenvec(1)*sqrt(smallest_eigenval)), '-b', 'LineWidth',1);
        hold on;
        Frame=getframe(gcf);     
        FrameData=Frame.cdata;
        [i1,i2] = find(FrameData==0);
        figure(1),subplot(3,3,2),imshow(FrameData)
        title('OUTPUT')
        FrameData = imcrop(FrameData,[i2(1) i1(1) 400-1 300-1]);
        imwrite(FrameData,[baseName '\' foldername5 '\' vidName '- PCA' num '.jpg'])
        hold off
          
        %%%%calculate
        Ang=atan2d(largest_eigenvec(2),largest_eigenvec(1));%%PCA Orientation (Major)
        Rot_Test=imrotate(FrameData,Ang+180);
        Rot=imrotate(Ibw,Ang+180);%%Rotate img 
        imwrite(Rot_Test,[baseName '\' foldername5 '\' vidName '- Test' num '.jpg'])
        imwrite(Rot,[baseName '\' foldername5 '\' vidName '- TPCA' num '.jpg'])

        [RowR,ColR]=size(Rot);
        %%%Major Axis
        M_Maj=double(((largest_eigenvec(2)*sqrt(largest_eigenval))-Y0)/((largest_eigenvec(1)*sqrt(largest_eigenval))-X0));
        Major_sum=sum(Rot,2);
        Major_sum=Major_sum(:);
        countLP=0;
        for cnt_Maj=1:RowR
            if(Major_sum(cnt_Maj,1)>0)
                countLP=countLP+1;
            end
        end
        Major_axis=countLP;
        countLP=0;
        %%%Minor Axis
        M_Min=double(((smallest_eigenvec(2)*sqrt(smallest_eigenval))-Y0)/((smallest_eigenvec(1)*sqrt(smallest_eigenval))-X0));
        Minor_sum=sum(Rot);
        for cnt_Min=1:ColR
            if(Minor_sum(1,cnt_Min)>0)
                countLP=countLP+1;
            end
        end
        Minor_axis=countLP;
        

    else    
        Asp1=0; Ctx1=0; Cty1=0; X0=0; Y0=0; Ang=0;  Major_axis=0; Minor_axis=0;
    end

    %%data
    Kk=Kk+1;
    Dat(Kk,1)=X0; %%Ctx 
    Dat(Kk,2)=Y0;%%Cty
    Dat(Kk,3)=Major_axis;%%Major Axis
    Dat(Kk,4)=Minor_axis;%%Minor Axis
    Dat(Kk,5)=abs(Major_axis/Minor_axis);%%Aspect Ratio2
    Dat(Kk,6)=Ang;%%Orientation2
    Dat(Kk,7)=abs(Dat(Kk,6)-Ort1);%%diff orientation=Orientation2-Orientation1

    Dat(1,7)=0;
    if(Dat(Kk,7)<-90||Dat(Kk,7)>90)
        Dat(Kk,7)=0;
     end
    Dat(Kk,8)=double(Dat(Kk,5)-Asp1);%%diff Aspect Ratio=Aspect Ratio2-Aspect Ratio1
    Dat(Kk,9)=double(Dat(Kk,1)-Ctx1);%%diff Centroid x=Centroid x 2-Centroid x 1;
    Dat(Kk,10)=double(Dat(Kk,2)-Cty1);%%diff Centroid y=Centroid y 2-Centroid y 1;
    Ort1=abs(Dat(Kk,6))  
    Asp1=Dat(Kk,5)
    Ctx1=Dat(Kk,1);  Cty1=Dat(Kk,2);

    figure(1),subplot(3,1,2),plot(abs(Dat(1:Kk,6)))
    %figure(1),subplot(3,1,2),plot(Dat(:,6))
    title('Orientation')
    figure(1),subplot(3,1,3),plot(Dat(1:Kk,5))
    title('Aspect Ratio')
    
    ASP=Dat(Kk,5); ORNT=Dat(Kk,7);
    h=subplot(3,3,3);
    cla(h,'reset')
 pstr(1)=0;   
    
 
 if Asp1 >= 0.9 %stand or lie
     if Ort1 >= 160
         %%standing
            set(h,'Visible','off')
            TexP='Standing';
            pstr(Kk)=2;
     elseif Ort1 >= 80 && Ort1 < 160
             %lying
                set(h,'Visible','off')
                TexP='Lying';
                pstr(Kk)=1;
     else
              %undefined
                set(h,'Visible','off')
                TexP='Undefined';
                pstr(Kk)=4;    
     end
     
 elseif Asp1 < 0.9   
     if Ort1 >=110
             %sitting
                set(h,'Visible','off')
                TexP='Sitting';
                pstr(Kk)=3;
     else
          %undefined
                set(h,'Visible','off')
                TexP='Undefined';
                pstr(Kk)=4;   
     end
 else
      %undefined
                set(h,'Visible','off')
                TexP='Undefined';
                pstr(Kk)=4;   
end

%  if(ORNT<=15)
%         if(ASP>0.5)
%             %%lying
%             set(h,'Visible','off')
%             TexP='Lying';
%             pstr(Kk)=1;
%         elseif(ASP>1.5)
%             %%standing
%             set(h,'Visible','off')
%             TexP='Standing';
%             pstr(Kk)=2;
%         elseif(ASP>0.5&&ASP<1.5)||(ASP>0.5&&Dat(Kk,6)<-90)
%             %%sitting
%             set(h,'Visible','off')
%             TexP='Sitting';
%             pstr(Kk)=3;
%         else
%             %%undefined
%             set(h,'Visible','off')
%             TexP='Undefined';
%             pstr(Kk)=4;
%         end    
%  elseif (Kk>1)&&(ORNT>15)
%      if(pstr(Kk-1)==1)
%         
%         ybw=sum(Ibw'); xbw=sum(Ibw);
%         s_ybw=sum(ybw(:)~=0); s_xbw=sum(xbw(:)~=0); 
%         if(s_ybw>s_xbw)
%          set(h,'Visible','off')
%          TexP='Standing';
%          pstr=2;
%         else
%          set(h,'Visible','off')
%          TexP='Lying';
%          pstr=1;
%         end
%             
%      elseif(pstr(Kk-1)==2)
%          
%         ybw=sum(Ibw'); xbw=sum(Ibw);
%         s_ybw=sum(ybw(:)~=0); s_xbw=sum(xbw(:)~=0); 
%         if(s_ybw>s_xbw)
%          set(h,'Visible','off')
%          TexP='Standing';
%          pstr=2;
%         else
%          set(h,'Visible','off')
%          TexP='Lying';
%          pstr=1;
%         end
%         
%      else
%             %%undefined
%             set(h,'Visible','off')
%             TexP='Undefined';
%             pstr(Kk)=4;
%         
%      end
%      
%  end
    
    text(.5,.5,TexP)
     
    Frame_R=getframe(gcf);
    FrameResult=Frame_R.cdata;
    imwrite(FrameResult,[baseName '\' foldername6 '\' vidName '- ' num '.jpg'])
    countvid=countvid+1;
    VFrame.i=FrameResult;
end
img=s(k-1).cdata;
hold off  

xlswrite([baseName '\' foldername6 '\' vidName  '_Dat.xlsx'],Dat)


%%
% %SAVE VIDEO
v = VideoWriter([baseName '\' foldername6 '\' vidName  '_Dat.avi']);
open(v)
% for k = 1:Loop-1
for k = 1:2880
counVD=k
A=imread([baseName '\' foldername6 '\' vidName '- ' int2str(k) '.jpg']);
writeVideo(v,A)
end
close(v)