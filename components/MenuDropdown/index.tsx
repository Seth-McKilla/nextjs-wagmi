import { Fragment, ReactElement } from "react";
import { Menu, Transition } from "@headlessui/react";
import { AiFillCaretDown } from "react-icons/ai";

interface Props {
  label: ReactElement | string | undefined;
  options: {
    label: string;
    onClick: () => void;
  }[];
}

export default function Example(props: Props) {
  const { label, options } = props;

  return (
    <Menu as="div" className="relative inline-block text-left">
      <Menu.Button className="inline-flex justify-between p-3 font-semibold border border-black rounded-md h-14 w-52 place-items-center">
        {label}
        <AiFillCaretDown className="w-5 h-5 ml-2 -mr-1" aria-hidden="true" />
      </Menu.Button>
      <Transition
        as={Fragment}
        enter="transition ease-out duration-100"
        enterFrom="transform opacity-0 scale-95"
        enterTo="transform opacity-100 scale-100"
        leave="transition ease-in duration-75"
        leaveFrom="transform opacity-100 scale-100"
        leaveTo="transform opacity-0 scale-95"
      >
        <Menu.Items className="absolute right-0 w-40 mt-2 origin-top-right bg-white divide-y divide-gray-100 rounded-md shadow-lg">
          {options.map(({ label, onClick }, idx) => (
            <div key={`${idx}-${label}`} className="px-1 py-1 ">
              <Menu.Item>
                {({ active }) => (
                  <button
                    className={`${
                      active && "bg-black text-white"
                    } group flex rounded-md items-center w-full px-2 py-2 text-sm`}
                    onClick={onClick}
                  >
                    {label}
                  </button>
                )}
              </Menu.Item>
            </div>
          ))}
        </Menu.Items>
      </Transition>
    </Menu>
  );
}
