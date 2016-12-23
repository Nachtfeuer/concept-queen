/**
 * @author  Thomas Lehmann
 * @file    Queen_parallel.d
 *
 * Copyright (c) 2017 Thomas Lehmann
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 * documentation files (the "Software"), to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies
 * or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
import std.stdio;
import std.conv;
import core.time;
import std.parallelism : taskPool;

class Queen {
    private int     m_width;       // width(=height) of board
    private int     m_lastRow;     // last row index
    private int[]   m_columns;     // occupied/free columns
    private bool[]  m_diagonals1;  // occupied/free diagonals "\"
    private bool[]  m_diagonals2;  // occupied/free diagonals "/"
    private int[][] m_solutions;   // found solutions

    /// initializing data structure for running the algorithm
    this(int width) {
        m_width   = width;
        m_lastRow = m_width - 1;

        const int numberOfDiagonals = 2 * m_width - 1;

        m_columns.length    = m_width;
        m_diagonals1.length = numberOfDiagonals;
        m_diagonals2.length = numberOfDiagonals;

        for (int index = 0; index < numberOfDiagonals; ++index) {
            if (index < m_width){
                m_columns[index] = -1;
            }
            m_diagonals1[index] = false;
            m_diagonals2[index] = false;
        }
    }

    /// width(=height) of board
    int getWidth() const {
        return m_width;
    }

    /// number of found solutions
    ulong getNumberOfSolutions() const {
        return m_solutions.length;
    }

    /// get current solutions
    int[][] getSolutions() {
        return m_solutions;
    }

    void run(const int column) {
        m_columns[column] = 0;
        m_diagonals1[column] = true;
        m_diagonals2[m_lastRow+column] = true;
        runAlgorithm(1);
    }

    /// the queen algorithm
    void runAlgorithm(const int row) {
        for (int column = 0; column < m_width; ++column) {
            // is this column occupied?
            if (m_columns[column] >= 0) {
                continue;
            }

            const ixDiag1 = row + column;
            if (m_diagonals1[ixDiag1]) {
                continue;
            }

            const ixDiag2 = m_lastRow - row + column;
            if (m_diagonals2[ixDiag2]) {
                continue;
            }

            m_columns[column] = row;
            m_diagonals1[ixDiag1] = true;
            m_diagonals2[ixDiag2] = true;

            if (row == m_lastRow) {
                m_solutions.length += 1;
                m_solutions[m_solutions.length-1].length = m_columns.length;
                m_solutions[m_solutions.length-1][] = m_columns[];
            } else {
                runAlgorithm(row + 1);
            }

            m_columns[column] = -1;
            m_diagonals1[ixDiag1] = false;
            m_diagonals2[ixDiag2] = false;
        }
    }

    /// printing of all solutions to console
    void printSolutions() const {
        foreach (const int[] solution; m_solutions) {
            for (int column = 0; column < m_width; ++column) {
                printf("(%d,%d)", column+1, solution[column]+1);
            }
            printf("\n");
        }
    }
}

/// application entry point
void main(string[] arguments) {
    int width = 8; // default

    if (arguments.length == 2) {
        width = to!int(arguments[1]);
    }

    printf("Queen raster (%dx%d)\n", width, width);
    const TickDuration start = TickDuration.currSystemTick();

    auto queens = new Queen[width];
    foreach (column, ref queen; taskPool.parallel(queens)) {
        queen = new Queen(width);
        queen.run(to!int(column));
    }

    int[][] solutions;
    foreach(Queen queen; queens) {
        ulong offset = solutions.length;
        solutions.length += queen.getNumberOfSolutions();
        foreach (int[] solution; queen.getSolutions()) {
            solutions[offset] = solution;
            ++offset;
        }
    }

    const TickDuration end = TickDuration.currSystemTick();
    printf("...took %f seconds.\n", (end - start).msecs / 1000.0);
    printf("...%d solutions found.\n", solutions.length);
    //instance.printSolutions();
}
