#include <iostream>
using namespace std;

#include "../analyze.h"

int main() {
	Analyze* analyze;
  analyze = new Analyze("/Users/gperciva/data/exer-1.wav", "music/exer.txt");
  analyze->calcDurations();
  analyze->calcNotes();
	analyze->writeNotes();
	delete analyze;
}

