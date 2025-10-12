'use client';

import { useState } from 'react';
import useSWR from 'swr';
import { 
  Server, Activity, Play, Square, RotateCcw, FileText, 
  CheckCircle2, XCircle, Loader2, AlertCircle, Box,
  Database, Shield, Code, Home, Link2, MessageSquare,
  Wifi, Network, Settings, Layers
} from 'lucide-react';

const fetcher = (url: string) => fetch(url).then((res) => res.json());

interface Stack {
  name: string;
  description: string;
  url: string;
}

interface StackStatus {
  stack: string;
  output: string;
  timestamp: string;
}

const STACK_ICONS: Record<string, any> = {
  core: Database,
  auth: Shield,
  code: Code,
  home: Home,
  kmps: Settings,
  link: Link2,
  messaging: MessageSquare,
  vpn: Wifi,
  proxy: Network,
  chain: Layers,
  default: Box,
};

const STACK_DESCRIPTIONS: Record<string, string> = {
  core: 'PostgreSQL, Redis, MQTT - Core infrastructure services',
  auth: 'Keycloak SSO & OAuth2 Proxy - Authentication and authorization',
  code: 'Gitea & CI/CD Runner - Git repository and automation',
  home: 'Home Assistant & Matter - Smart home automation',
  kmps: 'Management Portal - Web-based administration interface',
  link: 'Linkwarden - Bookmark and link management',
  messaging: 'Communication tools and messaging platforms',
  vpn: 'WireGuard VPN - Secure network access',
  proxy: 'Traefik - Reverse proxy and SSL termination',
  chain: 'n8n & Semaphore - Workflow and deployment automation',
};

export default function StacksDashboard() {
  const [selectedStack, setSelectedStack] = useState<string | null>(null);
  const [logs, setLogs] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState<Record<string, boolean>>({});

  const { data: stacksData, error: stacksError, mutate } = useSWR('/api/kompose/stacks', fetcher, {
    refreshInterval: 10000,
  });

  const stacks: Stack[] = stacksData?.data || [];

  // Function to get stack status
  const getStackStatus = async (stackName: string) => {
    try {
      const response = await fetch(`/api/kompose/stacks/${stackName}`);
      const data = await response.json();
      return data.data;
    } catch (error) {
      return null;
    }
  };

  // Function to perform stack action
  const performStackAction = async (stackName: string, action: 'start' | 'stop' | 'restart') => {
    setIsLoading(prev => ({ ...prev, [stackName]: true }));
    
    try {
      const response = await fetch(`/api/kompose/stacks/${stackName}/${action}`, {
        method: 'POST',
      });
      
      const data = await response.json();
      
      if (data.status === 'success') {
        // Wait a moment for the change to propagate
        setTimeout(() => {
          mutate();
        }, 2000);
      }
      
      return data;
    } catch (error) {
      console.error(`Failed to ${action} stack ${stackName}:`, error);
      return null;
    } finally {
      setIsLoading(prev => ({ ...prev, [stackName]: false }));
    }
  };

  // Function to get stack logs
  const getStackLogs = async (stackName: string) => {
    try {
      const response = await fetch(`/api/kompose/stacks/${stackName}/logs`);
      const data = await response.json();
      
      if (data.status === 'success') {
        setLogs(data.data.logs);
        setSelectedStack(stackName);
      }
    } catch (error) {
      console.error(`Failed to get logs for ${stackName}:`, error);
    }
  };

  // Parse stack status to determine if running
  const isStackRunning = (status: StackStatus | null) => {
    if (!status) return false;
    return status.output?.includes('running') || status.output?.includes('Up');
  };

  if (stacksError) {
    return (
      <div className="bg-red-500/10 border border-red-500/20 rounded-lg p-6">
        <div className="flex items-center space-x-3">
          <XCircle className="h-6 w-6 text-red-400" />
          <div>
            <p className="text-red-400 font-medium">Failed to load stacks</p>
            <p className="text-red-300 text-sm mt-1">Please ensure the Kompose API server is running</p>
          </div>
        </div>
      </div>
    );
  }

  if (!stacks || stacks.length === 0) {
    return (
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <h2 className="text-3xl font-bold text-white flex items-center space-x-3">
            <Server className="h-8 w-8 text-emerald-500" />
            <span>Stack Management</span>
          </h2>
        </div>
        
        {/* Loading skeletons */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {[1, 2, 3, 4, 5, 6].map((i) => (
            <div key={i} className="bg-slate-800/50 border border-slate-700 rounded-lg p-6 animate-pulse">
              <div className="h-6 bg-slate-700 rounded w-1/3 mb-4"></div>
              <div className="h-4 bg-slate-700 rounded w-2/3 mb-6"></div>
              <div className="flex gap-2">
                <div className="h-10 bg-slate-700 rounded flex-1"></div>
                <div className="h-10 bg-slate-700 rounded flex-1"></div>
              </div>
            </div>
          ))}
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h2 className="text-3xl font-bold text-white flex items-center space-x-3">
          <Server className="h-8 w-8 text-emerald-500" />
          <span>Stack Management</span>
        </h2>
        <div className="flex items-center space-x-2 text-sm text-slate-400">
          <Activity className="h-4 w-4 text-emerald-500 animate-pulse" />
          <span>Real-time monitoring</span>
        </div>
      </div>

      {/* Overview Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div className="bg-slate-800/50 border border-slate-700 rounded-lg p-4">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-slate-400 text-sm">Total Stacks</p>
              <p className="text-2xl font-bold text-white mt-1">{stacks.length}</p>
            </div>
            <Layers className="h-8 w-8 text-blue-500 opacity-50" />
          </div>
        </div>
        
        <div className="bg-emerald-500/10 border border-emerald-500/20 rounded-lg p-4">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-emerald-400 text-sm">Running</p>
              <p className="text-2xl font-bold text-emerald-400 mt-1">-</p>
            </div>
            <CheckCircle2 className="h-8 w-8 text-emerald-500 opacity-50" />
          </div>
        </div>
        
        <div className="bg-red-500/10 border border-red-500/20 rounded-lg p-4">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-red-400 text-sm">Stopped</p>
              <p className="text-2xl font-bold text-red-400 mt-1">-</p>
            </div>
            <XCircle className="h-8 w-8 text-red-500 opacity-50" />
          </div>
        </div>
        
        <div className="bg-blue-500/10 border border-blue-500/20 rounded-lg p-4">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-blue-400 text-sm">Containers</p>
              <p className="text-2xl font-bold text-blue-400 mt-1">-</p>
            </div>
            <Box className="h-8 w-8 text-blue-500 opacity-50" />
          </div>
        </div>
      </div>

      {/* Stacks Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {stacks.map((stack) => (
          <StackCard
            key={stack.name}
            stack={stack}
            isLoading={isLoading[stack.name]}
            onAction={performStackAction}
            onViewLogs={getStackLogs}
          />
        ))}
      </div>

      {/* Logs Modal */}
      {logs && selectedStack && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-slate-800 border border-slate-700 rounded-lg max-w-4xl w-full max-h-[80vh] flex flex-col">
            <div className="flex items-center justify-between p-6 border-b border-slate-700">
              <h3 className="text-xl font-bold text-white flex items-center space-x-2">
                <FileText className="h-6 w-6 text-emerald-500" />
                <span>Logs: {selectedStack}</span>
              </h3>
              <button
                onClick={() => {
                  setLogs(null);
                  setSelectedStack(null);
                }}
                className="text-slate-400 hover:text-white transition-colors"
              >
                ✕
              </button>
            </div>
            
            <div className="flex-1 overflow-auto p-6">
              <pre className="text-xs text-slate-300 font-mono bg-slate-900 p-4 rounded border border-slate-700 overflow-auto">
                {logs}
              </pre>
            </div>
            
            <div className="p-6 border-t border-slate-700 flex justify-end">
              <button
                onClick={() => {
                  setLogs(null);
                  setSelectedStack(null);
                }}
                className="px-4 py-2 bg-slate-700 hover:bg-slate-600 text-white rounded-lg transition-colors"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

interface StackCardProps {
  stack: Stack;
  isLoading: boolean;
  onAction: (stack: string, action: 'start' | 'stop' | 'restart') => Promise<any>;
  onViewLogs: (stack: string) => void;
}

function StackCard({ stack, isLoading, onAction, onViewLogs }: StackCardProps) {
  const [status, setStatus] = useState<any>(null);
  const [loadingStatus, setLoadingStatus] = useState(true);

  // Fetch status on mount and periodically
  useState(() => {
    const fetchStatus = async () => {
      try {
        const response = await fetch(`/api/kompose/stacks/${stack.name}`);
        const data = await response.json();
        setStatus(data.data);
      } catch (error) {
        console.error(`Failed to fetch status for ${stack.name}:`, error);
      } finally {
        setLoadingStatus(false);
      }
    };

    fetchStatus();
    const interval = setInterval(fetchStatus, 15000);
    return () => clearInterval(interval);
  });

  const Icon = STACK_ICONS[stack.name] || STACK_ICONS.default;
  const description = STACK_DESCRIPTIONS[stack.name] || stack.description;
  const isRunning = status?.output?.toLowerCase().includes('running') || 
                   status?.output?.toLowerCase().includes('up');

  return (
    <div className="bg-slate-800/50 border border-slate-700 rounded-lg p-6 hover:border-emerald-500/30 transition-all backdrop-blur-sm">
      <div className="flex items-start justify-between mb-4">
        <div className="flex items-center space-x-3">
          <div className={`p-3 rounded-lg ${isRunning ? 'bg-emerald-500/10 text-emerald-500' : 'bg-slate-700 text-slate-400'}`}>
            <Icon className="h-6 w-6" />
          </div>
          <div>
            <h3 className="text-lg font-bold text-white capitalize">{stack.name}</h3>
            <p className="text-xs text-slate-500 uppercase tracking-wider">Stack</p>
          </div>
        </div>
        
        {loadingStatus ? (
          <Loader2 className="h-5 w-5 text-slate-500 animate-spin" />
        ) : (
          <div className={`flex items-center space-x-2 px-3 py-1 rounded-full text-xs font-medium ${
            isRunning
              ? 'bg-emerald-500/20 text-emerald-400 border border-emerald-500/30'
              : 'bg-red-500/20 text-red-400 border border-red-500/30'
          }`}>
            <div className={`w-2 h-2 rounded-full ${isRunning ? 'bg-emerald-500' : 'bg-red-500'} ${isRunning ? 'animate-pulse' : ''}`}></div>
            <span>{isRunning ? 'Running' : 'Stopped'}</span>
          </div>
        )}
      </div>

      <p className="text-sm text-slate-400 mb-6 leading-relaxed">
        {description}
      </p>

      <div className="grid grid-cols-2 gap-2 mb-4">
        <button
          onClick={() => onAction(stack.name, 'start')}
          disabled={isLoading || isRunning}
          className="flex items-center justify-center space-x-2 px-3 py-2 bg-emerald-500/10 hover:bg-emerald-500/20 text-emerald-400 rounded-lg transition-all disabled:opacity-50 disabled:cursor-not-allowed border border-emerald-500/20 hover:border-emerald-500/30"
        >
          {isLoading ? <Loader2 className="h-4 w-4 animate-spin" /> : <Play className="h-4 w-4" />}
          <span className="text-sm font-medium">Start</span>
        </button>

        <button
          onClick={() => onAction(stack.name, 'stop')}
          disabled={isLoading || !isRunning}
          className="flex items-center justify-center space-x-2 px-3 py-2 bg-red-500/10 hover:bg-red-500/20 text-red-400 rounded-lg transition-all disabled:opacity-50 disabled:cursor-not-allowed border border-red-500/20 hover:border-red-500/30"
        >
          {isLoading ? <Loader2 className="h-4 w-4 animate-spin" /> : <Square className="h-4 w-4" />}
          <span className="text-sm font-medium">Stop</span>
        </button>
      </div>

      <div className="grid grid-cols-2 gap-2">
        <button
          onClick={() => onAction(stack.name, 'restart')}
          disabled={isLoading}
          className="flex items-center justify-center space-x-2 px-3 py-2 bg-blue-500/10 hover:bg-blue-500/20 text-blue-400 rounded-lg transition-all disabled:opacity-50 disabled:cursor-not-allowed border border-blue-500/20 hover:border-blue-500/30"
        >
          {isLoading ? <Loader2 className="h-4 w-4 animate-spin" /> : <RotateCcw className="h-4 w-4" />}
          <span className="text-sm font-medium">Restart</span>
        </button>

        <button
          onClick={() => onViewLogs(stack.name)}
          className="flex items-center justify-center space-x-2 px-3 py-2 bg-slate-700/50 hover:bg-slate-700 text-slate-300 rounded-lg transition-all border border-slate-600 hover:border-slate-500"
        >
          <FileText className="h-4 w-4" />
          <span className="text-sm font-medium">Logs</span>
        </button>
      </div>
    </div>
  );
}
