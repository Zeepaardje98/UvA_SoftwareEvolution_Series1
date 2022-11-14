module Helper

import lang::java::m3::Core;
import lang::java::m3::AST;


// getASTs(|project://smallsql0.21_src|);
list[Declaration] getASTs(loc projectLocation) {
    M3 model = createM3FromMavenProject(projectLocation);
    list[Declaration] asts = [createAstFromFile(f, true)
        | f <- files(model.containment), isCompilationUnit(f)];
    return asts;
}

int scoreFromBuckets(map[int, int] buckets) {
    int total = 0;
    int score = 0;
    for (bucket <- buckets) {
        score += buckets[bucket] * bucket;
        total += buckets[bucket];
    }
    return score / total;
}