#!/bin/bash

# [assignment] create your own bash script to compile Multipler3.circom modeling after compile-HelloWorld.sh below



cd contracts/circuits

mkdir Multiplier3_plonk

if [ -f ./powersOfTau28_hez_final_10.ptau ]; then
    echo "powersOfTau28_hez_final_10.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_10.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau
fi

echo "Compiling _plonkMultiplier3.circom..."

# compile circuit

circom Multiplier3.circom --r1cs --wasm --sym -o Multiplier3_plonk
snarkjs r1cs info Multiplier3_plonk/Multiplier3.r1cs

# Start a new zkey 

snarkjs plonk setup Multiplier3_plonk/Multiplier3.r1cs powersOfTau28_hez_final_10.ptau Multiplier3_plonk/Multiplier3.zkey

snarkjs zkey export verificationkey Multiplier3_plonk/Multiplier3.zkey Multiplier3_plonk/verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier Multiplier3_plonk/Multiplier3.zkey ../Multiplier3_plonkVerifier.sol




#Generate witness;
node "Multiplier3_plonk/Multiplier3_js/generate_witness.js" Multiplier3_plonk/Multiplier3_js/Multiplier3.wasm input.json Multiplier3_plonk/witness.wtns


#Generate proof;
snarkjs plonk prove Multiplier3_plonk/Multiplier3.zkey Multiplier3_plonk/witness.wtns Multiplier3_plonk/proof.json Multiplier3_plonk/public.json

#verify proof

snarkjs plonk verify Multiplier3_plonk/verification_key.json Multiplier3_plonk/public.json Multiplier3_plonk/proof.json

#generate call

snarkjs zkey export soliditycalldata Multiplier3_plonk/public.json Multiplier3_plonk/proof.json > Multiplier3_plonk/call.txt



cd ../..