import React, { useState, useEffect } from "react";
import { ethers } from "ethers";
import Chart from "chart.js/auto";
import "./style.css";

const CONTRACT_ABI = [
    // Add your contract's ABI here
];
const CONTRACT_ADDRESS = "YOUR_CONTRACT_ADDRESS";

function App() {
    const [provider, setProvider] = useState(null);
    const [signer, setSigner] = useState(null);
    const [contract, setContract] = useState(null);
    const [tokens, setTokens] = useState([]);
    const [metadataURI, setMetadataURI] = useState("");
    const [votingData, setVotingData] = useState({ yes: 0, no: 0, abstain: 0 });

    useEffect(() => {
        async function connectWallet() {
            if (window.ethereum) {
                const tempProvider = new ethers.providers.Web3Provider(window.ethereum);
                const tempSigner = tempProvider.getSigner();
                const tempContract = new ethers.Contract(CONTRACT_ADDRESS, CONTRACT_ABI, tempSigner);
                setProvider(tempProvider);
                setSigner(tempSigner);
                setContract(tempContract);
            } else {
                alert("Please install MetaMask to use this dApp!");
            }
        }
        connectWallet();
    }, []);

    const mintNFT = async () => {
        if (!metadataURI) {
            alert("Please enter a valid metadata URI");
            return;
        }
        try {
            const recipient = await signer.getAddress();
            const tx = await contract.mint(recipient, metadataURI);
            await tx.wait();
            alert("NFT Minted!");
            setMetadataURI("");
            fetchTokens();
        } catch (error) {
            console.error(error);
            alert("Error minting NFT!");
        }
    };

    const updateNFTMetadata = async (tokenId) => {
        try {
            const newMetadataURI = generateChartURI();
            const tx = await contract.updateMetadata(tokenId, newMetadataURI);
            await tx.wait();
            alert(`Metadata for Token #${tokenId} updated!`);
            fetchTokens();
        } catch (error) {
            console.error(error);
            alert("Error updating metadata!");
        }
    };

    const generateChartURI = () => {
        const canvas = document.createElement("canvas");
        new Chart(canvas, {
            type: "pie",
            data: {
                labels: ["Yes Votes", "No Votes", "Abstain"],
                datasets: [
                    {
                        data: [votingData.yes, votingData.no, votingData.abstain],
                        backgroundColor: ["#4CAF50", "#FF5252", "#9E9E9E"],
                    },
                ],
            },
        });
        return canvas.toDataURL("image/png");
    };

    const fetchTokens = async () => {
        try {
            const totalSupply = await contract.tokenIdCounter();
            const tokenList = [];
            for (let i = 0; i < totalSupply; i++) {
                const owner = await contract.ownerOf(i);
                const uri = await contract.tokenMetadataURIs(i);
                tokenList.push({ id: i, owner, uri });
            }
            setTokens(tokenList);
        } catch (error) {
            console.error(error);
        }
    };

    useEffect(() => {
        if (contract) fetchTokens();
    }, [contract]);

    return (
        <div className="app">
            <header>
                <h1>Dynamic NFT Governance dApp</h1>
            </header>
            <main>
                <div className="mint-section">
                    <h2>Mint a New NFT</h2>
                    <input
                        type="text"
                        placeholder="Enter metadata URI (e.g., IPFS link)"
                        value={metadataURI}
                        onChange={(e) => setMetadataURI(e.target.value)}
                    />
                    <button onClick={mintNFT}>Mint NFT</button>
                </div>
                <div className="voting-section">
                    <h2>Vote and Update Metadata</h2>
                    <label>
                        Yes Votes:
                        <input
                            type="number"
                            value={votingData.yes}
                            onChange={(e) => setVotingData({ ...votingData, yes: e.target.value })}
                        />
                    </label>
                    <label>
                        No Votes:
                        <input
                            type="number"
                            value={votingData.no}
                            onChange={(e) => setVotingData({ ...votingData, no: e.target.value })}
                        />
                    </label>
                    <label>
                        Abstain:
                        <input
                            type="number"
                            value={votingData.abstain}
                            onChange={(e) => setVotingData({ ...votingData, abstain: e.target.value })}
                        />
                    </label>
                    <button onClick={() => updateNFTMetadata(0)}>Update Metadata</button>
                </div>
                <div className="tokens-section">
                    <h2>Your NFTs</h2>
                    <div className="tokens-container">
                        {tokens.map((token) => (
                            <div className="token-card" key={token.id}>
                                <h3>Token #{token.id}</h3>
                                <p>Owner: {token.owner}</p>
                                <p>Metadata URI: {token.uri}</p>
                                <img src={token.uri} alt={`Token ${token.id}`} />
                            </div>
                        ))}
                    </div>
                </div>
            </main>
        </div>
    );
}

export default App;
