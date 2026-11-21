const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  
  console.log("Deploying XBM Token with the account:", deployer.address);
  console.log("Account balance:", (await hre.ethers.provider.getBalance(deployer.address)).toString());

  const XBM = await hre.ethers.getContractFactory("XBM");
  const xbm = await XBM.deploy(deployer.address);
  
  await xbm.waitForDeployment();
  
  const address = await xbm.getAddress();
  console.log("XBM Token deployed to:", address);
  console.log("Total Supply:", await xbm.totalSupply());
  console.log("Owner:", await xbm.owner());
  
  // Optional: Verify on Etherscan
  if (hre.network.name !== "hardhat" && hre.network.name !== "localhost") {
    console.log("Waiting for block confirmations...");
    await xbm.deploymentTransaction().wait(5);
    
    console.log("Verifying contract on Etherscan...");
    try {
      await hre.run("verify:verify", {
        address: address,
        constructorArguments: [deployer.address],
      });
      console.log("Contract verified successfully");
    } catch (error) {
      console.log("Verification failed:", error.message);
    }
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
