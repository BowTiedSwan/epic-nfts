const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT');
    const nftContract =  await nftContractFactory.deploy();
    await nftContract.deployed();

    console.log("Contract deployed to:", nftContract.address);

    // Call NFT mint function
    let txn = await nftContract.makeAnEpicNFT()
    // Wait fo the NFT to be minted
    await txn.wait();

    // Mint a second NFT
    txn = await nftContract.makeAnEpicNFT()
    // Wait for minting to complete
    await txn.wait();
};


const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (err) {
        console.log(err);
        process.exit(1);
    }
};

runMain();