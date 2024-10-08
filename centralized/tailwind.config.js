/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        foreground: "#F7FAFD",
        primary: "#214290",
        secondary: "#589245",
      },
      maxWidth: {
        margin: "1350px",
      },
    },
  },
  plugins: [],
};
