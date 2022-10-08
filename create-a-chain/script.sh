#!/bin/bash

# Install node 16
apt update
apt install -y curl
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt install -y nodejs

# Create the folders
mkdir -p Node-0/data/keystore
mkdir -p Node-1/data/keystore
mkdir -p Node-2/data/keystore
mkdir -p Node-3/data/keystore
mkdir -p Node-4/data/keystore

# Define the QBFT network
npx quorum-genesis-tool --consensus qbft --chainID 1234 --blockperiod 5 --requestTimeout 10 --epochLength 30000 --difficulty 1 --gasLimit '0x33450' --coinbase '0x0000000000000000000000000000000000000000' --validators 5 --members 0 --bootnodes 0 --outputPath 'artifacts' --maxCodeSize 64 --txnSizeLimit 64 

# Organize the data
mv artifacts/2022-02-23-12-34-35/* artifacts/

# Edit static nodes
# Insert the right port and ip
cd artifacts/goQuorum
vi static-nodes.json

# Copy them to the right folders
cp static-nodes.json genesis.json ../../Node-0/data/
cp static-nodes.json genesis.json ../../Node-1/data/
cp static-nodes.json genesis.json ../../Node-2/data/
cp static-nodes.json genesis.json ../../Node-3/data/
cp static-nodes.json genesis.json ../../Node-4/data/
cp validator0/nodekey* address ../../Node-0/data
cp validator1/nodekey* address ../../Node-1/data
cp validator2/nodekey* address ../../Node-2/data
cp validator3/nodekey* address ../../Node-3/data
cp validator4/nodekey* address ../../Node-4/data
cp validator0/account* ../../Node-0/data/keystore
cp validator1/account* ../../Node-1/data/keystore
cp validator2/account* ../../Node-2/data/keystore
cp validator3/account* ../../Node-3/data/keystore
cp validator4/account* ../../Node-4/data/keystore

# Distribute the folders onto the various nodes if you use multiple machines then
geth --datadir data init data/genesis.json
# on any node

# Lastly, start it
# Note this start in local, use a reverse proxy or use 0.0.0.0 (risky)

screen -S nameofyourchain

# Now you are in a screen, run
export ADDRESS=$(grep -o '"address": *"[^"]*"' ./data/keystore/accountKeystore | grep -o '"[^"]*"$' | sed 's/"//g')
export PRIVATE_CONFIG=ignore
./geth --datadir data \
    --networkid 1234 --nodiscover --verbosity 5 \
    --syncmode full --nousb \
    --istanbul.blockperiod 5 --mine --miner.threads 1 --miner.gasprice 0 --emitcheckpoints \
    --http --http.addr 127.0.0.1 --http.port 8545 --http.corsdomain "*" --http.vhosts "*" \
    --ws --ws.addr 127.0.0.1 --ws.port 8546 --ws.origins "*" \
    --http.api admin,trace,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul,qbft \
    --ws.api admin,trace,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul,qbft \
    --unlock ${ADDRESS} --allow-insecure-unlock --password ./data/keystore/accountPassword \
    --port 30300
	
# And press ctrl+a+d to detach
# screen -r nameofyourchain will let you see the status