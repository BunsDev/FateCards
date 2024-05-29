import React, { useState, useRef, useEffect } from 'react';

const CustomDropdown = ({ options, selectedValues, onChange, label }) => {
    const [isOpen, setIsOpen] = useState(false);
    const dropdownRef = useRef(null);

    const handleOptionClick = (value) => {
        let newSelectedValues;
        if (selectedValues.includes(value)) {
            newSelectedValues = selectedValues.filter(v => v !== value);
        } else {
            newSelectedValues = [value]; 
        }
        onChange(newSelectedValues);
        setIsOpen(false); 
    };

    const handleClickOutside = (event) => {
        if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
            setIsOpen(false);
        }
    };

    useEffect(() => {
        document.addEventListener('mousedown', handleClickOutside);
        return () => {
            document.removeEventListener('mousedown', handleClickOutside);
        };
    }, []);

    return (
        <div className="custom-dropdown" ref={dropdownRef}>
            <label>{label}</label>
            <div className="dropdown-selected" onClick={() => setIsOpen(!isOpen)}>
                {selectedValues.length > 0 ? (
                    selectedValues.map(value => (
                        <div key={value} className="dropdown-option">
                            <img src={options.find(option => option.id === value).imageUrl} alt={`Card ${value}`} />
                          
                        </div>
                    ))
                ) : (
                    "Select a card"
                )}
            </div>
            {isOpen && (
                <div className="dropdown-options">
                    {options.map((option) => (
                        <div
                            key={option.id}
                            className="dropdown-option"
                            onClick={() => handleOptionClick(option.id)}
                        >
                            <img src={option.imageUrl} alt={`Card ${option.id}`} />
                          
                        </div>
                    ))}
                </div>
            )}
        </div>
    );
};

export default CustomDropdown;
