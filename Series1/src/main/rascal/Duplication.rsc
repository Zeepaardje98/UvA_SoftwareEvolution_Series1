module Duplication

import Helper;

import IO;
import List;
import Set;
import String;

import util::FileSystem;
import util::Math;
import lang::java::m3::Core;
import lang::java::m3::AST;


// Function to remove blank lines and comments and create a map of the new
// line numbers to the original line numbers.
tuple[list [str], map[int, int]] cleanUpFile(list [str] file) {
    map [int lineNrClean, int lineNrOriginal] lineNrMap = ();
    list [str] cleanFile = [];
    int m = 0;

    for (int n <- [0..size(file)]) {
        if (!isBlankLine(file[n]) && !isCommentLine(file[n])) {
            cleanFile += trim(split("//", file[n])[0]); // remove comment at end of line and trim whitespace
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
set[int] findDuplicates(list [str] file, int blockSize) {
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

// Parse the file, compute the duplicate blocks and calculate the duplication score
int duplication(loc projectLoc, bool print, list[int] thresholds = [3, 5, 10, 20]) {
    list[str] fileLines = [];
    M3 model = createM3FromMavenProject(projectLoc);
    list[loc] projectFiles = [ f | f <- files(model.containment), isCompilationUnit(f)];

    // Put all project file lines into one big file
    for(f <- projectFiles) {
        fileLines += readFileLines(f);
    }

    // Clean up the file lines (removing comments and blank lines)
    tuple[list[str], map[int, int]] cleanFileData = cleanUpFile(fileLines);
    list[str] cleanFileLines = cleanFileData[0];
    map[int, int] lineNrMap = cleanFileData[1];

    // Compute duplication score
    duplicateLines = {lineNrMap[d] + 1 | d <- findDuplicates(cleanFileLines, 6)}; // + 1 for user readability
    duplicationPercentage = toInt(toReal(size(duplicateLines)) / toReal(size(cleanFileLines)) * 100);
    duplicationScore = scoreIndex(duplicationPercentage, thresholds);

    if (print) {
        println("Amount of duplicate lines: <size(duplicateLines)>");
        println("Duplication percentage: <duplicationPercentage>%");
        println("Duplication score: <getRank(duplicationScore)>");
    }

    return duplicationScore;
}


void main() {
    projectLoc = |project://smallsql0.21_src|;
    duplication(projectLoc, true);
}