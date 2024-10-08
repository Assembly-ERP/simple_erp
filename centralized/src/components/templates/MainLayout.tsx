import { FC } from "react";
import { Outlet } from "react-router-dom";

interface Props { }

const MainLayout: FC<Props> = () => {
  return (
    <div className="flex flex-col min-h-screen">
      <main className="flex-1 m-auto max-w-[1080px] px-5 w-full">
        <Outlet />
      </main>
    </div>
  );
};

export default MainLayout;
