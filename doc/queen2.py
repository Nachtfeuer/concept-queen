"""Module queen2."""
# pylint: disable=E0602
import sys
import time

def queen(width, solutions=[]):
    def run(row=1, solution=[], columns=[]):
        for column in columns:
            found = False
            # validation:
            for scolumn, srow in solution:
                if abs(scolumn - column) == abs(srow-row):
                    found = True
                    break

            if found:
                continue

            if row == width:
                solutions.append(solution + [(column, row)])
            else:
                run(row+1, solution + [(column, row)],
                    [x for x in columns if not x == column])
    run(row=1, solution=[], columns=range(1, width+1))

def main():
    width = 8 # default
    if len(sys.argv) == 2:
        width = int(sys.argv[1])

    print("Queen raster (%dx%d)" % (width, width))
    solutions = []
    start = time.time()
    queen(width, solutions)
    print("...took %f seconds." % (time.time() - start))
    print("...%d solutions found." % len(solutions))
    print("...one solution: %s" % (solutions[0]))
    # print all solutions:
    #for solution in solutions: print(solution)

if __name__ == "__main__":
    main()
