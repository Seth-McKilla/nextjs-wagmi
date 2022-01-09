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
      className={`h-14 bg-transparent hover:bg-blue-500 text-blue-700 font-semibold hover:text-white py-2 px-4 border border-blue-500 hover:border-transparent rounded ${
        width && `w-${width}`
      }`}
      {...rest}
    >
      {children}
    </button>
  );
}
