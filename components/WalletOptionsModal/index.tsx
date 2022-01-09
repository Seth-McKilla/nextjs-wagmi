import { Dispatch, SetStateAction } from "react";
import { useConnect } from "wagmi";

interface Props {
  open: boolean;
  setOpen: Dispatch<SetStateAction<boolean>>;
}

export default function WalletOptionsModal(props: Props) {
  const { open, setOpen } = props;

  const [{ data, error }, connect] = useConnect();

  return open ? (
    <>
      <div className="justify-center items-center flex overflow-x-hidden overflow-y-auto fixed inset-0 z-50 outline-none focus:outline-none">
        <div className="relative w-auto my-6 mx-auto max-w-3xl">
          <div className="border-0 rounded-lg shadow-lg relative flex flex-col w-full bg-white outline-none focus:outline-none">
            <div className="flex items-start justify-between p-5 border-b border-solid border-blueGray-200 rounded-t mb-4">
              <h3 className="text-2xl font-semibold">Choose a Wallet</h3>
            </div>

            {data.connectors.map((c) => (
              <button
                className="bg-transparent hover:bg-blue-500 text-blue-700 font-semibold hover:text-white py-2 px-4 border border-blue-500 hover:border-transparent rounded w-80 mr-2 ml-2 mb-3"
                disabled={!c.ready}
                key={c.id}
                onClick={() => connect(c)}
              >
                {c.name}
                {!c.ready && " (unsupported)"}
              </button>
            ))}
            {error && <div>{error?.message ?? "Failed to connect"}</div>}

            <div className="flex items-center justify-end p-6 border-t border-solid border-blueGray-200 rounded-b mt-1">
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
