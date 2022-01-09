import Head from "next/head";
import Image from "next/image";
import { ReactNode, useState } from "react";
import { Button, MenuDropdown, WalletOptionsModal } from "..";
import { useAccount } from "wagmi";

export default function Layout({ children }: { children: ReactNode }) {
  const [showWalletOptions, setShowWalletOptions] = useState(false);
  const [{ data: accountData }, disconnect] = useAccount({
    fetchEns: true,
  });

  const renderLabel = () => {
    if (accountData?.ens) {
      return (
        <>
          {accountData.ens.avatar && (
            <div className="h-8 w-8 relative mr-2">
              <Image
                src={accountData?.ens.avatar}
                alt="ENS Avatar"
                layout="fill"
                objectFit="cover"
                className="rounded-full"
              />
            </div>
          )}
          <span className="truncate max-w-[100px]">
            {accountData.ens?.name}
          </span>
        </>
      );
    }

    return (
      <span className="truncate max-w-[150px]">{accountData?.address}</span>
    );
  };

  const renderButton = () => {
    if (accountData) {
      return (
        <MenuDropdown
          label={renderLabel()}
          options={[{ label: "Disconnect", onClick: disconnect }]}
        />
      );
    }

    return <Button onClick={() => setShowWalletOptions(true)}>Connect</Button>;
  };

  return (
    <div>
      <Head>
        <title>NextJS wagmi</title>
        <meta name="description" content="NextJS and wagmi template" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <WalletOptionsModal
        open={showWalletOptions}
        setOpen={setShowWalletOptions}
      />

      <div className="bg-gradient-to-r from-blue-500 to-blue-100 absolute w-screen">
        <div className="flex items-center justify-between p-4">
          <div className="flex items-center">
            <h4 className="text-2xl font-bold text-white cursor-default">
              NextJS wagmi
            </h4>
          </div>
          {renderButton()}
        </div>
      </div>
      {children}
    </div>
  );
}
