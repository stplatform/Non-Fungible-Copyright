/**
* @type import('hardhat/config').HardhatUserConfig
*/
require('dotenv').config();
require("@nomiclabs/hardhat-truffle5");
require("@nomiclabs/hardhat-waffle");

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
   const accounts = await hre.ethers.getSigners();
   for (const account of accounts) {
     console.log(account.address);
   }
 });

module.exports = {
  solidity: "0.8.15",
  paths: {
    artifacts: "./artifacts",
    sources: "./contracts",
    cache: "./cache",
    tests: "./test"
  },
  defaultNetwork: "localhost",
   networks: {
      hardhat: {},
      /*
      mumbai: {
         url: process.env.API_URL_MUMBAI,
         accounts: [process.env.PRIVATE_KEY],
      }
      */
   },
};