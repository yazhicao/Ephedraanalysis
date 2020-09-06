clear all;
close all;
clc

[filedata,filename] = xlsread('snp_sites.xlsx');
totalrows = size(filename,1);
totalcolums = size(filename,2);
classify_results_str = cell(totalrows,totalcolums+1);
classify_results_str(1,1:5) =[{'id of transcripts'},{'the position of SNP sites'},{'sites of KB_F'},{'sites of E.equisetina'},{'sites of E.regeliana'}];
classify_results_str(1,totalcolums+1) = [{'SNP types of KB_F'}];
classify_results_str(2:totalrows,1:totalcolums) = [filename(2:totalrows,1),filename(2:totalrows,3:5),num2cell(filedata(1:totalrows-1,2))];
count = 1;
for row_num=2:totalrows
    disp([num2str(row_num),' of ',num2str(size(filename,1))]);
    count = count + 1;
    str1 = filename{row_num,4};
    str5 = filename{row_num,5};
    str6 = filename{row_num,3};
    
    A_group = strrep(str1(1:min(3:numel(str1))),'/','');
    B_group = strrep(str5(1:min(3:numel(str5))),'/','');
    C_group = strrep(str6(1:7),'/','');
    D_group = strrep([str1(1:min(3:numel(str1))),str5(1:min(3:numel(str5))),str6(1:3)],'/','');
    
    deleteflag = 0;
    if(sum(abs(D_group)==abs('0'))==numel(D_group) || sum(abs(D_group)==abs('0'))==1)
        deleteflag = 1;
    end
    if(sum(abs(D_group)==abs('1'))==numel(D_group) || sum(abs(D_group)==abs('1'))==1)
        deleteflag = 1;
    end
    if(sum(abs(D_group)==abs('2'))==numel(D_group) || sum(abs(D_group)==abs('2'))==1)
        deleteflag = 1;
    end
    classify_results_str(count,totalcolums+m-8) = {'None'};
    if(isempty(intersect(A_group,B_group)) )
        if(~isempty(intersect(C_group,A_group)) && isempty(intersect(C_group,B_group)))
            classify_results_str(count,totalcolums+m-8) = {'P'};
        end
        if(~isempty(intersect(C_group,B_group)) && isempty(intersect(C_group,A_group)))
            classify_results_str(count,totalcolums+m-8) = {'M'};
        end
        if(~isempty(intersect(C_group,A_group)) && ~isempty(intersect(C_group,B_group)) && isempty(intersect(A_group,B_group)))
            classify_results_str(count,totalcolums+m-8) = {'PM'};
        end
    end
    if (deleteflag)
        classify_results_str(count,totalcolums+m-8) = {'Dele'};
    end
    if (~isempty(strfind(str6,'my_snp_GT_filter')))
        classify_results_str(count,totalcolums+m-8) = {'Dele'};
    end
    if (~isempty(strfind(str6,'./.')))
        classify_results_str(count,totalcolums+m-8) = {'Dele'};
    end
end
xlswrite('snp_sites_type.xlsx',classify_results_str);

