const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("XBM Token", function () {
  let xbm;
  let owner;
  let addr1;
  let addr2;

  const TOTAL_SUPPLY = ethers.parseUnits("410000000", 18);

  beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();
    
    const XBM = await ethers.getContractFactory("XBM");
    xbm = await XBM.deploy(owner.address);
    await xbm.waitForDeployment();
  });

  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      expect(await xbm.owner()).to.equal(owner.address);
    });

    it("Should assign the total supply to the owner", async function () {
      const ownerBalance = await xbm.balanceOf(owner.address);
      expect(await xbm.totalSupply()).to.equal(ownerBalance);
      expect(ownerBalance).to.equal(TOTAL_SUPPLY);
    });

    it("Should have correct name and symbol", async function () {
      expect(await xbm.name()).to.equal("XBM");
      expect(await xbm.symbol()).to.equal("XBM");
      expect(await xbm.decimals()).to.equal(18);
    });
  });

  describe("Transfers", function () {
    it("Should transfer tokens between accounts", async function () {
      const amount = ethers.parseUnits("1000", 18);
      await xbm.transfer(addr1.address, amount);
      expect(await xbm.balanceOf(addr1.address)).to.equal(amount);
    });

    it("Should fail if sender doesn't have enough tokens", async function () {
      const initialOwnerBalance = await xbm.balanceOf(owner.address);
      await expect(
        xbm.connect(addr1).transfer(owner.address, 1)
      ).to.be.reverted;
      expect(await xbm.balanceOf(owner.address)).to.equal(initialOwnerBalance);
    });
  });

  describe("Pause functionality", function () {
    it("Should pause and unpause transfers", async function () {
      await xbm.pause();
      await expect(
        xbm.transfer(addr1.address, 100)
      ).to.be.revertedWithCustomError(xbm, "EnforcedPause");
      
      await xbm.unpause();
      await xbm.transfer(addr1.address, 100);
      expect(await xbm.balanceOf(addr1.address)).to.equal(100);
    });

    it("Only owner can pause", async function () {
      await expect(
        xbm.connect(addr1).pause()
      ).to.be.revertedWithCustomError(xbm, "OwnableUnauthorizedAccount");
    });
  });

  describe("Recovery", function () {
    it("Should recover ETH", async function () {
      await owner.sendTransaction({
        to: await xbm.getAddress(),
        value: ethers.parseEther("1.0")
      });
      
      const ownerBalanceBefore = await ethers.provider.getBalance(owner.address);
      await xbm.recoverETH();
      const ownerBalanceAfter = await ethers.provider.getBalance(owner.address);
      
      expect(ownerBalanceAfter).to.be.gt(ownerBalanceBefore);
    });
  });
});
