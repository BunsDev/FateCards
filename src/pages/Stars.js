
import React, { useState, useContext, useEffect } from 'react';
import BottomImage from "./components/BottomImage";
import Trade from "./components/Trade";
import UpTrades from "./components/UpTrades";
import HeldFates from "./components/HeldFates";
import ShiningStar from './components/ShiningStar';
import Reveal from './components/Reveal';


export default function Stars({ signer, nftContract, cardContract, mainContract }) {
    const [activeComponent, setActiveComponent] = useState(null);
    const [addr, setAddr] = useState('');

    useEffect(() => {
        async function initAddr() {
            try {
                const address = await signer.getAddress();
                setAddr(address);
            } catch (error) {
                console.error('Error setting addr:', error.message);
            }
        }

        initAddr();
    }, []);

    const canReveal = async () => {
        const canReveal = await mainContract.claimed(signer.getAddress());
        await canReveal.wait();
        return canReveal();
    };

    const handleShineClick = (component) => {
        setActiveComponent(component);
    };

    const handleReturnBack = () => {
        setActiveComponent(null);
    };



    return (
        <div>
            <BottomImage imageUrl="./stars.png" />

            {!activeComponent && (
                <div>
                    <ShiningStar onClick={() => handleShineClick(<Trade signer={signer} cardContract={cardContract} mainContract={mainContract} />)} className="sparkle" style={{ backgroundColor: "blue", width: 100, height: 100, position: "absolute", top: 100, left: 1550 }} />
                    <ShiningStar onClick={() => handleShineClick(<UpTrades signer={signer} nftContract={nftContract} cardContract={cardContract} mainContract={mainContract} />)} className="sparkle" style={{ backgroundColor: "violet", width: 100, height: 100, position: "absolute", top: 750, left: 1200 }} />
                    <ShiningStar onClick={() => handleShineClick(<HeldFates signer={signer} cardContract={cardContract} />)} className="sparkle" style={{ backgroundColor: "pink", width: 100, height: 100, position: "absolute", top: 450, left: 900 }} />
                    {canReveal && <ShiningStar onClick={() => handleShineClick(<Reveal addr={addr} cardContract={cardContract} mainContract={mainContract} />)} className="sparkle" style={{ backgroundColor: "purple", width: 100, height: 100, position: "absolute", top: 700, left: 650 }} />}
                </div>
            )}

            {activeComponent && (
                <div>
                    <button onClick={handleReturnBack} className='back-button'>Return Back</button>
                    {activeComponent}
                </div>
            )}
        </div>
    );
}