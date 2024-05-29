import React, { useState, useEffect } from 'react';
import BottomImage from "./BottomImage.js";
import CustomDropdown from "./CustomDropdown";
import { ethers } from "ethers";
import TradeDisplay from "./TradeDisplay";

export default function Trade({ cardContract, mainContract }) {
    const [trading, setTrading] = useState(null);
    const [address, setAddress] = useState('');
    const [selectedCardFor, setSelectedCardFor] = useState([]);
    const [selectedCardHaving, setSelectedCardHaving] = useState([]);
    const [cards, setCards] = useState([]);
    const [userTrade, setUserTrade] = useState(null);
    const [otherUserTrade, setOtherUserTrade] = useState(null);

    useEffect(() => {
        checkTrade();
        fetchCardData();
    }, []);

    const checkTrade = async () => {
        const [trade1, trade2] = await mainContract.viewTrade();
        const userHasTrade = trade1.user1 !== ethers.ZeroAddress;
        const otherUserHasTrade = trade2.user1 !== ethers.ZeroAddress;

        setUserTrade(userHasTrade ? trade1 : null);
        setOtherUserTrade(otherUserHasTrade ? trade2 : null);
        setTrading(userHasTrade || otherUserHasTrade);
    };

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

    const handleSubmit = async () => {
        if (selectedCardFor.length !== 1 || selectedCardHaving.length !== 1) {
            alert("Please select exactly one card for each field.");
            return;
        }

        const cardId1 = selectedCardFor[0];
        const cardId2 = selectedCardHaving[0];

        try {
            const tx = await mainContract.trade(address, cardId1, cardId2);
            await tx.wait();
            await checkTrade();
        } catch (error) {
            console.error("Error calling contract function:", error.message);
        }
    };

    const handleConfirmTrade = async () => {
        const tx = await mainContract.confirmTrade();
        await tx.wait();
        await checkTrade();
    };

    const handleCancelTrade = async () => {
        const tx = await mainContract.cancelTrade();
        await tx.wait();
        await checkTrade();
    };

    return (
        <div>
            <BottomImage imageUrl="./fateTrade.png" />
            {otherUserTrade && (
                <div>
                    <TradeDisplay
                        address={otherUserTrade.user1}
                        forImageValue={otherUserTrade.cardId2}
                        havingImageValue={otherUserTrade.cardId1}
                        isUserTrade={false}
                    />
                </div>
            )}
            {userTrade ? (
                <div>
                    <div>
                        <TradeDisplay
                            address={userTrade.user1}
                            forImageValue={userTrade.cardId2}
                            havingImageValue={userTrade.cardId1}
                            isUserTrade={true}
                        />
                    </div>
                    {!userTrade.confirm ? (
                        <div className="confirmCancelButtons">
                            <button onClick={handleConfirmTrade} className="tradeButton">Confirm Trade</button>
                            <button onClick={handleCancelTrade} className="tradeButton">Cancel Trade</button>
                        </div>
                    ) : (
                        <p className='tradeConfirmText'>Trade is confirmed by your side</p>
                    )}
                </div>
            ) : (
                <div className="tradeForm">
                    <form id="myForm">
                        <div>
                            <label htmlFor="address">Other Player's address:  </label>
                        </div>
                        <div>
                            <input
                                type="text"
                                id="address"
                                name="address"
                                value={address}
                                onChange={e => setAddress(e.target.value)}
                            />
                        </div>
                        <CustomDropdown
                            label="Select Card You Want:"
                            options={cards}
                            selectedValues={selectedCardFor}
                            onChange={(values) => setSelectedCardFor(values)}
                        />
                        <CustomDropdown
                            label="Select Card You Have:"
                            options={cards}
                            selectedValues={selectedCardHaving}
                            onChange={(values) => setSelectedCardHaving(values)}
                        />
                        <button type="button" onClick={handleSubmit} className="tradeButton">Submit</button>
                    </form>
                </div>
            )}
        </div>
    );
}