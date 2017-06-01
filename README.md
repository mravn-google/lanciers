# lanciers

Max bipartite pairing dressed up for Les Lanciers.

## Usage

A simple usage example:

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
      print(maxPairingExponential(graph));
      print(maxPairingQuadratic(graph));
    }
