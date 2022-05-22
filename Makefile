# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

all: clean remove install update build 

# Install proper solc version.
# solc:; nix-env -f https://github.com/dapphub/dapptools/archive/master.tar.gz -iA solc-static-versions.solc_0_8_10

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

# Install the Modules
install :; 
	forge install OpenZeppelin/openzeppelin-contracts

# Update Dependencies
update:; forge update

# Builds
build  :; forge clean && forge build

setup-yarn:
	yarn 

local-node: setup-yarn 
	anvil -a 10 

# update contract you want to deploy
deploy-local:
	forge create MyNFT --private-key ${PRIVATE_KEY_LOCAL} # --rpc-url

# update contract you want to deploy
deploy:
	forge create MyNFT --private-key ${PRIVATE_KEY} # --rpc-url ${RPC_URL} #