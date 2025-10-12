'use client';

import useSWR from 'swr';
import { Users, Key, Layers, Activity, Shield, TrendingUp, Clock, UserCheck, CheckCircle2 } from 'lucide-react';

const fetcher = (url: string) => fetch(url).then((res) => res.json());

export default function Dashboard() {
  const { data: stats, error } = useSWR('/api/dashboard/stats', fetcher, {
    refreshInterval: 30000,
  });

  const { data: recentUsers } = useSWR('/api/dashboard/recent-users', fetcher, {
    refreshInterval: 60000,
  });

  if (error) {
    return (
      <div className="bg-red-500/10 border border-red-500/20 rounded-lg p-4">
        <p className="text-red-400">Failed to load dashboard data</p>
      </div>
    );
  }

  if (!stats) {
    return (
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {[1, 2, 3, 4].map((i) => (
          <div key={i} className="bg-slate-800/50 border border-slate-700 rounded-lg p-6 animate-pulse">
            <div className="h-4 bg-slate-700 rounded w-1/2 mb-2"></div>
            <div className="h-8 bg-slate-700 rounded w-1/3"></div>
          </div>
        ))}
      </div>
    );
  }

  return (
    <div className="space-y-8">
      {/* Status Bar */}
      <div className="bg-gradient-to-r from-emerald-500/10 to-blue-500/10 border border-emerald-500/20 rounded-lg p-4">
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <div className="w-3 h-3 bg-emerald-500 rounded-full animate-pulse"></div>
            <span className="text-emerald-400 font-medium">System Operational</span>
          </div>
          <div className="flex items-center space-x-6 text-sm text-slate-400">
            <div className="flex items-center space-x-2">
              <Shield className="h-4 w-4 text-emerald-500" />
              <span>SSO Active</span>
            </div>
            <div className="flex items-center space-x-2">
              <Activity className="h-4 w-4 text-blue-500" />
              <span>Identity Management</span>
            </div>
          </div>
        </div>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <StatCard
          title="Total Users"
          value={stats.usersCount || 0}
          icon={Users}
          color="emerald"
          description="Registered accounts"
        />
        <StatCard
          title="Active Users"
          value={stats.activeUsersCount || 0}
          icon={UserCheck}
          color="blue"
          description="Enabled accounts"
        />
        <StatCard
          title="OAuth Clients"
          value={stats.clientsCount || 0}
          icon={Key}
          color="purple"
          description="Registered applications"
        />
        <StatCard
          title="User Groups"
          value={stats.groupsCount || 0}
          icon={Layers}
          color="orange"
          description="Group configurations"
        />
      </div>

      {/* Main Content Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Recent Users */}
        <div className="lg:col-span-2 bg-slate-800/50 border border-slate-700 rounded-lg p-6 backdrop-blur-sm">
          <div className="flex items-center justify-between mb-6">
            <h3 className="text-xl font-bold text-white flex items-center space-x-2">
              <Users className="h-6 w-6 text-emerald-500" />
              <span>Recent Users</span>
            </h3>
            <a href="/users" className="text-sm text-emerald-400 hover:text-emerald-300 transition-colors">
              View All →
            </a>
          </div>
          
          {recentUsers && recentUsers.length > 0 ? (
            <div className="space-y-3">
              {recentUsers.slice(0, 5).map((user: any) => (
                <div
                  key={user.id}
                  className="flex items-center justify-between p-4 bg-slate-700/30 rounded-lg hover:bg-slate-700/50 transition-all cursor-pointer border border-slate-700/50 hover:border-emerald-500/30"
                >
                  <div className="flex items-center space-x-4">
                    <div className="w-12 h-12 rounded-full bg-gradient-to-br from-emerald-500 to-emerald-600 flex items-center justify-center shadow-lg">
                      <span className="text-white font-bold text-lg">
                        {(user.username || user.email)?.charAt(0).toUpperCase()}
                      </span>
                    </div>
                    <div>
                      <p className="text-white font-medium">{user.username || user.email}</p>
                      <p className="text-slate-400 text-sm">{user.email}</p>
                    </div>
                  </div>
                  <div className="text-right">
                    <span
                      className={`px-3 py-1 rounded-full text-xs font-medium ${
                        user.enabled
                          ? 'bg-emerald-500/20 text-emerald-400 border border-emerald-500/30'
                          : 'bg-red-500/20 text-red-400 border border-red-500/30'
                      }`}
                    >
                      {user.enabled ? 'Active' : 'Disabled'}
                    </span>
                    {user.createdTimestamp && (
                      <p className="text-slate-500 text-xs mt-1 flex items-center justify-end space-x-1">
                        <Clock className="h-3 w-3" />
                        <span>{new Date(user.createdTimestamp).toLocaleDateString()}</span>
                      </p>
                    )}
                  </div>
                </div>
              ))}
            </div>
          ) : (
            <div className="text-center py-12 text-slate-400">
              <Users className="h-12 w-12 mx-auto mb-3 opacity-50" />
              <p>No users found</p>
            </div>
          )}
        </div>

        {/* Quick Actions */}
        <div className="space-y-4">
          <h3 className="text-xl font-bold text-white mb-4">Quick Actions</h3>
          <QuickActionCard
            title="Create User"
            description="Add new user account"
            icon={Users}
            color="emerald"
            href="/users?action=create"
          />
          <QuickActionCard
            title="Add Client"
            description="Register OAuth client"
            icon={Key}
            color="blue"
            href="/clients?action=create"
          />
          <QuickActionCard
            title="Manage Groups"
            description="Configure user groups"
            icon={Layers}
            color="purple"
            href="/groups?action=create"
          />
        </div>
      </div>
    </div>
  );
}

interface StatCardProps {
  title: string;
  value: number;
  icon: any;
  color: 'emerald' | 'blue' | 'purple' | 'orange';
  description: string;
}

function StatCard({ title, value, icon: Icon, color, description }: StatCardProps) {
  const colorClasses = {
    emerald: 'bg-emerald-500/10 text-emerald-500 border-emerald-500/20',
    blue: 'bg-blue-500/10 text-blue-500 border-blue-500/20',
    purple: 'bg-purple-500/10 text-purple-500 border-purple-500/20',
    orange: 'bg-orange-500/10 text-orange-500 border-orange-500/20',
  };

  return (
    <div className="bg-slate-800/50 border border-slate-700 rounded-lg p-6 hover:border-slate-600 transition-all hover:shadow-lg hover:shadow-emerald-500/5 backdrop-blur-sm">
      <div className="flex items-center justify-between mb-4">
        <div className={`p-3 rounded-lg border ${colorClasses[color]}`}>
          <Icon className="h-6 w-6" />
        </div>
      </div>
      <h3 className="text-3xl font-bold text-white mb-1">{value}</h3>
      <p className="text-slate-400 text-sm font-medium">{title}</p>
      <p className="text-slate-500 text-xs mt-2">{description}</p>
    </div>
  );
}

interface QuickActionCardProps {
  title: string;
  description: string;
  icon: any;
  color: 'emerald' | 'blue' | 'purple';
  href: string;
}

function QuickActionCard({ title, description, icon: Icon, color, href }: QuickActionCardProps) {
  const colorClasses = {
    emerald: 'bg-emerald-500/10 text-emerald-500',
    blue: 'bg-blue-500/10 text-blue-500',
    purple: 'bg-purple-500/10 text-purple-500',
  };

  return (
    <a
      href={href}
      className="block bg-slate-800/30 border border-slate-700 rounded-lg p-4 hover:bg-slate-800/50 hover:border-emerald-500/30 transition-all hover:shadow-lg backdrop-blur-sm"
    >
      <div className={`inline-flex p-2 rounded-lg mb-3 ${colorClasses[color]}`}>
        <Icon className="h-5 w-5" />
      </div>
      <h4 className="text-base font-semibold text-white mb-1">{title}</h4>
      <p className="text-slate-400 text-sm">{description}</p>
    </a>
  );
}
