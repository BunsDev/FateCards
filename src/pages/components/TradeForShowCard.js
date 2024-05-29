import React from 'react';

const TradeForShowCard = ({ player, cardId1, cardId2, tradeId }) => {
    return (
        <div className="trade-for-show-card">
            <div className="player-address">{player}</div>
            <div className="trade-id">Trade ID: {tradeId.toString()}</div>
            <div className="card-images">
                <div className="card-item">
                    <p className="card-label">Having</p>
                    <img src={`/${cardId1}.png`} alt={`Card ${cardId1}`} className="card-image" />
                </div>
                <div className="card-item">
                    <p className="card-label">For</p>
                    <img src={`/${cardId2}.png`} alt={`Card ${cardId2}`} className="card-image" />
                </div>
            </div>
        </div>
    );
};

export default TradeForShowCard;
