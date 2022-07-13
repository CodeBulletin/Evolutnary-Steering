class Genotype {
  float[] dna;
  Genotype() {
    dna = new float[7];
    dna[0] = random(0, forceMul);
    dna[1] = random(-forceMul, 0);
    dna[2] = random(-forceMul, 0);
    dna[3] = random(0, eye_limit);
    dna[4] = random(0, eye_limit);
    dna[5] = random(0, eye_limit);
    dna[6] = random(0, eye_limit);
  }
  Genotype(float[] _dna) {
    dna = _dna;
  }
  Genotype copy() {
    float[] newDna = new float[dna.length];
    for (int i = 0; i < dna.length; i++) {
      newDna[i] = dna[i];
    }
    return new Genotype(newDna);
  }
  Genotype crossover(Genotype other) {
    float[] newDna = new float[dna.length];
    for (int i = 0; i < dna.length; i++) {
      if (random(1) < 0.5) {
        newDna[i] = other.dna[i];
      } else {
        newDna[i] = dna[i];
      }
    }
    return new Genotype(newDna);
  }
  void mutate(int breaker) {
    for (int i = 0; i < dna.length; i++) {
      if (random(1) < mutation) {
        if (random(1) < Small_mutation_percentage) {
          if (i < breaker) {
            dna[i] = constrain(dna[i] + random(-1, 1), -forceMul, forceMul);
          } else {
            dna[i] = constrain(dna[i] + random(-50, 50), 0, eye_limit);
          }
        } else {
          if (i < breaker) {
            dna[i] = random(-forceMul, forceMul);
          } else {
            dna[i] = random(0, eye_limit);
          }
        }
      }
    }
  }
}
