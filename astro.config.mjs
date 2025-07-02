import { defineConfig } from 'astro/config';

export default defineConfig({
  site: 'https://bericson.com',
  markdown: {
    shikiConfig: {
      theme: 'github-light',
      wrap: true
    }
  }
});
