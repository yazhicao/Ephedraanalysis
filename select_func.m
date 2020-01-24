function[select_strs,seq_name] = select_func(filename)
fid = fopen(filename,'r');
ftmp = fopen('tmp.fas','w');
tline = fgets(fid);
linecount = 0;
seq_len = 0;
seq_name = cell(0,0);
while(ischar(tline))
    if(strcmp(tline(1),'>'))
        S = strsplit(tline,{'>',' ','\n','\r'});

        linecount = linecount + 1;
        if(linecount>1)
            fprintf(ftmp,'\n');
        end
        seq_name = [seq_name;S(2)];
        seq_len = 0;
    else
        seq_len = seq_len + fprintf(ftmp,'%s',tline(1:end-1));
    end
    tline = fgets(fid);
%     disp(tline);
end
fprintf(ftmp,'\n');
fclose(fid);
fclose(ftmp);

strs = '';
ftmp = fopen('tmp.fas','r');
tline = fgets(ftmp);
while(ischar(tline))
    strs = [strs;tline(1:end-1)];
    tline = fgets(ftmp);
end
fclose(ftmp);

strs = strs';
select_strs = strs;
count = 0;
for n=1:size(strs,1)
    allsameflag = 1;
    idx = find(strs(n,:)~='-');
    if(length(idx)<=1)
        allsameflag = 1;
    else
        for m=2:length(idx)
            if(strs(n,idx(1))~=strs(n,idx(m)))
                allsameflag = 0;
            end
        end
    end
    if(allsameflag==0)
        count = count + 1;
        select_strs(count,:) = strs(n,:);
    end
end
select_strs = select_strs(1:count,:)';
