process run_kallisto {
    input:
        tuple path(fastq1), path(fastq2), path(fastq), val(sraId), val(genome), val(isPaired) from input
        
    output:
        path("${params.outputDir}/${sraId}_abundance.tsv") into output
        
    script:
        """
        kallistoIndex = "${params.outputDir}/${genome}/kallisto_index.idx"
        outputDir = "${params.outputDir}/$sraId"
        mkdir -p $outputDir
        
        # Run kallisto quantification
        if (isPaired) {
            kallisto quant -i $kallistoIndex -o $outputDir $fastq1 $fastq2
        } else {
            kallisto quant -i $kallistoIndex -o $outputDir --single -l 200 -s 20 $fastq
        }

        # Move the abundance file
        mv $outputDir/abundance.tsv ${params.outputDir}/${sraId}_abundance.tsv
        """
}

