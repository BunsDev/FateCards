import React from 'react';

const ImageDisplay = ({ src }) => {
    return (
        <div className="image-display-container">
            <img className="image-display" src={src} alt="Image" />
        </div>
    );
}

export default ImageDisplay;
