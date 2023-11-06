import { type Plant, type Cultivar } from './types';
import { Turbo } from '@hotwired/turbo-rails';

export async function fetchPlants(): Promise<Plant[]> {
  try {
    const response = await fetch('/map_data/plants');
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Error fetching plants:', error);
    throw error;
  }
}

export async function routeToInfoPanel(cultivarId: number) {
  const token = document && document.querySelector('meta[name="csrf-token"]');
  if (!token) {
    throw new Error('CSRF token not found');
  }
  try {
    const response = await fetch(`/map_data/info_panel/${cultivarId}`, {
      method: 'POST',
      headers: {
        Accept: 'text/vnd.turbo-stream.html',
        'X-CSRF-Token': token.getAttribute('content') || '',
      },
    });

    if (!response.ok) {
      throw new Error('Network response was not ok');
    }

    const body = await response.text();
    Turbo.renderStreamMessage(body);
  } catch (error) {
    console.error('Error fetching cultivar info:', error);
    throw error;
  }
}

export async function routeToResultPanel(results: Cultivar[]) {
  const token = document && document.querySelector('meta[name="csrf-token"]');
  if (!token) {
    throw new Error('CSRF token not found');
  }
  try {
    const response = await fetch(`/map_data/results_panel/`, {
      method: 'POST',
      body: JSON.stringify(results),
      headers: {
        Accept: 'text/vnd.turbo-stream.html',
        'X-CSRF-Token': token.getAttribute('content') || '',
      },
    });

    if (!response.ok) {
      throw new Error('Network response was not ok');
    }

    const body = await response.text();
    Turbo.renderStreamMessage(body);
  } catch (error) {
    console.error('Error fetching cultivar info:', error);
    throw error;
  }
}

export async function queryCultivars(queryString: string): Promise<Cultivar[]> {
  try {
    const response = await fetch(`/map_data/cultivars?query=${queryString}`);
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Error querying cultivars:', error);
    throw error;
  }
}
