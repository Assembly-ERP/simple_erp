import React from "react"
import { Outlet } from "react-router-dom"

function MainLayout() {
  return (
    <div className="flex flex-col min-h-screen">
      <main className="flex-1 m-auto max-w-[1080px] px-5 w-full">
        <React.Suspense fallback={<div>Loading..</div>}>
          <Outlet />
        </React.Suspense>
      </main>
    </div>
  )
}

export default MainLayout
