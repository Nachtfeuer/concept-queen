/'
   @author  Thomas Lehmann
   @file    Queen.bas

   Copyright (c) 2016 Thomas Lehmann

   Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
   documentation files (the "Software"), to deal in the Software without restriction, including without limitation
   the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
   and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in all copies
   or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
   INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
   DAMAGES OR OTHER LIABILITY,
   WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
'/
type solution
        m_columns as integer ptr
end type

type queen
    declare constructor(p_width as integer)
    declare function getNumberOfSolutions() as integer
    declare sub run(row as integer)
    declare sub printSolutions()

    private:
        m_width             as integer       ' is width and height of the chess board
        m_lastrow           as integer       ' is width-1 supporting zero based indices
        m_columns           as integer  ptr  ' occupied columns by which row (-1 means: free)
        m_diagonals1        as integer  ptr  ' occupied diagonals of form "\"
        m_diagonals2        as integer  ptr  ' occupied diagonals of form "/"
        m_numberOfSolutions as integer       ' number of found solution
        m_solutions         as solution ptr  ' dynamic array of solutions

        ' is for copying m_columns. The result will be "appended"
        ' to the array of found solutions.
        declare function copy(array as integer ptr) as integer ptr
end type

' initializes the algorithm depending on its input paramter "width"
constructor queen(byval p_width as integer)
    this.m_width             = p_width
    this.m_lastRow           = p_width - 1
    this.m_columns           = callocate(p_width, sizeof(integer))
    this.m_numberOfSolutions = 0

    dim numberOfDiagonals as integer = this.m_width * 2 - 1
    this.m_diagonals1 = callocate(numberOfDiagonals, sizeof(integer))
    this.m_diagonals2 = callocate(numberOfDiagonals, sizeof(integer))

    for index as integer = 0 to numberOfDiagonals-1
        if index < this.m_width then
            this.m_columns[index] = -1
        end if
        this.m_diagonals1[index] = 0
        this.m_diagonals2[index] = 0
    next
end constructor

' returns number of found solutions
function queen.getNumberOfSolutions() as integer
    return this.m_numberOfSolutions
end function

'  copying an array
function queen.copy(array as integer ptr) as integer ptr
    dim newArray as integer ptr = callocate(this.m_width, sizeof(integer))
    for index as integer = 0 to this.m_width-1
        newArray[index] = array[index]
    next
    return newArray
end function

' the queen algorithm (recursive)
sub queen.run(row as integer)
    for column as integer = 0 to this.m_width-1
        if this.m_columns[column] >= 0 then
            continue for
        end if

        dim ixDiag1 as integer = row + column
        if this.m_diagonals1[ixDiag1] = 1 then
            continue for
        end if

        dim ixDiag2 as integer = this.m_lastRow - row + column
        if this.m_diagonals2[ixDiag2] = 1 then
            continue for
        end if

        this.m_columns[column]     = row
        this.m_diagonals1[ixDiag1] = 1
        this.m_diagonals2[ixDiag2] = 1

        if row = this.m_lastRow then
            this.m_numberOfSolutions = this.m_numberOfSolutions + 1
            this.m_solutions = reallocate(this.m_solutions, this.m_numberOfSolutions * sizeof(solution))
            this.m_solutions[this.m_numberOfSolutions-1].m_columns = this.copy(this.m_columns)
        else
            this.run(row+1)
        end if

        this.m_columns[column]     = -1
        this.m_diagonals1[ixDiag1] = 0
        this.m_diagonals2[ixDiag2] = 0
    next
end sub

' printing all solutions
sub queen.printSolutions()
    for index as integer = 0 to this.m_numberOfSolutions-1
        dim row as string = ""
        for column as integer = 0 to this.m_width-1
            row = row & "(" & str(column+1) & "," & str(this.m_solutions[index].m_columns[column]+1) & ")"
        next
        print row
    next
end sub

'
' Application "main()" code:
'
dim queenWidth as integer = val(command$(1))
dim instance   as queen   = queen(queenWidth)
print "Queen raster (" & str(queenWidth) & "x" & str(queenWidth) & ")"
dim start as double = timer
instance.run(0)
print "...took " & str(timer - start) & " seconds."
print "..." & str(instance.getNumberOfSolutions()) & " solutions found."
' instance.printSolutions()
