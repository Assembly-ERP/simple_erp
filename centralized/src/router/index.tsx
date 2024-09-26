import React from "react";
import { Route, Routes } from "react-router-dom";
import { MainLayout } from "@/components/templates";

const Home = React.lazy(() => import("@/pages/Home"))

function Router() {
  return (
    <Routes>
      <Route element={<MainLayout />}>
        <Route index element={<Home />} />
      </Route>
    </Routes>
  );
};

export default Router;
