import React from 'react';
import ReactDOM from 'react-dom/client';

const App = () => <h1>Hello from React!</h1>;

const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
);

root.render(<App />);
