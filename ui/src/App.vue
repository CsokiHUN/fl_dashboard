<template>
  <div v-if="visible" class="main d-flex">
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
    data() {
      return {
        visible: false,

        settings: {},
      };
    },
    methods: {
      close() {
        console.log('bezárás');
        fetch(`https://${GetParentResourceName()}/close`);
      },
    },
    mounted() {
      window.addEventListener('message', ({ data }) => {
        if (data.visible !== undefined) this.visible = data.visible;

        if (data.loadSettings !== undefined) {
          this.settings = {};

          for (const setting of data.loadSettings) {
            let stored = localStorage.getItem('dashboard:' + setting.name);
            stored = stored === null ? setting.defaultValue : stored === 'true';
            this.settings[setting.name] = {
              label: setting.label,
              value: stored,
            };

            fetch(`https://${GetParentResourceName()}/updateSetting`, {
              method: 'POST',
              body: JSON.stringify({
                name: setting.name,
                checked: stored,
                storeLoad: true,
              }),
            });
          }
        }

        if (data.saveSettings !== undefined) {
          for (const setting of data.saveSettings) {
            localStorage.setItem('dashboard:' + setting.name, setting.state);
          }
        }
      });

      document.addEventListener('keydown', ({ key }) => {
        if (key !== 'Escape') return;
        if (!this.visible) return;
        this.close();
      });
    },
  };
</script>

<style>
  * {
    user-select: none;
  }

  body {
    background-color: transparent !important;
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

  /* width */
  ::-webkit-scrollbar {
    width: 10px;
  }

  /* Track */
  ::-webkit-scrollbar-track {
    background: rgb(35, 35, 35);
    border-radius: 0.25em;
  }

  /* Handle */
  ::-webkit-scrollbar-thumb {
    background: rgb(65, 65, 65);
    border-radius: 0.25em;
  }

  /* Handle on hover */
  ::-webkit-scrollbar-thumb:hover {
    background: #555;
  }
</style>
