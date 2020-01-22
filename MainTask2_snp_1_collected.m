clear;
close;
clc

direnamelist = ['kskt_120000_try1_out'];

for D1 = 1:size(direnamelist,2)
    dirname = ['../kskt/',direnamelist{D1}];
    % dirname = '../kb_f/results_kb_f_120000_try2';
    D = dir([dirname,'/*.merge']);
    totallinecount = 0;
    for n=1:size(D,1)
        filename = D(n).name;
        [select_strs,seq_name] = select_func_delete_rhy1([dirname,'/',D(n).name]);
        if(size(select_strs,1)~=size(seq_name,1))
            disp('critical error!');
            continue;
        end
        for m=1:size(select_strs,1)
            seqstr = seq_name{m};
            if(isempty(find(strcmp(seqstr,{'rhy1','klc2','ys1','hxm3','zl3','my1'})==true, 1)))
                totallinecount = totallinecount + 1;
            end
        end
    end
    fclose all;
    
    results = cell(totallinecount+1,7);
    fresult = fopen('fresults.txt','w');
    ferr = fopen('ferrs.txt','w');
    linecount = 1;
    results(linecount,:) = [{'filename'},{'seqname'},{'eqma_eqfa'},{'eqma_neqfa'},{'neqma_eqfa'},{'neqma_neqfa'},{'neqma_neqfa_solo'}];
    for n=1:size(D,1)
        filename = D(n).name;
        [select_strs,seq_name] = select_func_delete_rhy1([dirname,'/',D(n).name]);
        if(size(select_strs,1)~=size(seq_name,1))
            fprintf(ferr,'%s\n',filename);
            disp('critical error!');
            continue;
        end
        seq_num = size(select_strs,1);
        seq_len = size(select_strs,2);
        
        motherIdx = zeros(0);
        fatherIdx = zeros(0);
        for m=1:seq_num
            seqstr = seq_name{m};
            if(~isempty(find(strcmp(seqstr,{'klc2','ys1'})==true, 1)))
                motherIdx = [motherIdx,m];
            end
            if(~isempty(find(strcmp(seqstr,{'hxm3','zl3','my1'})==true, 1)))
                fatherIdx = [fatherIdx,m];
            end
        end
        sonIdx = setdiff((1:seq_num),[motherIdx,fatherIdx]);
        
        for m=1:seq_num
            seqstr = seq_name{m};
            eqma_eqfa = 0;
            eqma_neqfa = 0;
            neqma_eqfa = 0;
            neqma_neqfa = 0;
            neqma_neqfa_solo = 0;
            if(isempty(find(strcmp(seqstr,{'rhy1','klc2','ys1','hxm3','zl3','my1'})==true, 1)))
                for k=1:seq_len
                    fa_flag = 0;
                    ma_flag = 0;
                    character = select_strs(m,k);
                    ma_cluster = select_strs(motherIdx,k)';
                    fa_cluster = select_strs(fatherIdx,k)';
                    son_cluster = select_strs(sonIdx,k)';
                    cluster_str = [character,ma_cluster,fa_cluster];
                    if(isempty(strfind(cluster_str,'-')))
                        if(numel(strfind(ma_cluster,character)) > 0)
                            ma_flag = 1;
                        end
                        if(numel(strfind(fa_cluster,character)) > 0)
                            fa_flag = 1;
                        end
                        if(fa_flag && ma_flag)
                            eqma_eqfa = eqma_eqfa + 1;
                        end
                        if(~fa_flag && ma_flag)
                            eqma_neqfa = eqma_neqfa + 1;
                        end
                        if(fa_flag && ~ma_flag)
                            neqma_eqfa = neqma_eqfa + 1;
                        end
                        if(~fa_flag && ~ma_flag)
                            neqma_neqfa = neqma_neqfa + 1;
                            if(numel(strfind(son_cluster,character))==1)
                                neqma_neqfa_solo = neqma_neqfa_solo + 1;
                            end
                        end
                    end
                end
                linecount =  linecount + 1;
                results(linecount,:) = [{filename},{seqstr},{eqma_eqfa},{eqma_neqfa},{neqma_eqfa},{neqma_neqfa},{neqma_neqfa_solo}];
                %             fprintf(fresult,'%-45s\t%-30s\t%-3d\t%-3d\t%-3d\t%-3d\n',filename,seqstr,eqma_eqfa,eqma_neqfa,neqma_eqfa,neqma_neqfa);
            end
        end
    end
    fclose all;
    xlswrite([direnamelist{D1},'.xlsx'],results,'sheet1');
end

