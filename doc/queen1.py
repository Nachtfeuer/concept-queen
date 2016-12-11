""" Module queen1."""
import sys
import time

def queen(width, row=1, solution=[], solutions=[]):
    for column in range(1, width+1):
        found = False
        for scolumn, srow in solution:
            if scolumn == column or srow == row:
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

def main():
    width = 8 # default
    if len(sys.argv) == 2: width = int(sys.argv[1])

    print("Queen raster (%dx%d)" % (width, width))
    solutions = []
    start = time.time()
    queen(width, 1, [], solutions)
    print("...took %f seconds." % (time.time() - start))
    print("...%d solutions found." % len(solutions))
    print("...one solution: %s" % (solutions[0]))
    # print all solutions:
    #for solution in solutions: print(solution)

if __name__ == "__main__":
    main()