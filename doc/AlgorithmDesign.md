# Welcome to the queen algorithm design

[**A simple recursive function approach**](#a-simple-recursice-function-approach)  
[**Improved functional approch**](#improved-functional-approach)  

## A simple recursive function approach

The complete code you find in [queen1.py](queen1.py). The output
looks like this:

```
Queen raster (11x11)
...took 1.708056 seconds.
...2680 solutions found.
...one solution: [(1, 1), (3, 2), (5, 3), (7, 4), (9, 5), (11, 6), (2, 7), (4, 8), (6, 9), (8, 10), (10, 11)]
```

Also it does work fine there are some disadvantages with this approach:

* With a growing number of found valid queen locations the validation takes longer.
* The whole current solution is copied for each function call
* Each function call require all information passed; looking at the objectoriented approach `row` is the only parameter you need.
* On each recursion level we have a loop for all columns also the number of available columns decrease.

```python
def queen(width, row=1, solution=[], solutions=[]):
    for column in range(1, width+1):
        found = False
        # validation:
        for scolumn, srow in solution:
            if scolumn == column:
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
```

## Improved functional approach

The complete code you find in [queen2.py](queen2.py). The output
looks like this:

```
Queen raster (11x11)
...took 0.693340 seconds.
...2680 solutions found.
...one solution: [(1, 1), (3, 2), (5, 3), (7, 4), (9, 5), (11, 6), (2, 7), (4, 8), (6, 9), (8, 10), (10, 11)]
```

As you can see the algorithm is at least two times faster. Following changes:

* Using the closure principle we can keep the two variables `width` and `solutions` global and so we don't need to pass them each function call.
* We now pass the list of available columns which reduce each recursion so we don't have to check for an occupied columns anymore.

```python
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
```