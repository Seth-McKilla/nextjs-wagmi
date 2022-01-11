import { useEffect, Dispatch, SetStateAction } from "react";
import { useConnect, useAccount } from "wagmi";
import { Button } from "..";

interface Props {
  open: boolean;
  setOpen: Dispatch<SetStateAction<boolean>>;
}

export default function WalletOptionsModal(props: Props) {
  const { open, setOpen } = props;

  const [{ data: connectData, error }, connect] = useConnect();
  const [{ data: accountData }] = useAccount();

  useEffect(() => {
    accountData && setOpen(false);
  }, [accountData, setOpen]);

  return open ? (
    <>
      <div className="fixed inset-0 z-50 flex items-center justify-center">
        <div className="relative w-auto max-w-3xl mx-auto my-6">
          <div className="relative flex flex-col bg-white border-0 rounded-lg shadow-lg">
            <div className="flex items-start justify-between p-5 mb-4">
              <h3 className="self-center text-3xl font-semibold">
                Choose a Wallet
              </h3>
            </div>

            {connectData.connectors.map((c) => (
              <div key={c.id} className="mb-2 ml-2 mr-2 w-80">
                <Button
                  width={80}
                  disabled={!c.ready}
                  onClick={() => connect(c)}
                >
                  {`${c.name}${!c.ready ? " (unsupported)" : ""}`}
                </Button>
              </div>
            ))}
            {error && (
              <div className="ml-2 text-red-500">
                {error?.message ?? "Failed to connect"}
              </div>
            )}

            <div className="flex items-center justify-end p-3 mt-1">
              <button
                className="px-6 py-2 mb-1 text-sm font-semibold text-red-500 uppercase"
                type="button"
                onClick={() => setOpen(false)}
              >
                Cancel
              </button>
            </div>
          </div>
        </div>
      </div>
      <div className="fixed inset-0 z-40 bg-black opacity-25"></div>
    </>
  ) : null;
}
