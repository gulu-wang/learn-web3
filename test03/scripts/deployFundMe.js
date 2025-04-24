// 导入ethers包
// 创建部署脚本
// 执行脚本进行部署

const { ethers } = require("hardhat");
async function main() {
  // 创建一个合约工厂函数
  const fundMeFactory = await ethers.getContractFactory("FundMe");
  console.log("Deploying...");

  // 使用工厂函数创建一个合约实例
  const fundMe = await fundMeFactory.deploy(300);
  await fundMe.waitForDeployment();
  console.log(
    `contract has been deployed successfully, contract address is ${fundMe.target}`
  );
  if (hre.network.config.chainId == 11155111 && process.env.ETHERSCAN_API_KEY) {
    console.log("Waiting for 5 block confirmations...");
    await fundMe.deploymentTransaction().wait(5); // 等待5个区块确认

    await hre.run("verify:verify", {
      address: fundMe.target,
      constructorArguments: [300],
    });
  } else {
    console.log("not on sepolia network, no need to verify");
  }

  // 初始化两个合约
  const [firstAccount, secondAccount] = await ethers.getSigners();
  // 用第一个账户向合约转账0.1个ETH
  const fundTx = await fundMe.fund({
    value: ethers.parseEther("0.1"),
  });
  await fundTx.wait();

  // check balance of the contract
  const balance1 = await ethers.provider.getBalance(fundMe.target);
  console.log(`contract balance is ${ethers.formatEther(balance1)}`);

  // 用第二个账户向合约转账0.2个ETH
  const fundTx2 = await fundMe.connect(secondAccount).fund({
    value: ethers.parseEther("0.2"),
  });
  await fundTx2.wait();
  // check balance of the contract
  const balance2 = await ethers.provider.getBalance(fundMe.target);
  console.log(`contract balance is ${ethers.formatEther(balance2)}`);

  fundMe.funds(firstAccount.address).then((fund) => {
    console.log(`first account funds is ${ethers.formatEther(fund)}`);
  });
  fundMe.funds(secondAccount.address).then((fund) => {
    console.log(`second account funds is ${ethers.formatEther(fund)}`);
  });
}

main()
  .then()
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
