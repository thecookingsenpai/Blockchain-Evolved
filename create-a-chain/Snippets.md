
# Snippets to create various chains structures:

## QBFT (5x nodes)

```
npx quorum-genesis-tool --consensus qbft --chainID 888 --blockperiod 3 --requestTimeout 10 --epochLength 15000 --difficulty 1 --gasLimit '0x33450' --coinbase '0x0000000000000000000000000000000000000000' --validators 5 --members 0 --bootnodes 0 --outputPath 'artifacts' --maxCodeSize 128 --txnSizeLimit 128 
```

##RAFT (2x nodes)

```bash
npx quorum-genesis-tool --consensus raft --chainID 333 --blockperiod 2 --requestTimeout 10 --epochLength 30000 --difficulty 1 --gasLimit '0xFFFFFF' --coinbase '0x0000000000000000000000000000000000000000' --validators 2 --members 0 --bootnodes 0 --outputPath 'artifacts'
```

## Generic structure (modify for other consensus)

Raft-Network
├── artifacts
    └──2022-02-23-12-34-35
        ├── goQuorum
        │         ├── disallowed-nodes.json
        │         ├── genesis.json
        │         ├── permissioned-nodes.json
        │         └── static-nodes.json
        ├── README.md
        ├── userData.json
        ├── validator0
        │         ├── accountAddress
        │         ├── accountKeystore
        │         ├── accountPassword
        │         ├── accountPrivateKey
        │         ├── address
        │         ├── nodekey
        │         └── nodekey.pub
        ├── validator1
        │         ├── accountAddress
                  ├── accountKeystore
                  ├── accountPassword
                  ├── accountPrivateKey
                  ├── address
                  ├── nodekey
                  └── nodekey.pub
				  


## Setup of static nodes file

**Change them to reflect ports and ip**

```
cd Raft-Network
mv artifacts/2022-02-23-12-34-35/* artifacts
cd artifacts/goQuorum
vi static-nodes.json
```

** While moving, just use the structure above **

```
cp static-nodes.json genesis.json ../../Node-0/data/
cp static-nodes.json genesis.json ../../Node-1/data/
cp static-nodes.json genesis.json ../../Node-2/data/
cp static-nodes.json genesis.json ../../Node-3/data/
cp nodekey* address ../../Node-0/data
cp nodekey* address ../../Node-1/data
cp account* ../../Node-0/data/keystore
cp account* ../../Node-1/data/keystore
[...]
```

## Initialization of the chain 

** In the node folder **
```
geth --datadir data init data/genesis.json
```
* Remember you can change everything in genesis.json to reach results *

* Remember also if you don't change it, gasPrice will be 0 *

## Start the first node

** Remember to reflect your changes in the id, ports and ips here! **

```
export ADDRESS=$(grep -o '"address": *"[^"]*"' ./data/keystore/accountKeystore | grep -o '"[^"]*"$' | sed 's/"//g')
export PRIVATE_CONFIG=ignore
./geth --datadir data \
    --networkid 888 --nodiscover --verbosity 5 \
    --syncmode full --nousb \
    --istanbul.blockperiod 3 --mine --miner.threads 1 --miner.gasprice 0 --emitcheckpoints \
    --http --http.addr 127.0.0.1 --http.port 8545 --http.corsdomain "*" --http.vhosts "*" \
    --ws --ws.addr 127.0.0.1 --ws.port 8546 --ws.origins "*" \
    --http.api admin,trace,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul,qbft \
    --ws.api admin,trace,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul,qbft \
    --unlock ${ADDRESS} --allow-insecure-unlock --password ./data/keystore/accountPassword \
    --port 30300
```

## Add a node

** Using the same command above, for the ones in static-nodes **

* For RAFT *
```
--raft --raftport 53001 --raftblocktime 300 --raftjoinexisting 2
```
* Where 2 is the id progressive and the ports need to be open the same way above *

** In case of additional nodes **

```
mkdir node5
cd node5
../istanbul-tools/build/bin/qbft setup --num 1 --verbose --quorum --save
```
* Remember to vote for validator. On 51% of the nodes do this *

```
geth attach node0/data/geth.ipc
istanbul.propose("0x2aabbc1bb9bacef60a09764d1a1f4f04a47885c1",true)
exit
```

* And to move the files where they belong and update static-nodes *

```
cd node5
mkdir -p data/geth
cp ../node0/static-nodes.json data
vi data/static-nodes.json
cp ../node0/genesis.json .
cp 0/nodekey data/geth
```

Now you can continue till the end


# Fast overview on RAFT vs QBFT (IBFT is obsolete and clique too in respect to the two)

- Raft is fast, consistent and require 51% of nodes online, but start working with 2 nodes; cons: is prone to failure if nodes fail; pro: is fast and consistent

- QBFT isn't as fast (still fast), is less consistent (risk of forks) and require 66% of nodes online (2/3 validation); cons: is a little slower; pro: is stable


# Example script

```
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
```

* Now you can use the docker-compose.yaml pre configured (check the settings) to have Blockscout on 127.0.0.1:26000 or 0.0.0.0 if you prefer *