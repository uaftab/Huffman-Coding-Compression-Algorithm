%% Umair Aftab 
%% behance.net/uaftab
%% github.com/uaftab
%% 09/11/12
%% Huffman For Images without any Default Functions
%% Raw Implementation of Algorithm
%% Matlab

%{
The MIT License (MIT)

Copyright (c) 2016 Umair Aftab

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
%}
clc 
clear all 
close all 


%%


img=imread('cameraman.tif');
%img = imread('lena.tiff');


%% Prob+Sort 
[row col channels]=size(img);

%Covert to Grayscale
if (channels~=1)
   img = 0.2989*img(:,:,1)+0.5870*img(:,:,2)+ 0.1140*img(:,:,3)  ;
end


quanta = 16;
img = double(img) / 255;
img = uint8(img * quanta); % Image is now quantized to 16 levels . 
 
% img = double(img) / quanta;
% imshow(img);
% % 
% figure
% imhist(img);


prob = zeros(1,quanta+1);
sym = zeros(1,quanta+1);

%[row col] = size(img);
for i=1:row
   
    for j=1:col
       
        prob(img(i,j)+1)=prob(img(i,j)+1)+1;
        
    end
end

for i=1:quanta
   
    sym(i)=i-1;
    
end

sumprob=sum(prob);
prob=prob./sumprob; % normalize the probabilities 

%% Algo

%probsort=sort(prob,2,'descend');
probsort=prob;

zero_one=['0'; '1']; 

if length(probsort)>2
    
    prob_sort_grow=probsort(:);
    h={zero_one(1),zero_one(2)};
    %prob_sort_grow(:,1)=probsort
    M=length(probsort);
    N=length(probsort)-1;
    
    for n=1:N
         [prob_sort_grow(1:M-n+1,n),org_ind(1:M-n+1,n)]=sort(prob_sort_grow(1:M-n+1,n),1,'descend')
         if n==1, ord0=org_ind; end
         if M-n>1, prob_sort_grow(1:M-n,n+1)=[prob_sort_grow(1:M-1-n,n); sum(prob_sort_grow(M-n:M-n+1,n))]; 
         end
    end
    for n=N:-1:2
       
        tmp=N-n+2;
        original_index=org_ind(1:tmp,n);
        
        for i=1:tmp
            h1{original_index(i)}=h{i};
        end
        h=h1;   
        h{tmp+1}=h{tmp};
        h{tmp}=[h{tmp} zero_one(1)];
        h{tmp+1}=[h{tmp+1} zero_one(2)];
    end
    
    for i=1:length(ord0)
        h1{ord0(i)}=h{i};
    end
      
      h=h1   % Ouput Codes
      
      probsort   % Output the symbols 
    
end
%%
%%Calc compression ratio
ord0=transpose(ord0);
sum=0;
for i=1:length(h1);
    sum=sum+(length(h{1,i})*ord0(1,i));
end

total = 255*channels*8;

Compression = (sum/total)*100

%%

img = double(img) / quanta;
imshow(img);
% 
figure
imhist(img);


