/**
 * @author  Thomas Lehmann
 * @file    Queen.dart
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
class Queen {
  /// width and height of the chessboard.
  int width;
  /// last index of row (avoids constantly doing a -1 operation)
  int lastRow;
  /// the index represents the column and the value at given index
  /// represents the row. When the value is >= 0 then the column at
  /// given index is locked.
  List<int> columns;
  /// the diagonals from top/left to bottom/right.
  /// a value >= 0 at given index indicates that this diagonal is locked.
  List<int> diaognals1;
  /// the diagonals from bottom/left to top/right.
  /// a value >= 0 at given index indicates that this diagonal is locked.
  List<int> diaognals2;
  /// copies of the columns list where each index has a value > 0 representing
  /// the locations of the queens.
  List<List<int>> solutions;

  /// initializing the queen algorithm for a given chessboard [width].
  Queen(int width) {
    this.width = width;
    this.lastRow = this.width - 1;
    this.columns = new List<int>.filled(this.width, -1, growable: false);
    this.diaognals1 =
        new List<int>.filled(this.width * 2 - 1, -1, growable: false);
    this.diaognals2 =
        new List<int>.filled(this.width * 2 - 1, -1, growable: false);
    this.solutions = new List<List<int>>();
  }

  /// recursive queen algorithm. Each depth handle one [row].
  void run(int row) {
    for (int column = 0; column < this.width; ++column) {
      if (this.columns[column] >= 0) {
        continue;
      }

      int ixDiag1 = row + column;
      if (this.diaognals1[ixDiag1] == 1) {
        continue;
      }

      int ixDiag2 = this.lastRow - row + column;
      if (this.diaognals2[ixDiag2] == 1) {
        continue;
      }

      this.columns[column] = row;
      this.diaognals1[ixDiag1] = 1;
      this.diaognals2[ixDiag2] = 1;

      if (row == this.lastRow) {
        this.solutions.add(new List<int>.from(this.columns));
      } else {
        this.run(row + 1);
      }

      this.columns[column] = -1;
      this.diaognals1[ixDiag1] = 0;
      this.diaognals2[ixDiag2] = 0;
    }
  }
}

/// application entry point.
void main(List<String> arguments) {
  var width = 8; // default chessbord width
  if (arguments.length == 1) {
    width = int.parse(arguments[0]);
  }
  var queen = new Queen(width);
  print("Queen raster (${queen.width}x${queen.width})");
  var watcher = new Stopwatch();
  watcher.start();
  queen.run(0);
  print("...took ${watcher.elapsedMilliseconds/1000.0} seconds.");
  print("...${queen.solutions.length} solutions found.");
}
