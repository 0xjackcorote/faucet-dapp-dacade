const hre = require("hardhat");

async function main() {
  const Faucet = await hre.ethers.getContractFactory("Faucet");
  const tokenAddress = "0x16289662Ad77589eEDE7F4a4AB8e660e475c790C";
  const faucet = await Faucet.deploy(tokenAddress);

  await faucet.deployed();

  console.log("Faucet contract deployed: ", faucet.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// Faucet contract: 0x3a86071F4470eF6Fa1734c59FC3ea76e191e6486