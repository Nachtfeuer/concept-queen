class GenericListNode<T> {
    public value: T;
    public next: GenericListNode<T>;

    constructor(value: T) {
        this.value = value;
        this.next = null;
    }
}

class GenericList<T> {
    private _head: GenericListNode<T>;
    private _tail: GenericListNode<T>;
    private _size: number;

    constructor() {
        this._head = null;
        this._tail = null;
        this._size = 0;
    }

    public push(value: T): void {
        if (this._head === null) {
            this._head = new GenericListNode(value);
            this._tail = this._head;
        } else {
            this._tail.next = new GenericListNode(value);
            this._tail = this._tail.next;
        }
        ++this._size;
    }

    public size(): number {
        return this._size;
    }
}

class Queen {
    // width and height of chessboard
    private width: number;
    // avoiding -1 operation each time
    private lastRow: number;
    // represents chessfield (index=colum, value=row)
    private columns: Array<Number>;
    // represents all diagonals from top/left to bottom/right
    private diagonals1: Array<Number>;
    // represents all diagonals from bottom/left to top/right
    private diagonals2: Array<Number>;
    public solutions: GenericList<Array<Number>>;

    // creates a "n x n" chessboard (n=width)
    constructor(width: number) {
        this.width = width;
        this.lastRow = width - 1;
        this.columns = new Array<Number>(width);
        this.columns.fill(-1);
        this.diagonals1 = new Array<Number>(2*width-1);
        this.diagonals1.fill(0);
        this.diagonals2 = new Array<Number>(2*width-1);
        this.diagonals2.fill(0);
        this.solutions = new GenericList<Array<Number>>();
    }

    public run(row: number = 0): void {
        for (let column = 0; column < this.width; ++column) {
            if (this.columns[column] >= 0) {
                continue;
            }
            let ixDiag1 = row + column;
            if (this.diagonals1[ixDiag1] > 0) {
                continue;
            }
            let ixDiag2 = this.lastRow - row + column;
            if (this.diagonals2[ixDiag2] > 0) {
                continue;
            }

            this.columns[column] = row;
            this.diagonals1[ixDiag1] = 1;
            this.diagonals2[ixDiag2] = 1;

            if (row == this.lastRow) {
                this.solutions.push(this.columns.slice());
            } else {
                this.run(row + 1);
            }

            this.columns[column] = -1;
            this.diagonals1[ixDiag1] = 0;
            this.diagonals2[ixDiag2] = 0;
        }
    }
}
// default chessboard size
let width: number = 8;

if (process.argv.length == 3) {
    width = parseInt(process.argv[2]);
}

// creating instance of queen algorithm
let queen: Queen = new Queen(width);
console.log(`Queen raster (${width}x${width})`);
let start = new Date().getTime();
queen.run();
console.log("...took " + (new Date().getTime() - start)/1000.0 + " seconds.");
console.log(`....${queen.solutions.size()} solutions found.`)

let output: boolean = false;

if (output) {
    let current: GenericListNode<Array<Number>> = queen.solutions._head;
    while (current !== null) {
        let line = "";
        for (let i = 0; i < current.value.length; ++i) {
            line += "(" + (i + 1) + ", " + (current.value[i] + 1) + ")";
        }
        console.log(line);
        current = current.next;
    }
}