"""
Module multi_processing.

On my machine the multiprocessing example is 3 times faster
then the calculation for whole range at once. Now the
question is how much improvement is possible for the
Python queen algorithm ...
"""
import math
import time
from multiprocessing import Pool

def is_prime(n):
    """
    Verifying that given number is a prime.
    :returns: True when given number is a prime, otherwise False.
    """
    if n < 2: return False
    if n % 2 == 0: return n == 2
    d = int(math.sqrt(n))
    for k in range(3, d+1, 2):
        if n % k == 0: return False
    return True

def primes(rng):
    """:returns: all prime numbers in given range."""
    return [n for n in range(rng[0], rng[1]+1) if is_prime(n)]

def profile(func):
    """
    Function decorator for calculating executiont time of a function.
    :returns: decorator function.
    """
    def decorator(*args, **kwargs):
        start = time.time()
        result = func(*args, *kwargs)
        print("%s: took %f seconds" % (func.__name__, time.time()-start))
        return result
    return decorator

def sub_ranges(max_n, max_ranges):
    """
    Calculate equal ranges for a maximum number.
    :returns: list of equal ranges.
    """
    ranges = []
    range_len = max_n // max_ranges
    for i in range(max_ranges):
        ranges.append((i*range_len, i*range_len + range_len - 1))
    return ranges 

@profile
def test1(max_n):
    """:returns: primes for whole range, single threaded."""
    return primes((0, max_n))

@profile
def test2(max_n):
    """
    Calculating prime ranges in parallel.
    """
    results = []
    with Pool(8) as pool:
        for result in pool.map(primes, sub_ranges(max_n, 8)):
            results.extend(result)
    return results

if __name__ == '__main__':
    max_n = 3000000
    primes1 = test1(max_n)
    print("test1: %d primes found" % (len(primes1)))
    primes2 = test2(max_n)
    print("test2: %d primes found" % (len(primes2)))
    assert primes1 == primes2
