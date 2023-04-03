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

  describe("Unsubscribing from feeds", function () {
    it("Should unsubscribe the caller from a feed", async function () {
      const feedUrl = "https://example.com/feed1.xml";
      await feedFanToken.connect(addr1).subscribe(feedUrl);
      await feedFanToken.connect(addr1).unsubscribe(1);
      expect(await feedFanToken.isSubscribed(1, addr1Address)).to.be.false;
    });

    it("Should not unsubscribe the caller if not subscribed", async function () {
      await expect(feedFanToken.connect(addr1).unsubscribe(1)).to.be.revertedWith("Not subscribed to the feed");
    });
  });

  describe("Getting feed URL and ID", function () {
    it("Should return the correct feed URL", async function () {
      const feedUrl = "https://example.com/feed1.xml";
      await feedFanToken.connect(addr1).subscribe(feedUrl);
      expect(await feedFanToken.getFeedUrl(1)).to.equal(feedUrl);
    });

    it("Should return the correct feed ID", async function () {
      const feedUrl = "https://example.com/feed1.xml";
      await feedFanToken.connect(addr1).subscribe(feedUrl);
      expect(await feedFanToken.getFeedId(feedUrl)).to.equal(1);
    });

    it("Should return 0 for a non-existent feed URL", async function () {
      expect(await feedFanToken.getFeedId("https://nonexistent.com/feed.xml")).to.equal(0);
    });
  });

  describe("Updating and getting last feed checked timestamp", function () {
    it("Should update the last feed checked timestamp", async function () {
      const feedUrl = "https://example.com/feed1.xml";
      await feedFanToken.connect(addr1).subscribe(feedUrl);
      await feedFanToken.connect(addr1).touchFeedLastCheckedAt(1);
      const lastCheckedAt = await feedFanToken.getLastFeedCheckedAt(1, addr1Address);
      expect(lastCheckedAt).to.be.closeTo(Math.floor(Date.now() / 1000), 30);
    });

    it("Should not update the last feed checked timestamp if not subscribed", async function () {
      await expect(feedFanToken.connect(addr1).touchFeedLastCheckedAt(1)).to.be.revertedWith("You are not subscribed to the feed");
    });

    it("Should return the last feed checked timestamp", async function () {
      const feedUrl = "https://example.com/feed1.xml";
      await feedFanToken.connect(addr1).subscribe(feedUrl);
      const initialTimestamp = await feedFanToken.getLastFeedCheckedAt(1, addr1Address);
      expect(initialTimestamp).to.equal(0);
      await feedFanToken.connect(addr1).touchFeedLastCheckedAt(1);
      const updatedTimestamp = await feedFanToken.getLastFeedCheckedAt(1, addr1Address);
      expect(updatedTimestamp).to.be.closeTo(Math.floor(Date.now() / 1000), 30);
    });

    it("Should not return the last feed checked timestamp if not subscribed", async function () {
      await expect(feedFanToken.getLastFeedCheckedAt(1, addr1Address)).to.be.revertedWith("The user is not subscribed to the feed");
    });
  });
});
