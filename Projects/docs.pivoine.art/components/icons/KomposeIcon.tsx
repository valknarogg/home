'use client'

import React, { useState } from 'react'
import './KomposeIcon.css'

interface KomposeIconProps {
  size?: string
  interactive?: boolean
  className?: string
}

export default function KomposeIcon({ 
  size = '192px', 
  interactive = true,
  className = ''
}: KomposeIconProps) {
  const [isClicked, setIsClicked] = useState(false)
  const [showRipple, setShowRipple] = useState(false)

  const handleClick = () => {
    if (!interactive) return

    setIsClicked(true)
    setShowRipple(true)

    setTimeout(() => {
      setIsClicked(false)
    }, 600)

    setTimeout(() => {
      setShowRipple(false)
    }, 800)
  }

  const handleTouch = (e: React.TouchEvent) => {
    if (!interactive) return
    handleClick()
  }

  const wrapperClasses = [
    'kompose-icon-wrapper',
    isClicked && 'is-clicked',
    interactive && 'is-interactive',
    className
  ].filter(Boolean).join(' ')

  return (
    <div
      className={wrapperClasses}
      onClick={handleClick}
      onTouchStart={handleTouch}
      style={{ width: size, height: size }}
    >
      <svg
        className="kompose-icon"
        viewBox="0 0 192 192"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
      >
        <defs>
          <pattern id="carbon192" x="0" y="0" width="7.68" height="7.68" patternUnits="userSpaceOnUse">
            <rect width="7.68" height="7.68" fill="#0a0e27"></rect>
            <path d="M0,0 L3.84,3.84 M3.84,0 L7.68,3.84 M0,3.84 L3.84,7.68" stroke="#060815" strokeWidth="1.5" opacity="0.5"></path>
          </pattern>

          <linearGradient id="bgGrad192" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" style={{ stopColor: '#1a1d2e', stopOpacity: 1 }}></stop>
            <stop offset="100%" style={{ stopColor: '#0a0e27', stopOpacity: 1 }}></stop>
          </linearGradient>

          <linearGradient id="primaryGrad192" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" className="gradient-start" style={{ stopColor: '#00DC82', stopOpacity: 1 }}></stop>
            <stop offset="100%" className="gradient-end" style={{ stopColor: '#00a86b', stopOpacity: 1 }}></stop>
          </linearGradient>

          <filter id="glow192">
            <feGaussianBlur stdDeviation="6" result="coloredBlur"></feGaussianBlur>
            <feMerge>
              <feMergeNode in="coloredBlur"></feMergeNode>
              <feMergeNode in="SourceGraphic"></feMergeNode>
            </feMerge>
          </filter>

          <filter id="intenseglow192">
            <feGaussianBlur stdDeviation="12" result="coloredBlur"></feGaussianBlur>
            <feMerge>
              <feMergeNode in="coloredBlur"></feMergeNode>
              <feMergeNode in="SourceGraphic"></feMergeNode>
            </feMerge>
          </filter>
        </defs>

        {/* Background */}
        <rect className="bg-rect" width="192" height="192" rx="24" fill="url(#bgGrad192)"></rect>
        <rect className="carbon-pattern" width="192" height="192" rx="24" fill="url(#carbon192)" opacity="0.4"></rect>

        {/* Stylized K */}
        <g className="k-letter" transform="translate(48, 48)">
          <line className="k-line k-vertical" x1="0" y1="0" x2="0" y2="96" stroke="url(#primaryGrad192)" strokeWidth="15" strokeLinecap="round" filter="url(#glow192)"></line>
          <line className="k-line k-diagonal-top" x1="0" y1="48" x2="57.6" y2="0" stroke="url(#primaryGrad192)" strokeWidth="15" strokeLinecap="round" filter="url(#glow192)"></line>
          <line className="k-line k-diagonal-bottom" x1="0" y1="48" x2="57.6" y2="96" stroke="url(#primaryGrad192)" strokeWidth="15" strokeLinecap="round" filter="url(#glow192)"></line>
        </g>

        {/* Animated status dot */}
        <circle className="status-dot" cx="163.2" cy="163.2" r="11.52" fill="#00DC82" opacity="0.9"></circle>
        <circle className="status-ring" cx="163.2" cy="163.2" r="17.28" fill="none" stroke="#00DC82" strokeWidth="3" opacity="0.3"></circle>

        {/* Tech corners */}
        <line className="corner corner-tl-h" x1="15.36" y1="15.36" x2="28.8" y2="15.36" stroke="#00DC82" strokeWidth="3" opacity="0.4"></line>
        <line className="corner corner-tl-v" x1="15.36" y1="15.36" x2="15.36" y2="28.8" stroke="#00DC82" strokeWidth="3" opacity="0.4"></line>
        <line className="corner corner-tr-h" x1="176.64" y1="15.36" x2="163.2" y2="15.36" stroke="#00DC82" strokeWidth="3" opacity="0.4"></line>
        <line className="corner corner-tr-v" x1="176.64" y1="15.36" x2="176.64" y2="28.8" stroke="#00DC82" strokeWidth="3" opacity="0.4"></line>
      </svg>

      {/* Ripple effect container */}
      {showRipple && <div className="ripple"></div>}
    </div>
  )
}
