import "../styles/globals.css";
import type { AppProps } from "next/app";
import { Provider, chain, defaultChains } from "wagmi";
import { InjectedConnector } from "wagmi/connectors/injected";
import { WalletConnectConnector } from "wagmi/connectors/walletConnect";
import { WalletLinkConnector } from "wagmi/connectors/walletLink";

const infuraApiKey = process.env.NEXT_PUBLIC_INFURA_API_KEY;

const chains = defaultChains;

type Connector =
  | InjectedConnector
  | WalletConnectConnector
  | WalletLinkConnector;

const connectors = ({ chainId }: { chainId?: number }): Connector[] => {
  const rpcUrl =
    chains.find((x) => x.id === chainId)?.rpcUrls?.[0] ??
    chain.mainnet.rpcUrls[0];
  return [
    new InjectedConnector({ chains }),
    new WalletConnectConnector({
      options: {
        infuraId: infuraApiKey,
        qrcode: true,
      },
    }),
    new WalletLinkConnector({
      options: {
        appName: "NextJS-wagmi",
        jsonRpcUrl: `${rpcUrl}/${infuraApiKey}`,
      },
    }),
  ];
};

export default function MyApp({ Component, pageProps }: AppProps) {
  return (
    <Provider autoConnect connectors={connectors}>
      <Component {...pageProps} />
    </Provider>
  );
}
