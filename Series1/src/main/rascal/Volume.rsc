module Volume

import Helper;

import IO;
import List;
import Set;

import util::FileSystem;
import lang::java::m3::Core;
import lang::java::m3::AST;


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
int volume(loc projectLoc, bool print, list[int] thresholds=[66000, 246000, 665000, 1310000], bool methods=false) {
    int totalLines = 0;
    int commentLines = 0;
    int blankLines = 0;

    list[loc] projectFiles;
    if (methods) {
        projectFiles = toList(files(projectLoc));
    } else {
        M3 model = createM3FromMavenProject(projectLoc);
        projectFiles = [ f | f <- files(model.containment), isCompilationUnit(f)];
    }

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
        println("Volume score: <rankMap[volumeRank]>");
    }

    return volumeRank;
}

void main() {
    projectLoc = |project://smallsql0.21_src|;
    volume(projectLoc, true);
}