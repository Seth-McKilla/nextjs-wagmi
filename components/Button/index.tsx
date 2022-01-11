interface Props {
  children: string;
  width?: number;
  [x: string]: any;
}

export default function Button(props: Props) {
  const { children, width, ...rest } = props;

  return (
    <button
      type="button"
      className={`h-14 p-3 font-semibold border border-black hover:border-transparent hover:text-white hover:bg-black rounded-md ${
        width && `w-${width}`
      }`}
      {...rest}
    >
      {children}
    </button>
  );
}
