'use client';

import { useState, useEffect } from 'react';
import useSWR from 'swr';
import { 
  Play, 
  Square, 
  RotateCw, 
  Activity, 
  Server, 
  CheckCircle2, 
  XCircle, 
  Clock,
  Boxes,
  Terminal,
  ChevronDown,
  ChevronRight,
  FileText,
  TrendingUp,
  Database,
  Shield,
  Code,
  Home,
  Link2,
  MessageSquare,
  Inbox,
  Globe
} from 'lucide-react';
import StackCard from './StackCard';
import LogsModal from './LogsModal';

const fetcher = (url: string) => fetch(url).then((res) => res.json());

const stackIcons: Record<string, any> = {
  core: Database,
  auth: Shield,
  code: Code,
  home: Home,
  chain: Link2,
  messaging: MessageSquare,
  news: Inbox,
  proxy: Globe,
  kmps: Server,
  vault: Shield,
  vpn: Globe,
  track: Activity,
  link: Link2,
  watch: Activity,
  trace: Activity
};

export default function StacksMonitor() {
  const [selectedStack, setSelectedStack] = useState<string | null>(null);
  const [logsStack, setLogsStack] = useState<string | null>(null);
  const [actionLoading, setActionLoading] = useState<Record<string, boolean>>({});
  const [lastAction, setLastAction] = useState<{ stack: string; action: string; success: boolean } | null>(null);
  
  const { data: stacksResponse, error, mutate } = useSWR('/api/kompose/stacks', fetcher, {
    refreshInterval: 10000, // Refresh every 10 seconds
  });

  const stacks = stacksResponse?.data || [];

  const handleAction = async (stackName: string, action: 'start' | 'stop' | 'restart') => {
    setActionLoading({ ...actionLoading, [`${stackName}-${action}`]: true });
    
    try {
      const response = await fetch(`/api/kompose/stacks/${stackName}/${action}`, {
        method: 'POST',
      });
      
      const data = await response.json();
      
      if (data.status === 'success') {
        setLastAction({ stack: stackName, action, success: true });
        // Refresh the stacks list
        mutate();
      } else {
        setLastAction({ stack: stackName, action, success: false });
        console.error(`Failed to ${action} stack:`, data.message);
      }
    } catch (error) {
      setLastAction({ stack: stackName, action, success: false });
      console.error(`Failed to ${action} stack:`, error);
    } finally {
      setActionLoading({ ...actionLoading, [`${stackName}-${action}`]: false });
      // Clear the action notification after 3 seconds
      setTimeout(() => setLastAction(null), 3000);
    }
  };

  if (error) {
    return (
      <div className="bg-red-500/10 border border-red-500/20 rounded-lg p-8">
        <div className="flex items-center space-x-3 mb-4">
          <XCircle className="h-6 w-6 text-red-400" />
          <h3 className="text-xl font-bold text-red-400">Connection Error</h3>
        </div>
        <p className="text-red-300 mb-4">Failed to connect to Kompose API server</p>
        <p className="text-slate-400 text-sm">
          Make sure the Kompose API server is running and accessible. Check your KOMPOSE_API_URL configuration.
        </p>
      </div>
    );
  }

  if (!stacks || stacks.length === 0) {
    return (
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-3xl font-bold text-white mb-2">Stack Monitor</h2>
            <p className="text-slate-400">Manage and monitor your Kompose infrastructure</p>
          </div>
        </div>
        
        <div className="bg-slate-800/50 border border-slate-700 rounded-lg p-12 text-center">
          <div className="animate-pulse mb-4">
            <Boxes className="h-16 w-16 text-slate-600 mx-auto" />
          </div>
          <p className="text-slate-400 text-lg">Loading stacks...</p>
          <div className="mt-6 flex justify-center space-x-2">
            {[1, 2, 3].map((i) => (
              <div key={i} className="w-2 h-2 bg-emerald-500 rounded-full animate-bounce" style={{ animationDelay: `${i * 0.1}s` }}></div>
            ))}
          </div>
        </div>
      </div>
    );
  }

  const totalStacks = stacks.length;
  const runningStacks = stacks.filter((s: any) => s.status?.includes('running') || s.status?.includes('Up')).length;

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-3xl font-bold text-white mb-2">Stack Monitor</h2>
          <p className="text-slate-400">Manage and monitor your Kompose infrastructure</p>
        </div>
        <button
          onClick={() => mutate()}
          className="flex items-center space-x-2 px-4 py-2 bg-emerald-500/10 hover:bg-emerald-500/20 border border-emerald-500/30 rounded-lg text-emerald-400 transition-all"
        >
          <RotateCw className="h-4 w-4" />
          <span>Refresh</span>
        </button>
      </div>

      {/* Action Notification */}
      {lastAction && (
        <div className={`p-4 rounded-lg border ${
          lastAction.success 
            ? 'bg-emerald-500/10 border-emerald-500/30' 
            : 'bg-red-500/10 border-red-500/30'
        } animate-fade-in`}>
          <div className="flex items-center space-x-3">
            {lastAction.success ? (
              <CheckCircle2 className="h-5 w-5 text-emerald-400" />
            ) : (
              <XCircle className="h-5 w-5 text-red-400" />
            )}
            <p className={lastAction.success ? 'text-emerald-400' : 'text-red-400'}>
              {lastAction.success 
                ? `Successfully ${lastAction.action}ed stack: ${lastAction.stack}`
                : `Failed to ${lastAction.action} stack: ${lastAction.stack}`
              }
            </p>
          </div>
        </div>
      )}

      {/* Stats Overview */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <div className="bg-slate-800/50 border border-slate-700 rounded-lg p-6 backdrop-blur-sm">
          <div className="flex items-center justify-between mb-4">
            <div className="p-3 rounded-lg bg-emerald-500/10 border border-emerald-500/20">
              <Boxes className="h-6 w-6 text-emerald-500" />
            </div>
          </div>
          <h3 className="text-3xl font-bold text-white mb-1">{totalStacks}</h3>
          <p className="text-slate-400 text-sm">Total Stacks</p>
        </div>

        <div className="bg-slate-800/50 border border-slate-700 rounded-lg p-6 backdrop-blur-sm">
          <div className="flex items-center justify-between mb-4">
            <div className="p-3 rounded-lg bg-blue-500/10 border border-blue-500/20">
              <Activity className="h-6 w-6 text-blue-500" />
            </div>
          </div>
          <h3 className="text-3xl font-bold text-white mb-1">{runningStacks}</h3>
          <p className="text-slate-400 text-sm">Running</p>
        </div>

        <div className="bg-slate-800/50 border border-slate-700 rounded-lg p-6 backdrop-blur-sm">
          <div className="flex items-center justify-between mb-4">
            <div className="p-3 rounded-lg bg-purple-500/10 border border-purple-500/20">
              <Server className="h-6 w-6 text-purple-500" />
            </div>
          </div>
          <h3 className="text-3xl font-bold text-white mb-1">{totalStacks - runningStacks}</h3>
          <p className="text-slate-400 text-sm">Stopped</p>
        </div>

        <div className="bg-slate-800/50 border border-slate-700 rounded-lg p-6 backdrop-blur-sm">
          <div className="flex items-center justify-between mb-4">
            <div className="p-3 rounded-lg bg-orange-500/10 border border-orange-500/20">
              <TrendingUp className="h-6 w-6 text-orange-500" />
            </div>
          </div>
          <h3 className="text-3xl font-bold text-white mb-1">
            {totalStacks > 0 ? Math.round((runningStacks / totalStacks) * 100) : 0}%
          </h3>
          <p className="text-slate-400 text-sm">Uptime Ratio</p>
        </div>
      </div>

      {/* Stacks Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-6">
        {stacks.map((stack: any) => (
          <StackCard
            key={stack.name}
            name={stack.name}
            description={stack.description}
            icon={stackIcons[stack.name] || Server}
            status={stack.status}
            onStart={() => handleAction(stack.name, 'start')}
            onStop={() => handleAction(stack.name, 'stop')}
            onRestart={() => handleAction(stack.name, 'restart')}
            onViewLogs={() => setLogsStack(stack.name)}
            loading={actionLoading}
          />
        ))}
      </div>

      {/* Logs Modal */}
      {logsStack && (
        <LogsModal
          stackName={logsStack}
          onClose={() => setLogsStack(null)}
        />
      )}
    </div>
  );
}
