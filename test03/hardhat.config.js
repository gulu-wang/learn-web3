require("@nomicfoundation/hardhat-toolbox");
// require("@chainlink/env-enc").config();
require("dotenv").config();
require("./tasks");
require("hardhat-deploy");

const { SEPOLIA_RPC_URL, PRIVATE_KEY, PRIVATE_KEY_1, ETHERSCAN_API_KEY } =
  process.env;

// 解决验证代码时网络超时问题
const { ProxyAgent, setGlobalDispatcher } = require("undici");
const proxyAgent = new ProxyAgent("http://127.0.0.1:7890");
setGlobalDispatcher(proxyAgent);

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "hardhat",
  solidity: "0.8.28",
  networks: {
    sepolia: {
      url: SEPOLIA_RPC_URL,
      accounts: [PRIVATE_KEY, PRIVATE_KEY_1],
      chainId: 11155111,
    },
  },
  etherscan: {
    apiKey: { sepolia: ETHERSCAN_API_KEY },
  },
  namedAccounts: {
    deployer: {
      default: 0,
    },
    user1: {
      default: 1,
    },
  },
  // sourcify: {
  //   enabled: true,
  // },
  mocha: {
    timeout: 300000,
  },
};
