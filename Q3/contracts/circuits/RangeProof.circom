pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";

template RangeProof(n) {
    assert(n <= 252);
    signal input in; // this is the number to be proved inside the range
    signal input range[2]; // the two elements should be the range, i.e. [lower bound, upper bound]
    signal output out;
    signal highOut;
    signal lowOut;

    component low = LessEqThan(n);
    component high = GreaterEqThan(n);

    // [assignment] insert your code here

    // more than lowerbound
    high.in[0] <== in;
    high.in[1] <== range[0];
    highOut <== high.out;
    highOut * (highOut - 1) === 0;

    // less than upperbound
    low.in[0] <== in;
    low.in[1] <== range[1];
    lowOut <== low.out;
    lowOut * (lowOut - 1) === 0;

    out <== highOut * lowOut;
}