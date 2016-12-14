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
  int width;
  int lastRow;
  List<int> columns;
  List<int> diaognals1;
  List<int> diaognals2;
  List<List<int>> solutions;

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
