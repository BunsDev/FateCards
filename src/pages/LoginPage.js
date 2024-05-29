import React from 'react';
import BottomImage from "./components/BottomImage";
import ShiningStar from './components/ShiningStar';

const LoginPage = ({ onLogin }) => {
  const handleShiningStarClick = () => {
    onLogin();
  };

  return (
    <div style={{ position: 'relative', width: '100%', height: '100vh' }}>
      <BottomImage imageUrl="./orb.png" />
      <div style={{ position: 'absolute', top: '47.50%', left: '48.60%', transform: 'translate(-50%, -50%)' }}>
        <ShiningStar onClick={handleShiningStarClick} className="shine" style={{ backgroundColor: "white" }} />
      </div>
    </div>
  );
};

export default LoginPage;
