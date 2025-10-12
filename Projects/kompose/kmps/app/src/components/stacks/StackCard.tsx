'use client';

import { Play, Square, RotateCw, FileText, CheckCircle2, XCircle, Loader2 } from 'lucide-react';

interface StackCardProps {
  name: string;
  description: string;
  icon: any;
  status?: string;
  onStart: () => void;
  onStop: () => void;
  onRestart: () => void;
  onViewLogs: () => void;
  loading: Record<string, boolean>;
}

export default function StackCard({
  name,
  description,
  icon: Icon,
  status,
  onStart,
  onStop,
  onRestart,
  onViewLogs,
  loading
}: StackCardProps) {
  const isRunning = status?.toLowerCase().includes('running') || status?.toLowerCase().includes('up');
  const isLoading = loading[`${name}-start`] || loading[`${name}-stop`] || loading[`${name}-restart`];

  return (
    <div className="bg-slate-800/50 border border-slate-700 rounded-lg overflow-hidden hover:border-emerald-500/30 transition-all hover:shadow-lg hover:shadow-emerald-500/5 backdrop-blur-sm group">
      {/* Header */}
      <div className="p-6 pb-4">
        <div className="flex items-start justify-between mb-4">
          <div className="flex items-center space-x-3">
            <div className={`p-3 rounded-lg border ${
              isRunning 
                ? 'bg-emerald-500/10 border-emerald-500/20 text-emerald-500' 
                : 'bg-slate-700/50 border-slate-600 text-slate-400'
            } group-hover:scale-110 transition-transform`}>
              <Icon className="h-6 w-6" />
            </div>
            <div>
              <h3 className="text-lg font-bold text-white">{name}</h3>
              <p className="text-slate-400 text-sm mt-1">{description}</p>
            </div>
          </div>
        </div>

        {/* Status Badge */}
        <div className="flex items-center space-x-2">
          <div className={`flex items-center space-x-2 px-3 py-1.5 rounded-full text-xs font-medium border ${
            isRunning
              ? 'bg-emerald-500/10 text-emerald-400 border-emerald-500/30'
              : 'bg-slate-700/50 text-slate-400 border-slate-600'
          }`}>
            {isRunning ? (
              <>
                <div className="w-2 h-2 bg-emerald-500 rounded-full animate-pulse"></div>
                <span>Running</span>
              </>
            ) : (
              <>
                <div className="w-2 h-2 bg-slate-500 rounded-full"></div>
                <span>Stopped</span>
              </>
            )}
          </div>
        </div>
      </div>

      {/* Divider */}
      <div className="border-t border-slate-700"></div>

      {/* Actions */}
      <div className="p-4 bg-slate-900/30">
        <div className="grid grid-cols-4 gap-2">
          <button
            onClick={onStart}
            disabled={isRunning || isLoading}
            className={`flex items-center justify-center space-x-1 px-3 py-2 rounded-lg text-sm font-medium transition-all ${
              isRunning || isLoading
                ? 'bg-slate-700/30 text-slate-500 cursor-not-allowed'
                : 'bg-emerald-500/10 hover:bg-emerald-500/20 text-emerald-400 border border-emerald-500/30 hover:border-emerald-500/50'
            }`}
            title="Start stack"
          >
            {loading[`${name}-start`] ? (
              <Loader2 className="h-4 w-4 animate-spin" />
            ) : (
              <Play className="h-4 w-4" />
            )}
            <span className="hidden sm:inline">Start</span>
          </button>

          <button
            onClick={onStop}
            disabled={!isRunning || isLoading}
            className={`flex items-center justify-center space-x-1 px-3 py-2 rounded-lg text-sm font-medium transition-all ${
              !isRunning || isLoading
                ? 'bg-slate-700/30 text-slate-500 cursor-not-allowed'
                : 'bg-red-500/10 hover:bg-red-500/20 text-red-400 border border-red-500/30 hover:border-red-500/50'
            }`}
            title="Stop stack"
          >
            {loading[`${name}-stop`] ? (
              <Loader2 className="h-4 w-4 animate-spin" />
            ) : (
              <Square className="h-4 w-4" />
            )}
            <span className="hidden sm:inline">Stop</span>
          </button>

          <button
            onClick={onRestart}
            disabled={!isRunning || isLoading}
            className={`flex items-center justify-center space-x-1 px-3 py-2 rounded-lg text-sm font-medium transition-all ${
              !isRunning || isLoading
                ? 'bg-slate-700/30 text-slate-500 cursor-not-allowed'
                : 'bg-blue-500/10 hover:bg-blue-500/20 text-blue-400 border border-blue-500/30 hover:border-blue-500/50'
            }`}
            title="Restart stack"
          >
            {loading[`${name}-restart`] ? (
              <Loader2 className="h-4 w-4 animate-spin" />
            ) : (
              <RotateCw className="h-4 w-4" />
            )}
            <span className="hidden sm:inline">Restart</span>
          </button>

          <button
            onClick={onViewLogs}
            className="flex items-center justify-center space-x-1 px-3 py-2 rounded-lg text-sm font-medium bg-purple-500/10 hover:bg-purple-500/20 text-purple-400 border border-purple-500/30 hover:border-purple-500/50 transition-all"
            title="View logs"
          >
            <FileText className="h-4 w-4" />
            <span className="hidden sm:inline">Logs</span>
          </button>
        </div>
      </div>
    </div>
  );
}
