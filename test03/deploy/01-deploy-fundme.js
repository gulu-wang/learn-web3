const {
  LOCK_TIME,
  developmentChains,
  networkConfig,
  waitConfirmations,
} = require("../helper-hardhat-config");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deployer, user1 } = await getNamedAccounts();

  let dataFeedAddr;
  if (developmentChains.includes(network.name)) {
    dataFeedAddr = (await deployments.get("MockV3Aggregator")).address;
  } else {
    dataFeedAddr = networkConfig[network.config.chainId]["ethUsdPriceFeed"];
  }

  const fundMe = await deployments.deploy("FundMe", {
    from: deployer,
    args: [LOCK_TIME, dataFeedAddr],
    log: true,
    waitConfirmations: waitConfirmations,
  });

  if (hre.network.config.chainId == 11155111 && process.env.ETHERSCAN_API_KEY) {
    await hre.run("verify:verify", {
      address: fundMe.address,
      constructorArguments: [LOCK_TIME, dataFeedAddr],
    });
  } else {
    console.log("not on sepolia network, no need to verify");
  }
};

module.exports.tags = ["all", "fundme"];

// remove deployment or add --reset flag to the command if you want to redeploy the contract
