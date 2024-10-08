import { cn } from "@/utils";
import { cva, VariantProps } from "class-variance-authority"
import { ButtonHTMLAttributes, FC, ReactNode } from "react"

export const buttonVariants = cva("rounded-lg text-base text-white", {
  variants: {
    variant: {
      primary: "bg-primary",
      secondary: "bg-secondary"
    },
    size: {
      sm: "px-3 py-1.5",
      md: "px-5 py-2.5",
    },
  },
  defaultVariants: {
    variant: "primary",
    size: "md",
  },
});

interface Props extends ButtonHTMLAttributes<HTMLButtonElement>,
  VariantProps<typeof buttonVariants> {
  children: ReactNode
}

const Button: FC<Props> = ({ className, variant, size, children, ...props }) => {
  return (
    <button className={cn(buttonVariants({ variant, size, className }))} {...props}>
      {children}
    </button>
  )
}

export default Button
