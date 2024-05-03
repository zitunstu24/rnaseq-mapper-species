process combineAll {
    input:
        path("${params.outputDir}/*.tsv") from abundances_ch
        
    output:
        path("${params.outputDir}/combined_abundance.tsv") into combined_ch
        
    module 'R'

    script:
        """
        #!/usr/bin/env Rscript

        
        combined_df <- read.csv(abundance_files[1], sep="\t")
        
        for (file_path in abundance_files[-1]) {
            additional_df <- read.csv(file_path, sep="\t")
            combined_df <- merge(combined_df, additional_df, all=TRUE)
        }
        
        write.table(combined_df, "${params.outputDir}/combined_abundance.tsv", row.names = FALSE, sep="\t", quote = FALSE)


        abundance_files <- list.files(pattern = "*.tsv", path = "${params.outputDir}")
        accession.ids = sub(".tsv", "", abundance.files)
        combined_df = read.csv(abundance.files[1], sep="\t")
        names(combined_df) = c("target_id", "length",paste0(accession.ids[1], "_eff_length"),
        paste0(accession.ids[1], "_est_counts"), 
        paste0(accession.ids[1], "_tpm"))
        for(i in 2:length(abundance.files)) {
            additional_df = read.csv(abundance.files[i], sep="\t")
            names(additional_df) = c("target_id", "length", 
            paste0(accession.ids[i], "_eff_length"), 
            paste0(accession.ids[i], "_est_counts"), 
            paste0(accession.ids[i], "_tpm"))
            combined_df = merge(combined_df, additional_df, all=T)
            }
            write.table(combined_df, "outputs/combined_abundance.tsv", row.names=F, sep="\t", quote=F)
        """
}

