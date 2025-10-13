'use client';

import { useEffect, useState } from 'react';
import { X, Terminal, Loader2, Download, RefreshCw } from 'lucide-react';

interface LogsModalProps {
  stackName: string;
  onClose: () => void;
}

export default function LogsModal({ stackName, onClose }: LogsModalProps) {
  const [logs, setLogs] = useState<string>('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchLogs = async () => {
    setLoading(true);
    setError(null);
    
    try {
      const response = await fetch(`/api/kompose/stacks/${stackName}/logs`);
      const data = await response.json();
      
      if (data.status === 'success') {
        setLogs(data.data?.logs || data.data?.output || 'No logs available');
      } else {
        setError(data.message || 'Failed to fetch logs');
      }
    } catch (err: any) {
      setError(err.message || 'Failed to fetch logs');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchLogs();
  }, [stackName]);

  const downloadLogs = () => {
    const blob = new Blob([logs], { type: 'text/plain' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `${stackName}-logs-${new Date().toISOString()}.txt`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/70 backdrop-blur-sm animate-fade-in">
      <div className="bg-slate-900 border border-slate-700 rounded-lg shadow-2xl max-w-6xl w-full max-h-[90vh] flex flex-col">
        {/* Header */}
        <div className="flex items-center justify-between p-6 border-b border-slate-700">
          <div className="flex items-center space-x-3">
            <div className="p-2 rounded-lg bg-purple-500/10 border border-purple-500/20">
              <Terminal className="h-5 w-5 text-purple-500" />
            </div>
            <div>
              <h3 className="text-xl font-bold text-white">Stack Logs</h3>
              <p className="text-slate-400 text-sm">{stackName}</p>
            </div>
          </div>
          
          <div className="flex items-center space-x-2">
            <button
              onClick={fetchLogs}
              disabled={loading}
              className="p-2 rounded-lg bg-blue-500/10 hover:bg-blue-500/20 text-blue-400 border border-blue-500/30 transition-all disabled:opacity-50 disabled:cursor-not-allowed"
              title="Refresh logs"
            >
              <RefreshCw className={`h-4 w-4 ${loading ? 'animate-spin' : ''}`} />
            </button>
            
            <button
              onClick={downloadLogs}
              disabled={loading || !logs}
              className="p-2 rounded-lg bg-emerald-500/10 hover:bg-emerald-500/20 text-emerald-400 border border-emerald-500/30 transition-all disabled:opacity-50 disabled:cursor-not-allowed"
              title="Download logs"
            >
              <Download className="h-4 w-4" />
            </button>
            
            <button
              onClick={onClose}
              className="p-2 rounded-lg bg-slate-700 hover:bg-slate-600 text-slate-300 transition-all"
            >
              <X className="h-4 w-4" />
            </button>
          </div>
        </div>

        {/* Logs Content */}
        <div className="flex-1 overflow-hidden p-6">
          {loading ? (
            <div className="flex items-center justify-center h-full">
              <div className="text-center">
                <Loader2 className="h-8 w-8 text-purple-500 animate-spin mx-auto mb-4" />
                <p className="text-slate-400">Loading logs...</p>
              </div>
            </div>
          ) : error ? (
            <div className="bg-red-500/10 border border-red-500/20 rounded-lg p-6">
              <p className="text-red-400">{error}</p>
            </div>
          ) : (
            <div className="h-full bg-slate-950 border border-slate-800 rounded-lg p-4 overflow-auto font-mono text-sm">
              <pre className="text-slate-300 whitespace-pre-wrap break-words">{logs}</pre>
            </div>
          )}
        </div>

        {/* Footer */}
        <div className="flex items-center justify-between p-6 border-t border-slate-700 bg-slate-900/50">
          <p className="text-slate-400 text-sm">
            Last updated: {new Date().toLocaleTimeString()}
          </p>
          <button
            onClick={onClose}
            className="px-4 py-2 rounded-lg bg-slate-700 hover:bg-slate-600 text-white transition-all"
          >
            Close
          </button>
        </div>
      </div>
    </div>
  );
}
