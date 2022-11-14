module UnitSize

import Helper;
import Volume;

import IO;
import Set;
import List;

import lang::java::m3::Core;
import lang::java::m3::AST;

int unitSize(loc fileLocation=|project://smallsql0.21_src|) {
    map[int rank, int nUnits] bucketsSize = ();
    map[int rank, int nUnits] bucketsComplexity = ();
    
    myMethods = toList(methods(createM3FromDirectory(fileLocation)));
    for (method <- myMethods) {
        // TODO: Find correct thresholds for the classification of unit/method scores
        int volumeScore = getVolumeData(method, false, thresholds=[20, 40, 80]);
        bucketsSize[volumeScore]?0 += 1;
    }
    
    int score = scoreFromBuckets(bucketsSize);
    return score;
}

