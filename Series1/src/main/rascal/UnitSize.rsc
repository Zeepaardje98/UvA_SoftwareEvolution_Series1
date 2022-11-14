module UnitSize

import Helper;
import Volume;

import IO;
import Set;
import List;

import lang::java::m3::Core;
import lang::java::m3::AST;

int unitSizeAndCC(loc fileLocation=|project://smallsql0.21_src|) {
    map[int rank, int nUnits] bucketsVolume = ();
    map[int rank, int nUnits] bucketsCC = ();
    
    myMethods = toList(methods(createM3FromDirectory(fileLocation)));
    for (method <- myMethods) {
        // Divide the methods to 'buckets' depending on their Volume score: 
        // Moderate, high, and very high risk. Scores are based on:
        // https://arxiv.org/pdf/2205.01842.pdf
        int volumeScore = getVolumeData(method, false, thresholds=[36, 63]);
        bucketsVolume[volumeScore]?0 += 1;

        int CCScore = getCCData(method);
        bucketsCC[CCScore]?0 += 1;
    }
    
    return rankFromBuckets(bucketsVolume, rankTable);
}

int rankFromBuckets(map[int, int] buckets, list[list[int]] rankTable) {
    for (rank <- rankTable) {
        continue;
    }
    return 0;
}

int getCCData(loc fileLocation) {
    int complexity = 0;
    Declaration methodAST = getASTs(fileLocation);
    visit(methodAST) {
        case \if(_, _) : complexity += 1;
    }
    return complexity;
}