module UnitSize

import Helper;
import Volume;

import IO;
import Set;
import List;

import lang::java::m3::Core;
import lang::java::m3::AST;

int unitSize(loc fileLocation=|project://smallsql0.21_src|) {
    map[int rank, int nUnits] buckets = ();
    
    myMethods = toList(methods(createM3FromDirectory(fileLocation)));
    for (method <- myMethods) {
        int volumeScore = getVolumeData(method, false, [10, 20, 50, 60]);
        buckets[volumeScore]?0 += 1;
    }
    
    int score = scoreFromBuckets(buckets);
    return score;
}

