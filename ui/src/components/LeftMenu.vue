<template>
  <div class="main text-center px-2">
    <div class="logo">
      <img src="@/assets/logo.png" class="mt-3" />
    </div>

    <div v-for="route in routes" :key="route">
      <router-link :to="route.path">
        <div class="menu-link p-1 mt-2" v-html="route.name"></div>
      </router-link>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'LeftMenu',
    computed: {
      routes() {
        return this.$router.getRoutes();
      },
    },
  };
</script>

<style scoped>
  .main {
    width: 15em;
    background-color: rgb(25, 25, 25);
  }
  .main a {
    color: white !important;
    text-decoration: none !important;
  }
  .logo {
    width: 100%;
    height: 12em;
  }
  .logo img {
    width: 10em;
    height: 10em;
  }
  .menu-link {
    background-color: rgb(40, 40, 40);
    border-radius: 0.25em;
    transition: all 0.5s linear;
  }
  .menu-link:hover {
    background-color: rgb(50, 50, 50);
    transition: all 0.5s linear;
  }
</style>
