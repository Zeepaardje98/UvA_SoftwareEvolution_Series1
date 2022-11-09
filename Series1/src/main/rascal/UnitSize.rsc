module UnitSize

import Helper;

import IO;
import Set;
import List;

import lang::java::m3::Core;
import lang::java::m3::AST;

void unitSize() {
    loc fileLocation = |project://smallsql0.21_src|;
    list[Declaration] asts = getASTs(fileLocation);
    map[str rank, int nUnits] buckets = ();
    
    myMethods = toList(methods(createM3FromDirectory(fileLocation)));

    println(myMethods);

    for (method <- myMethods) {
        println(method);
    }
}

void findLOC(Declaration unit) {
    println(unit);
}

int unitLOC() {
    return 0;
}