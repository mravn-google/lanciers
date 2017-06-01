// Copyright (c) 2017, mravn. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:lanciers/lanciers.dart';
import 'package:test/test.dart';

void main() {
  PairingGraph graph(
          List<Boy> boys, List<Girl> girls, List<Pair> possiblePairs) =>
      new PairingGraph(boys, girls, possiblePairs);
  Boy boy(int b) => new Boy('$b');
  Girl girl(int g) => new Girl('$g');
  Pair pair(Boy left, Girl right) => new Pair(left, right);
  final alice = new Girl('Alice');
  final bob = new Boy('Bob');
  final carol = new Girl('Carol');
  final dean = new Boy('Dean');
  final vorrevang =
      graph(new List.generate(33, boy), new List.generate(23, girl), [
    pair(boy(0), girl(0)),
    pair(boy(0), girl(1)),
    pair(boy(0), girl(12)),
    pair(boy(0), girl(17)),
    pair(boy(1), girl(9)),
    pair(boy(1), girl(11)),
    pair(boy(2), girl(7)),
    pair(boy(2), girl(10)),
    pair(boy(2), girl(15)),
    pair(boy(3), girl(10)),
    pair(boy(3), girl(17)),
    pair(boy(3), girl(20)),
    pair(boy(4), girl(3)),
    pair(boy(4), girl(8)),
    pair(boy(4), girl(15)),
    pair(boy(4), girl(17)),
    pair(boy(4), girl(19)),
    pair(boy(5), girl(4)),
    pair(boy(5), girl(5)),
    pair(boy(5), girl(10)),
    pair(boy(6), girl(6)),
    pair(boy(6), girl(7)),
    pair(boy(6), girl(8)),
    pair(boy(6), girl(22)),
    pair(boy(7), girl(8)),
    pair(boy(7), girl(9)),
    pair(boy(7), girl(10)),
    pair(boy(7), girl(17)),
    pair(boy(8), girl(2)),
    pair(boy(8), girl(9)),
    pair(boy(8), girl(12)),
    pair(boy(9), girl(4)),
    pair(boy(9), girl(5)),
    pair(boy(9), girl(8)),
    pair(boy(10), girl(3)),
    pair(boy(10), girl(10)),
    pair(boy(10), girl(13)),
    pair(boy(11), girl(10)),
    pair(boy(11), girl(19)),
    pair(boy(12), girl(0)),
    pair(boy(12), girl(16)),
    pair(boy(13), girl(6)),
    pair(boy(13), girl(7)),
    pair(boy(13), girl(10)),
    pair(boy(13), girl(11)),
    pair(boy(13), girl(12)),
    pair(boy(14), girl(13)),
    pair(boy(14), girl(14)),
    pair(boy(15), girl(8)),
    pair(boy(15), girl(18)),
    pair(boy(16), girl(6)),
    pair(boy(16), girl(7)),
    pair(boy(16), girl(10)),
    pair(boy(16), girl(12)),
    pair(boy(16), girl(15)),
    pair(boy(16), girl(21)),
    pair(boy(17), girl(4)),
    pair(boy(17), girl(5)),
    pair(boy(17), girl(6)),
    pair(boy(17), girl(7)),
    pair(boy(18), girl(20)),
    pair(boy(18), girl(21)),
    pair(boy(19), girl(2)),
    pair(boy(19), girl(4)),
    pair(boy(19), girl(5)),
    pair(boy(19), girl(6)),
    pair(boy(19), girl(8)),
    pair(boy(20), girl(10)),
    pair(boy(20), girl(14)),
    pair(boy(20), girl(16)),
    pair(boy(20), girl(17)),
    pair(boy(21), girl(11)),
    pair(boy(21), girl(13)),
    pair(boy(21), girl(15)),
    pair(boy(21), girl(16)),
    pair(boy(21), girl(17)),
    pair(boy(21), girl(19)),
    pair(boy(22), girl(3)),
    pair(boy(22), girl(8)),
    pair(boy(23), girl(17)),
    pair(boy(23), girl(18)),
    pair(boy(23), girl(19)),
    pair(boy(24), girl(20)),
    pair(boy(25), girl(9)),
    pair(boy(25), girl(13)),
    pair(boy(25), girl(15)),
    pair(boy(25), girl(16)),
    pair(boy(26), girl(0)),
    pair(boy(26), girl(1)),
    pair(boy(26), girl(18)),
    pair(boy(27), girl(10)),
    pair(boy(27), girl(15)),
    pair(boy(27), girl(18)),
    pair(boy(27), girl(19)),
    pair(boy(28), girl(12)),
    pair(boy(28), girl(18)),
    pair(boy(29), girl(12)),
    pair(boy(29), girl(16)),
    pair(boy(30), girl(13)),
    pair(boy(30), girl(14)),
    pair(boy(31), girl(20)),
    pair(boy(31), girl(21)),
    pair(boy(32), girl(20)),
    pair(boy(32), girl(21)),
  ]);
  group('Exponential algorithm', () {
    test('empty graph', () {
      checkMaxPairing(graph([], [], []), maxPairingExponential, []);
    });
    test('graph without edges', () {
      checkMaxPairing(graph([bob], [alice], []), maxPairingExponential, []);
    });
    test('graph with single edge', () {
      checkMaxPairing(graph([bob], [alice], [pair(bob, alice)]),
          maxPairingExponential, [pair(bob, alice)]);
    });
    test('graph with a max pairing', () {
      checkMaxPairing(
          graph([bob, dean], [alice, carol],
              [pair(bob, alice), pair(dean, alice), pair(bob, carol)]),
          maxPairingExponential,
          [pair(bob, carol), pair(dean, alice)]);
    });
    test('vorrevang', () {}, skip: true); // takes too long
  });
  group('Quadratic algorithm', () {
    test('empty graph', () {
      checkMaxPairing(graph([], [], []), maxPairingQuadratic, []);
    });
    test('graph without edges', () {
      checkMaxPairing(graph([bob], [alice], []), maxPairingQuadratic, []);
    });
    test('graph with single edge', () {
      checkMaxPairing(graph([bob], [alice], [pair(bob, alice)]),
          maxPairingQuadratic, [pair(bob, alice)]);
    });
    test('graph with a max pairing', () {
      checkMaxPairing(
          graph([bob, dean], [alice, carol],
              [pair(bob, alice), pair(dean, alice), pair(bob, carol)]),
          maxPairingQuadratic,
          [pair(bob, carol), pair(dean, alice)]);
    });
    test('vorrevang', () {
      expect(maxPairingQuadratic(vorrevang), hasLength(23));
    });
  });
}

typedef List<Pair> Pairer(PairingGraph graph);

void checkMaxPairing(
    PairingGraph graph, Pairer pairer, List<Pair> expectedResult) {
  if (expectedResult.isEmpty) {
    expect(pairer(graph), isEmpty);
  } else {
    expect(pairer(graph), containsAllInOrder(expectedResult));
  }
}
