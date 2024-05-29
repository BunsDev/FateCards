import React, { useState } from "react";
import LoginPage from "./LoginPage";
import Stars from "./Stars";
import { ethers } from "ethers";
import mainABI from "./mainABI.json";
import cardABI from "./cardABI.json";
import nftABI from "./nftABI.json";
require('dotenv').config();

export default function Home() {
  const [connectedWallet, setConnectedWallet] = useState(null);
  const [login, setLogin] = useState(0);
  const [signer, setSigner] = useState(null);
  const [nftContract, setNftContract] = useState(null);
  const [cardContract, setCardContract] = useState(null);
  const [mainContract, setMainContract] = useState(null);

  const handleInitialization = async () => {
    try {
      if (window.ethereum) {
        await window.ethereum.request({ method: "eth_requestAccounts" });
        const provider = new ethers.BrowserProvider(window.ethereum);
        const signer = await provider.getSigner();
        const address = await signer.getAddress();
        setSigner(signer);
        setConnectedWallet(address);

        // Enter addresses here
        const NFTC_ADDRESS = "";
        const CARDC_ADDRESS = "";
        const MAINC_ADDRESS = "";

        const nftContract = new ethers.Contract(NFTC_ADDRESS, nftABI, signer);
        const cardContract = new ethers.Contract(CARDC_ADDRESS, cardABI, signer);
        const mainContract = new ethers.Contract(MAINC_ADDRESS, mainABI, signer);

        setNftContract(nftContract);
        setCardContract(cardContract);
        setMainContract(mainContract);

      } else {
        setLogin(2);
        throw new Error("MetaMask not installed");
      }
    } catch (error) {
      console.log("Error in initialization:", error);
    }
  }

  const loginFunc = async () => {
    try {
      console.log("User logged in!");
      setLogin(1);
    }

    catch (error) {
      console.error("Error connecting wallet:", error.message);
    }
  }

  const checkInit = async () => {
    if (connectedWallet === null || mainContract === null || nftContract === null || cardContract === null) {
      await new Promise(resolve => setTimeout(resolve, 1000));
      checkInit();
    } else {
      loginFunc();
    }
  }

  const handleLogin = async () => {
    await handleInitialization();
    checkInit();
  }

  return (
    <main>
      {login === 0 && <LoginPage onLogin={handleLogin} />}
      {login === 1 && signer && nftContract && cardContract && mainContract && (
        <Stars signer={signer} nftContract={nftContract} cardContract={cardContract} mainContract={mainContract} />
      )}
      {login === 2 && (
        <>
          <LoginPage onLogin={handleLogin} />
          <h1
            style={{
              color: "white",
              position: "fixed",
              bottom: 0,
              left: 0,
              width: "100%",
              backgroundColor: "black",
              textAlign: "center",
              padding: "10px",
            }}
            className="sparkle"
          >
            Please Install Metamask
          </h1>
        </>
      )}
    </main>
  );
}
