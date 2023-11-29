const hre = require("hardhat");

async function main() {
  const FaucetToken = await hre.ethers.getContractFactory("FaucetToken");
  const faucetToken = await FaucetToken.deploy(100000000, 50);

  await faucetToken.deployed();

  console.log("Faucet Token deployed: ", faucetToken.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// Token contract: 0x16289662Ad77589eEDE7F4a4AB8e660e475c790C
