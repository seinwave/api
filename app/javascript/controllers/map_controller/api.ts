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

export async function routeToInfoPanel(cultivarId: number) {
  console.log('firing request');
  try {
    const response = await fetch(`/map_data/info_panel/${cultivarId}`);
    console.log('request fired');
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    const data = await response.json();
    const infoPanelContainer = document.getElementById('info-panel-container');
    if (!infoPanelContainer) {
      return;
    }
  } catch (error) {
    console.error('Error fetching plants:', error);
    throw error;
  }
}
