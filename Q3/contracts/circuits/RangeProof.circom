pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";

template RangeProof(n) {
    assert(n <= 252);
    signal input in; // this is the number to be proved inside the range
    signal input range[2]; // the two elements should be the range, i.e. [lower bound, upper bound]
    signal output out;

    component low = LessEqThan(n);
    component high = GreaterEqThan(n);
    

    low.in[0]<==in;
    low.in[1]<==range[0];
    high.in[0]<==in;
    high.in[1]<==range[1];
    out<==(1-low.out)*(1-high.out)S;
    // [assignment] insert your code here
}
