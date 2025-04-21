const { task } = require("hardhat/config");

task("interact-fundme", "interact with fundme contract")
  .addParam("addr", "fundme contract addr")
  .setAction(async (taskArgs, hre) => {
    const fundMeFactory = await ethers.getContractFactory("FundMe");
    const fundMe = await fundMeFactory.attach(taskArgs.addr);
    // 初始化两个合约
    const [firstAccount, secondAccount] = await ethers.getSigners();
    // 用第一个账户向合约转账0.1个ETH
    const fundTx = await fundMe.fund({
      value: ethers.parseEther("0.5"),
    });
    await fundTx.wait();

    // check balance of the contract
    const balance1 = await ethers.provider.getBalance(fundMe.target);
    console.log(`contract balance is ${ethers.formatEther(balance1)}`);

    // 用第二个账户向合约转账0.2个ETH
    const fundTx2 = await fundMe.connect(secondAccount).fund({
      value: ethers.parseEther("0.5"),
    });
    await fundTx2.wait();
    // check balance of the contract
    const balance2 = await ethers.provider.getBalance(fundMe.target);
    console.log(`contract balance is ${ethers.formatEther(balance2)}`);

    await fundMe.funds(firstAccount.address).then((fund) => {
      console.log(`first account funds is ${ethers.formatEther(fund)}`);
    });
    await fundMe.funds(secondAccount.address).then((fund) => {
      console.log(`second account funds is ${ethers.formatEther(fund)}`);
    });
  });

module.exports = {};
