<?php
/**
 * @author  Thomas Lehmann
 * @file    Queen.php
 *
 * Copyright (c) 2016 Thomas Lehmann
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
define("FREE", 0);
define("OCCUPIED", 1);
define("OUTPUT", 0);

class Queen {
    private $width;
    private $lastRow;
    private $columns    = Array();
    private $diagonals1 = Array();
    private $diagonals2 = Array();
    private $solutions  = Array();

    public function __construct($width) {
        $this->width = $width;
        $this->lastRow = $this->width - 1;

        $numberOfDiagonals = 2 * $this->width - 1;
        for ($index = 0; $index < $numberOfDiagonals; ++$index) {
            if ($index < $this->width) {
                $this->columns[] = -1;
            }
            $this->diagonals1[] = FREE;
            $this->diagonals2[] = FREE;
        }
    }

    public function getWidth() {
        return $this->width;
    }

    public function getNumberOfSolutions() {
        return count($this->solutions);
    }

    public function printSolutions() {
        foreach (array_values($this->solutions) as $solution) {
            for ($column = 0; $column < $this->width; ++$column) {
                echo "(" . ($column + 1) . "," . ($solution[$column] + 1) . ")";
            }
            echo "\n";
        }
    }

    public function run() {
        $widthFirstRow = intval($this->width >> 1) + $this->width % 2;
        for ($column = 0; $column < $widthFirstRow; ++$column) {
            $ixDiag1 = $column;
            $ixDiag2 = $this->lastRow + $column;

            $this->columns[$column] = 0;
            $this->diagonals1[$ixDiag1] = OCCUPIED;
            $this->diagonals2[$ixDiag2] = OCCUPIED;

            $this->calculate(1);

            $this->columns[$column] = -1;
            $this->diagonals1[$ixDiag1] = FREE;
            $this->diagonals2[$ixDiag2] = FREE;
        }
    }

    private function calculate($row) {
        for ($column = 0; $column < $this->width; ++$column) {
            if ($this->columns[$column] >= 0) {
                continue;
            }

            $ixDiag1 = $row + $column;
            if ($this->diagonals1[$ixDiag1] == OCCUPIED) {
                continue;
            }

            $ixDiag2 = $this->lastRow - $row + $column;
            if ($this->diagonals2[$ixDiag2] == OCCUPIED) {
                continue;
            }

            $this->columns[$column] = $row;
            $this->diagonals1[$ixDiag1] = OCCUPIED;
            $this->diagonals2[$ixDiag2] = OCCUPIED;

            if ($row == $this->lastRow) {
                $solutionA = $this->columns;
                $this->solutions[implode(",", $solutionA)] = $solutionA;

                $solutionB = array_reverse($solutionA);
                $this->solutions[implode(",", $solutionB)] = $solutionB;

                $solutionC = array_map(function($n){return $this->lastRow - $n;}, $solutionA);
                $this->solutions[implode(",", $solutionC)] = $solutionC;

                $solutionD = array_map(function($n){return $this->lastRow - $n;}, $solutionB);
                $this->solutions[implode(",", $solutionD)] = $solutionD;
            } else {
                $this->calculate($row + 1);
            }

            $this->columns[$column] = -1;
            $this->diagonals1[$ixDiag1] = FREE;
            $this->diagonals2[$ixDiag2] = FREE;
        }
    }
}

function microtime_float()
{
    list($usec, $sec) = explode(" ", microtime());
    return ((float)$usec + (float)$sec);
}

function main() {
    global $argv;

    $width = 8; /* default */

    if (count($argv) == 2) {
        $width = intval($argv[1]);
    }

    ini_set('memory_limit', '-1');

    echo "Running with PHP Version " . PHP_VERSION . "\n";
    $instance = new Queen($width);
    echo "Queen raster (" . $instance->getWidth() . "x" . $instance->getWidth() . ")\n";
    $start = microtime_float();
    $instance->run();
    echo "...took " . (microtime_float() - $start) . " seconds.\n";
    echo "..." . $instance->getNumberOfSolutions() . " solutions found.\n";

    if (OUTPUT == 1) {
        $instance->printSolutions();
    }
}

main();

?>
