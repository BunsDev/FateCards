import BottomImage from "./BottomImage.js";
import { ethers } from "ethers";
export default function Reveal({ addr, cardContract, mainContract }) {

    const imageRev = (cardID) => {
        console.log("received", cardID);
        const imageName = `${cardID.toString()}.png`;
        const imagePath = `./${imageName}`; 
        document.getElementById('fateImage').src = imagePath;
    }

    const handleReveal = async () => {
        try {
            const response = await mainContract.revealFate();
            const card = await response.wait();
            if (card) {
                const id = await mainContract.getLatestCard(addr);
                imageRev(id);

            }
        } catch (error) {
            console.error("Error revealing:", error.message);
        }
    }


    return (
        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center' }}>
            <BottomImage imageUrl="./reveal.png" />
            <img onClick={handleReveal} src="./cardBack.png" id="fateImage" alt="Fate photo" className="centered revealImage reveal-button" />
        </div>
    )
}
