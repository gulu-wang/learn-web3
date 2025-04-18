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

  await hre.run("verify:verify", {
    address: fundMe.target,
    constructorArguments: [300],
  });
}

main()
  .then()
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
