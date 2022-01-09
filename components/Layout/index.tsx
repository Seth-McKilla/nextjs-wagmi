import Head from "next/head";
import { ReactNode } from "react";
import { useState } from "react";

export default function Layout({ children }: { children: ReactNode }) {
  const [showWalletOptions, setShowWalletOptions] = useState(false);

  return (
    <div>
      <Head>
        <title>NextJS wagmi</title>
        <meta name="description" content="NextJS and wagmi template" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <div className="bg-gradient-to-r from-blue-200 to-blue-100">
        <div className="flex items-center justify-between p-4">
          <div className="flex items-center">
            <a
              href="#home"
              className="text-xl font-bold no-underline text-gray-800 hover:text-gray-600"
            >
              NextJS wagmi
            </a>
          </div>
          <button
            type="button"
            className="bg-transparent hover:bg-blue-500 text-blue-700 font-semibold hover:text-white py-2 px-4 border border-blue-500 hover:border-transparent rounded"
          >
            Connect
          </button>
        </div>
      </div>
      {children}
    </div>
  );
}
