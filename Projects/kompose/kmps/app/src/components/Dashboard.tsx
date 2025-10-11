'use client';

import useSWR from 'swr';
import { Users, Key, Layers, Activity } from 'lucide-react';

const fetcher = (url: string) => fetch(url).then((res) => res.json());

export default function Dashboard() {
  const { data: stats, error } = useSWR('/api/dashboard/stats', fetcher, {
    refreshInterval: 30000, // Refresh every 30 seconds
  });

  const { data: recentUsers } = useSWR('/api/dashboard/recent-users', fetcher, {
    refreshInterval: 60000, // Refresh every minute
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
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {[1, 2, 3].map((i) => (
          <div key={i} className="bg-slate-800/50 border border-slate-700 rounded-lg p-6 animate-pulse">
            <div className="h-4 bg-slate-700 rounded w-1/2 mb-2"></div>
            <div className="h-8 bg-slate-700 rounded w-1/3"></div>
          </div>
        ))}
      </div>
    );
  }

  const statCards = [
    {
      name: 'Total Users',
      value: stats.usersCount || 0,
      icon: Users,
      color: 'emerald',
      description: 'Active user accounts'
    },
    {
      name: 'OAuth Clients',
      value: stats.clientsCount || 0,
      icon: Key,
      color: 'blue',
      description: 'Registered applications'
    },
    {
      name: 'Groups',
      value: stats.groupsCount || 0,
      icon: Layers,
      color: 'purple',
      description: 'User groups'
    },
  ];

  return (
    <div className="space-y-8">
      {/* Welcome Banner */}
      <div className="bg-gradient-to-r from-emerald-500/10 to-blue-500/10 border border-emerald-500/20 rounded-lg p-6">
        <div className="flex items-center space-x-3">
          <Activity className="h-8 w-8 text-emerald-500" />
          <div>
            <h2 className="text-2xl font-bold text-white">Welcome to KMPS</h2>
            <p className="text-slate-300 mt-1">Manage your Kompose SSO users, clients, and groups</p>
          </div>
        </div>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {statCards.map((stat) => {
          const Icon = stat.icon;
          return (
            <div
              key={stat.name}
              className="bg-slate-800/50 border border-slate-700 rounded-lg p-6 hover:border-slate-600 transition-all hover:shadow-lg"
            >
              <div className="flex items-center justify-between mb-4">
                <div className={`p-3 rounded-lg bg-${stat.color}-500/10`}>
                  <Icon className={`h-6 w-6 text-${stat.color}-500`} />
                </div>
              </div>
              <h3 className="text-3xl font-bold text-white mb-1">{stat.value}</h3>
              <p className="text-slate-400 text-sm">{stat.name}</p>
              <p className="text-slate-500 text-xs mt-2">{stat.description}</p>
            </div>
          );
        })}
      </div>

      {/* Recent Users */}
      {recentUsers && recentUsers.length > 0 && (
        <div className="bg-slate-800/50 border border-slate-700 rounded-lg p-6">
          <h3 className="text-xl font-bold text-white mb-4 flex items-center space-x-2">
            <Users className="h-5 w-5 text-emerald-500" />
            <span>Recent Users</span>
          </h3>
          <div className="space-y-3">
            {recentUsers.slice(0, 5).map((user: any) => (
              <div
                key={user.id}
                className="flex items-center justify-between p-3 bg-slate-700/30 rounded-lg hover:bg-slate-700/50 transition-colors"
              >
                <div className="flex items-center space-x-3">
                  <div className="w-10 h-10 rounded-full bg-emerald-500/20 flex items-center justify-center">
                    <span className="text-emerald-500 font-bold">
                      {user.username?.charAt(0).toUpperCase() || user.email?.charAt(0).toUpperCase()}
                    </span>
                  </div>
                  <div>
                    <p className="text-white font-medium">{user.username || user.email}</p>
                    <p className="text-slate-400 text-sm">{user.email}</p>
                  </div>
                </div>
                <div className="text-right">
                  <span
                    className={`px-2 py-1 rounded text-xs ${
                      user.enabled
                        ? 'bg-emerald-500/20 text-emerald-400'
                        : 'bg-red-500/20 text-red-400'
                    }`}
                  >
                    {user.enabled ? 'Active' : 'Disabled'}
                  </span>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Quick Actions */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <QuickActionCard
          title="Add User"
          description="Create a new user account"
          href="/users?action=create"
          icon={Users}
          color="emerald"
        />
        <QuickActionCard
          title="Add Client"
          description="Register a new OAuth client"
          href="/clients?action=create"
          icon={Key}
          color="blue"
        />
        <QuickActionCard
          title="Add Group"
          description="Create a new user group"
          href="/groups?action=create"
          icon={Layers}
          color="purple"
        />
      </div>
    </div>
  );
}

function QuickActionCard({
  title,
  description,
  href,
  icon: Icon,
  color,
}: {
  title: string;
  description: string;
  href: string;
  icon: any;
  color: string;
}) {
  return (
    <a
      href={href}
      className="block bg-slate-800/30 border border-slate-700 rounded-lg p-6 hover:border-emerald-500/50 transition-all hover:shadow-lg hover:shadow-emerald-500/10"
    >
      <div className={`inline-flex p-3 rounded-lg bg-${color}-500/10 mb-4`}>
        <Icon className={`h-6 w-6 text-${color}-500`} />
      </div>
      <h4 className="text-lg font-semibold text-white mb-2">{title}</h4>
      <p className="text-slate-400 text-sm">{description}</p>
    </a>
  );
}
