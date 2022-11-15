module Volume

import Helper;

import IO;
import List;

import util::FileSystem;


// Get the total amount of lines in a single file
int getTotalLines(list[str] fileLines) {
    return size(fileLines);
}

// Get the amount of lines that only contain comments
int getCommentLines(list[str] fileLines) {
    int counter = 0;
    for(line <- fileLines) {
        if (isCommentLine(line)) {
            counter += 1;
        }
    }
    return counter;
}

// Get the amount of blank lines
int getBlankLines(list[str] fileLines) {
    int counter = 0;
    for(line <- fileLines) {
        if (isBlankLine(line)) {
            counter += 1;
        }
    }
    return counter;
}

// Returns the (numeric) volume rank of a project.
// If parameter print is set to true, also print the amount of
// total lines, comment lines, blank lines, code lines and the volume rank.
int volume(loc projectLoc, bool print, list[int] thresholds=[66000, 246000, 665000, 1310000]) {
    int totalLines = 0;
    int commentLines = 0;
    int blankLines = 0;

    set[loc] projectFiles = files(projectLoc);

    for(f <- projectFiles) {
        list[str] fileLines = readFileLines(f);
        totalLines += getTotalLines(fileLines);
        commentLines += getCommentLines(fileLines);
        blankLines += getBlankLines(fileLines);
    }

    int codeLines = totalLines - commentLines - blankLines;
    int volumeRank = scoreIndex(codeLines, thresholds);

    if(print) {
        println("Total lines: <totalLines>");
        println("Comment lines: <commentLines>");
        println("Blank lines: <blankLines>");
        println("Code lines: <codeLines>");
        println("Volume score: <getRank(volumeRank)>");
    }

    return volumeRank;
}

void main() {
    fileLoc = |file:///home/michelle/Documents/master-se/software-evolution/smallsql0.21_src/smallsql0.21_src/src/smallsql/junit/AllTests.java|;
    projectLoc = |file:///home/michelle/Documents/master-se/software-evolution/smallsql0.21_src/smallsql0.21_src|;
    volume(projectLoc, true);
}