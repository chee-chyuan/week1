
cd RangeProof_js
node generate_witness.js RangeProof.wasm input.json witness.wtns
cd ..
snarkjs groth16 prove circuit_final.zkey RangeProof_js/witness.wtns proof.json public.json
