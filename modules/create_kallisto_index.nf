process create_kallisto_index {
    input:
        tuple val(genome), val(referenceAnnotation) from input
    
    output:
        path("${params.outputDir}/${genome}/kallisto_index.idx") into output
        
    script:
        """
        mkdir -p ${params.outputDir}/${genome}
        kallisto index -i ${params.outputDir}/${genome}/kallisto_index.idx $referenceAnnotation
        """
}

