module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deployer, user1 } = await getNamedAccounts();

  await deployments.deploy("FundMe", {
    from: deployer,
    args: [300],
    log: true,
  });
};

module.exports.tags = ["all", "fundme"];
