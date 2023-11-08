import { Controller } from '@hotwired/stimulus';
import { generateMap } from './map';

declare global {
  interface Event {
    detail: {
      fetchResponse: {
        location: string;
      };
    };
  }
}

declare global {
  interface Window {
    Turbo: any;
  }
}

export class MapController extends Controller<Element> {
  initialize() {
    generateMap();
    document.addEventListener('turbo:render', async (e) => {
      console.log('TURBO RENDER');
      if (
        e.target &&
        (e.target as Element).id &&
        ['main', '_top'].includes((e.target as Element).id)
      )
        history.pushState(
          history.state,
          '',
          await e.detail.fetchResponse.location
        );
    });
    window.addEventListener('popstate', () => {
      console.log('POPSTATE');
      window.Turbo.visit(document.location, { acceptsStreamResponse: true });
    });
    window.addEventListener('load', () => {
      console.log('page show', document.location.href);
      window.Turbo.visit(document.location, { acceptsStreamResponse: true });
    });
  }
}
