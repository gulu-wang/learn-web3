const {
  DECIMAL,
  INITIAL_ANSWER,
  developmentChains,
} = require("../helper-hardhat-config");

module.exports = async ({ getNamedAccounts, deployments }) => {
  if (developmentChains.includes(network.name)) {
    const { deployer, user1 } = await getNamedAccounts();
    const { deploy } = deployments;
    await deploy("MockV3Aggregator", {
      from: deployer,
      args: [DECIMAL, INITIAL_ANSWER],
      log: true,
    });
  } else {
    console.log(
      "environment is not localhost or hardhat, skipping mock deployment"
    );
  }
};

module.exports.tags = ["all", "mock"];
