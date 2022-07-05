import { ethers } from "hardhat";
import { Signer } from "ethers";

const { expect } = require("chai");
const {
  initializeContract,
  getOptionsWithValue,
} = require("./helpers/eve721A");

describe("Mabudachi Contract", function () {
  it("Contract Owner Function Returns Ethers Signer First Addresss", async function () {
    const [owner] = await ethers.getSigners();
    const mabudachiContract = await initializeContract();

    const contractOwner = await mabudachiContract.owner();

    expect(contractOwner).to.equal(owner.address);
  });

  it("Inital Balance of Signer should be 0", async function () {
    const mabudachiContract = await initializeContract();

    const initialBalanceOfSigner = await mabudachiContract.balanceOf(
      mabudachiContract.owner()
    );

    expect(initialBalanceOfSigner).to.equal(0);
  });

  it("Cannot batchMint Before Public Mint Active", async function () {
    const [owner] = await ethers.getSigners();
    const mabudachiContract = await initializeContract();

    await expect(mabudachiContract.regularMint(1)).to.be.revertedWith(
      "Regular Mint Not Enabled"
    );
  });

  it("Cannot regularMint while providing 0 Value", async function () {
    const [owner] = await ethers.getSigners();
    const mabudachiContract = await initializeContract();

    await mabudachiContract.toggleRegularMintEnabled();
    expect(mabudachiContract.regularMint(1)).to.be.revertedWith(
      "Incorrect Price"
    );
  });

  // it("Can batchMint-25 while PublicStage is On and (0.0005*25) Eth is msg.value", async function () {
  //   const mabudachiContract = await initializeContract();;

  //   await mabudachiContract.togglePublicmintStage();

  //   const PublicStagePriceInEther = ethers.utils.formatEther(
  //     String(JSON.parse(await mabudachiContract.publicMintStagePrice()))
  //   );

  //   const batchSize = 25;

  //   const options = await getOptionsWithValue(mabudachiContract,batchSize)

  //   await mabudachiContract.batchMint(batchSize, options);

  //   expect(await mabudachiContract.balanceOf(mabudachiContract.owner())).to.be.equal(
  //     batchSize
  //   );
  // });

  // it("Can not call mintTo without setting mintToCaller", async function () {
  //   const mabudachiContract = await initializeContract();

  //   await mabudachiContract.togglePublicmintStage();

  //   const contractOwnerAddress = await mabudachiContract.owner();

  //   const batchSize =25;
  //   const options = await getOptionsWithValue(mabudachiContract,batchSize)

  //   expect(
  //     mabudachiContract.mintTo(contractOwnerAddress, batchSize, options)
  //   ).to.be.revertedWith("not authorized to call MintTo");
  // });

  // it("Can call mintTo after setting mintToCaller", async function () {

  //   const [owner,addr1,addr2] = await ethers.getSigners();
  //   const mabudachiContract = await initializeContract();

  //   await mabudachiContract.togglePublicmintStage();

  //   const mintToCallerAddress = addr1.address;
  //   const mintToRecieverAddress = addr2.address;

  //   await mabudachiContract.setMintToCaller(mintToCallerAddress);

  //   const batchSize =25;

  //   const options = await getOptionsWithValue(mabudachiContract,batchSize)

  //   await mabudachiContract.connect(addr1).mintTo(mintToRecieverAddress, batchSize, options);

  //   expect(await mabudachiContract.balanceOf(mintToRecieverAddress)).to.be.
  //     equal(batchSize);
  // });
});
