import Head from "next/head";
import Image from "next/image";
import { ReactNode } from "react";
import { Button, MenuDropdown, WalletOptionsModal } from "..";
import { useAccount } from "wagmi";

interface Props {
  children: ReactNode;
  showWalletOptions: boolean;
  setShowWalletOptions: (showWalletOptions: boolean) => void;
}

export default function Layout(props: Props) {
  const { children, showWalletOptions, setShowWalletOptions } = props;

  const [{ data: accountData, loading }, disconnect] = useAccount({
    fetchEns: true,
  });

  const renderLabel = () => {
    if (accountData?.ens) {
      return (
        <>
          <div className="relative w-8 h-8 mr-2">
            {accountData.ens.avatar ? (
              <Image
                src={accountData?.ens.avatar}
                alt="ENS Avatar"
                layout="fill"
                objectFit="cover"
                className="rounded-full"
              />
            ) : (
              <Image
                src="/images/black-gradient.png"
                alt="ENS Avatar"
                layout="fill"
                objectFit="cover"
                className="rounded-full"
              />
            )}
          </div>
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

    return (
      <Button
        loading={loading || showWalletOptions}
        onClick={() => setShowWalletOptions(true)}
      >
        Connect
      </Button>
    );
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

      <div className="absolute w-screen bg-gradient-to-r from-black to-white">
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
