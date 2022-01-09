import { useState } from "react";
import type { NextPage } from "next";
import { Button, Layout, WalletOptionsModal } from "../components";

const Home: NextPage = () => {
  const [showWalletOptions, setShowWalletOptions] = useState(false);

  return (
    <>
      <WalletOptionsModal
        open={showWalletOptions}
        setOpen={setShowWalletOptions}
      />

      <Layout>
        <div className="grid place-items-center h-screen">
          <div className="grid place-items-center">
            <h1 className="text-4xl font-bold mb-8">
              Welcome to the NextJS wagmi template!
            </h1>
            <Button onClick={() => setShowWalletOptions(true)}>
              Connect to Wallet
            </Button>
          </div>
        </div>
      </Layout>
    </>
  );
};

export default Home;
