"""Module queen2."""
# pylint: disable=E0602
import sys
import time

def queen(width, solutions=[]):
    lastRow = width - 1
    columns = [-1] * width
    diagonals1 = [0] * (width * 2 - 1)
    diagonals2 = [0] * (width * 2 - 1)
    def run(row, available_columns=[]):
        for column in available_columns:
            ixDiag1 = row + column
            if diagonals1[ixDiag1] == 1:
                continue

            ixDiag2 = lastRow - row + column
            if diagonals2[ixDiag2] == 1:
                continue

            columns[column] = row
            diagonals1[ixDiag1] = 1
            diagonals2[ixDiag2] = 1

            if row == lastRow:
                solutions.append(columns[:])
            else:
                run(row+1, [x for x in available_columns if not x == column])

            columns[column] = -1
            diagonals1[ixDiag1] = 0
            diagonals2[ixDiag2] = 0

    run(row=0, available_columns=range(width))

def solutionToString(solution):
    return ",".join(["(%s, %d)" % (i+1, v+1)
                 for i, v in enumerate(solution)])

def main():
    output = False
    width = 8 # default
    if len(sys.argv) == 2:
        width = int(sys.argv[1])

    print("Queen raster (%dx%d)" % (width, width))
    solutions = []
    start = time.time()
    queen(width, solutions)
    print("...took %f seconds." % (time.time() - start))
    print("...%d solutions found." % len(solutions))
    print("...one solution: %s" % (solutionToString(solutions[0])))
    if output:
        # print all solutions
        for solution in solutions:
            print(solutionToString(solution))

if __name__ == "__main__":
    main()
