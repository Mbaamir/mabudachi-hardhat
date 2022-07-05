const { ethers } = require("hardhat");

export async function initializeContract () {

    const mabudachiContract = await ethers.getContractFactory("Mabudachi");
    const mabudachiDeployed = await mabudachiContract.deploy();
    return mabudachiDeployed;

}