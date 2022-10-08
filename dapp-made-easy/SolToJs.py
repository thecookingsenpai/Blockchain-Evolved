import os

os.chdir(os.path.dirname(os.path.realpath(__file__)))

filename = "betting_native.sol"

filestream = open(filename, "r").readlines()

# NOTE: Variables and authentication
jscode = "let contract_address = ''\nlet contract_abi = ''\n\n"
jscode += """
    var provider;
    var signer;
    var signer_address;
"""
jscode += """\n
        async function authenticate() {
            // Prompt user for account connections
            provider = new ethers.providers.Web3Provider(window.ethereum, "any")
            await provider.send("eth_requestAccounts", []);
            signer = provider.getSigner();
            signer_address = await signer.getAddress()
            console.log("Account:", signer_address);
            console.log(provider)
            // Loading the contract
            let contractInstance = new ethers.Contract(contract_address, contract_abi, signer)
            console.log(contractInstance)
            let chain_info = await provider.getNetwork()
            chain_id = chain_info.chainId
            console.log(chain_info)
            console.log(chain_id)
            const allowed_networks = [1,5]
            if(!(allowed_networks.includes(chain_id))) { // Goerli: 5; Mainnet: 1; BSC: 54; Rinkeby: 4; Doge: 2000
            alert("ERROR: Wrong network")
            return "ERROR: Wrong network"
            }
            return signer_address
        }\n\n
  """

# NOTE Contract parsing
for line in filestream:
    line = line.strip()
    if "function" in line and "public" in line:
        fname = line.split("function ")[1].split("(")[0]
        args = line.split("function ")[1].split("(")[1].split(")")[0]
        js_args = args.replace(
                            "bytes32 ", ""
                            ).replace(
                            "bool ", ""
                            ).replace(
                            "address ", ""
                            ).replace(
                            "string ", ""
                            ).replace(
                            "uint8 ", ""
                            ).replace(
                            "uint256 ", ""
                            ).replace(
                            "uint ", ""
                            ).replace(
                            "[] ", ""
                            ).replace(
                            "calldata ", ""
                            ).replace(
                            "memory ", ""
                            )
        internal = ""
        if "view" in line:
            internal = """
             try {
                let result = await contractInstance.""" + fname + """(""" + js_args + """);
                console.log(result)
                return true, result
            } catch(error) {
                console.log(error)
                return false, error
            }
            """
        else:
            internal = """
             try {
                let txhash = await contractInstance.""" + fname + """(""" + js_args + """);
                let receipt = await txhash.wait()
                receipt = JSON.stringify(receipt)
                console.log(receipt)
                return true, receipt
            } catch(error) {
                console.log(error)
                return false, error
            } 
            """
        fstatement = "async function " + fname + "(" + js_args + ") {\n\n" + internal + "\n\n}" 
        jscode += fstatement + "\n\n"

print(jscode)
with open(filename + ".js", "w+") as f:
    f.write(jscode)