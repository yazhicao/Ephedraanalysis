clear;
close;
clc

direnamelist = ['one-to-one-OGs'];%%filename

for D1 = 1:size(direnamelist,2)
    dirname = [direnamelist{D1}];
    D = dir([dirname,'/*.fasta']);
    totallinecount = 0;
    for n=1:size(D,1)
        filename = D(n).name;
        [select_strs,seq_name] = select_func([dirname,'/',D(n).name]);
        if(size(select_strs,1)~=size(seq_name,1))
            disp('critical error!');
            continue;
        end
        for m=1:size(select_strs,1)
            seqstr = seq_name{m};
            if(isempty(find(strcmp(seqstr,{'prz','rege','equi','mon','min'})==true, 1)))
                totallinecount = totallinecount + 1;
            end
        end
    end
    fclose all;
    
    results = cell(totallinecount+1,6);
    fresult = fopen('fresults.txt','w');
    ferr = fopen('ferrs.txt','w');
    linecount = 1;
    %%M_sites:SNPs that only shared with maternal parents;P_sites:SNPs that only shared with paternal parents
    %%poly_sites:SNPs that were from polyploid sample
    %%poly_sites_single:SNPs that were only from one polyploid sample
    results(linecount,:) = [{'filename'},{'seqname'},{'eqma_neqfa M_sites'},{'P_sites'},{'poly_sites'},{'poly_sites_single'}];
    for n=1:size(D,1)
        filename = D(n).name;
        [select_strs,seq_name] = select_func([dirname,'/',D(n).name]);
        if(size(select_strs,1)~=size(seq_name,1))
            fprintf(ferr,'%s\n',filename);
            disp('critical error!');
            continue;
        end
        seq_num = size(select_strs,1);
        seq_len = size(select_strs,2);
        
        maternalIdx = zeros(0);
        paternalIdx = zeros(0);
        for m=1:seq_num
            seqstr = seq_name{m};
            if(~isempty(find(strcmp(seqstr,{'prz','rege'})==true, 1)))
                maternalIdx = [maternalIdx,m];
            end
            if(~isempty(find(strcmp(seqstr,{'equi','mon','min'})==true, 1)))
                paternalIdx = [paternalIdx,m];
            end
        end
        sonIdx = setdiff((1:seq_num),[maternalIdx,paternalIdx]);
        
        for m=1:seq_num
            seqstr = seq_name{m};
            M_sites = 0;
            P_sites = 0;
            poly_sites = 0;
            poly_sites_single = 0;
            if(isempty(find(strcmp(seqstr,{'prz','rege','equi','mon','min'})==true, 1)))
                for k=1:seq_len
                    fa_flag = 0;
                    ma_flag = 0;
                    character = select_strs(m,k);
                    ma_cluster = select_strs(maternalIdx,k)';
                    fa_cluster = select_strs(paternalIdx,k)';
                    poly_cluster = select_strs(polyIdx,k)';
                    cluster_str = [character,ma_cluster,fa_cluster];
                    if(isempty(strfind(cluster_str,'-')))
                        if(numel(strfind(ma_cluster,character)) > 0)
                            ma_flag = 1;
                        end
                        if(numel(strfind(fa_cluster,character)) > 0)
                            fa_flag = 1;
                        end
                        if(~fa_flag && ma_flag)
                            M_sites = M_sites + 1;
                        end
                        if(fa_flag && ~ma_flag)
                            P_sites = P_sites + 1;
                        end
                        if(~fa_flag && ~ma_flag)
                            poly_sites = poly_sites + 1;
                            if(numel(strfind(poly_cluster,character))==1)
                                poly_sites_single = poly_sites_single + 1;
                            end
                        end
                    end
                end
                linecount =  linecount + 1;
                results(linecount,:) = [{filename},{seqstr},{M_sites},{P_sites},{poly_sites},{poly_sites_single}];
            end
        end
    end
    fclose all;
    xlswrite([direnamelist{D1},'.xlsx'],results,'sheet1');
end

