import { ethers } from "hardhat";

async function main() {
  const BasicSFTContract = await ethers.getContractFactory("BasicSFT");
  const BasicSFT = await BasicSFTContract.deploy();

  await BasicSFT.deployed();

  console.log(`Deployed to ${BasicSFT.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
