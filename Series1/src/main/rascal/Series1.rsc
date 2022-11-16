module Series1

import Helper;
import UnitSizeCC;
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
    int volume = volume(projectLoc, true);
    println("\n-------------------");
    println("--- Duplication ---");
    println("-------------------");
    int duplication = duplication(projectLoc, true);
    tuple[int, int] UnitSizeCC = unitSizeAndCC(fileLocation=projectLoc);
    int unitSize = UnitSizeCC[0];
    int unitCC = UnitSizeCC[1];
    println("\n-----------------");
    println("--- Unit Size ---");
    println("-----------------");
    println("UnitSize Score: <rankMap[unitSize]>");
    println("\n---------------");
    println("--- Unit CC ---");
    println("---------------");
    println("Unit Cyclomatic Complexity Score: <rankMap[unitCC]> \n");

    int analysability = (volume + duplication + unitSize) / 3;
    println("Analysability: <rankMap[analysability]>");

    int changeability = (unitCC + duplication) / 2;
    println("Changeability: <rankMap[changeability]>");
    
    int testability = (unitCC + unitSize) / 2;
    println("Testability: <rankMap[testability]>");

    int maintainability = ((volume + duplication + unitSize) + (unitCC + duplication) + (unitCC + unitSize)) / 7;
    println("Maintainability: <rankMap[maintainability]>");
}