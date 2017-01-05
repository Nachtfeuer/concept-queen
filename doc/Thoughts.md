## Thoughts

The locking mechanism is for the moment the fastest solution
in this project. However the code for finding just one solution
demonstrates that a big chessboard has too many false operation
until one solution has been found. Now the question arrives whether
it's possible to detect that a choosen path is wrong.

How to do that? Consider a 8 x 8 chessboard. When you place a queen
the number of available fields is reduced by a column and by a row:

```
8 x 8 = 64; 64 - (2 x 8 - 1) = 49
```` 

Since one column and one row share one chess field the reduce of
the overall fields is `2 x width - 1`. For the diagonals it's a bit more
difficult since a lot of diagonals do have different cells. As
example the diagonals in the corners has one cell and the diagonals
in the middle do have `width` cells. Also I have not investigated on
how to calculate that the question is now, how does this help?

Not sure yet but obviously it's a lot of efford to get into last
row and the reason is that there is constantly a diagonal locked
and we have to calculate the diagonal to see. For a 8 x 8
chessboard we are talking about column loops `8 x 7 x 6 x 5 x 4 x 3 x 2 x 1`
columns or short: `8! = 40320` and we know already there are just
92 solutions. We don't need to check the row and also not the column
since we never place a queen on an occupied field by this but we 
need to check the diagonals. Each placements affects chessboard fields
in further rows.

|     |     |     |     |
| --- | --- | --- | --- |
| Q1  | xxx | xxx | xxx |
| xxx | xxx | -   | -   |
| xxx | -   | xxx | -   |
| xxx | -   | -   | xxx |

Just one queen placed but on 4 x 4 chessboard field it occupies
10 fields (marked as `xxx`) which is more than 62%. Consider
next queen location like this one:

|     |     |     |     |
| --- | --- | --- | --- |
| Q1  | xxx | xxx | xxx |
| xxx | xxx | Q2  | yyy |
| xxx | yyy | xxx | yyy |
| xxx | -   | yyy | xxx |

The additional fields occupied are marked as `yyy`.
You see that 2 queen are placed and 2 queens are remaining and
just one field is free.

For a small chessboard size eventually not effective.
The Q2 is a valid position until now and a new algorithm recognizing
the remaining fields could be a way to stop placing Q2. That's the idea.

For each diagonal we have a boolean flag and now I consider to store the
number of affected fields - minus 1. We substract one since tow diagonals
share one chess field and we have to subtract that one once only.

We can caclulate that value storing it parallel to each diagonal aside 
with its flag. If no diagonal does lock then we subtract from currently
available fields the fields occpupied by those diagonals and finally 
we subtract 1 (as mentioned) and then we check that the remaining fields
allow to place the remaining queens.
