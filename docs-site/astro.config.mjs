// @ts-check
import { defineConfig } from 'astro/config'
import starlight from '@astrojs/starlight'

// https://astro.build/config
export default defineConfig({
  site: 'https://eerieA.github.io',
  base: '/game-qs-grill',
  integrations: [
    starlight({
      title: 'Game QS Grill Docs for Devs'
    })
  ]
})
