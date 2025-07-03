import { defineConfig } from 'astro/config';

export default defineConfig({
  site: 'https://bericson.com',
  markdown: {
    shikiConfig: {
      theme: 'css-variables',
      wrap: true
    }
  }
});
