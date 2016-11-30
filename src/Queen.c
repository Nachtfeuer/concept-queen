/**
 * @author  Thomas Lehmann
 * @file    Queen.c
 *
 * Copyright (c) 2013 Thomas Lehmann
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
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <time.h>

static const int8_t   FREE     = 0; /* indicates that a diagonal position is free */
static const int8_t   OCCUPIED = 1; /* indicates that a diagonal position is occupied */
static const int      OUTPUT   = 0; /* when 1 the solutions are shown */

/**
    Represent one solution and the possibility to build
    a list of solutions.
 */
struct Solution {
    int32_t*         columns;     /* occupied colums by given row but with no conflicts */
    struct Solution* next;        /* next solution */
};

/**
    Contains all relevant data for running the queen algorithm.
 */
struct Queen {
    uint32_t         width;             /* width=height of the board */
    uint32_t         lastRow;           /* last row (index) */
    int32_t*         columns;           /* occupied colums by given row */
    int8_t*          diagonals1;        /* occupied diagonals from top left to bottom right */
    int8_t*          diagonals2;        /* occupied diagonals from bottoom left to top right */
    uint32_t         numberOfSolutions; /* number of found valid queen combinations */
    struct Solution* solutionsHead;     /* first element in list of solutions */
    struct Solution* solutionsTail;     /* last element in list of solutions */
};

/**
    @param   width is width (=height) of the board being a square.
    @return  new instance with initialized fields required for calculation.
 */
struct Queen* createInstance(const uint32_t width) {
    struct Queen* instance = malloc(sizeof(struct Queen));
    instance->width   = width;
    instance->lastRow = instance->width - 1;
    instance->columns = (int32_t*)malloc(sizeof(int32_t) * instance->width);

    const uint32_t numberOfDiagonals = 2 * instance->width - 1;

    instance->diagonals1 = (int8_t*)malloc(sizeof(int8_t) * numberOfDiagonals);
    instance->diagonals2 = (int8_t*)malloc(sizeof(int8_t) * numberOfDiagonals);

    for (size_t index = 0; index < numberOfDiagonals; ++index) {
        if (index < instance->width) {
            instance->columns[index] = -1;
        }
        instance->diagonals1[index] = FREE;
        instance->diagonals2[index] = FREE;
    }

    // no solutions yet
    instance->solutionsHead = 0;
    instance->solutionsTail = 0;
    return instance;
}

void runAlgorithm(struct Queen* instance, const uint32_t row) {
    for (uint32_t column = 0; column < instance->width; column += 1) {
        /* is column occupied? */
        if (instance->columns[column] >= 0) {
            continue;
        }

        /* relating diagonale '\' depending on current row and column */
        const uint32_t ixDiag1 = row + column;
        if (instance->diagonals1[ixDiag1] == OCCUPIED) {
            continue;
        }

        /* relating diagonale '/' depending on current row and column */
        const uint32_t ixDiag2 = instance->width - 1 - row + column;
        if (instance->diagonals2[ixDiag2] == OCCUPIED) {
            continue;
        }

        instance->columns[column] = row;
        instance->diagonals1[ixDiag1] = OCCUPIED;
        instance->diagonals2[ixDiag2] = OCCUPIED;

        // solution has been found?
        if (row == instance->lastRow) {
            struct Solution* solution = (struct Solution*)malloc(sizeof(struct Solution));

            solution->columns = (int32_t*)malloc(sizeof(int32_t)*instance->width);
            solution->next    = 0;

            memcpy(solution->columns, instance->columns, sizeof(int32_t) * instance->width);
            if (0 == instance->solutionsHead) {
                instance->solutionsHead = solution;
                instance->solutionsTail = solution;
            } else {
                instance->solutionsTail->next = solution;
                instance->solutionsTail = solution;
            }

            instance->numberOfSolutions += 1;
        } else {
            // walking next row...
            runAlgorithm(instance, row + 1);
        }

        instance->columns[column] = -1;
        instance->diagonals1[ixDiag1] = FREE;
        instance->diagonals2[ixDiag2] = FREE;
    }
}

/**
    Printing all solutions as x/y pairs as coordinates for the board.
    @param instance contains the solutions (when there are)
 */
void printSolutions(const struct Queen* instance) {
    struct Solution* solution = instance->solutionsHead;
    while (0 != solution) {
        for (size_t column = 0; column < instance->width; column += 1) {
            printf("(%d/%d)", column+1, solution->columns[column]+1);
        }
        printf("\n");
        solution = solution->next;
    }
}

/**
    Should do the cleanup.

    @param instance the allocated data for the queen algorithm
 */
void destroyInstance(struct Queen* instance) {
    free(instance->columns);
    free(instance->diagonals1);
    free(instance->diagonals2);

    struct Solution* solution = instance->solutionsHead;
    while (0 != solution) {
        struct Solution* nextSolution = solution->next;
        free(solution->columns);
        free(solution);
        solution = nextSolution;
    }

    free(instance);
}

/**
    Entry point for running the queen algorithm.

    @param argc number of arguments
    @param argv list of arguments (1st is program, 2nd should be width of the board)
    @param program exit code
 */
int main(int argc, char** argv) {
    int width = 8; /* default */

    if (2 == argc) {
        width = atoi(argv[1]);
    }

    struct Queen* instance = createInstance(width);
    printf("Queen raster (%dx%d)\n", instance->width, instance->width);
    clock_t start = clock();
    runAlgorithm(instance, 0);
    printf("...%d solutions found!\n", instance->numberOfSolutions);
    printf("...calculation took %f seconds\n", (clock() - start) / (float)CLOCKS_PER_SEC);

    if (1 == OUTPUT) {
        printSolutions(instance);
    }

    destroyInstance(instance);
    return 0;
}


