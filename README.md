# Galaxy PAT-seq Processing Guide (Hemp Analysis)

This guide provides the exact step by step protocol for processing raw PAT-seq data in Galaxy. Follow these instructions.

---

## Step 1: Upload Files
* **Purpose:** Load your raw data and reference files into a clean Galaxy history.
* **What to Input:** 
  1. Raw sequence FASTQ file (`.fastq` or `.fastq.gz`)
  2. Hemp reference genome (`.fa`)
  3. Hemp annotation file (`.gtf`)
  4. Tab-delimited barcode text file
* **Expected Output:** Four uploaded datasets loaded into your active history.

## Step 2: Trim Sequences (Remove Random Spacer)
* **Purpose:** Remove the random two-base spacer (NN) added at the start of each read during sequencing so the barcode splitter can function.
* **What to Input:** Raw sequence FASTQ file from Step 1.
* **Module Settings:** Set **First base of trimmed sequence** to 3. Leave the **Last base of trimmed sequence** field completely empty.
* **Expected Output:** A trimmed FASTQ file where reads start exactly at the barcode.

## Step 3: Barcode Splitter
* **Purpose:** Sort the pooled sequencing reads into individual sample files using your barcode key.
* **What to Input:** 
  1. Trimmed FASTQ file from Step 2
  2. Tab-delimited barcode text file from Step 1
* **Module Settings:** Configure the tool to look for barcodes at the exact beginning (5' end) of the reads.
* **Expected Output:** A collection of split FASTQ files, creating one distinct file for each barcode.

## Step 4: Trimmomatic (HEADCROP)
* **Purpose:** Discard the barcode sequences and the first few bases of the oligo-dT primer.
* **What to Input:** The collection of split FASTQ files from Step 3.
* **Module Settings:** Select the **HEADCROP** operation and enter a value of 8.
* **Expected Output:** Cleaned files with the barcodes and early oligo-dT bases successfully removed.

## Step 5: Reverse-Complement
* **Purpose:** Flip the sequence orientation. Reads are currently reversed relative to the original mRNA, and flipping is required to isolate the poly(A) tail.
* **What to Input:** The Trimmomatic output files from Step 4.
* **Module Settings:** Use the default tool settings to reverse and complement the sequences.
* **Expected Output:** A collection of reversed-complemented FASTQ files.

## Step 6: Trim Galore!
* **Purpose:** Strip away the poly(A) tail to isolate the true, high-quality mRNA sequence.
* **What to Input:** The reverse-complemented files from Step 5.
* **Module Settings:** Navigate to the parameter list and explicitly select **Remove polyA tails**.
* **Expected Output:** Clean mRNA sequence files optimized for genome mapping.

## Step 7: HiSat2 (Alignment)
* **Purpose:** Map your cleaned mRNA sequences to their exact locations in the hemp genome.
* **What to Input:** Cleaned FASTQ files from Step 6.
* **Module Settings:** 
  * Set *Source for the reference genome* to use a genome from your history. 
  * Select your uploaded Hemp reference genome (`.fa`) instead of the default Arabidopsis file. 
  * Set the data type parameter to **Single-end**.
* **Expected Output:** A collection of BAM mapping files.

## Step 8: featureCounts
* **Purpose:** Count how many sequence reads successfully map to each specific hemp gene.
* **What to Input:** 
  1. HiSat2 BAM files from Step 7
  2. Hemp GTF annotation file from Step 1
* **Module Settings:** Change the default selection in the *Feature type* field from **exon** to **gene**. The custom annotation files for this protocol only catalog genes.
* **Expected Output:** Finalized count tables displaying individual gene expression levels, ready for RStudio.

## Step 9: edgeR
* **Purpose:** Perform differential expression of count data
* **What to Input:** The featureCounts on Collection data
* **Module Settings:**
  * Fill in the names for Factor and Group names.
  *Under Group 1 and 2, when selecting the 'Count Files', Press the three dots and select the        features counts appropriately, only selecting the files labeled **Count** not summary
  *Under contrast, this is the name of the two groups seperated by a hyphen. e.g. **Control-Salt
**
