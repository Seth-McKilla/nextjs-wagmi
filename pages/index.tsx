import Image from "next/image";
import { useState } from "react";
import type { NextPage } from "next";
import { useAccount, useBalance } from "wagmi";
import { Button, Layout, WalletOptionsModal } from "../components";

const Home: NextPage = () => {
  const [showWalletOptions, setShowWalletOptions] = useState(false);
  const [{ data: accountData }] = useAccount();
  const [{ data: balanceData }] = useBalance({
    addressOrName: accountData?.address,
  });

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
              {accountData
                ? "Account Details"
                : "Welcome to the NextJS wagmi template!"}
            </h1>
            {accountData && balanceData ? (
              <>
                <h6 className="text-2xl mb-2">{`Wallet Address: ${accountData.address}`}</h6>
                <div className="inline-flex place-items-center">
                  <Image
                    src={
                      "https://ethereum.org/static/6b935ac0e6194247347855dc3d328e83/cdbe4/eth-diamond-black.webp"
                    }
                    alt="ETH Diamond"
                    width={40}
                    height={65}
                  />
                  <h6 className="text-2xl ml-2">{`${Number(
                    balanceData.formatted
                  ).toFixed(4)} Ether`}</h6>
                </div>
              </>
            ) : (
              <Button onClick={() => setShowWalletOptions(true)}>
                Connect to Wallet
              </Button>
            )}
          </div>
        </div>
      </Layout>
    </>
  );
};

export default Home;
