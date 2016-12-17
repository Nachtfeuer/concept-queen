
class ChessboardPainter {
    private readonly size: number = 8;
    private readonly clientWidth: number = 100;
    private readonly margin: number = 50;
    private readonly marginCell: number = 0;
    private readonly cellw: number = (this.clientWidth - 2 * this.margin) / this.size;
    private readonly darkCell: string = "rgb( 90,  90,  90)";
    private readonly lightCell: string = "rgb(250, 250, 250)";
    private element: HTMLCanvasElement = null;

    /**
     * Initializes chessboard with a concrete {size} and passing the
     * HTML Canvas {element} to paint on.
     */
    constructor(size: number, element: HTMLCanvasElement) {
        this.size = size;
        this.element = element;
        this.clientWidth = element.clientWidth;
        this.cellw = (this.clientWidth - 2 * this.margin) / this.size;
    }

    /**
     * Main function to initiate painting of the chessboard.
     */
    public paint(): void {
        this.paintAll(this.element.getContext("2d"));
    }

    /**
     * Painting the chessboard with row labels and columns labels.
     * You have to pass the canvas [context] which can be retrieved
     * with `document.getElementById("myid").getContext()`.
     */
    private paintAll(context: CanvasRenderingContext2D): void {
        this.paintRowLabels(context);
        this.paintColumnLabels(context);
        this.paintChessboard(context);
        this.paintDiagonals1(context);
        // TODO: this.paintDiagonals2(context);
    }

    /**
     * Paint of the row labels (zero based indices).
     */
    private paintRowLabels(context: CanvasRenderingContext2D): void {
        context.beginPath();
        context.font = "14px Arial bold";
        for (var row = 0; row < this.size; ++row) {
            context.fillText(
                (this.size - row - 1).toString(),
                this.margin * 3 / 4,
                this.margin + this.cellw / 2 + row * this.cellw);
        }
        context.closePath();
        context.fill();
    }

    /**
     * Paint of the column labels (zero based indices).
     */
    private paintColumnLabels(context: CanvasRenderingContext2D): void {
        context.beginPath();
        context.font = "14px Arial bold";
        for (var column = 0; column < this.size; ++column) {
            context.fillText(
                column.toString(),
                this.margin + this.cellw / 2 + column * this.cellw,
                this.clientWidth - this.margin * 3 / 4);
        }
        context.closePath();
        context.fill();
    }

    /**
     * Paint of the chessboard fields colorizing the fields.
     */
    private paintChessboard(context: CanvasRenderingContext2D): void {
        context.beginPath();
        for (var column = 0; column < this.size; ++column) {
            for (var row = 0; row < this.size; ++row) {
                context.fillStyle = this.darkCell;

                if (row % 2 == 0) {
                    if (column % 2 == 0) {
                        context.fillStyle = this.lightCell;
                    }
                } else {
                    if (column % 2 != 0) {
                        context.fillStyle = this.lightCell;
                    }
                }

                context.fillRect(
                    this.margin + column * this.cellw,
                    this.margin + row * this.cellw,
                    this.cellw - this.marginCell, this.cellw - this.marginCell);
                context.rect(
                    this.margin + column * this.cellw,
                    this.margin + row * this.cellw,
                    this.cellw - this.marginCell, this.cellw - this.marginCell);
            }
        }
        context.closePath();
        context.stroke();
   }

    /**
     * Paint the diagonals which go from top/left to bottom/right.
     * Each diagonal gets zero based indices.
     */
    private paintDiagonals1(context: CanvasRenderingContext2D): void {
        context.beginPath();
        context.fillStyle = "rgb(200, 200, 200)"
        context.font = "11px Arial bold";
        context.lineWidth = 0.2;

        for (var k = 0; k < this.size; ++k) {
            context.moveTo(5, 5 + k * this.cellw);
            context.lineTo(this.margin - 5 + (this.size - k + 1) * this.cellw, this.clientWidth - 5);
            context.fillText((this.size - k - 1).toString(),
                             5, (k + 1) * this.cellw - this.cellw / 2);

            if (k > 0) {
                context.moveTo(5 + k * this.cellw, 5);
                context.lineTo(this.clientWidth - 5, this.clientWidth - 5 - k * this.cellw);
                context.fillText((7 + k).toString(),
                                  k * this.cellw - 8, 15);
            }
        }

        context.closePath();
        context.stroke();
   }
}