import React from 'react';
const TradeDisplay = ({ address, forImageValue, havingImageValue, isUserTrade }) => {

  const forImagePath = `./${forImageValue}.png`;
  const havingImagePath = `./${havingImageValue}.png`;

  return (
    <div className={`trade-display ${isUserTrade ? 'basicTrade userTrade' : 'basicTrade otherUserTrade'}`}>
      <p><strong>{address}</strong></p>
      <div className="images-container">
        <div className="image-wrapper">
          <img src={forImagePath} alt="For" />
          <p>For</p>
        </div>
        <div className="image-wrapper">
          <img src={havingImagePath} alt="Having" />
          <p>Having</p>
        </div>
      </div>
    </div>
  );
};

export default TradeDisplay;
