clc
clear
global baseName vidName foldername0 foldername1 foldername2 foldername3 foldername4 foldername5 foldername6 
baseName = 'D:\Fall Detection' ;    VDO=1;  %change path name/ Input type 
%create results folder..
foldername0 = 'Results'; mkdir(baseName,foldername0);
%INPUT
if VDO == 1 %%Video for input
    vidObj=VideoReader('D:\Fall Detection\dataset\Le2i\Home_01\Videos\video (3).avi');
    vidHeight = vidObj.Height; vidWidth = vidObj.Width;
    vidName=vidObj.Name;  vidName=vidName(1,1:double(max(size(vidName)))-4);
    %collect each frame in s(structure)
    s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
        'colormap',[]);
    k = 1;
    while hasFrame(vidObj)
        s(k).cdata = readFrame(vidObj);
        k = k+1;
    end
    
else %%if Sequence of images for input
    vidName='fall-01-cam0-rgb';
    Dir_im = [baseName '\dataset\UR Fall Detection Dataset\' vidName '\'];
    file=ls(Dir_im);
    file=cellstr(file);
    S_dir=size(file,1); 
    k=1;
    for cdir = 3:S_dir
        s(k).cdata=imread([Dir_im  file{cdir}]);
        k=k+1;
    end
    [vidHeight,vidWidth] = size(s(1).cdata);
    
end
%create folder..
	CreateFD;
        
               
set(gcf,'position',[240 320 vidWidth vidHeight]);
set(gca,'units','pixels');
set(gca,'position',[0 0 vidWidth vidHeight]);
close
cd(baseName)
cd(foldername2)

Kk=0; Ort1=0; Asp1=0; Ctx1=0; Cty1=0;countvid=0; Dat=0;
Loop=k;

BGsum=double(s(1).cdata);
% %Create Mean filter as a bg
% for i=1:k-1
%           Frame=double(s(i).cdata); 
%           BGsum(:,:,1) = double(BGsum(:,:,1)+Frame(:,:,1));
%           BGsum(:,:,2) = double(BGsum(:,:,2)+Frame(:,:,2));
%           BGsum(:,:,3) = double(BGsum(:,:,3)+Frame(:,:,3));
% end       
%           BGMean=uint8(BGsum/(i+1)); %Average bg 
% for i=45:k-1
for i=1:k-1
         %Create Mean filter as a bg
          Frame=double(s(i).cdata); 
          BGsum(:,:,1) = double(BGsum(:,:,1)+Frame(:,:,1));
          BGsum(:,:,2) = double(BGsum(:,:,2)+Frame(:,:,2));
          BGsum(:,:,3) = double(BGsum(:,:,3)+Frame(:,:,3));
          BGMean=uint8(BGsum/(i+1)); %Average bg 
        fBG=s(1).cdata; %BG filter(First BG)
        
        lim=k-1; countIP=i     
        num=int2str(i);
        imwrite(s(i).cdata,[vidName '-' num '.jpg'])
        img=s(i).cdata; [x1 y1 z1]=size(img); 
        Imfall=imresize(img,[240 320]); img=Imfall;
        fBG=imresize(fBG,[240 320]);
        IS=imresize(BGMean,[240 320]);%first BG          
        
        %%BG subtraction  
        [Ibw,num]=BGsubtr(img,IS,fBG,num);
        
%       figure(3),imshow(Ibw)
        imwrite(Ibw,[baseName '\' foldername4 '\' vidName '-' num '.jpg'])
%         hold off

%     if sum(sum(Ibw)) < 240*320/2              
       [Ibw,Kk,k] = pcacaldat(Ibw,k,Kk,num);
%       [Ibw,Dat,Kk,k,Ort1,Asp1] = pcacaldat(Ibw,k,Kk,num,Ort1,Asp1,Dat);
%     
%     
    Frame_R=getframe(gcf);
    FrameResult=Frame_R.cdata;
    imwrite(FrameResult,[baseName '\' foldername6 '\' vidName '- ' num '.jpg'])
    countvid=countvid+1;
    VFrame.i=FrameResult;
    img=s(k-1).cdata;
    hold off  
%     end

  
end
% xlswrite([baseName '\' foldername6 '\' vidName  '_Dat.xlsx'],Dat)


%%
% % %SAVE VIDEO
% v = VideoWriter([foldername6 '\' vidName  '_Dat.avi']);
% open(v)
% for k = 1:Loop-1
% %for k = 1:1000
% counVD=k
% A=imread([foldername6 '\' vidName '- ' int2str(k) '.jpg']);
% A=imresize(A,[506 353]);
% writeVideo(v,A)
% end
% close(v)