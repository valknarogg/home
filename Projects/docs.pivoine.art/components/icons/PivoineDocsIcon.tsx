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
  const [isHovered, setIsHovered] = useState(false)
  const [isClicked, setIsClicked] = useState(false)

  const handleMouseEnter = () => {
    if (!interactive) return
    setIsHovered(true)
  }

  const handleMouseLeave = () => {
    if (!interactive) return
    setIsHovered(false)
  }

  const handleClick = () => {
    if (!interactive) return

    setIsClicked(true)
    setTimeout(() => {
      setIsClicked(false)
    }, 1200)
  }

  const handleTouch = (e: React.TouchEvent) => {
    if (!interactive) return
    e.preventDefault()
    setIsHovered(true)
    
    setTimeout(() => {
      handleClick()
    }, 50)

    setTimeout(() => {
      setIsHovered(false)
    }, 1500)
  }

  const wrapperClasses = [
    'pivoine-docs-icon-wrapper',
    isHovered && 'is-hovered',
    isClicked && 'is-clicked',
    interactive && 'is-interactive',
    className
  ].filter(Boolean).join(' ')

  // Generate bloom particles with varied properties
  const bloomParticles = Array.from({ length: 12 }, (_, i) => ({
    id: i,
    angle: (360 / 12) * i,
    distance: 80 + Math.random() * 20,
    size: 2 + Math.random() * 2,
    delay: i * 0.08,
  }))

  return (
    <div
      className={wrapperClasses}
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
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
          {/* Enhanced Gradients for natural peony colors */}
          <radialGradient id="petal-gradient-1" cx="30%" cy="30%">
            <stop offset="0%" style={{ stopColor: '#fce7f3', stopOpacity: 1 }} />
            <stop offset="40%" style={{ stopColor: '#fbcfe8', stopOpacity: 1 }} />
            <stop offset="70%" style={{ stopColor: '#f9a8d4', stopOpacity: 1 }} />
            <stop offset="100%" style={{ stopColor: '#ec4899', stopOpacity: 0.95 }} />
          </radialGradient>

          <radialGradient id="petal-gradient-2" cx="30%" cy="30%">
            <stop offset="0%" style={{ stopColor: '#fae8ff', stopOpacity: 1 }} />
            <stop offset="40%" style={{ stopColor: '#f3e8ff', stopOpacity: 1 }} />
            <stop offset="70%" style={{ stopColor: '#e9d5ff', stopOpacity: 1 }} />
            <stop offset="100%" style={{ stopColor: '#c084fc', stopOpacity: 0.95 }} />
          </radialGradient>

          <radialGradient id="petal-gradient-3" cx="30%" cy="30%">
            <stop offset="0%" style={{ stopColor: '#fdf4ff', stopOpacity: 1 }} />
            <stop offset="40%" style={{ stopColor: '#fae8ff', stopOpacity: 1 }} />
            <stop offset="70%" style={{ stopColor: '#f0abfc', stopOpacity: 1 }} />
            <stop offset="100%" style={{ stopColor: '#d946ef', stopOpacity: 0.95 }} />
          </radialGradient>

          <radialGradient id="petal-gradient-4" cx="30%" cy="30%">
            <stop offset="0%" style={{ stopColor: '#fce7f3', stopOpacity: 1 }} />
            <stop offset="40%" style={{ stopColor: '#fda4af', stopOpacity: 1 }} />
            <stop offset="70%" style={{ stopColor: '#fb7185', stopOpacity: 1 }} />
            <stop offset="100%" style={{ stopColor: '#f43f5e', stopOpacity: 0.95 }} />
          </radialGradient>

          <radialGradient id="center-gradient" cx="50%" cy="50%">
            <stop offset="0%" style={{ stopColor: '#fef3c7', stopOpacity: 1 }} />
            <stop offset="30%" style={{ stopColor: '#fde68a', stopOpacity: 1 }} />
            <stop offset="60%" style={{ stopColor: '#fbbf24', stopOpacity: 1 }} />
            <stop offset="100%" style={{ stopColor: '#f59e0b', stopOpacity: 1 }} />
          </radialGradient>

          <radialGradient id="center-inner-gradient" cx="50%" cy="50%">
            <stop offset="0%" style={{ stopColor: '#fffbeb', stopOpacity: 1 }} />
            <stop offset="50%" style={{ stopColor: '#fef3c7', stopOpacity: 1 }} />
            <stop offset="100%" style={{ stopColor: '#fde68a', stopOpacity: 1 }} />
          </radialGradient>

          <linearGradient id="page-gradient" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" style={{ stopColor: '#ffffff', stopOpacity: 0.98 }} />
            <stop offset="100%" style={{ stopColor: '#f3f4f6', stopOpacity: 0.98 }} />
          </linearGradient>

          {/* Enhanced Filters */}
          <filter id="petal-glow">
            <feGaussianBlur stdDeviation="2.5" result="coloredBlur" />
            <feMerge>
              <feMergeNode in="coloredBlur" />
              <feMergeNode in="SourceGraphic" />
            </feMerge>
          </filter>

          <filter id="intense-glow">
            <feGaussianBlur stdDeviation="8" result="coloredBlur" />
            <feComponentTransfer in="coloredBlur" result="brightBlur">
              <feFuncA type="linear" slope="1.5" />
            </feComponentTransfer>
            <feMerge>
              <feMergeNode in="brightBlur" />
              <feMergeNode in="SourceGraphic" />
            </feMerge>
          </filter>

          <filter id="center-glow">
            <feGaussianBlur stdDeviation="4" result="coloredBlur" />
            <feMerge>
              <feMergeNode in="coloredBlur" />
              <feMergeNode in="coloredBlur" />
              <feMergeNode in="SourceGraphic" />
            </feMerge>
          </filter>

          <filter id="sparkle-glow">
            <feGaussianBlur stdDeviation="2" result="coloredBlur" />
            <feMerge>
              <feMergeNode in="coloredBlur" />
              <feMergeNode in="SourceGraphic" />
            </feMerge>
          </filter>

          <filter id="page-shadow">
            <feDropShadow dx="0" dy="2" stdDeviation="4" floodOpacity="0.15" />
          </filter>
        </defs>

        {/* Subtle background glow */}
        <circle className="bg-glow" cx="128" cy="128" r="120" fill="url(#petal-gradient-3)" opacity="0.08" />

        {/* Outer layer - Large petals (8 petals) */}
        <g className="outer-petals">
          {[
            { angle: 0, scaleX: 1.1, scaleY: 1, gradient: 1 },
            { angle: 45, scaleX: 1, scaleY: 1.05, gradient: 2 },
            { angle: 90, scaleX: 1.05, scaleY: 1, gradient: 3 },
            { angle: 135, scaleX: 1, scaleY: 1.1, gradient: 4 },
            { angle: 180, scaleX: 1.08, scaleY: 1, gradient: 1 },
            { angle: 225, scaleX: 1, scaleY: 1.02, gradient: 2 },
            { angle: 270, scaleX: 1.02, scaleY: 1, gradient: 3 },
            { angle: 315, scaleX: 1, scaleY: 1.06, gradient: 4 },
          ].map((petal, i) => (
            <ellipse
              key={`outer-${i}`}
              className={`petal outer-petal petal-${i}`}
              cx="128"
              cy="70"
              rx="40"
              ry="68"
              fill={`url(#petal-gradient-${petal.gradient})`}
              filter="url(#petal-glow)"
              style={{rotate: `${petal.angle}deg`, width: `${128 * petal.scaleX}px`, height: `${70 * petal.scaleY}px`}}
            />
          ))}
        </g>

        {/* Middle layer - Medium petals (8 petals, offset) */}
        <g className="middle-petals">
          {[
            { angle: 22.5, scaleX: 1, scaleY: 1, gradient: 2 },
            { angle: 67.5, scaleX: 1.05, scaleY: 1, gradient: 3 },
            { angle: 112.5, scaleX: 1, scaleY: 1.02, gradient: 4 },
            { angle: 157.5, scaleX: 1.02, scaleY: 1, gradient: 1 },
            { angle: 202.5, scaleX: 1, scaleY: 1.05, gradient: 2 },
            { angle: 247.5, scaleX: 1.03, scaleY: 1, gradient: 3 },
            { angle: 292.5, scaleX: 1, scaleY: 1, gradient: 4 },
            { angle: 337.5, scaleX: 1.02, scaleY: 1, gradient: 1 },
          ].map((petal, i) => (
            <ellipse
              key={`middle-${i}`}
              className={`petal middle-petal petal-m-${i}`}
              cx="128"
              cy="78"
              rx="34"
              ry="56"
              fill={`url(#petal-gradient-${petal.gradient})`}
              filter="url(#petal-glow)"
              style={{rotate: `${petal.angle}deg`, width: `${128 * petal.scaleX}px`, height: `${70 * petal.scaleY}px`}}
            />
          ))}
        </g>

        {/* Inner layer - Small petals (10 petals) */}
        <g className="inner-petals">
          {[
            { angle: 0, gradient: 3 },
            { angle: 36, gradient: 4 },
            { angle: 72, gradient: 1 },
            { angle: 108, gradient: 2 },
            { angle: 144, gradient: 3 },
            { angle: 180, gradient: 4 },
            { angle: 216, gradient: 1 },
            { angle: 252, gradient: 2 },
            { angle: 288, gradient: 3 },
            { angle: 324, gradient: 4 },
          ].map((petal, i) => (
            <ellipse
              key={`inner-${i}`}
              className={`petal inner-petal petal-i-${i}`}
              cx="128"
              cy="88"
              rx="28"
              ry="44"
              fill={`url(#petal-gradient-${petal.gradient})`}
              filter="url(#petal-glow)"
              style={{rotate: `${petal.angle}deg`}}
            />
          ))}
        </g>

        {/* Center circles - Flower stamen */}
        <circle 
          className="center-circle-outer" 
          cx="128" 
          cy="128" 
          r="12" 
          fill="url(#center-gradient)" 
          filter="url(#center-glow)" 
        />
        <circle 
          className="center-circle-inner" 
          cx="128" 
          cy="128" 
          r="2" 
          fill="url(#center-inner-gradient)" 
          opacity="0.9"
        />

        {/* Center details - tiny stamens */}
        <g className="center-stamens">
          {Array.from({ length: 8 }).map((_, i) => {
            const angle = (360 / 8) * i
            const x = 128 + Math.cos((angle * Math.PI) / 180) * 10
            const y = 128 + Math.sin((angle * Math.PI) / 180) * 10
            return (
              <circle
                key={`stamen-${i}`}
                className={`stamen stamen-${i}`}
                cx={x}
                cy={y}
                r="2"
                fill="#d97706"
                opacity="0.8"
              />
            )
          })}
        </g>

        {/* Sparkles - ambient magical effect */}
        <g className="sparkles">
          <circle className="sparkle sparkle-1" cx="180" cy="75" r="3" fill="#fbbf24" filter="url(#sparkle-glow)" />
          <circle className="sparkle sparkle-2" cx="76" cy="76" r="2.5" fill="#a855f7" filter="url(#sparkle-glow)" />
          <circle className="sparkle sparkle-3" cx="180" cy="180" r="2.5" fill="#ec4899" filter="url(#sparkle-glow)" />
          <circle className="sparkle sparkle-4" cx="76" cy="180" r="3" fill="#c026d3" filter="url(#sparkle-glow)" />
          <circle className="sparkle sparkle-5" cx="128" cy="50" r="2" fill="#f0abfc" filter="url(#sparkle-glow)" />
          <circle className="sparkle sparkle-6" cx="206" cy="128" r="2" fill="#fb7185" filter="url(#sparkle-glow)" />
          <circle className="sparkle sparkle-7" cx="128" cy="206" r="2.5" fill="#fbbf24" filter="url(#sparkle-glow)" />
          <circle className="sparkle sparkle-8" cx="50" cy="128" r="2" fill="#c084fc" filter="url(#sparkle-glow)" />
        </g>

        {/* Flying bloom particles (visible on hover) */}
        <g className="bloom-particles">
          {bloomParticles.map((particle) => (
            <circle
              key={`bloom-particle-${particle.id}`}
              className={`bloom-particle bloom-particle-${particle.id}`}
              cx="128"
              cy="128"
              r={particle.size}
              fill={`url(#petal-gradient-${(particle.id % 4) + 1})`}
              opacity="0"
              filter="url(#sparkle-glow)"
              style={{
                '--particle-angle': `${particle.angle}deg`,
                '--particle-distance': `${particle.distance}px`,
                '--particle-delay': `${particle.delay}s`,
              } as React.CSSProperties}
            />
          ))}
        </g>
      </svg>

      {/* Optional label */}
      {showLabel && (
        <div className="icon-label">
          <span className="label-text">Pivoine Docs</span>
        </div>
      )}
    </div>
  )
}
