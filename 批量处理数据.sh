cat idname1 | while read id
#创建一个idname1文件，里面写sra号，一行写一个号码
#SRR16067189
#SRR16067182
#SRR16067181
do
    /storx/chenlei/software/sratoolkit/bin/prefetch "$id"
#调用prefetch
    if [ ! -d "$id" ]; then
        echo "$id folder not found, skipping to next iteration"
        continue
    fi
#判断是否下载成功
    mkdir ${id}_results
    cd "$id"
#这个文件夹下载后就会存在
    /storx/chenlei/software/sratoolkit/bin/fastq-dump --split-3 "${id}.sra"
#调用fastq-dump拆分sra数据
    cp ../vRICseq_prot-RNAseq.py ./
#复制脚本
    cp ../TGEV.fasta ./
#复制参考序列到当前文件夹
    python vRICseq_prot-RNAseq.py -r TGEV.fasta -f "${id}_1.fastq" -s "${id}_2.fastq" -t "$id"
    mv "${id}_1.fastq" "${id}_2.fastq" *_in_Virion.sort.list *_in_Virion.list *virus.loops *HQ* *hic /storx/ccl/workapce/vRICseq/TGEV/${id}_results
    cd /storx/ccl/workapce/vRICseq/TGEV
    rm -r  /storx/ccl/workapce/vRICseq/TGEV/${id}
#删除中间文件，是为了节省内存
done

