import { type Notyf } from 'notyf';

export interface Plant {
  id: number;
  cultivar_id: number;
  cultivar_name?: string;
  latitude: number;
  longitude: number;
  is_deleted: boolean;
  created_at: string;
  updated_at: string;
  sector_id: number;
  form: number;
  is_favorite?: boolean;
}

export interface Cultivar {
  id: number;
  name: string;
  breeder: string;
  description: string;
  bred_year: number;
  introduced_year: number;
  cultivar_group_id: number;
  image_url: string;
  created_at: string;
  updated_at: string;
  is_deleted: boolean;
}
