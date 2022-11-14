module Series1

import UnitSize;
import Volume;

import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;

map [int rankNum, str rankStr] rank = (-2 : "--",-1 : "-",0 : "o",1 : "+",2 : "++");

void main() {
    projectLoc = |project://smallsql0.21_src|;
    println("--- Maintainability Metric Scores ---");
    println("Volume: <rank[volume(projectLoc, false, [66000, 246000, 665000, 1310000])]>");
    println("Unit size: <rank[unitSize()]>");
}