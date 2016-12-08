package algorithm

import java.util.ArrayList
import kotlin.system.measureTimeMillis

class Queen(val width: Int = 8) {
    val lastRow: Int = width - 1;
    var columns:    Array<Int> = Array<Int>(width, {i -> -1})
    var diagonals1: MutableList<Int> = ArrayList<Int>()
    var diagonals2: MutableList<Int> = ArrayList<Int>()
    var solutions:  MutableList<Array<Int>> = ArrayList<Array<Int>>()

    init {
        for (x in 0..(2*width-1)) {
            diagonals1.add(0);
            diagonals2.add(0);
        }
    }

    fun run(row: Int = 0) {
        for (column in 0..lastRow) {
            if (columns[column] >= 0) {
                continue;
            }

            val ixDiag1 = row + column
            if (diagonals1[ixDiag1] > 0) {
                continue;
            }

            val ixDiag2 = lastRow - row + column
            if (diagonals2[ixDiag2] > 0) {
                continue;
            }

            columns[column] = row;
            diagonals1[ixDiag1] = 1;
            diagonals2[ixDiag2] = 1;

            if (row == lastRow) {
                solutions.add(columns.clone());
            } else {
                run(row+1);
            }

            columns[column] = -1;
            diagonals1[ixDiag1] = 0;
            diagonals2[ixDiag2] = 0;
        }
    }
}

fun main(arguments: Array<String>) {
    var width: Int = 8;

    if (arguments.size == 1) {
        width = arguments[0].toInt();
    }

    var queen = Queen(width)
    println("Queen raster (${queen.width}x${queen.width})")
    val duration = measureTimeMillis {
        queen.run()
    }
    val solutions = queen.solutions.size;
    println("...tool ${duration/1000.0} seconds.")
    println("...${solutions} solutions found.")
}
