import type { NextPage } from "next";
import { Layout } from "../components";

const Home: NextPage = () => {
  return (
    <Layout>
      <div className="container mx-auto">
        <h1 className="text-3xl font-bold underline">Hello</h1>
      </div>
    </Layout>
  );
};

export default Home;
