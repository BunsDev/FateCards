import React from 'react';

const ShiningStar = ({ onClick,className, style }) => {
    return (
        <div
            className={className}
            onClick={onClick}
            style={style}
        ></div>
    );
};

export default ShiningStar;
