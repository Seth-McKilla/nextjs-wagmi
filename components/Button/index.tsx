interface Props {
  children: string;
  width?: number;
  [x: string]: any;
}

export default function Button(props: Props) {
  const { children, width } = props;

  return (
    <button
      type="button"
      className={`bg-transparent hover:bg-blue-500 text-blue-700 font-semibold hover:text-white py-2 px-4 border border-blue-500 hover:border-transparent rounded ${
        width && `w-${width}`
      }`}
      {...props}
    >
      {children}
    </button>
  );
}
