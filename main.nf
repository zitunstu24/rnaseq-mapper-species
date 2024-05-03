nextflow.enable.dsl=2

include { create_kallisto_index } from "./modules/create_kallisto_index.nf"
include { download_sra } from "./modules/download_sra.nf"
include { run_kallisto } from "./modules/run_kallisto.nf"
include { combineAll } from "./modules/combineAll.nf"

// Load the input CSV file and create a channel from it
def samplesChannel = Channel.fromPath(params.csvFile)
    .map { row ->
        def columns = row.split(',')
        [
            sraId: columns[0],
            genome: columns[1],
            referenceAnnotation: columns[2],
            isPaired: columns[3].toLowerCase().trim() == 'paired'
        ]
    }

// // Create the kallisto index
// def kallistoIndex = create_kallisto_index(samplesChannel)

// // Download the SRA samples
// def sraFiles = download_sra(samplesChannel)

// // Map reads using kallisto
// def abundances_ch = run_kallisto(sraFiles, samplesChannel)

// // Combine all abundance files
// combineAll(abundances_ch)

workflow {
    create_kallisto_index()
    download_sra()
    run_kallisto()
    combineAll()
}
