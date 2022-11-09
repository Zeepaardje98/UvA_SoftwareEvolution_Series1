module Volume

import IO;
import List;
import util::FileSystem;

map [int rankNum, str rankStr] rank = (-2 : "--",-1 : "-",0 : "o",1 : "+",2 : "++");

// Get the total amount of lines in a single file
int getTotalLines(list[str] fileLines) {
    return size(fileLines);
}

// Get the amount of lines that only contain comments
int getCommentLines(list[str] fileLines) {
    int counter = 0;
    for(line <- fileLines) {
        // source: https://github.com/PhilippDarkow/rascal/blob/master/Assignment1/src/count/CountLines.rsc
        // TODO: try to make regex myself
        if(/((\s|\/*)(\/\*|\s\*)|[^\w,\;]\s\/*\/)/ := line) { // regex -> entire string is a comment
            counter += 1;
        }
    }
    return counter;
}

// Get the amount of blank lines
int getBlankLines(list[str] fileLines) {
    int counter = 0;
    for(line <- fileLines) {
        if(/^\s*$/ := line) { // regex -> entire string is whitespace
            counter += 1;
        }
    }
    return counter;
}

// Get the numeric rank value for the volume metric
int getVolumeRank(int codeLines, list[int] thresholds) {
    if(codeLines <= thresholds[0]) {
        return 2;
    }
    else if(codeLines <= thresholds[1]) {
        return 1;
    }
    else if(codeLines <= thresholds[2]) {
        return 0;
    }
    else if(codeLines <= thresholds[3]) {
        return -1;
    }
    else {
        return -2;
    }
}

// Returns the (numeric) volume rank of a project.
// If parameter print is set to true, also print the amount of
// total lines, comment lines, blank lines, code lines and the volume rank.
int getVolumeData(loc projectLoc, bool print, list[int] thresholds) {
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
    int volumeRank = getVolumeRank(codeLines, thresholds);

    if(print) {
        println("Total lines: <totalLines>");
        println("Comment lines: <commentLines>");
        println("Blank lines: <blankLines>");
        println("Code lines: <codeLines>");
        println("Volume rank: <rank[volumeRank]>");
    }

    return volumeRank;
}

void main() {
    fileLoc = |file:///home/michelle/Documents/master-se/software-evolution/smallsql0.21_src/smallsql0.21_src/src/smallsql/junit/AllTests.java|;
    projectLoc = |file:///home/michelle/Documents/master-se/software-evolution/smallsql0.21_src/smallsql0.21_src|;
    getVolumeData(projectLoc, true, [66000, 246000, 665000, 1310000]);
}