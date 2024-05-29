## Getting started
Use Hardhat or Foundry or any other framework to work with solidity contracts. Contract data is present in 'Contracts-data' folder.  Adjust the neccessary details in Luck ( You can use the code present in commented lines instead of using chainlink part if you want to work locally on the chain ), insert a base string in Card Contract.  
Download the necessary imported files in the contract (@chainlink/contracts , @openzeppelin/contracts, etc).
Note : All the tests in NormalTests.sol in 'test' folder may not work as the deploy script and other bits of codes were changed as the overall code was developed.
### If using foundry 
Use ```anvil``` to run the local blockchain.   
Then use ```forge script script/Deploy.sol --fork-url http://localhost:7545 --private-key <private-key> --broadcast``` in another terminal to deploy the script to the localnet. You can use the addresses returned in nextjs part too ( for the front-end).


### Front-end
After deploying the contracts, set their addresses in index.js.   
Use ```npm run dev``` to run the app.
