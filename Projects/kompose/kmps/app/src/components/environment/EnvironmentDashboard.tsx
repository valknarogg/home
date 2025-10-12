'use client';

import { useState } from 'react';
import useSWR from 'swr';
import { 
  Settings, FileText, Shield, AlertCircle, CheckCircle2, 
  XCircle, Loader2, Eye, EyeOff, Server, Database,
  Layers, RefreshCcw
} from 'lucide-react';

const fetcher = (url: string) => fetch(url).then((res) => res.json());

interface StackEnv {
  stack: string;
  prefix: string;
  count: number;
}

export default function EnvironmentDashboard() {
  const [selectedStack, setSelectedStack] = useState<string | null>(null);
  const [showValues, setShowValues] = useState(false);
  const [validationResults, setValidationResults] = useState<Record<string, any>>({});

  const { data: stacksEnvData, error } = useSWR('/api/env/stacks', fetcher, {
    refreshInterval: 30000,
  });

  const { data: selectedStackData, mutate: mutateStack } = useSWR(
    selectedStack ? `/api/env/show/${selectedStack}` : null,
    fetcher
  );

  const stacksEnv: StackEnv[] = stacksEnvData?.data || [];

  const validateStack = async (stackName: string) => {
    try {
      const response = await fetch(`/api/env/validate/${stackName}`);
      const data = await response.json();
      
      setValidationResults(prev => ({
        ...prev,
        [stackName]: data.data
      }));
    } catch (error) {
      console.error(`Failed to validate ${stackName}:`, error);
    }
  };

  const parseVariables = (output: string) => {
    const lines = output.split('\n');
    const variables: Array<{ key: string; value: string; section?: string }> = [];
    let currentSection = '';

    for (const line of lines) {
      if (line.startsWith('===') || line.startsWith('---')) continue;
      
      // Check for section headers
      if (line.includes('variables') && line.includes(':')) {
        currentSection = line.split(':')[0].trim();
        continue;
      }

      // Parse KEY=VALUE
      const match = line.match(/^\s*([A-Z_][A-Z0-9_]*)=(.*)/);
      if (match) {
        variables.push({
          key: match[1],
          value: match[2],
          section: currentSection
        });
      }
    }

    return variables;
  };

  if (error) {
    return (
      <div className="bg-red-500/10 border border-red-500/20 rounded-lg p-6">
        <div className="flex items-center space-x-3">
          <XCircle className="h-6 w-6 text-red-400" />
          <div>
            <p className="text-red-400 font-medium">Failed to load environment configuration</p>
            <p className="text-red-300 text-sm mt-1">Please ensure the Kompose API server is running</p>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h2 className="text-3xl font-bold text-white flex items-center space-x-3">
          <Settings className="h-8 w-8 text-emerald-500" />
          <span>Environment Configuration</span>
        </h2>
        <button
          onClick={() => setShowValues(!showValues)}
          className="flex items-center space-x-2 px-4 py-2 bg-slate-700 hover:bg-slate-600 text-white rounded-lg transition-colors"
        >
          {showValues ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
          <span className="text-sm">{showValues ? 'Hide' : 'Show'} Values</span>
        </button>
      </div>

      {/* Info Banner */}
      <div className="bg-blue-500/10 border border-blue-500/20 rounded-lg p-4">
        <div className="flex items-start space-x-3">
          <AlertCircle className="h-5 w-5 text-blue-400 mt-0.5" />
          <div className="flex-1">
            <p className="text-blue-300 text-sm">
              Environment variables are centrally managed in <code className="px-2 py-0.5 bg-blue-500/20 rounded">.env</code> and <code className="px-2 py-0.5 bg-blue-500/20 rounded">secrets.env</code> files. 
              Each stack uses a prefix (e.g., <code className="px-2 py-0.5 bg-blue-500/20 rounded">CORE_</code>, <code className="px-2 py-0.5 bg-blue-500/20 rounded">AUTH_</code>) to scope its variables.
            </p>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Stack List */}
        <div className="lg:col-span-1 space-y-4">
          <h3 className="text-xl font-bold text-white mb-4">Stacks</h3>
          
          {!stacksEnv || stacksEnv.length === 0 ? (
            <div className="space-y-2">
              {[1, 2, 3, 4, 5].map((i) => (
                <div key={i} className="bg-slate-800/50 border border-slate-700 rounded-lg p-4 animate-pulse">
                  <div className="h-5 bg-slate-700 rounded w-1/3 mb-2"></div>
                  <div className="h-4 bg-slate-700 rounded w-1/2"></div>
                </div>
              ))}
            </div>
          ) : (
            <div className="space-y-2">
              {stacksEnv.map((stackEnv) => {
                const validation = validationResults[stackEnv.stack];
                
                return (
                  <button
                    key={stackEnv.stack}
                    onClick={() => setSelectedStack(stackEnv.stack)}
                    className={`w-full text-left bg-slate-800/50 border rounded-lg p-4 transition-all ${
                      selectedStack === stackEnv.stack
                        ? 'border-emerald-500 bg-emerald-500/5'
                        : 'border-slate-700 hover:border-slate-600 hover:bg-slate-800/70'
                    }`}
                  >
                    <div className="flex items-center justify-between mb-2">
                      <div className="flex items-center space-x-2">
                        <Server className="h-5 w-5 text-emerald-500" />
                        <span className="text-white font-medium capitalize">{stackEnv.stack}</span>
                      </div>
                      {validation && (
                        validation.valid ? (
                          <CheckCircle2 className="h-5 w-5 text-emerald-500" />
                        ) : (
                          <XCircle className="h-5 w-5 text-red-500" />
                        )
                      )}
                    </div>
                    <div className="flex items-center justify-between text-xs">
                      <span className="text-slate-400">{stackEnv.count} variables</span>
                      <span className="text-slate-500 font-mono">{stackEnv.prefix}</span>
                    </div>
                  </button>
                );
              })}
            </div>
          )}
        </div>

        {/* Variables Display */}
        <div className="lg:col-span-2">
          {!selectedStack ? (
            <div className="bg-slate-800/30 border border-slate-700 rounded-lg p-12 text-center">
              <Layers className="h-16 w-16 text-slate-600 mx-auto mb-4" />
              <p className="text-slate-400">Select a stack to view its environment variables</p>
            </div>
          ) : !selectedStackData ? (
            <div className="bg-slate-800/50 border border-slate-700 rounded-lg p-6">
              <div className="flex items-center justify-center space-x-3">
                <Loader2 className="h-6 w-6 text-emerald-500 animate-spin" />
                <span className="text-slate-400">Loading variables...</span>
              </div>
            </div>
          ) : (
            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <h3 className="text-xl font-bold text-white capitalize flex items-center space-x-2">
                  <Server className="h-6 w-6 text-emerald-500" />
                  <span>{selectedStack} Variables</span>
                </h3>
                <div className="flex items-center space-x-2">
                  <button
                    onClick={() => validateStack(selectedStack)}
                    className="flex items-center space-x-2 px-3 py-2 bg-blue-500/10 hover:bg-blue-500/20 text-blue-400 rounded-lg transition-all border border-blue-500/20"
                  >
                    <RefreshCcw className="h-4 w-4" />
                    <span className="text-sm">Validate</span>
                  </button>
                  <button
                    onClick={() => mutateStack()}
                    className="p-2 bg-slate-700 hover:bg-slate-600 text-slate-300 rounded-lg transition-colors"
                  >
                    <RefreshCcw className="h-4 w-4" />
                  </button>
                </div>
              </div>

              {/* Validation Result */}
              {validationResults[selectedStack] && (
                <div className={`border rounded-lg p-4 ${
                  validationResults[selectedStack].valid
                    ? 'bg-emerald-500/10 border-emerald-500/20'
                    : 'bg-red-500/10 border-red-500/20'
                }`}>
                  <div className="flex items-center space-x-3">
                    {validationResults[selectedStack].valid ? (
                      <CheckCircle2 className="h-5 w-5 text-emerald-500" />
                    ) : (
                      <XCircle className="h-5 w-5 text-red-500" />
                    )}
                    <div>
                      <p className={`font-medium ${validationResults[selectedStack].valid ? 'text-emerald-400' : 'text-red-400'}`}>
                        {validationResults[selectedStack].message}
                      </p>
                      {validationResults[selectedStack].output && (
                        <pre className="text-xs mt-2 text-slate-400 whitespace-pre-wrap">
                          {validationResults[selectedStack].output}
                        </pre>
                      )}
                    </div>
                  </div>
                </div>
              )}

              {/* Variables List */}
              <div className="bg-slate-800/50 border border-slate-700 rounded-lg overflow-hidden">
                <div className="overflow-auto max-h-[600px]">
                  {parseVariables(selectedStackData.data.variables).length === 0 ? (
                    <div className="p-8 text-center text-slate-400">
                      <FileText className="h-12 w-12 mx-auto mb-3 opacity-50" />
                      <p>No variables found for this stack</p>
                    </div>
                  ) : (
                    <div className="divide-y divide-slate-700">
                      {parseVariables(selectedStackData.data.variables).map((variable, index) => (
                        <div key={index} className="p-4 hover:bg-slate-700/30 transition-colors">
                          {variable.section && index === 0 && (
                            <div className="text-xs text-emerald-400 mb-2 font-medium uppercase tracking-wider">
                              {variable.section}
                            </div>
                          )}
                          <div className="flex items-start justify-between">
                            <div className="flex-1 min-w-0">
                              <div className="flex items-center space-x-2">
                                <code className="text-emerald-400 font-mono text-sm">{variable.key}</code>
                                {variable.key.toLowerCase().includes('secret') || 
                                 variable.key.toLowerCase().includes('password') || 
                                 variable.key.toLowerCase().includes('token') ? (
                                  <Shield className="h-4 w-4 text-yellow-500" title="Sensitive value" />
                                ) : null}
                              </div>
                              <div className="mt-1">
                                {showValues ? (
                                  <code className="text-slate-400 text-sm break-all">
                                    {variable.value || <span className="text-slate-600 italic">empty</span>}
                                  </code>
                                ) : (
                                  <code className="text-slate-600 text-sm">••••••••</code>
                                )}
                              </div>
                            </div>
                          </div>
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
