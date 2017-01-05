import 'dart:async';
import 'dart:math';

bool isPrime(int n) {
  if (n < 2) return false;
  if (n % 2 == 0) return n == 2;
  int d = sqrt(n).toInt();
  for (var k = 3; k <= d; k += 2) {
    if (n % k == 0) return false;
  }
  return true;
}

Future<List<int>> createPrimes(int a, int b) async {
  //print("createPrimes(a=${a}, b=${b})...");
  List<int> primes = new List<int>();
  for (var k = a; k <= b; ++k) {
    if (isPrime(k)) {
      primes.add(k);
    }
  }
  return primes;
}

Future test_future(int maxChunks, int chunkSize) async {
  print("test_future (n <= ${maxChunks*chunkSize})...");
  var watcher = new Stopwatch();
  watcher.start();

  List<Future<List<int>>> results = new List<Future<List<int>>>();
  for (var chunk = 0; chunk < maxChunks; ++chunk) {
    var a = chunk * chunkSize;
    var b = a + chunkSize - 1;
    results.add(createPrimes(a, b));
  }

  List<int> primes = new List<int>();
  Completer<bool> done = new Completer<bool>();
  Future.wait(results).then((results) {
    for (var result in results) {
      primes.addAll(result);
    }
  }).whenComplete(() {
    done.complete(true);
  });

  await done;
  print("...took ${watcher.elapsedMilliseconds/1000.0} seconds.");
  print("...${primes.length} primes found.");
  return primes;
}

List<int> test_no_future(int maxChunks, int chunkSize) {
  print("test_no_future (n <= ${maxChunks*chunkSize})...");
  var watcher = new Stopwatch();
  watcher.start();

  List<int> primes = new List<int>();
  var a = 0;
  var b = maxChunks * chunkSize;
  for (var k = a; k <= b; ++k) {
    if (isPrime(k)) {
      primes.add(k);
    }
  }

  print("...took ${watcher.elapsedMilliseconds/1000.0} seconds.");
  print("...${primes.length} primes found.");
  return primes;
}

main() async {
  const int maxChunks = 20;
  const int chunkSize = 500000;

  print("main started...");
  var primesA = await test_future(maxChunks, chunkSize);
  var primesB = test_no_future(maxChunks, chunkSize);
  assert(primesA.toString() == primesB.toString());
  print("main done.");
}
