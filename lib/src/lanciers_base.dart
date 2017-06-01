class PairingGraph {
  final List<Boy> boys;
  final List<Girl> girls;
  final Map<Dancer, List<Pair>> pairsForDancer;

  PairingGraph(this.boys, this.girls, List<Pair> pairs) : pairsForDancer = {} {
    for (final dancer in dancers) {
      this.pairsForDancer[dancer] = [];
    }
    for (final pair in pairs) {
      this.pairsForDancer[pair.boy].add(pair);
      this.pairsForDancer[pair.girl].add(pair);
    }
  }

  Iterable<Dancer> get dancers => [boys, girls].expand((dancers) => dancers);
  Iterable<Pair> get pairs => boys.expand((boy) => pairsForDancer[boy]);

  Iterable<Pair> pairsInvolving(Dancer dancer) {
    return pairsForDancer[dancer];
  }

  bool isAlone(Dancer dancer) =>
      pairsInvolving(dancer).where((pair) => pair.isSelected).isEmpty;

  List<Pair> pairing() => pairs.where((pair) => pair.isSelected).toList();
}

class Pair {
  final Boy boy;
  final Girl girl;
  bool isSelected = false;

  Pair(this.boy, this.girl);

  void toggleSelected() {
    isSelected = !isSelected;
  }

  bool get isMarked => boy.isMarked || girl.isMarked;

  void mark() {
    boy.mark();
    girl.mark();
  }

  void unmark() {
    boy.unmark();
    girl.unmark();
  }

  @override
  operator ==(o) => o is Pair && o.boy == boy && o.girl == girl;

  @override
  int get hashCode => boy.hashCode ^ girl.hashCode;

  @override
  String toString() => '$boy-${isSelected ? '!' : '?'}-$girl';
}

class Dancer {
  final String name;
  bool isMarked = false;

  Dancer(this.name);

  void mark() {
    isMarked = true;
  }

  void unmark() {
    isMarked = false;
  }

  @override
  operator ==(o) => o?.runtimeType == this.runtimeType && o.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => name;
}

class Boy extends Dancer {
  Boy(String name) : super(name);
}

class Girl extends Dancer {
  Girl(String name) : super(name);
}

List<Pair> maxPairingExponential(PairingGraph graph) {
  void toggleSelected(List<Pair> pairs) {
    for (final pair in pairs) {
      pair.toggleSelected();
    }
  }

  var bestPairing = <Pair>[];
  for (final pair in graph.pairs.where((pair) => !pair.isMarked)) {
    pair.mark();
    final candidatePairing = <Pair>[]
      ..add(pair)
      ..addAll(maxPairingExponential(graph));
    if (bestPairing.length < candidatePairing.length) {
      toggleSelected(bestPairing);
      bestPairing = candidatePairing;
      toggleSelected(bestPairing);
    }
    pair.unmark();
  }
  return bestPairing;
}

List<Pair> maxPairingQuadratic(PairingGraph graph) {
  bool findAndInvertChainFrom(Boy boy) {
    for (final pair1 in graph
        .pairsInvolving(boy)
        .where((pair) => !pair.isSelected && !pair.girl.isMarked)) {
      final girl = pair1.girl;
      if (graph.isAlone(girl)) {
        girl.mark();
        pair1.toggleSelected();
        return true;
      } else {
        for (final pair2 in graph
            .pairsInvolving(girl)
            .where((pair) => pair.isSelected && !pair.boy.isMarked)) {
          pair2.mark();
          if (findAndInvertChainFrom(pair2.boy)) {
            pair1.toggleSelected();
            pair2.toggleSelected();
            return true;
          }
        }
      }
    }
    return false;
  }

  bool findAndInvertChain() {
    for (Boy boy in graph.boys) {
      if (graph.isAlone(boy)) {
        boy.mark();
        if (findAndInvertChainFrom(boy)) {
          return true;
        }
      }
    }
    return false;
  }

  void removeMarks() {
    for (Dancer dancer in graph.dancers) {
      dancer.unmark();
    }
  }

  while (findAndInvertChain()) {
    removeMarks();
  }
  return graph.pairing();
}
