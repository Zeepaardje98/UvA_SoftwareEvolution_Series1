module UnitSize

import Helper;
import Volume;

import IO;
import Set;
import List;

import lang::java::m3::Core;
import lang::java::m3::AST;

str unitSizeAndCC(loc fileLocation=|project://smallsql0.21_src|) {
    map[int rank, num nUnits] bucketsVolume = ();
    map[int rank, num nUnits] bucketsCC = ();
    
    myMethods = toList(methods(createM3FromDirectory(fileLocation)));
    for (method <- myMethods) {
        // Divide the methods to 'buckets' depending on their Volume score: 
        // Moderate, high, and very high risk. Scores are based on:
        // https://arxiv.org/pdf/2205.01842.pdf
        int volumeScore = getVolumeData(method, false, thresholds=[24, 36, 63]);
        bucketsVolume[volumeScore]?0 += 1;
        
        println(method[1]);
        int CCScore = getCCData(method[1]);
        bucketsCC[CCScore]?0 += 1;
    }

    for (key <- bucketsVolume) {
        bucketsVolume[key] = (bucketsVolume[key] / size(myMethods)) * 100;
    }
    for (key <- bucketsCC) {
        bucketsCC[key] = (bucketsCC[key] / size(myMethods)) * 100;
    }

    println(bucketsCC);

    // Maximum LOC in risk groups: very high, high, moderate.
    rankTable = [[0,0,25],[0,5,30],[0,10,40],[5,15,50]];
    return rankFromBuckets(bucketsVolume, rankTable);
}

str rankFromBuckets(map[int, num] percentages, list[list[int]] rankTable) {
    int nRank = size(rankTable);
    for (rank <- rankTable) {
        bool rankIsValid = true;

        // Check if the the percentages fall within the current rank of the
        // rankTable.
        for (int n <- [0 .. (size(rank)-1)]) {
            percentages[n]?0;
            if (rank[n] > percentages[n]) {
                continue;
            }
            rankIsValid = false;
            break;
        }
        // If the current rank is the right one, return it.
        if (rankIsValid) {
            println(rank);
            return rankMap[nRank];
        }
        // Current rank is not applicable. Try 1 rank lower.
        nRank = nRank - 1;
    }
    return rankMap[nRank];
}

int getCCData(loc fileLocation, list[int] thresholds=[10,20,50]) {
    int complexity = 0;
    list[Declaration] methodAST = getASTs(fileLocation);
    visit(methodAST) {
        case \if(_, _) : complexity += 1;
    }
    return scoreIndex(complexity, thresholds);
}