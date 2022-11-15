module Duplication


import IO;
import List;
import util::FileSystem;


// Function to remove blank lines and comments and create a map of the new
// line numbers to the original line numbers.
// Source for comment line regex: https://github.com/PhilippDarkow/rascal/blob/master/Assignment1/src/count/CountLines.rsc
tuple[list [str], map[int, int]] cleanUpFile(list [str] file) {
    map [int lineNrClean, int lineNrOriginal] lineNrMap = ();
    list [str] cleanFile = [];
    int m = 0;

    for (int n <- [0..size(file)]) {
        if (/^\s*$/ !:= file[n] && /((\s|\/*)(\/\*|\s\*)|[^\w,\;]\s\/*\/)/ !:= file[n]) {
            cleanFile += file[n];
            lineNrMap[m] = n;
            m += 1;
        }
    }

    return <cleanFile, lineNrMap>;
}

// Function that hashes a file into a map with a code block as the key,
// and the corresponding line numbers as the values.
// If a hash key already exists, that means there is a duplicate block,
// and the line numbers will be added to a set of duplicate lines.
set[int] findDuplicates(list [str] file, blockSize) {
    map[list[str], list[int]] codeBlocks = ();
    set[int] duplicateLines = {};

    for (n <- [0..size(file) - blockSize + 1]) {
        // indicates a duplicate block
        if (file[n..n + blockSize] in codeBlocks) {
            codeBlocks[file[n..n + blockSize]] += [n..n + blockSize];
            duplicateLines += toSet(codeBlocks[file[n..n + blockSize]]);
        }
        else {
            codeBlocks[file[n..n + blockSize]] = [n..n + blockSize];
        }
    }

    return duplicateLines;
}

// Parse the file, compute the duplicate blocks and calculate the score
void duplication(loc fileLoc) {
    tuple[list[str], map[int, int]] cleanFile = cleanUpFile(readFileLines(fileLoc));
    file = cleanFile[0];
    lineNrMap = cleanFile[1];
    // + 1 because line numbers start at 1 not zero
    duplicateLines = {lineNrMap[d] + 1 | d <- findDuplicates(file, 3)};
    println(duplicateLines);
}


void main() {
    fileLoc = |file:///home/michelle/Documents/master-se/software-evolution/UvA_SoftwareEvolution_Series0/Series1/test2.txt|;
    duplication(fileLoc);
}