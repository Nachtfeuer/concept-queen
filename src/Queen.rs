use std::env;
use std::cmp;
use std::usize;
use std::collections::LinkedList;
use std::time::Instant;

const OUTPUT: bool = false; // Set to `true` for printing all solutions

enum Diagonal {
    FREE,
    OCCUPIED,
}

#[derive(Default)]
struct Queen {
    width: usize,
    last_row: usize,
    columns: Vec<usize>,
    diagonals1: Vec<Diagonal>,
    diagonals2: Vec<Diagonal>,
    solutions: LinkedList<Vec<usize>>,
}

impl Queen {
    fn new(n: usize) -> Queen {
        let mut queen = Queen { width: n, last_row: n - 1, ..Default::default() };
        let nr_of_diag = 2 * n - 1;

        for x in 0..nr_of_diag {
            if x < n {
                queen.columns.push(usize::MAX);
            }
            queen.diagonals1.push(Diagonal::FREE);
            queen.diagonals2.push(Diagonal::FREE);
        }
        queen
    }

    #[allow(dead_code)]
    fn nr_of_solutions(&self) -> usize {
        self.solutions.len()
    }

    fn run_algorithm(&mut self, row: usize) {
        for c in 0..self.width {
            if self.columns[c] < usize::MAX {
                continue;
            }

            let ix_diag1 = row + c;
            match self.diagonals1[ix_diag1] {
                Diagonal::OCCUPIED => continue,
                _ => (),
            }

            let ix_diag2 = self.last_row - row + c;
            match self.diagonals2[ix_diag2] {
                Diagonal::OCCUPIED => continue,
                _ => (),
            }

            self.columns[c] = row;
            self.diagonals1[ix_diag1] = Diagonal::OCCUPIED;
            self.diagonals2[ix_diag2] = Diagonal::OCCUPIED;

            if row == self.last_row {
                self.solutions.push_back(self.columns.to_vec());
            } else {
                self.run_algorithm(row + 1);
            }

            self.columns[c] = usize::MAX;
            self.diagonals1[ix_diag1] = Diagonal::FREE;
            self.diagonals2[ix_diag2] = Diagonal::FREE;
        }
    }

    fn print_solutions(&self) {
        for s in &self.solutions {
            for c in 0..self.width {
                print!("({},{})", c + 1, s[c] + 1);
            }
            println!("");
        }
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let mut width: usize = 8;
    
    if args.len() > 1 {
        match args[1].parse::<usize>() {
            Ok(a) => width = cmp::max(1, cmp::min(a, usize::MAX - 1)),
            Err(_) => println!("ERROR: Given argument is not a valid number!"),
        }
    }
    let mut q = Queen::new(width);
    
    println!("Queen raster ({0}x{0})", width);
    let now = Instant::now();
    q.run_algorithm(0);
    let then = now.elapsed().as_nanos() as f64;

    println!("...took {} seconds.", then / 1_000_000_000.0);
    println!("...{} solutions found.", q.nr_of_solutions());
    if OUTPUT {
        q.print_solutions();
    }
}