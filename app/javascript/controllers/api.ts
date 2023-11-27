import { type Plant } from './types';
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
  try {
    Turbo.visit('/map_data/info_panel/' + cultivarId, {
      acceptsStreamResponse: true,
      action: 'advance',
    });
    history.pushState(history.state, '', '/map_data/info_panel/' + cultivarId);
  } catch (error) {
    console.error('Error fetching cultivar info:', error);
    throw error;
  }
}

export async function queryCultivars(queryString: string) {
  try {
    Turbo.visit('/map_data/cultivars?query=' + queryString, {
      acceptsStreamResponse: true,
      action: 'advance',
    });
    history.pushState(
      history.state,
      '',
      '/map_data/cultivars?query=' + queryString
    );
  } catch (error) {
    console.error('Error querying cultivars:', error);
    throw error;
  }
}

export async function getMagicLink(email: string) {
  try {
    const response = await fetch('/login?email=' + email, { method: 'POST' });
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Error fetching magic link:', error);
    throw error;
  }
}
