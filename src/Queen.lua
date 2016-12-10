--
-- @author  Thomas Lehmann
-- @file    Queen.lua
--
-- Copyright (c) 2016 Thomas Lehmann
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
-- documentation files (the "Software"), to deal in the Software without restriction, including without limitation
-- the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
-- and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all copies
-- or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
-- IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
-- DAMAGES OR OTHER LIABILITY,
-- WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--
Queen = {
    width      = 8,
    lastRow    = 7,
    columns    = {},
    diagonals1 = {},
    diagonals2 = {},
    solutions  = {}
}

function Queen:new(parameter)
    self.width   = parameter.width
    self.lastRow = self.width-1
    for column = 0, self.lastRow do
        self.columns[column] = -1;
    end
    for diagonal = 0, (self.width*2-1)-1 do
        self.diagonals1[diagonal] = 0;
        self.diagonals2[diagonal] = 0;
    end
    return self
end

function Queen:printAll()
    for i, solution in pairs(self.solutions) do
        line = ""
        for j, v in pairs(solution) do
            line = line .. "(" .. j+1 .. "," .. v+1 .. ")"
        end
        print(line)
    end
end

function Queen:run(row)
    for column = 0, self.lastRow do
        if self.columns[column] < 0 then
            local ixDiag1 = row + column
            if 0 == self.diagonals1[ixDiag1] then
                local ixDiag2 = self.lastRow - row + column
                if 0 == self.diagonals2[ixDiag2] then
                    self.columns[column]     = row
                    self.diagonals1[ixDiag1] = 1
                    self.diagonals2[ixDiag2] = 1

                    if row == self.lastRow then
                        copied_colums = {}
                        for i, v in pairs(self.columns) do
                            copied_colums[i] = v
                        end
                        self.solutions[#self.solutions+1] = copied_colums
                    else
                        self:run(row + 1)
                    end

                    self.columns[column]     = -1
                    self.diagonals1[ixDiag1] = 0
                    self.diagonals2[ixDiag2] = 0
                end
            end
        end
    end
end

local width = 8
if #arg == 1 then
    width = tonumber(arg[1])
end

local queen = Queen:new{width = width}
print("Queen raster (" .. queen.width .. "x" .. queen.width .. ")")
local start = os.clock()
queen:run(0)
print("...took " .. os.clock() - start .. " seconds.")
print("..." .. #queen.solutions .. " solutions found.")
-- queen:printAll()
