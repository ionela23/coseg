% Segmentarea imaginii folosing algoritmul Fuzzy k Means
% converteste imaginea input in 2 segmente folosing algoritmul Fuzzy k means
 
clear all;
clc;
clearvars;
inputImage=input('Tasteaza numele imaginii.eg. ducs.png ','s');
 
IMAGE=imread(inputImage);
IMAGE = rgb2gray(IMAGE);
IMAGE=double(IMAGE);
figure
% converteste la 8 bit unsigned integer
imshow(uint8(IMAGE))
% preia dimensiunile matricii( imaginii)
[maxX,maxY]=size(IMAGE);
IMM=cat(3,IMAGE,IMAGE);
%%%%%%%%%%%%%%%%
ccluster1=8;
ccluster2=250;

ttFuzzycmeans=0;
while(ttFuzzycmeans<15)
    ttFuzzycmeans=ttFuzzycmeans+1
    % creeaza matricile cc1, cc2 folosind copiile valorilor cc1, cc2
    cluster1=repmat(ccluster1,maxX,maxY);
    cluster2=repmat(ccluster2,maxX,maxY);
    %  
    if ttFuzzycmeans==1 
        test1=cluster1; test2=cluster2;
    end
    % concatenare matrici specificand dimensiunea 3
    c=cat(3,cluster1,cluster2);
   % disp('c=');
   % disp(c);
    % ree - matrice cu val 0.000001 de dim maxX * maxY
    ree=repmat(0.000001,maxX,maxY);
    ree1=cat(3,ree,ree);
    
    distance=IMM-c;
    distance=distance.*distance+ree1;
    
    probability1=1./distance;
    
    probability2=probability1(:,:,1)+probability1(:,:,2);
    distance1=distance(:,:,1).*probability2;
    u1=1./distance1;
    distance2=distance(:,:,2).*probability2;
    u2=1./distance2;
      
    cCentercluster1=sum(sum(u1.*u1.*IMAGE))/sum(sum(u1.*u1));
    cCentercluster2=sum(sum(u2.*u2.*IMAGE))/sum(sum(u2.*u2));
   
    tmpMatrix=[abs(ccluster1-cCentercluster1)/ccluster1,abs(ccluster2-cCentercluster2)/ccluster2];
    pp=cat(3,u1,u2);
    
    for i=1:maxX
        for j=1:maxY
            if max(pp(i,j,:))==u1(i,j)
                IX2(i,j)=2;
           
            else
                IX2(i,j)=0;
            end
        end
    end
    %%%%%%%%%%%%%%%
   if max(tmpMatrix)<0.0001
         break;
  else
         ccluster1=cCentercluster1;
         ccluster2=cCentercluster2;
        
  end

 for i=1:maxX
       for j=1:maxY
            if IX2(i,j)==2
            IMMModified(i,j)=254;
                 else
            IMMModified(i,j)=8;
       end
    end
end
%%%%%%%%%%%%%%%%%%
  figure(2);
 
imshow(uint8(IMMModified));
%tostore=uint8(IMMModified);
%imwrite(tostore,inputImage);
end

for i=1:maxX
    for j=1:maxY
         if IX2(i,j)== 2
            IMMModified(i,j)=200;
             else
             IMMModified(i,j)=1;
    end
  end
end 

%%%%%%%%%%%%%%%%%%
IMMModified=uint8(IMMModified);
figure(3);
imshow(IMMModified);
disp('The final cluster centers are');
cCentercluster1
cCentercluster2
