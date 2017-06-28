#!/usr/bin/env bash

echo
echo "----------------------------------------------------------------------"
echo "Install CUDA 'cuda-command-line-tools-8-0' without the driver !!!"
echo
echo "Please enter password from user 'prospector'..."
echo "----------------------------------------------------------------------"
echo

sudo apt-get install -y cuda-command-line-tools-8-0


echo
echo "----------------------------------------------------------------------"
echo "Compile 'etherminer' with the optimized code by David Li (from NVIDIA)"
echo "----------------------------------------------------------------------"
echo 
echo "The code is optimized for GTX1060,"
echo "can improve GTX1060 with 2 GPC performance by 15%,"
echo "and GTX1060 with 1 GPC performance by more than 30%. Meanwhile,"
echo "it also increases performance on GTX1070."
echo
echo "Please wait..."
sleep 5

# https://www.reddit.com/r/EtherMining/comments/6jjhob/ethereum_code_optimized_for_some_nvidian_cards/
# https://github.com/ethereum-mining/ethminer/pull/18

cd ~prospector || exit 9
mkdir ethereum-mining
cd ethereum-mining || exit 9
git clone https://github.com/ethereum-mining/ethminer.git
cd ethminer || exit 9
mkdir build
cd build || exit 9
cmake -D CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-8.0 -DETHASHCL=OFF -DETHASHCUDA=ON ..
cmake --build .


cd ~prospector || exit 9
echo
echo "----------------------------------------------------------------------"
echo "Now this script automatically adjusts your 'miner.sh'"
echo "for the just compiled ethminer."
echo "----------------------------------------------------------------------"
echo
echo "Please wait..."
sleep 5

# miner.sh
echo; echo "Update '.screenrc'"
perl -i -pe's|ethminer-genoil|ethminer|g' miner.sh
perl -i -pe's|https://github.com/Genoil/cpp-ethereum|https://github.com/ethereum-mining/ethminer|g' miner.sh
perl -i -pe's|/home/prospector/cpp-ethereum/build/ethminer/ethminer|/home/prospector/ethereum-mining/ethminer/build/ethminer/ethminer|g' miner.sh

# .bashrc
echo; echo "Update '.bashrc'"
perl -i -pe's|ethminer-genoil|ethminer|g' .bashrc
perl -i -pe's|/home/prospector/cpp-ethereum/build/ethminer/ethminer|/home/prospector/ethereum-mining/ethminer/build/ethminer/ethminer|g' .bashrc

echo
echo "----------------------------------------------------------------------"
echo "DONE: ethminer updated"
echo "----------------------------------------------------------------------"
echo
