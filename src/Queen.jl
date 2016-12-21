# @author  Thomas Lehmann
# @file    Queen.jl
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
type Queen
    width::Int64
    columns::Array{Int64, 1}
    diagonals1::Array{Bool, 1}
    diagonals2::Array{Bool, 1}
    solutions::Array{Any, 1}

    run::Function

    function Queen(width::Int64) 
        this = new(width, Int64[-1 for c = 1: width],
                   [false for d = 1: width*2], [false for d = 1: width*2], [])

        this.run = function(row::Int64)
            for column = 1: this.width
                if this.columns[column] >= 0
                    continue
                end

                ixDiag1 = row + column
                if this.diagonals1[ixDiag1]
                    continue
                end

                ixDiag2 = width - row + column
                if this.diagonals2[ixDiag2]
                    continue
                end

                this.columns[column] = row
                this.diagonals1[ixDiag1] = true
                this.diagonals2[ixDiag2] = true

                if (row == width)
                    append!(this.solutions, [copy(this.columns)])
                else
                    this.run(row + 1)
                end

                this.columns[column] = -1
                this.diagonals1[ixDiag1] = false
                this.diagonals2[ixDiag2] = false
            end
        end

        return this
    end
end

width  = 8
if length(ARGS) == 1
    width = parse(ARGS[1])
end

output = false
queen  = Queen(width)
println("Queen raster ($(queen.width)x$(queen.width))")
start  = now()
queen.run(1)
println("...took $(Int(now() - start)/1000.0) seconds.")
println("...", length(queen.solutions), " solutions found.")

if output
    for solution in queen.solutions
        line = ""
        for (index, value) in enumerate(solution)
            line = string(line," ($index, $value)")
        end
        println(line)
    end
end
