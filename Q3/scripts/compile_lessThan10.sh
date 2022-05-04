#!/bin/bash

# [assignment] create your own bash script to compile Multiplier3.circom modeling after compile-HelloWorld.sh below
#!/bin/bash

cd contracts/circuits

mkdir LessThan10Use

if [ -f ./powersOfTau28_hez_final_10.ptau ]; then
    echo "powersOfTau28_hez_final_10.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_10.ptau'
    curl https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau -o powersOfTau28_hez_final_10.ptau
fi

echo "Compiling Multiplier3.circom..."

# compile circuit

circom LessThan10Use.circom --r1cs --wasm --sym -o LessThan10Use
snarkjs r1cs info LessThan10Use/LessThan10Use.r1cs

# Start a new zkey and make a contribution

snarkjs groth16 setup LessThan10Use/LessThan10Use.r1cs powersOfTau28_hez_final_10.ptau LessThan10Use/circuit_0000.zkey
snarkjs zkey contribute LessThan10Use/circuit_0000.zkey LessThan10Use/circuit_final.zkey --name="1st Contributor Name" -v -e="random text"
snarkjs zkey export verificationkey LessThan10Use/circuit_final.zkey LessThan10Use/verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier LessThan10Use/circuit_final.zkey ../LessThan10UseVerifier.sol

cd ../..