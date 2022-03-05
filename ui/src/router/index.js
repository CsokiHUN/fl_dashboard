import { createRouter, createWebHashHistory } from 'vue-router';

const routes = [
  {
    path: '/',
    name: '<i class="fas fa-user"></i> Áttekintés',
    component: () => import('../views/HomeView.vue'),
  },
  {
    path: '/property',
    name: '<i class="fas fa-car"></i> Vagyon',
    component: () => import('../views/PropertyView.vue'),
  },
  {
    path: '/admins',
    name: '<i class="fas fa-users"></i> Adminisztrátorok',
    component: () => import('../views/PropertyView.vue'),
  },
  {
    path: '/premium',
    name: '<i class="fa-solid fa-credit-card"></i> Támogatás',
    component: () => import('../views/PropertyView.vue'),
  },
  {
    path: '/settings',
    name: '<i class="fas fa-cog"></i> Beállítások',
    component: () => import('../views/PropertyView.vue'),
  },
];

const router = createRouter({
  history: createWebHashHistory(),
  routes,
});

export default router;
