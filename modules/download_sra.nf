process download_sra {
    input:
        tuple val(sraId), val(isPaired) from input

    output:
        path("${params.outputDir}/${sraId}_1.fastq"), path("${params.outputDir}/${sraId}_2.fastq") if $isPaired into outputPaired
        path("${params.outputDir}/${sraId}.fastq") if !$isPaired into outputSingle

    script:
        if (isPaired) {
            """
            fasterq-dump --outdir ${params.outputDir} --split-files $sraId
            """
        } else {
            """
            fasterq-dump --outdir ${params.outputDir} $sraId
            """
        }
}
