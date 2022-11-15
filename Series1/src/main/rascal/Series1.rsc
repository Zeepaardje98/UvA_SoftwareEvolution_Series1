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
    println("--- Maintainability Metric Scores ---");
    println("Volume: <getRank(volume(projectLoc, false))>");
    // println("Unit size: <getRank(unitSize())>");
    println("Duplication: <getRank(duplication(projectLoc, false))>");
}