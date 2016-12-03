package Queen;
use Storable qw(dclone);
use Time::HiRes qw(time);

sub new {
    my $class = shift;
    my $self  = {};

    $self->{m_width}      = shift;
    $self->{m_lastRow}    = $self->{m_width} - 1;
    $self->{m_columns}    = [];
    $self->{m_diagonals1} = [];
    $self->{m_diagonals2} = [];
    $self->{m_solutions}  = [];

    my $numberOfDiagonals = 2 * $self->{m_width} - 1;

    for (my $index = 0; $index < $numberOfDiagonals; ++$index) {
        if ($index < $self->{m_width}) {
            push($self->{m_columns}, int(-1));
        }
        push($self->{m_diagonals1}, 0);
        push($self->{m_diagonals2}, 0);
    }

    bless($self, $class);
    return $self;
}

sub getWidth {
    my $self = shift;
    return $self->{m_width};
}

sub getNumberOfSolutions {
    my $self = shift;
    return scalar(@{$self->{m_solutions}});
}

sub runAlgorithm {
    my $self = shift;
    my $row  = shift;

    #print("row=$row\n");

    for (my $column = 0; $column < $self->{m_width}; ++$column) {
        if ($self->{m_columns}[$column] >= 0) {
            next;
        }

        my $ixDiag1 = $row + $column;
        if (1 == $self->{m_diagonals1}[$ixDiag1]) {
            next;
        }

        my $ixDiag2 = $self->{m_lastRow} - $row + $column;
        if (1 == $self->{m_diagonals2}[$ixDiag2]) {
            next;
        }

        $self->{m_columns}[$column] = $row;
        $self->{m_diagonals1}[$ixDiag1] = 1;
        $self->{m_diagonals2}[$ixDiag2] = 1;

        if ($row == $self->{m_lastRow}) {
            push($self->{m_solutions}, dclone(\@{$self->{m_columns}}) );
        } else {
            $self->runAlgorithm($row + 1);
        }

        $self->{m_columns}[$column] = -1;
        $self->{m_diagonals1}[$ixDiag1] = 0;
        $self->{m_diagonals2}[$ixDiag2] = 0;
    }
}

sub printSolutions {
    my $self = shift;

    for (my $solution = 0; $solution lt $self->getNumberOfSolutions; ++$solution) {
        for (my $column = 0; $column lt $self->{m_width}; ++$column) {
            printf("(%d,%d)", ($column+1), ($self->{m_solutions}[$solution][$column]+1));
        }
        printf("\n");
    }
}

$theWidth = 8; # this is the default
if (@ARGV eq 1) {
    $theWidth = int($ARGV[0]);
}

$instance = Queen->new($theWidth);
printf("Queen raster (%dx%d)\n", $instance->getWidth, $instance->getWidth);
my $start = time();
$instance->runAlgorithm(0);
printf("...took %.2f seconds.\n", time() - $start);
printf("...%d solutions found.\n", $instance->getNumberOfSolutions);
#$instance->printSolutions;
