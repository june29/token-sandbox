import { ethers } from "hardhat";
import { expect } from "chai";
import { Contract } from "@ethersproject/contracts";
import { Signer } from "@ethersproject/abstract-signer";

describe("FeedFanToken", function () {
  let FeedFanToken;
  let feedFanToken: Contract;
  let owner: Signer;
  let addr1: Signer;
  let addr2: Signer;
  let ownerAddress: string;
  let addr1Address: string;
  let addr2Address: string;

  beforeEach(async function () {
    FeedFanToken = await ethers.getContractFactory("FeedFanToken");
    [owner, addr1, addr2] = await ethers.getSigners();
    ownerAddress = await owner.getAddress();
    addr1Address = await addr1.getAddress();
    addr2Address = await addr2.getAddress();
    feedFanToken = await FeedFanToken.deploy();
  });

  describe("Subscribing to feeds", function () {
    it("Should subscribe the caller to a new feed", async function () {
      const feedUrl = "https://example.com/feed1.xml";
      await feedFanToken.connect(addr1).subscribe(feedUrl);
      expect(await feedFanToken.isSubscribed(1, addr1Address)).to.be.true;
    });

    it("Should not subscribe the caller to an existing feed", async function () {
      const feedUrl = "https://example.com/feed1.xml";
      await feedFanToken.connect(addr1).subscribe(feedUrl);
      await expect(feedFanToken.connect(addr1).subscribe(feedUrl)).to.be.revertedWith("Already subscribed");
    });

    it("Should subscribe multiple users to the same feed", async function () {
      const feedUrl = "https://example.com/feed1.xml";
      await feedFanToken.connect(addr1).subscribe(feedUrl);
      await feedFanToken.connect(addr2).subscribe(feedUrl);
      expect(await feedFanToken.isSubscribed(1, addr1Address)).to.be.true;
      expect(await feedFanToken.isSubscribed(1, addr2Address)).to.be.true;
    });
  });

  // Add more test cases here
});
