import React from 'react';

const BottomImage = ({ imageUrl }) => {
    const containerStyle = {
        position: 'fixed',
        bottom: 0,
        left: 0,
        width: '100%',
        height: '100%',
        zIndex: -1,
    };

    const blackBackgroundStyle = {
        position: 'absolute',
        top: 0,
        left: 0,
        width: '100%',
        height: '100%',
        backgroundColor: 'black',
        zIndex: -2,
    };

    const imageStyle = {
        maxWidth: '100%',
        maxHeight: '100%',
        display: 'block',
        margin: 'auto',
        position: 'relative',
        zIndex: -1,
    };

    return (
        <div style={containerStyle}>
            <div style={blackBackgroundStyle}></div>
            <img src={imageUrl} alt="Bottom Image" style={imageStyle} />
        </div>
    );
};

export default BottomImage;
