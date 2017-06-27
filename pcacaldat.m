% function [Ibw,Kk,k] = pcacaldat(Ibw,k,Kk,num,img)
function [Ibw,Dat,Kk,k,Ort2,Asp2] = pcacaldat(Ibw,k,Kk,num,img,Ort1,Asp1,Dat)
global baseName vidName  foldername5 
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
        if(Rows>1)
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
                iptsetpref('ImshowBorder','tight');
                figure(2),imshow(Ibw)
                hold on;
                quiver(Y0, X0, -abs(double(largest_eigenvec(2)*sqrt(largest_eigenval))), -abs(double(largest_eigenvec(1)*sqrt(largest_eigenval))), '-r', 'LineWidth',1);
                quiver(Y0, X0, -abs(smallest_eigenvec(2)*sqrt(smallest_eigenval)), abs(smallest_eigenvec(1)*sqrt(smallest_eigenval)), '-b', 'LineWidth',1);

                Frame=getframe(gcf);     
                FrameData=Frame.cdata;
                [i1,i2] = find(FrameData==0);
                FrameData = imcrop(FrameData,[i2(1) i1(1) 400-1 300-1]);
%                 figure(1),subplot(1,2,2),imshow(FrameData)
                 figure(1),subplot(3,3,2),imshow(FrameData)
                % % rectangle('Position', [203, 147, 218, 162],...
                % %'EdgeColor','r', 'LineWidth', 3)
                title('OUTPUT')
%                 FrameData = imcrop(FrameData,[i2(1) i1(1) 400-1 300-1]);
                
                imwrite(FrameData,[baseName '\' foldername5 '\' vidName '- PCA-' num '.jpg'])
                hold off

                %%%%calculate
                Ang=atan2d(largest_eigenvec(2),largest_eigenvec(1));%%PCA Orientation (Major)
                Rot=imrotate(Ibw,Ang+180,'loose', 'bilinear');%%Rotate img 180
                imwrite(Rot,[baseName '\' foldername5 '\Rotate' vidName '- TPCA-' num '.jpg'])
                [RowR,ColR]=size(Rot);
                Ort1=Ang+180;
                %%%Major Axis rotated pixels
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
                %%%Minor Axis rotated pixels
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
            Dat(Kk,1)=abs(Major_axis/Minor_axis);%%Aspect Ratio2
            Dat(Kk,2)=abs(double(Ang));%%Orientation2
            Dat(Kk,3)=abs(Dat(Kk,2)-double(Ort1));%%diff orientation=Orientation2-Orientation1
            Dat(Kk,4)=0;%abs(Dat(Kk,1)-Asp1);%%diff Aspect Ratio=Aspect Ratio2-Aspect Ratio1
            Ort2=Dat(Kk,2); Asp2=Dat(Kk,1);
            figure(1),subplot(3,1,2),plot(Dat(1:Kk,2))
            title('Orientation')
            figure(1),subplot(3,1,3),plot(Dat(1:Kk,1))
            title('Aspect Ratio')
        end