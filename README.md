# Welcome to the NextJS wagmi starter template 👋
Looking to get up and running with a Typescript / NextJS dApp as quickly as possible? You're in the right place! This repo serves as a minimal template for integrating the wagmi React hooks for Ethereum library with Typescript & NextJS. Due to its ease of customizability and extensibility, this template has been styled with the Tailwind CSS framework. Let's get to it!
### Check out the live demo 👉 [NextJS wagmi](https://nextjs-wagmi.vercel.app/)

## Get up and running in 3 simple steps:

### 1. Create an app using this repo as the template
```bash
npx create-next-app@latest -e https://github.com/Seth-McKilla/nextjs-wagmi
```
>Note: The above command automatically downloads and installs the dependencies so no "npm install" or "yarn add" required!

### 2. Create a .env.local file within the root directory with the following environment variables
```bash
NEXT_PUBLIC_INFURA_ID=<insert infura id>
```
>Note: Grab an Infura ID from the [Infura website](https://infura.io/)

### 3. Start the local development environment
```bash
npm run dev
# or
yarn dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

That's it, you're all set!

## Resources
To learn more about the packages used in this project, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.
- [React Typescript Cheatsheet](https://react-typescript-cheatsheet.netlify.app/docs/basic/setup/) - helpful tips for using Typescript with React.
- [wagmi Documentation](https://wagmi-xyz.vercel.app/) - learn about the wagmi React hooks for Ethereum.
- [Tailwind CSS Documentation](https://tailwindcss.com/) - learn about the Tailwind CSS styling framework.

## Deploy on Vercel
[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https%3A%2F%2Fgithub.com%2FSeth-McKilla%2Fnextjs-wagmi&env=NEXT_PUBLIC_INFURA_ID)

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.
