import { Plant } from '../types';

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

export function routeToInfoPanel(cultivarId: number) {
  const url = `/map/info_panel/${cultivarId}`;
  window.location.href = url;
}
