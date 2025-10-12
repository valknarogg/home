'use client';

import { useSession, signOut } from 'next-auth/react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { Home, Users, Key, Layers, LogOut, Shield } from 'lucide-react';

export default function Layout({ children }: { children: React.ReactNode }) {
  const { data: session } = useSession();
  const pathname = usePathname();

  const navigation = [
    { name: 'Dashboard', href: '/', icon: Home },
    { name: 'Users', href: '/users', icon: Users },
    { name: 'Clients', href: '/clients', icon: Key },
    { name: 'Groups', href: '/groups', icon: Layers },
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900">
      {/* Header */}
      <header className="bg-slate-800/50 border-b border-slate-700 backdrop-blur-sm sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <Link href="/" className="flex items-center space-x-3 group">
              {/* Kompose Logo */}
              <div className="w-10 h-10 bg-gradient-to-br from-slate-800 to-slate-900 rounded-lg border-2 border-emerald-500/30 p-1.5 shadow-lg shadow-emerald-500/10 group-hover:border-emerald-500/50 transition-all">
                <svg viewBox="0 0 96 96" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <defs>
                    <linearGradient id="kGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                      <stop offset="0%" style={{ stopColor: '#00DC82', stopOpacity: 1 }} />
                      <stop offset="100%" style={{ stopColor: '#00A86B', stopOpacity: 1 }} />
                    </linearGradient>
                    <filter id="kGlow">
                      <feGaussianBlur stdDeviation="2" result="coloredBlur"/>
                      <feMerge>
                        <feMergeNode in="coloredBlur"/>
                        <feMergeNode in="SourceGraphic"/>
                      </feMerge>
                    </filter>
                  </defs>
                  <g transform="translate(24, 24)" filter="url(#kGlow)">
                    <line x1="0" y1="0" x2="0" y2="48" stroke="url(#kGrad)" strokeWidth="7.5" strokeLinecap="round" />
                    <line x1="0" y1="24" x2="28.8" y2="0" stroke="url(#kGrad)" strokeWidth="7.5" strokeLinecap="round" />
                    <line x1="0" y1="24" x2="28.8" y2="48" stroke="url(#kGrad)" strokeWidth="7.5" strokeLinecap="round" />
                  </g>
                  <circle cx="81.6" cy="81.6" r="5.76" fill="#00DC82" opacity="0.9">
                    <animate attributeName="opacity" values="0.6;1;0.6" dur="2s" repeatCount="indefinite"/>
                  </circle>
                </svg>
              </div>
              <div>
                <h1 className="text-lg font-bold text-white group-hover:text-emerald-400 transition-colors">
                  KMPS
                </h1>
                <p className="text-xs text-slate-400">Management Portal</p>
              </div>
            </Link>
            
            {session && (
              <div className="flex items-center space-x-4">
                <div className="text-right hidden sm:block">
                  <p className="text-sm font-medium text-white">{session.user?.name || session.user?.email}</p>
                  <p className="text-xs text-slate-400">Administrator</p>
                </div>
                <button
                  onClick={() => signOut()}
                  className="flex items-center space-x-2 px-4 py-2 rounded-lg bg-slate-700 hover:bg-slate-600 text-white transition-colors"
                >
                  <LogOut className="h-4 w-4" />
                  <span className="hidden sm:inline">Sign Out</span>
                </button>
              </div>
            )}
          </div>
        </div>
      </header>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Navigation */}
        <nav className="mb-8">
          <div className="flex space-x-2 bg-slate-800/30 rounded-lg p-2 backdrop-blur-sm border border-slate-700/50">
            {navigation.map((item) => {
              const Icon = item.icon;
              const isActive = pathname === item.href;
              
              return (
                <Link
                  key={item.name}
                  href={item.href}
                  className={`flex items-center space-x-2 px-4 py-2 rounded-lg transition-all ${
                    isActive
                      ? 'bg-emerald-500 text-white shadow-lg shadow-emerald-500/20'
                      : 'text-slate-300 hover:bg-slate-700/50 hover:text-white'
                  }`}
                >
                  <Icon className="h-5 w-5" />
                  <span className="font-medium">{item.name}</span>
                </Link>
              );
            })}
          </div>
        </nav>

        {/* Main Content */}
        <main>{children}</main>
      </div>

      {/* Footer */}
      <footer className="border-t border-slate-700 mt-16">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <div className="flex items-center justify-between text-sm text-slate-400">
            <div className="flex items-center space-x-2">
              <Shield className="h-4 w-4 text-emerald-500" />
              <span>Secured with Keycloak SSO</span>
            </div>
            <div>
              <span>Kompose.sh © {new Date().getFullYear()}</span>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
}
