import { ReactNode } from "react"

type Props = {
  variant?: 'primary' | 'secondary'
  size?: 'sm' | 'md' | 'lg'
  children: ReactNode
}

function Button({
  variant = 'primary',
  size = 'md',
  children
}: Props) {
  return (
    <button className={`rounded-md btn--${variant} btn--${size}`}>
      {children}
    </button>
  )
}

export default Button
