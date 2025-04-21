const { task } = require("hardhat/config");

task("deploy-fundme", "deploy and verify contract").setAction(
  async (taskArgs, hre) => {
    // 创建一个合约工厂函数
    const fundMeFactory = await ethers.getContractFactory("FundMe");
    console.log("Deploying...");

    // 使用工厂函数创建一个合约实例
    const fundMe = await fundMeFactory.deploy(600);
    await fundMe.waitForDeployment();
    console.log(
      `contract has been deployed successfully, contract address is ${fundMe.target}`
    );
    if (
      hre.network.config.chainId == 11155111 &&
      process.env.ETHERSCAN_API_KEY
    ) {
      console.log("Waiting for 5 block confirmations...");
      await fundMe.deploymentTransaction().wait(5); // 等待5个区块确认

      await hre.run("verify:verify", {
        address: fundMe.target,
        constructorArguments: [600],
      });
    } else {
      console.log("not on sepolia network, no need to verify");
    }
  }
);
module.exports = {};
