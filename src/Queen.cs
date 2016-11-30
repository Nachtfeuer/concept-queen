/**
 * @author  Thomas Lehmann
 * @file    Queen.cs
 *
 * Copyright (c) 2016 Thomas Lehmann
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
using System;
using System.Collections.Generic;
using System.Diagnostics;

namespace Algorithm
{
    class Queen
    {
        private int             width;       // width(=height) of the boartd
        private int             lastRow;     // the last row index
        private List<int>       columns;     // occupied/free columns (when occupied: row)
        private List<bool>      diagonals1;  // occupied/free diagonals "\"
        private List<bool>      diagonals2;  // occupied/free diagonals "/"
        private List<List<int>> solutions;   // found solutions.

        /// <summary>
        /// Initializing data structure for calculation.
        /// </summary>
        /// <param name="width">width(=height) of board</param>
        public Queen(int width) {
            this.width      = width;
            this.lastRow    = this.width - 1;
            this.columns    = new List<int>();
            this.diagonals1 = new List<bool>();
            this.diagonals2 = new List<bool>();
            this.solutions  = new List<List<int>>();

            int numberOfDiagonals = 2 * this.width - 1;

            for (int index = 0; index < numberOfDiagonals; ++index) {
                if (index < this.width) {
                    this.columns.Add(-1);
                }
                this.diagonals1.Add(false);
                this.diagonals2.Add(false);
            }
        }

        /// <returns>width(=height) of board.</returns>
        public int GetWidth() {
            return this.width;
        }

        /// <returns>number of found solutions</returns>
        public int getNumberOfSolutions() {
            return this.solutions.Count;
        }

        /// <summary>
        /// Queen algorithm trying to find all solutions.
        /// </summary>
        /// <param name="row">current row to check</param>
        public void RunAlgorithm(int row) {
            for (int column = 0; column < this.width; ++column) {
                // is this column occupied?
                if (this.columns[column] >= 0) {
                    continue;
                }

                int ixDiag1 = row + column;
                if (this.diagonals1[ixDiag1]) {
                    continue;
                }

                int ixDiag2 = this.width - 1 - row + column;
                if (this.diagonals2[ixDiag2]) {
                    continue;
                }

                this.columns[column] = row;
                this.diagonals1[ixDiag1] = true;
                this.diagonals2[ixDiag2] = true;

                if (row == this.lastRow) {
                    this.solutions.Add(new List<int>(this.columns));
                } else {
                    this.RunAlgorithm(row + 1);
                }

                this.columns[column] = -1;
                this.diagonals1[ixDiag1] = false;
                this.diagonals2[ixDiag2] = false;
            }
        }

        /// <summary>
        /// Printing all solutions to the console.
        /// </summary>
        public void printSolutions() {
            foreach (List<int> solution in this.solutions) {
                for (int column = 0; column < this.width; ++column) {
                    Console.Write("(" + (column+1) + "," + (solution[column]+1) + ")");
                }
                Console.WriteLine("");
            }
        }

        /// <summary>
        /// Application entry point.
        /// </summary>
        /// <param name="args"></param>
        public static void Main(string[] arguments)
        {
            int width = 8; // default

            if (arguments.Length == 1) {
                width = Convert.ToInt32(arguments[0]);
            }

            Queen instance = new Queen(width);
            Console.WriteLine("Queen raster (" + instance.GetWidth() + "x"
                                               + instance.GetWidth() + ")");
            int start = Environment.TickCount;
            instance.RunAlgorithm(0);
            Console.WriteLine("..." + instance.getNumberOfSolutions() + " found.");
            Console.WriteLine("...calculation took " + ((Environment.TickCount - start) / 1000.0) + " seconds.");

            //instance.printSolutions();
        }
    }
}
