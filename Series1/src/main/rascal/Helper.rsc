module Helper

import lang::java::m3::Core;
import lang::java::m3::AST;

import List;


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