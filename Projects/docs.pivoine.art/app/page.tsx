'use client'

import React, { useState, useEffect } from 'react'
import { BookOpen, Code2, Globe, ChevronRight, Sparkles, Terminal } from 'lucide-react'
import KomposeIcon from '@/components/icons/KomposeIcon'
import { PivoineDocsIcon } from '@/components/icons'

export default function DocsHub() {
  const [mousePosition, setMousePosition] = useState({ x: 0, y: 0 })
  const [isHovering, setIsHovering] = useState<string | null>(null)

  useEffect(() => {
    const handleMouseMove = (e: MouseEvent) => {
      setMousePosition({
        x: (e.clientX / window.innerWidth) * 20 - 10,
        y: (e.clientY / window.innerHeight) * 20 - 10,
      })
    }
    window.addEventListener('mousemove', handleMouseMove)
    return () => window.removeEventListener('mousemove', handleMouseMove)
  }, [])

  const projects = [
    {
      name: 'Kompose',
      status: 'Active',
      description: 'Comprehensive documentation for Kompose project',
      url: '/kompose',
      gradient: 'from-violet-500 to-purple-600'
    }
  ]

  const links = [
    {
      title: "Valknar's Blog",
      icon: Globe,
      url: 'http://pivoine.art',
      gradient: 'from-pink-500 to-rose-600'
    },
    {
      title: 'Source Code',
      icon: Code2,
      url: 'https://code.pivoine.art',
      gradient: 'from-cyan-500 to-blue-600'
    }
  ]

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-900 via-purple-900/20 to-gray-900 text-white overflow-hidden">
      {/* Animated background orbs */}
      <div className="fixed inset-0 overflow-hidden pointer-events-none">
        <div 
          className="absolute w-96 h-96 bg-purple-500/20 rounded-full blur-3xl top-0 -left-48 animate-pulse"
          style={{
            transform: `translate(${mousePosition.x}px, ${mousePosition.y}px)`,
            transition: 'transform 0.3s ease-out'
          }}
        />
        <div 
          className="absolute w-96 h-96 bg-pink-500/20 rounded-full blur-3xl bottom-0 -right-48 animate-pulse"
          style={{
            transform: `translate(${-mousePosition.x}px, ${-mousePosition.y}px)`,
            transition: 'transform 0.3s ease-out',
            animationDelay: '1s'
          }}
        />
        <div className="absolute w-96 h-96 bg-cyan-500/10 rounded-full blur-3xl top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 animate-pulse" style={{ animationDelay: '0.5s' }} />
      </div>

      {/* Main content */}
      <div className="relative z-10 container mx-auto px-6 py-12 max-w-6xl">
        {/* Header */}
        <header className="text-center mb-20 pt-12">
          {/* Hero Icon */}
          <div className="flex justify-center mb-8">
            <PivoineDocsIcon size="200px" showLabel={false} interactive={true} />
          </div>
          
          <div className="inline-flex items-center gap-2 mb-6 px-4 py-2 bg-white/5 backdrop-blur-sm rounded-full border border-white/10">
            <Sparkles className="w-4 h-4 text-purple-400" />
            <span className="text-sm text-purple-300">Documentation Hub</span>
          </div>
          
          <h1 className="text-7xl font-bold mb-6 bg-gradient-to-r from-white via-purple-200 to-pink-200 bg-clip-text text-transparent animate-pulse">
            Pivoine Docs
          </h1>
          
          <p className="text-xl text-gray-300 max-w-2xl mx-auto leading-relaxed">
            Comprehensive documentation for all projects by <span className="text-purple-400 font-semibold">Valknar</span>. 
            Explore technical guides, API references, and tutorials.
          </p>
        </header>

        {/* Projects Grid */}
        <section className="mb-20">
          <div className="flex items-center gap-3 mb-8">
            <Terminal className="w-6 h-6 text-purple-400" />
            <h2 className="text-3xl font-bold">Project Documentation</h2>
          </div>
          
          <div className="grid md:grid-cols-2 gap-6">
            {projects.map((project, idx) => (
              <a
                key={idx}
                href={project.url}
                onMouseEnter={() => setIsHovering(project.name)}
                onMouseLeave={() => setIsHovering(null)}
                className="group relative bg-white/5 backdrop-blur-md rounded-2xl p-8 border border-white/10 hover:border-purple-500/50 transition-all duration-300 hover:scale-105 hover:shadow-2xl hover:shadow-purple-500/20"
              >
                <div className="absolute inset-0 bg-gradient-to-br opacity-0 group-hover:opacity-10 rounded-2xl transition-opacity duration-300" 
                     style={{ background: `linear-gradient(135deg, rgb(168, 85, 247), rgb(147, 51, 234))` }} />
                
                <div className="relative">
                  <div className="flex items-start justify-between mb-4">
                    {project.name === 'Kompose' ? (
                      <div className={`relative w-14 h-14 rounded-xl bg-gradient-to-br ${project.gradient} shadow-lg flex items-center justify-center`}>
                        <KomposeIcon size="36px" interactive={false} className='' />
                      </div>
                    ) : (
                      <div className={`p-3 rounded-xl bg-gradient-to-br ${project.gradient} shadow-lg`}>
                        <BookOpen className="w-8 h-8 text-white" />
                      </div>
                    )}
                    <span className="px-3 py-1 bg-emerald-500/20 text-emerald-300 rounded-full text-sm border border-emerald-500/30">
                      {project.status}
                    </span>
                  </div>
                  
                  <h3 className="text-2xl font-bold mb-3 group-hover:text-purple-300 transition-colors">
                    {project.name}
                  </h3>
                  
                  <p className="text-gray-400 mb-4 leading-relaxed">
                    {project.description}
                  </p>
                  
                  <div className="flex items-center text-purple-400 font-semibold group-hover:gap-3 gap-2 transition-all">
                    Read docs
                    <ChevronRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
                  </div>
                </div>
              </a>
            ))}
            
            {/* Coming Soon Card */}
            <div className="relative bg-white/5 backdrop-blur-md rounded-2xl p-8 border border-dashed border-white/20">
              <div className="opacity-60">
                <div className="p-3 rounded-xl bg-gradient-to-br from-gray-600 to-gray-700 w-fit mb-4">
                  <BookOpen className="w-8 h-8 text-white" />
                </div>
                <h3 className="text-2xl font-bold mb-3 text-gray-400">More Projects</h3>
                <p className="text-gray-500 leading-relaxed">
                  Additional documentation sites coming soon...
                </p>
              </div>
            </div>
          </div>
        </section>

        {/* External Links */}
        <section>
          <div className="flex items-center gap-3 mb-8">
            <Sparkles className="w-6 h-6 text-pink-400" />
            <h2 className="text-3xl font-bold">Explore More</h2>
          </div>
          
          <div className="grid md:grid-cols-2 gap-6">
            {links.map((link, idx) => {
              const Icon = link.icon
              return (
                <a
                  key={idx}
                  href={link.url}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="group bg-white/5 backdrop-blur-md rounded-2xl p-6 border border-white/10 hover:border-pink-500/50 transition-all duration-300 hover:scale-105 hover:shadow-2xl hover:shadow-pink-500/20 flex items-center gap-4"
                >
                  <div className={`p-4 rounded-xl bg-gradient-to-br ${link.gradient} shadow-lg group-hover:scale-110 transition-transform`}>
                    <Icon className="w-7 h-7 text-white" />
                  </div>
                  <div className="flex-1">
                    <h3 className="text-xl font-bold group-hover:text-pink-300 transition-colors">
                      {link.title}
                    </h3>
                    <p className="text-gray-400 text-sm">{link.url}</p>
                  </div>
                  <ChevronRight className="w-6 h-6 text-gray-400 group-hover:text-pink-400 group-hover:translate-x-1 transition-all" />
                </a>
              )
            })}
          </div>
        </section>

        {/* Footer */}
        <footer className="mt-20 pt-8 border-t border-white/10 text-center text-gray-400">
          <p className="text-sm">
            Crafted with passion by <span className="text-purple-400 font-semibold">Valknar</span> · 
            <a href="http://pivoine.art" className="hover:text-purple-300 transition-colors ml-1">pivoine.art</a>
          </p>
        </footer>
      </div>
    </div>
  )
}
