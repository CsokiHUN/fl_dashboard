<template>
  <div class="main d-flex">
    <LeftMenu />

    <div class="right-side">
      <a @click="close" href="#" class="text-danger float-end me-1">
        <i class="fas fa-times"></i>
      </a>

      <div class="content">
        <router-view />
      </div>
    </div>
  </div>
</template>

<script>
  import LeftMenu from '@/components/LeftMenu.vue';

  export default {
    components: {
      LeftMenu,
    },
    methods: {
      close() {
        console.log('bezárás');
      },
    },
  };
</script>

<style>
  body {
    width: 100vw;
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .main {
    width: 60em;
    height: 35em;
    background-color: rgb(20, 20, 20);
    color: white;
  }

  .right-side {
    width: 100%;
  }

  .content {
    padding: 0.5em;
    padding-top: 1em;
    height: 100%;
  }

  input:not([type='checkbox']),
  .input-group-text {
    color: white !important;
    background: rgb(35, 35, 35) !important;
    border: 1px solid rgb(60, 60, 60) !important;
    font-weight: bold !important;
  }

  input::placeholder {
    color: lightgray;
  }

  /* TODO: SCROLLBAR!!!! */
  /* width */
  ::-webkit-scrollbar {
    width: 10px;
  }

  /* Track */
  ::-webkit-scrollbar-track {
    background: #f1f1f1;
  }

  /* Handle */
  ::-webkit-scrollbar-thumb {
    background: #888;
  }

  /* Handle on hover */
  ::-webkit-scrollbar-thumb:hover {
    background: #555;
  }
</style>
