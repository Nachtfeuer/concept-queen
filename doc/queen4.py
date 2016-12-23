"""Module queen4."""
# pylint: disable=E0602
import sys
import time
import multiprocessing

from contextlib import closing


def queen(width, row=1, solution=[], solutions=[]):
    for column in range(1, width+1):
        found = False
        # validation:
        for scolumn, srow in solution:
            if scolumn == column:
                found = True
                break
            if abs(scolumn - column) == abs(srow-row):
                found = True
                break

        if found:
            continue

        if row == width:
            solutions.append(solution + [(column, row)])
        else:
            queen(width, row+1, solution + [(column, row)], solutions)

def worker(data):
    width, column = data
    solutions = []
    queen(width, 2, [(column, 1)], solutions)
    return solutions

def main():
    width = 8 # default
    if len(sys.argv) == 2:
        width = int(sys.argv[1])

    print("Queen raster (%dx%d)" % (width, width))
    start = time.time()

    solutions = []
    with closing(multiprocessing.Pool(multiprocessing.cpu_count())) as pool:
        for solution in pool.map(worker, [(width, column) for column in range(1, width+1)]):
            solutions.extend(solution)
        pool.terminate()

    print("...took %f seconds." % (time.time() - start))
    print("...%d solutions found." % len(solutions))
    print("...one solution: %s" % (solutions[0]))
    # print all solutions:
    #for solution in solutions: print(solution)

if __name__ == "__main__":
    multiprocessing.freeze_support()
    main()
