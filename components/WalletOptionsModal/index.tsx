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
      <div className="justify-center items-center flex overflow-x-hidden overflow-y-auto fixed inset-0 z-50 outline-none focus:outline-none">
        <div className="relative w-auto my-6 mx-auto max-w-3xl">
          <div className="border-0 rounded-lg shadow-lg relative flex flex-col w-full bg-white outline-none focus:outline-none">
            <div className="flex items-start justify-between p-5 border-b border-solid border-blueGray-200 rounded-t mb-4">
              <h3 className="text-2xl font-semibold">Choose a Wallet</h3>
            </div>

            {connectData.connectors.map((c) => (
              <div key={c.id} className="ml-2 mr-2 mb-2 w-80">
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
              <div className="text-red-500 ml-2">
                {error?.message ?? "Failed to connect"}
              </div>
            )}

            <div className="flex items-center justify-end p-3 border-t border-solid border-blueGray-200 rounded-b mt-1">
              <button
                className="text-red-500 background-transparent font-bold uppercase px-6 py-2 text-sm outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
                type="button"
                onClick={() => setOpen(false)}
              >
                Cancel
              </button>
            </div>
          </div>
        </div>
      </div>
      <div className="opacity-25 fixed inset-0 z-40 bg-black"></div>
    </>
  ) : null;
}
