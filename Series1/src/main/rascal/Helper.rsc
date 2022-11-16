module Helper

import lang::java::m3::Core;
import lang::java::m3::AST;

import List;
import String;

public map [int rankNum, str rankStr] rankMap = (0 : "--",1 : "-",2 : "o",3 : "+",4 : "++");

// getASTs(|project://smallsql0.21_src|);
list[Declaration] getASTs(loc projectLocation) {
    M3 model = createM3FromMavenProject(projectLocation);
    list[Declaration] asts = [createAstFromFile(f, true)
        | f <- files(model.containment), isCompilationUnit(f)];
    return asts;
}

// Get the average score of collection of buckets with their values.
int scoreFromBuckets(map[int, int] buckets) {
    int total = 0;
    int score = 0;
    for (bucket <- buckets) {
        score += buckets[bucket] * bucket;
        total += buckets[bucket];
    }
    return score / total;
}

// Get the 'score' of a number n based on a list of thresholds, where the
// score gets lower for each threshold it doesn't pass. The maximum score
// is the size of the list of thresholds, and the lowest score is 0.
int scoreIndex(int n, list[int] thresholds) {
    int score = size(thresholds);
    for(threshold <- thresholds) {
        if (n <= threshold) {
            return score;
        }
        score -= 1;
    }
    return score;
}

str getRank(int score) {
    map [int rankNum, str rankStr] rank = (0 : "--",1 : "-",2 : "o",3 : "+",4 : "++");
    return rank[score];
}

// Check if a line is a blank line using RegEx
bool isBlankLine(str line) {
    if (/^[\s\t\n]*$/ := line) {
        return true;
    }
    return false;
}

// Check if a line is a comment using RegEx
bool isCommentLine(str line) {
    switch (trim(line)) {
        case /^[\s\t\n]*(\/\/).*$/ :   // trimmed line starts with 2+ slashes
            return true;
        case /^[\s\t\n]*(\*).*$/ :          // trimmed line starts with a * (not fully theoretically sound)
            return true;
        case /^[\s\t\n]*(^\/\*).*$/ :        // trimmed line starts with a /*
            return true;
        case /(\*\/$)/ :        // trimmed line ends with a */
            return true;
        default :
            return false;
    }
}