import Head from "next/head";
import { ReactNode, useState } from "react";
import { Button, WalletOptionsModal } from "..";

export default function Layout({ children }: { children: ReactNode }) {
  const [showWalletOptions, setShowWalletOptions] = useState(false);

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

      <div className="bg-gradient-to-r from-blue-200 to-blue-100 absolute w-screen">
        <div className="flex items-center justify-between p-4">
          <div className="flex items-center">
            <a
              href="#home"
              className="text-xl font-bold no-underline text-gray-800 hover:text-gray-600"
            >
              NextJS wagmi
            </a>
          </div>
          <Button onClick={() => setShowWalletOptions(true)}>Connect</Button>
        </div>
      </div>

      {children}
    </div>
  );
}
