import { type Cultivar } from '../types';

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

export async function allCultivarNames(): Promise<String[]> {
  try {
    const response = await fetch(`/map_data/cultivars_names`);
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Error fetching cultivar names', error);
    throw error;
  }
}
