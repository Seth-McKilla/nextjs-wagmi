interface Props {
  size: number;
}

export default function Loader(props: Props) {
  const { size } = props;

  return (
    <div className="flex items-center justify-center ">
      <div
        className={`w-${size} h-${size} m-2 border-b-2 border-gray-900 rounded-full animate-spin`}
      />
    </div>
  );
}
