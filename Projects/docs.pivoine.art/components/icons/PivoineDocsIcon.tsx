'use client'

import React, { useState } from 'react'

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

  return (
    <div
      className={`pivoine-docs-icon-wrapper ${isClicked ? 'is-clicked' : ''} ${interactive ? 'is-interactive' : ''} ${className}`}
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
              opacity="0.85"
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
              opacity="0.9"
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
              opacity="0.95"
            />
          ))}
        </g>

        {/* Center - Document pages */}
        <g className="center-docs">
          {/* Page stack */}
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

      <style jsx>{`
        .pivoine-docs-icon-wrapper {
          position: relative;
          display: inline-flex;
          flex-direction: column;
          align-items: center;
          gap: 1rem;
          cursor: pointer;
          transition: transform 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
          transform-style: preserve-3d;
        }

        .pivoine-docs-icon-wrapper:not(.is-interactive) {
          cursor: default;
        }

        .pivoine-docs-icon {
          width: 100%;
          height: 100%;
          display: block;
          filter: drop-shadow(0 10px 40px rgba(168, 85, 247, 0.3));
          transition: filter 0.4s ease;
        }

        /* Background pulse */
        .bg-circle {
          animation: bg-pulse 4s ease-in-out infinite;
        }

        /* Petal animations */
        .petal {
          transform-origin: 128px 128px;
          transition: all 0.4s ease;
        }

        /* Sparkles twinkle */
        .sparkle {
          animation: twinkle 2s ease-in-out infinite;
        }
        .sparkle-1 { animation-delay: 0s; }
        .sparkle-2 { animation-delay: 0.5s; }
        .sparkle-3 { animation-delay: 1s; }
        .sparkle-4 { animation-delay: 1.5s; }

        /* Particles orbit */
        .particle {
          animation: orbit 8s linear infinite;
          transform-origin: 128px 128px;
        }
        .particle-1 { animation-delay: 0s; }
        .particle-2 { animation-delay: 2s; }
        .particle-3 { animation-delay: 4s; }
        .particle-4 { animation-delay: 6s; }

        /* Center circle pulse */
        .center-circle {
          animation: center-pulse 3s ease-in-out infinite;
        }

        /* Pages subtle movement */
        .page {
          transform-origin: center;
          animation: page-float 3s ease-in-out infinite;
        }
        .page-1 { animation-delay: 0s; }
        .page-2 { animation-delay: 0.3s; }
        .page-3 { animation-delay: 0.6s; }

        /* Text lines appear */
        .text-line {
          stroke-dasharray: 30;
          stroke-dashoffset: 30;
          animation: line-appear 2s ease-out forwards;
        }
        .line-1 { animation-delay: 0.2s; }
        .line-2 { animation-delay: 0.4s; }
        .line-3 { animation-delay: 0.6s; }
        .line-4 { animation-delay: 0.8s; }
        .line-5 { animation-delay: 1s; }

        /* Hover effects */
        .pivoine-docs-icon-wrapper.is-interactive:hover {
          transform: scale(1.08) translateY(-8px);
        }

        .pivoine-docs-icon-wrapper.is-interactive:hover .pivoine-docs-icon {
          filter: drop-shadow(0 20px 60px rgba(168, 85, 247, 0.6));
        }

        .pivoine-docs-icon-wrapper.is-interactive:hover .outer-petal {
          animation: petal-bloom 1.2s ease-out forwards;
        }

        .pivoine-docs-icon-wrapper.is-interactive:hover .middle-petal {
          animation: petal-bloom 1.2s ease-out 0.1s forwards;
        }

        .pivoine-docs-icon-wrapper.is-interactive:hover .inner-petal {
          animation: petal-bloom 1.2s ease-out 0.2s forwards;
        }

        .pivoine-docs-icon-wrapper.is-interactive:hover .center-circle {
          animation: center-glow 1s ease-in-out infinite;
        }

        .pivoine-docs-icon-wrapper.is-interactive:hover .sparkle {
          animation: sparkle-burst 0.8s ease-out infinite;
        }

        .pivoine-docs-icon-wrapper.is-interactive:hover .page {
          animation: page-fan 0.8s ease-out forwards;
        }

        /* Click effects */
        .pivoine-docs-icon-wrapper.is-clicked {
          animation: icon-bounce 0.8s cubic-bezier(0.34, 1.56, 0.64, 1);
        }

        .pivoine-docs-icon-wrapper.is-clicked .pivoine-docs-icon {
          animation: icon-spin 0.8s cubic-bezier(0.34, 1.56, 0.64, 1);
          filter: drop-shadow(0 25px 80px rgba(168, 85, 247, 0.9));
        }

        .pivoine-docs-icon-wrapper.is-clicked .petal {
          animation: petal-explode 0.8s ease-out;
        }

        .pivoine-docs-icon-wrapper.is-clicked .center-circle {
          animation: center-burst 0.8s ease-out;
        }

        /* Ripple effect */
        .ripple-effect {
          position: absolute;
          top: 50%;
          left: 50%;
          width: 100%;
          height: 100%;
          border-radius: 50%;
          background: radial-gradient(circle, rgba(168, 85, 247, 0.6) 0%, rgba(168, 85, 247, 0) 70%);
          transform: translate(-50%, -50%) scale(0);
          animation: ripple-expand 1s ease-out;
          pointer-events: none;
        }

        /* Label */
        .icon-label {
          margin-top: 0.5rem;
        }

        .label-text {
          font-size: 1.25rem;
          font-weight: 700;
          background: linear-gradient(135deg, #a855f7, #ec4899);
          background-clip: text;
          -webkit-background-clip: text;
          -webkit-text-fill-color: transparent;
          animation: label-shimmer 3s ease-in-out infinite;
        }

        /* Keyframes */
        @keyframes bg-pulse {
          0%, 100% { opacity: 0.4; transform: scale(1); }
          50% { opacity: 0.7; transform: scale(1.05); }
        }

        @keyframes twinkle {
          0%, 100% { opacity: 0.4; transform: scale(1); }
          50% { opacity: 1; transform: scale(1.3); }
        }

        @keyframes orbit {
          from { transform: rotate(0deg) translateX(80px) rotate(0deg); }
          to { transform: rotate(360deg) translateX(80px) rotate(-360deg); }
        }

        @keyframes center-pulse {
          0%, 100% { opacity: 0.6; transform: scale(1); }
          50% { opacity: 1; transform: scale(1.15); }
        }

        @keyframes page-float {
          0%, 100% { transform: translateY(0); }
          50% { transform: translateY(-2px); }
        }

        @keyframes line-appear {
          to { stroke-dashoffset: 0; }
        }

        @keyframes petal-bloom {
          0% { opacity: 0.85; }
          50% { opacity: 1; filter: url(#intense-glow); }
          100% { opacity: 0.95; filter: url(#petal-glow); }
        }

        @keyframes center-glow {
          0%, 100% { opacity: 0.8; transform: scale(1); }
          50% { opacity: 1; transform: scale(1.2); filter: url(#intense-glow); }
        }

        @keyframes sparkle-burst {
          0%, 100% { opacity: 0.8; transform: scale(1); }
          50% { opacity: 1; transform: scale(1.8); }
        }

        @keyframes page-fan {
          0% { transform: translateY(0) rotate(0deg); }
          100% { transform: translateY(-3px) rotate(2deg); }
        }

        @keyframes icon-bounce {
          0% { transform: scale(1) translateY(0) rotateZ(0deg); }
          30% { transform: scale(0.9) translateY(0) rotateZ(0deg); }
          60% { transform: scale(1.15) translateY(-15px) rotateZ(180deg); }
          80% { transform: scale(0.95) translateY(0) rotateZ(360deg); }
          100% { transform: scale(1) translateY(0) rotateZ(360deg); }
        }

        @keyframes icon-spin {
          0% { transform: perspective(1000px) rotateY(0deg); }
          50% { transform: perspective(1000px) rotateY(180deg); }
          100% { transform: perspective(1000px) rotateY(360deg); }
        }

        @keyframes petal-explode {
          0% { transform: scale(1); opacity: 1; }
          50% { transform: scale(1.3); opacity: 0.8; filter: url(#intense-glow); }
          100% { transform: scale(1); opacity: 1; filter: url(#petal-glow); }
        }

        @keyframes center-burst {
          0% { transform: scale(1); opacity: 0.8; }
          50% { transform: scale(1.8); opacity: 1; }
          100% { transform: scale(1); opacity: 0.8; }
        }

        @keyframes ripple-expand {
          0% { transform: translate(-50%, -50%) scale(0); opacity: 1; }
          100% { transform: translate(-50%, -50%) scale(3); opacity: 0; }
        }

        @keyframes label-shimmer {
          0%, 100% { filter: brightness(1); }
          50% { filter: brightness(1.3); }
        }

        /* Responsive */
        @media (max-width: 768px) {
          .pivoine-docs-icon-wrapper.is-interactive:hover {
            transform: scale(1.05) translateY(-4px);
          }
        }

        /* Reduced motion */
        @media (prefers-reduced-motion: reduce) {
          .pivoine-docs-icon-wrapper,
          .pivoine-docs-icon,
          .petal,
          .sparkle,
          .particle,
          .center-circle,
          .page,
          .text-line,
          .ripple-effect,
          .label-text {
            animation: none !important;
            transition: none !important;
          }

          .pivoine-docs-icon-wrapper.is-interactive:hover {
            transform: scale(1.03);
          }
        }

        /* Touch devices */
        @media (hover: none) and (pointer: coarse) {
          .pivoine-docs-icon-wrapper.is-interactive:active {
            transform: scale(0.95);
          }
        }
      `}</style>
    </div>
  )
}
