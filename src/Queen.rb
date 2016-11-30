#
# @author  Thomas Lehmann
# @file    Queen.rb
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
#
class Queen
    def initialize(width)
        # width(=height) of the board
        @width   = width
        @lastRow = @width - 1
        # for the occupied/free columns
        @columns = Array.new(@width, -1)
        # for the occupied/free diagonals "/" and "\"
        numberOfDiagonals = 2 * @width - 1
        @diagonals1 = Array.new(numberOfDiagonals, false)
        @diagonals2 = Array.new(numberOfDiagonals, false)
        # no sulution yet
        @solutions = Array.new
    end

    # width(=height) of board
    def getWidth; @width; end
    # number of found solutions
    def getNumberOfSolutions; @solutions.length; end

    # the queen algorithm which tries to find all solutions
    def runAlgorithm(row)
        for column in 0..@width-1
            if @columns[column] >= 0 then
                next
            end

            ixDiag1 = row + column
            if @diagonals1[ixDiag1] then
                next
            end

            ixDiag2 = @lastRow - row + column
            if @diagonals2[ixDiag2] then
                next
            end

            @columns[column] = row
            @diagonals1[ixDiag1] = true
            @diagonals2[ixDiag2] = true

            if row == @lastRow then
                @solutions.push(@columns.dup)
            else
                runAlgorithm(row + 1)
            end

            @columns[column] = -1
            @diagonals1[ixDiag1] = false
            @diagonals2[ixDiag2] = false
        end
    end

    # printing all solutions
    def printSolutions
        @solutions.each do |solution|
            for column in 0..@width-1
                print("(#{column+1},#{solution[column]+1})")
            end
            puts("")
        end
    end
end

# application entry point
def main
    width = 8 # default

    if ARGV.length == 1 then
        width = Integer(ARGV[0])
    end

    instance = Queen.new(width)
    puts("Running Ruby " + RUBY_VERSION)
    puts("Queen raster (#{instance.getWidth}x#{instance.getWidth})")
    start = Time.now
    instance.runAlgorithm(0)
    puts("...#{instance.getNumberOfSolutions} solutions found.")
    puts("...calculation took #{Time.now - start} seconds")

    #instance.printSolutions()
end

main
