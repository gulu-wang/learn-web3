const { assert } = require("chai");
describe("test fundme contract", function () {
  it("test owner", async function () {
    const [deployer] = await ethers.getSigners();
    const fundMeFactory = await ethers.getContractFactory("FundMe");
    const fundMe = await fundMeFactory.deploy(300);
    await fundMe.waitForDeployment();
    assert.equal(await fundMe.owner(), deployer.address);
  });
});

// const { assert } = require("chai");
// const { deployments, ethers, getNamedAccounts } = require("hardhat");

// describe("test fundme contract", async function () {
//   let fundMe;
//   let deployer;
//   this.beforeEach(async () => {
//     await deployments.fixture(["all"]);
//     deployer = await getNamedAccounts().deployer;
//     const fundMeDeployment = await deployments.get("FundMe");
//     fundMe = await ethers.getContractAt("FundMe", fundMeDeployment.address);
//   });
//   it("test if the owner is msg.sender", async () => {
//     await fundMe.waitForDeployment();
//     assert.equal(await fundMe.owner(), firstAccount.address);
//   });
// });
