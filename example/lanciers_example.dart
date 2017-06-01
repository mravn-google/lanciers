import 'package:lanciers/lanciers.dart';

main() {
  final alice = new Girl('Alice');
  final bob = new Boy('Bob');
  final carol = new Girl('Carol');
  final dean = new Boy('Dean');
  final graph = new PairingGraph(
    <Boy>[bob, dean],
    <Girl>[alice, carol],
    <Pair>[
      new Pair(bob, alice),
      new Pair(dean, alice),
      new Pair(bob, carol),
    ],
  );
  print(maxPairingQuadratic(graph));
}
