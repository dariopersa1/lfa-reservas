import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import EventosView from '../views/EventosView.vue'
import EventoView from '../views/EventoView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView
    },
    {
      path: '/eventos',
      name: 'eventos',
      component: EventosView
    },
    {
      path: '/evento/:id',
      name: 'evento',
      component: EventoView
    }
  ]
})

export default router
