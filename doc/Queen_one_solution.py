"""
# @author  Thomas Lehmann
# @file    Queen_one_solution.py
#
# Copyright (c) 2016 Thomas Lehmann
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies
# or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"""
# pylint: disable=E0602,C0325
import sys
import time
import json
import multiprocessing
from contextlib import closing

OUTPUT = False    # enable/disable of printing the solutions


class Queen(object):
    """Queen algorithm."""

    def __init__(self, width):
        self.width = width
        self.last_row = self.width-1
        # locked columns
        self.columns = self.width * [-1]
        # locked diagonals
        number_of_diagonals = 2 * self.width - 1
        self.diagonals1 = number_of_diagonals * [False]
        self.diagonals2 = number_of_diagonals * [False]
        # the one solution
        self.solution = []

    def run(self):
        """
        Starts the search with initial parameters and organizing
        to search the half only
        """
        for column in range(self.width // 2 + self.width % 2):
            ix_diag1 = column
            ix_diag2 = self.last_row + column
            # occupying column and diagonals depending on current row and column
            self.columns[column] = 0
            self.diagonals1[ix_diag1] = True
            self.diagonals2[ix_diag2] = True

            self.calculate(1, [k for k in range(self.width) if not k == column])

            # Freeing column and diagonals depending on current row and column
            self.diagonals1[ix_diag1] = False
            self.diagonals2[ix_diag2] = False

    def calculate(self, row, column_range):
        """searches for all possible solutions."""
        for column in column_range:
            # relating diagonale '\' depending on current row and column
            ix_diag1 = row + column

            if self.diagonals1[ix_diag1]:
                continue

            # relating diagonale '/' depending on current row and column
            ix_diag2 = self.last_row - row + column

            # is one of the relating diagonals OCCUPIED by a queen?
            if self.diagonals2[ix_diag2]:
                continue

            # occupying column and diagonals depending on current row and column
            self.columns[column] = row
            self.diagonals1[ix_diag1] = True
            self.diagonals2[ix_diag2] = True

            # all queens have been placed?
            if row == self.last_row:
                self.solution = [(k+1, v+1) for k, v in enumerate(self.columns)]
                return True
            else:
                # trying to place next queen...
                if self.calculate(row + 1, [k for k in column_range if k != column]):
                    return True

            # Freeing column and diagonals depending on current row and column
            self.diagonals1[ix_diag1] = False
            self.diagonals2[ix_diag2] = False
        return False


def worker(data):
    """Thread function."""
    width = data
    queen = Queen(width)
    start = time.time()
    queen.run()

    return {"duration": time.time() - start,
            "width": width,
            "solution": queen.solution}


def main():
    """Application entry point."""
    max_width = 8  # default
    if len(sys.argv) == 2:
        max_width = int(sys.argv[1])

    print("Running %s with %s - version %s" % \
          (sys.argv[0], sys.executable, sys.version))

    solutions = []
    with closing(multiprocessing.Pool(multiprocessing.cpu_count())) as pool:
        for solution in pool.map(worker, range(8, max_width+1)):
            solutions.append(solution)
        pool.terminate()

    print("board size | duration | one solution")
    print("-" * 120)
    for solution in solutions:
        if solution["width"] > 20:
            print(" %(width)2d x %(width)2d   | %(duration)8.5f | ...(too long)" % solution)
        else:
            print(" %(width)2d x %(width)2d   | %(duration)8.5f | %(solution)s" % solution)

    with open("one_solution.json", "w") as handle:
        handle.write(json.dumps(solutions, indent=2))

if __name__ == '__main__':
    main()
