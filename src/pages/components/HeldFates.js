import React, { useState, useEffect } from 'react';
import BottomImage from "./BottomImage.js";
import ImageDisplay from "./ImageDisplay"; 

export default function HeldFates({ signer, cardContract }) {
    const [cards, setCards] = useState([]);

    useEffect(() => {
        async function fetchData() {
            try {
                const cardValues = await cardContract.getListOfAllHeldCard(signer.getAddress());
                setCards(cardValues);

            } catch (error) {
                console.error('Error fetching data:', error.message);
            }
        }

        fetchData(); 
    }, [signer, cardContract]); 

    const getList = () => {
        var arr = [];
        for (var i = 0; i < cards.length; i++) {
            arr.push(cards[i].length);
        }
        return arr;
    }

    return (
        <div>
            <div className='darkened'>
                <BottomImage imageUrl="./fortuneTable.png" />
            </div>

            <div id="image-container">
                {cards.map((cardCounts, index) => (
                    <div key={index}>
                        {Array(getList()[index]).fill().map((_, i) => (
                            <ImageDisplay key={i} src={`${index}.png`} />
                        ))}
                    </div>
                ))}
            </div>
        </div>
    );
}
