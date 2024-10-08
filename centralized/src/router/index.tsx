import { Route, Routes } from "react-router-dom";
import { MainLayout } from "@/components/templates";
import Home from "@/pages/Home";

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
