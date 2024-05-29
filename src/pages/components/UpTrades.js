import BottomImage from "./BottomImage";
import { useState, useEffect } from "react";
import CustomDropdown from "./CustomDropdown";
import TradeForShowCard from "./TradeForShowCard";

export default function UpTrades({ signer, nftContract, cardContract, mainContract }) {
    const [upTrades, setUpTrades] = useState([]);
    const [selectedCardHave, setSelectedCardHave] = useState([]);
    const [selectedCardWant, setSelectedCardWant] = useState([]);
    const [tId, setTId] = useState('');
    const [cards, setCards] = useState([]);

    useEffect(() => {
        const fetchTrades = async () => {
            try {
                const trades = await mainContract.showAllUpTrades();
                setUpTrades(trades);
            } catch (error) {
                console.error("Error fetching trades:", error.message);
            }
        };
        fetchTrades();

        const fetchCardData = async () => {
            try {
                const uris = await cardContract.getNumberOfUris();
                const cardData = [];

                for (let i = 0; i < uris; i++) {
                    cardData.push({ id: i, imageUrl: `/${i}.png` });
                }

                setCards(cardData);
            } catch (error) {
                console.error("Failed to fetch card data:", error);
            }
        };
        fetchCardData();
    }, [mainContract]);

    const handleSubmit = async (e) => {
        e.preventDefault();
        if (selectedCardHave.length !== 1 || selectedCardWant.length !== 1) {
            alert("Please select exactly one card for each dropdown.");
            return;
        }
        const cardIdHave = selectedCardHave[0];
        const cardIdWant = selectedCardWant[0];
        try {
            const tx = await mainContract.showATrade(cardIdHave, cardIdWant);
            await tx.wait();
            console.log("Trade put up successfully");

            const trades = await mainContract.showAllUpTrades();
            setUpTrades(trades);
        } catch (error) {
            console.error("Error putting up trade:", error.message);
        }
    }

    const handleTradeDown = async (e) => {
        e.preventDefault();
        try {
            const tx = await mainContract.putDownATrade(tId - 1);
            await tx.wait();
            console.log("Trade put down successfully");

            const trades = await mainContract.showAllUpTrades();
            setUpTrades(trades);
        } catch (error) {
            console.error("Error putting down trade:", error.message);
        }
    }
    return (
        <div className="trades-container">
            <BottomImage imageUrl="./tellerPlace.png" />
            <div className="uptradeform">
                <h1 className="upHead">Put up a Trade</h1>
                <form onSubmit={handleSubmit}>
                    <CustomDropdown
                        label="Select Card You Have"
                        options={cards}
                        selectedValues={selectedCardHave}
                        onChange={setSelectedCardHave}
                    />
                    <CustomDropdown
                        label="Select Card You Want"
                        options={cards}
                        selectedValues={selectedCardWant}
                        onChange={setSelectedCardWant}
                    />
                    <button className="upTradeButton" type="submit">Submit</button>
                </form>
            </div>

            <div className="uptradeform">
                <h1 className="upHead">Put your trade down</h1>
                <form onSubmit={handleTradeDown}>
                    <label htmlFor="tId">Trade ID:</label>
                    <input className="upTradeInput"
                        type="number"
                        id="tId"
                        value={tId}
                        min="1"
                        onChange={(e) => {
                            const value = e.target.value;
                            if (/^[1-9]\d*$/.test(value) || value === "") {
                                setTId(value);
                            }
                        }}
                    />
                    <button className="upTradeButton" type="submit">Put Trade Down</button>
                </form>
            </div>

            <div className="exchangeableFates">
                <h1 className="upHead">All Exchangeable Fates</h1>
                <div className="trades-list">
                    {upTrades.map((trade, index) => (
                        trade.tradeId != 0 && (
                            <TradeForShowCard
                                key={index}
                                player={trade.player}
                                cardId1={trade.cardId1}
                                cardId2={trade.cardId2}
                                tradeId={trade.tradeId}
                            />
                        )
                    ))}
                </div>
            </div>
        </div>
    );
}    