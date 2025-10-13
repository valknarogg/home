import { NextResponse } from 'next/server';

const KOMPOSE_API_URL = process.env.KOMPOSE_API_URL || 'http://kompose-api:8080';

export async function GET() {
  try {
    const response = await fetch(`${KOMPOSE_API_URL}/api/stacks`, {
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
    console.error('Failed to fetch stacks:', error);
    return NextResponse.json(
      { 
        status: 'error', 
        message: error.message || 'Failed to fetch stacks',
        data: null 
      },
      { status: 500 }
    );
  }
}
