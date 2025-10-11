import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '../../auth/[...nextauth]/route';
import { getUsers } from '@/lib/keycloak';

export async function GET() {
  try {
    const session = await getServerSession(authOptions);
    if (!session) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const users = await getUsers();
    // Sort by creation timestamp (newest first) and limit to recent users
    const recentUsers = users
      .sort((a, b) => (b.createdTimestamp || 0) - (a.createdTimestamp || 0))
      .slice(0, 10);
    
    return NextResponse.json(recentUsers);
  } catch (error: any) {
    console.error('Error fetching recent users:', error);
    return NextResponse.json(
      { error: error.message || 'Failed to fetch recent users' },
      { status: 500 }
    );
  }
}
