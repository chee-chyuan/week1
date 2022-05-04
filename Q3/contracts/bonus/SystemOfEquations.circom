pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib-matrix/circuits/matMul.circom"; // hint: you can use more than one templates in circomlib-matrix to help you

template SystemOfEquations(n) { // n is the number of variables in the system of equations
    signal input x[n]; // this is the solution to the system of equations
    signal input A[n][n]; // this is the coefficient matrix
    signal input b[n]; // this are the constants in the system of equations
    signal output out; // 1 for correct solution, 0 for incorrect solution

    signal matOutput[n];
    signal isEqualRes[n];
    signal result[n];

    component isEquals[n];
    component matrixMul = matMul(n, n, 1);

    // [bonus] insert your code here
    for (var i = 0; i < n; i++) {
        for (var j = 0; j < n; j++) {
            matrixMul.a[i][j] <== A[i][j];
        }
        matrixMul.b[i][0] <== x[i];
    }

    // get output
    for (var i = 0; i < n; i++) {
        matrixMul.out[i][0] ==> matOutput[i];
    }

    // compare output for each element
    for (var i = 0; i < n; i++) {
        isEquals[i] = IsEqual();
        isEquals[i].in[0] <== matrixMul.out[i][0];
        isEquals[i].in[1] <== b[i];

        isEquals[i].out ==> isEqualRes[i];
    }

    // compound result
    result[0] <== isEqualRes[0];
    for (var i = 1; i < n; i++) {
        result[i] <== result[i-1] * isEqualRes[i];
    }

    result[n-1] ==> out;
}

component main {public [A, b]} = SystemOfEquations(3);