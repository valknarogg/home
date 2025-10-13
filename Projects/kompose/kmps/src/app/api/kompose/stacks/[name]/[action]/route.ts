import { NextRequest, NextResponse } from 'next/server';

const KOMPOSE_API_URL = process.env.KOMPOSE_API_URL || 'http://kompose-api:8080';

export async function POST(
  request: NextRequest,
  { params }: { params: { name: string; action: string } }
) {
  try {
    const { name, action } = params;
    
    // Validate action
    const validActions = ['start', 'stop', 'restart'];
    if (!validActions.includes(action)) {
      return NextResponse.json(
        { 
          status: 'error', 
          message: `Invalid action: ${action}. Valid actions: ${validActions.join(', ')}` 
        },
        { status: 400 }
      );
    }

    const response = await fetch(`${KOMPOSE_API_URL}/api/stacks/${name}/${action}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
    });

    if (!response.ok) {
      throw new Error(`Kompose API error: ${response.statusText}`);
    }

    const data = await response.json();
    return NextResponse.json(data);
  } catch (error: any) {
    console.error(`Failed to ${params.action} stack:`, error);
    return NextResponse.json(
      { 
        status: 'error', 
        message: error.message || `Failed to ${params.action} stack`,
        data: null 
      },
      { status: 500 }
    );
  }
}

export async function GET(
  request: NextRequest,
  { params }: { params: { name: string; action: string } }
) {
  try {
    const { name, action } = params;
    
    // Only logs action supports GET
    if (action !== 'logs') {
      return NextResponse.json(
        { 
          status: 'error', 
          message: 'GET method only supported for logs action' 
        },
        { status: 405 }
      );
    }

    const response = await fetch(`${KOMPOSE_API_URL}/api/stacks/${name}/logs`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
    });

    if (!response.ok) {
      throw new Error(`Kompose API error: ${response.statusText}`);
    }

    const data = await response.json();
    return NextResponse.json(data);
  } catch (error: any) {
    console.error('Failed to fetch logs:', error);
    return NextResponse.json(
      { 
        status: 'error', 
        message: error.message || 'Failed to fetch logs',
        data: null 
      },
      { status: 500 }
    );
  }
}
