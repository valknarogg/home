'use client'

import React, { useState } from 'react'
import './PivoineDocsIcon.css'

interface PivoineDocsIconProps {
  size?: string
  interactive?: boolean
  className?: string
  showLabel?: boolean
}

export default function PivoineDocsIcon({ 
  size = '256px', 
  interactive = true,
  className = '',
  showLabel = false
}: PivoineDocsIconProps) {
  const [isClicked, setIsClicked] = useState(false)
  const [showRipple, setShowRipple] = useState(false)

  const handleClick = () => {
    if (!interactive) return

    setIsClicked(true)
    setShowRipple(true)

    setTimeout(() => {
      setIsClicked(false)
    }, 800)

    setTimeout(() => {
      setShowRipple(false)
    }, 1000)
  }

  const handleTouch = (e: React.TouchEvent) => {
    if (!interactive) return
    handleClick()
  }

  const wrapperClasses = [
    'pivoine-docs-icon-wrapper',
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
        className="pivoine-docs-icon"
        viewBox="0 0 256 256"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
      >
        <defs>
          {/* Gradients */}
          <linearGradient id="petal-gradient-1" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" style={{ stopColor: '#a855f7', stopOpacity: 1 }} />
            <stop offset="100%" style={{ stopColor: '#ec4899', stopOpacity: 1 }} />
          </linearGradient>

          <linearGradient id="petal-gradient-2" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" style={{ stopColor: '#9333ea', stopOpacity: 1 }} />
            <stop offset="100%" style={{ stopColor: '#db2777', stopOpacity: 1 }} />
          </linearGradient>

          <linearGradient id="petal-gradient-3" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" style={{ stopColor: '#c026d3', stopOpacity: 1 }} />
            <stop offset="100%" style={{ stopColor: '#f472b6', stopOpacity: 1 }} />
          </linearGradient>

          <linearGradient id="center-gradient" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" style={{ stopColor: '#fbbf24', stopOpacity: 1 }} />
            <stop offset="50%" style={{ stopColor: '#f59e0b', stopOpacity: 1 }} />
            <stop offset="100%" style={{ stopColor: '#d97706', stopOpacity: 1 }} />
          </linearGradient>

          <linearGradient id="page-gradient" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" style={{ stopColor: '#f3f4f6', stopOpacity: 0.95 }} />
            <stop offset="100%" style={{ stopColor: '#e5e7eb', stopOpacity: 0.95 }} />
          </linearGradient>

          {/* Filters */}
          <filter id="petal-glow">
            <feGaussianBlur stdDeviation="4" result="coloredBlur" />
            <feMerge>
              <feMergeNode in="coloredBlur" />
              <feMergeNode in="SourceGraphic" />
            </feMerge>
          </filter>

          <filter id="intense-glow">
            <feGaussianBlur stdDeviation="8" result="coloredBlur" />
            <feMerge>
              <feMergeNode in="coloredBlur" />
              <feMergeNode in="SourceGraphic" />
            </feMerge>
          </filter>

          <filter id="page-shadow">
            <feDropShadow dx="0" dy="2" stdDeviation="3" floodOpacity="0.3" />
          </filter>
        </defs>

        {/* Background circle */}
        <circle className="bg-circle" cx="128" cy="128" r="120" fill="#1e293b" opacity="0.6" />

        {/* Outer petals (8 petals) */}
        <g className="outer-petals">
          {[0, 45, 90, 135, 180, 225, 270, 315].map((angle, i) => (
            <ellipse
              key={`outer-${i}`}
              className={`petal outer-petal petal-${i}`}
              cx="128"
              cy="128"
              rx="35"
              ry="65"
              fill={`url(#petal-gradient-${(i % 3) + 1})`}
              filter="url(#petal-glow)"
              transform={`rotate(${angle} 128 128)`}
              style={{ transformOrigin: '128px 128px' }}
            />
          ))}
        </g>

        {/* Middle petals (6 petals) */}
        <g className="middle-petals">
          {[30, 90, 150, 210, 270, 330].map((angle, i) => (
            <ellipse
              key={`middle-${i}`}
              className={`petal middle-petal petal-m-${i}`}
              cx="128"
              cy="128"
              rx="28"
              ry="50"
              fill={`url(#petal-gradient-${((i + 1) % 3) + 1})`}
              filter="url(#petal-glow)"
              transform={`rotate(${angle} 128 128)`}
              style={{ transformOrigin: '128px 128px' }}
            />
          ))}
        </g>

        {/* Inner petals (4 petals) */}
        <g className="inner-petals">
          {[45, 135, 225, 315].map((angle, i) => (
            <ellipse
              key={`inner-${i}`}
              className={`petal inner-petal petal-i-${i}`}
              cx="128"
              cy="128"
              rx="22"
              ry="38"
              fill={`url(#petal-gradient-${((i + 2) % 3) + 1})`}
              filter="url(#petal-glow)"
              transform={`rotate(${angle} 128 128)`}
              style={{ transformOrigin: '128px 128px' }}
            />
          ))}
        </g>

        {/* Center - Document pages */}
        <g className="center-docs">
          <rect
            className="page page-3"
            x="102"
            y="102"
            width="52"
            height="52"
            rx="4"
            fill="url(#page-gradient)"
            filter="url(#page-shadow)"
            opacity="0.4"
          />
          <rect
            className="page page-2"
            x="104"
            y="104"
            width="48"
            height="48"
            rx="4"
            fill="url(#page-gradient)"
            filter="url(#page-shadow)"
            opacity="0.6"
          />
          <rect
            className="page page-1"
            x="106"
            y="106"
            width="44"
            height="44"
            rx="4"
            fill="url(#page-gradient)"
            filter="url(#page-shadow)"
            opacity="0.9"
          />

          {/* Text lines on front page */}
          <line className="text-line line-1" x1="112" y1="115" x2="138" y2="115" stroke="#6366f1" strokeWidth="2" strokeLinecap="round" opacity="0.6" />
          <line className="text-line line-2" x1="112" y1="122" x2="144" y2="122" stroke="#6366f1" strokeWidth="2" strokeLinecap="round" opacity="0.6" />
          <line className="text-line line-3" x1="112" y1="129" x2="135" y2="129" stroke="#6366f1" strokeWidth="2" strokeLinecap="round" opacity="0.6" />
          <line className="text-line line-4" x1="112" y1="136" x2="142" y2="136" stroke="#a855f7" strokeWidth="2" strokeLinecap="round" opacity="0.6" />
          <line className="text-line line-5" x1="112" y1="143" x2="137" y2="143" stroke="#a855f7" strokeWidth="2" strokeLinecap="round" opacity="0.6" />
        </g>

        {/* Center golden circle */}
        <circle className="center-circle" cx="128" cy="128" r="18" fill="url(#center-gradient)" filter="url(#petal-glow)" opacity="0.8" />

        {/* Sparkle dots */}
        <g className="sparkles">
          <circle className="sparkle sparkle-1" cx="180" cy="80" r="3" fill="#fbbf24" opacity="0.8" />
          <circle className="sparkle sparkle-2" cx="76" cy="76" r="2.5" fill="#a855f7" opacity="0.8" />
          <circle className="sparkle sparkle-3" cx="180" cy="180" r="2" fill="#ec4899" opacity="0.8" />
          <circle className="sparkle sparkle-4" cx="76" cy="180" r="2.5" fill="#c026d3" opacity="0.8" />
        </g>

        {/* Orbiting particles */}
        <g className="particles">
          <circle className="particle particle-1" cx="128" cy="48" r="2" fill="#a855f7" opacity="0.6" />
          <circle className="particle particle-2" cx="208" cy="128" r="2" fill="#ec4899" opacity="0.6" />
          <circle className="particle particle-3" cx="128" cy="208" r="2" fill="#db2777" opacity="0.6" />
          <circle className="particle particle-4" cx="48" cy="128" r="2" fill="#c026d3" opacity="0.6" />
        </g>
      </svg>

      {/* Ripple effect */}
      {showRipple && <div className="ripple-effect"></div>}

      {/* Optional label */}
      {showLabel && (
        <div className="icon-label">
          <span className="label-text">Pivoine Docs</span>
        </div>
      )}
    </div>
  )
}
