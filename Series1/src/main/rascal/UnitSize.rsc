module UnitSize

import Helper;
import Volume;

import IO;
import Set;
import List;

import lang::java::m3::Core;
import lang::java::m3::AST;

void unitSize() {
    loc fileLocation = |project://smallsql0.21_src|;
    list[Declaration] asts = getASTs(fileLocation);
    map[int rank, int nUnits] buckets = ();
    
    myMethods = toList(methods(createM3FromDirectory(fileLocation)));

    // println(myMethods);

    for (method <- myMethods) {
        int ranking = getVolumeData(method, false, [10, 20, 50, 60]);
    }
}
