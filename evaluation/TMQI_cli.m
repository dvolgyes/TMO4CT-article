#!/usr/bin/octave -qf
pkg load image;

arg_list = argv ();

i1 = imread(arg_list{1});
i2 = imread(arg_list{2});
[Q,S,N,smap,slocal]=TMQI(i1,i2);
x=sprintf("%s  S= %.2f",arg_list{2},S);
out=sprintf("smap_%s",arg_list{2});
disp(x)
m=cell2mat(smap(1,1));
imwrite(uint8(m.*255),out);
