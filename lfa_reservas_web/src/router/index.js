import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import EventosView from '../views/EventosView.vue'
import EventoView from '../views/EventoView.vue'
import ReservaFormView from '../views/ReservaFormView.vue'

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
    },
    {
      path: '/reserva/:evento/:px',
      name: 'reservaForm',
      props: true,
      component: ReservaFormView
    }

  ]
})

export default router
