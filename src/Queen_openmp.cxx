/**
 * @author  Thomas Lehmann
 * @file    Queen_openmp.cxx
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
#include <stdint.h>
#include <stdlib.h>

#include <iostream>
#include <vector>
#include <list>
#include <chrono>
#include <memory>

static const uint8_t FREE = 0;
static const uint8_t OCCUPIED = 1;
static const bool    OUTPUT = false;

class Queen {
public:
    typedef int16_t                  IndexType;
    typedef std::vector<IndexType>   ColumnsType;
    typedef std::vector<uint8_t>     DiagonalsType;
    typedef std::list<ColumnsType>   SolutionsType;

    Queen(IndexType width)
        : m_width(width)
        , m_lastRow(width - 1)
        , m_columns()
        , m_diagonals1()
        , m_diagonals2()
        , m_solutions() {

        const IndexType numberOfDiaogonals = 2 * m_width - 1;

        for (IndexType index = 0; index < numberOfDiaogonals; ++index) {
            if (index < this->m_width) {
                m_columns.push_back(-1);
            }

            m_diagonals1.push_back(FREE);
            m_diagonals2.push_back(FREE);
        }
    }

    IndexType getWidth() const {
        return m_width;
    }
    /// number of found solutions
    uint32_t getNumberOfSolutions() const {
        return m_solutions.size();
    }
    /// list of found solutions
    const SolutionsType& getSolutions() const {
        return m_solutions;
    }

    void run(const IndexType column) {
        m_solutions.clear();
        this->m_columns[column] = 0;
        this->m_diagonals1[column] = OCCUPIED;
        this->m_diagonals2[this->m_lastRow + column] = OCCUPIED;
        this->calculate(1);
    }

    static void printSolutions(const SolutionsType& solutions) {
        SolutionsType::const_iterator it = solutions.begin();
        SolutionsType::const_iterator itEnd = solutions.end();
        for (; it != itEnd; ++it) {
            const ColumnsType& solution = *it;
            for (IndexType column = 0; column < solution.size(); ++column) {
                std::cout << "(" << (column + 1) << ","
                          << (solution[column] + 1) << ")";
            }
            std::cout << std::endl;
        }
    }

private:
    IndexType     m_width;       // is width(=height) of board
    IndexType     m_lastRow;     // is last row index
    ColumnsType   m_columns;     // occupied/free columns
    DiagonalsType m_diagonals1;  // occupied/free diagonals "\"
    DiagonalsType m_diagonals2;  // occupied/free diagonals "/"
    SolutionsType m_solutions;   // found solutions

    /**
        Implements the queen algorithm.

        @param row represents current row (initially starting by zero).
     */
    void calculate(const IndexType row) {
        for (IndexType column = 0; column < this->m_width; ++column) {
            // the column is occupied?
            if (this->m_columns[column] >= 0) {
                continue;
            }

            const IndexType ixDiag1 = row + column;
            if (this->m_diagonals1[ixDiag1] == OCCUPIED) {
                continue;
            }

            const IndexType ixDiag2 = this->m_lastRow - row + column;
            if (this->m_diagonals2[ixDiag2] == OCCUPIED) {
                continue;
            }

            // occupying one column and two diagonals
            this->m_columns[column] = row;
            this->m_diagonals1[ixDiag1] = OCCUPIED;
            this->m_diagonals2[ixDiag2] = OCCUPIED;

            // solution found?
            if (row == this->m_lastRow) {
                m_solutions.push_back(m_columns);
            } else {
                // solution found?
                this->calculate(row + 1);
            }

            // freeing one column and two diagonals
            this->m_columns[column] = -1;
            this->m_diagonals1[ixDiag1] = FREE;
            this->m_diagonals2[ixDiag2] = FREE;
        }
    }
};

int main(int argc, char* argv[]) {
    int width = 8; // default;

    if (2 == argc) {
        width = atoi(argv[1]);
    }

    std::cout << "Queen raster (" << width << "x"
                                  << width << ")" << std::endl;
    auto start = std::chrono::high_resolution_clock::now();

    std::vector<std::unique_ptr<Queen>> queens(width);
    #pragma omp parallel for
    for (int column = 0; column < width; ++column) {
        auto queen = new Queen(width);
        queen->run(column);
        queens[column].reset(queen);
    }
    // put all solutions together
    Queen::SolutionsType solutions;
    for (int column = 0; column < width; ++column) {
        for (const auto& solution: queens[column]->getSolutions()) {
            solutions.push_back(solution);
        }
    }

    std::cout << "...took "  << std::chrono::duration<double>(
              std::chrono::high_resolution_clock::now() - start).count()
              << " seconds." << std::endl;
    std::cout << "..." << solutions.size() << " solutions found." << std::endl;
    if (OUTPUT) {
        Queen::printSolutions(solutions);
    }
    return 0;
}
