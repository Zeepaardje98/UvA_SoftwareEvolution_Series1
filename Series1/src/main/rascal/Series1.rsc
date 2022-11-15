module Series1

import Helper;
import UnitSize;
import Volume;
import Duplication;

import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;

void main() {
    projectLoc = |project://smallsql0.21_src|;

    println("-------------------------------------");
    println("--- Maintainability Metric Scores ---");
    println("-------------------------------------\n");
    println("--------------");
    println("--- Volume ---");
    println("--------------");
    volume(projectLoc, true);
    println("\n-------------------");
    println("--- Duplication ---");
    println("-------------------");
    // println("Unit size: <getRank(unitSize())>");
    duplication(projectLoc, true);
}