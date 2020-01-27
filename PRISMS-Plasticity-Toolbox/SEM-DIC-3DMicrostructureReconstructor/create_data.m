clear all
close all
load('Grain_data.mat');
grain1=Grain2(:);
[l2 l1]=size(Grain2);
len_x=X(1,2)-X(1,1);
len_y=Y(2,1)-Y(1,1);
[X Y]=meshgrid(0:len_x:(l1-1)*len_x,0:len_y:(l2-1)*len_y);
x1=X(:);
y1=Y(:);

[l2 l1]=size(Grain2);

vpoints=[x1 y1];
% vpoints=rand(21,2);
kpoints=grain1;

parfor i=1:l2-1
    for j=2:l1-1
        
        if(Grain2(i,j)~=Grain2(i,j+1))
            vpoints=[vpoints; [X(i,j+1) Y(i,j+1)]];
            kpoints=[kpoints;Grain2(i,j)];
            vpoints=[vpoints; [X(i,j) Y(i,j)]];
            kpoints=[kpoints;Grain2(i,j+1)];
        end
        
        if(Grain2(i,j)~=Grain2(i+1,j))
            vpoints=[vpoints; [X(i+1,j) Y(i+1,j)]];
            kpoints=[kpoints;Grain2(i,j)];
            vpoints=[vpoints; [X(i,j) Y(i,j)]];
            kpoints=[kpoints;Grain2(i+1,j)];
        end
        
        if(Grain2(i,j)~=Grain2(i+1,j+1))
            vpoints=[vpoints; [X(i+1,j+1) Y(i+1,j+1)]];
            kpoints=[kpoints;Grain2(i,j)];
            vpoints=[vpoints; [X(i,j) Y(i,j)]];
            kpoints=[kpoints;Grain2(i+1,j+1)];
        end
        
        if(Grain2(i,j)~=Grain2(i+1,j-1))
            vpoints=[vpoints; [X(i+1,j-1) Y(i+1,j-1)]];
            kpoints=[kpoints;Grain2(i,j)];
            vpoints=[vpoints; [X(i,j) Y(i,j)]];
            kpoints=[kpoints;Grain2(i+1,j-1)];
        end
    end
    i
end

save('input_data.mat','kpoints','vpoints');
