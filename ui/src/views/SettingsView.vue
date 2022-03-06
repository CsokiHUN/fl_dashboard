<template>
  <div>
    <h4>Beállítások</h4>

    <ul>
      <li v-for="(data, name) in settings" :key="name">
        <div class="form-check form-switch">
          <input class="form-check-input" type="checkbox" v-model="data.value" checked />
          {{ data.label }}
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
  export default {
    name: 'SettingsView',
    data() {
      return {
        settings: {
          radar: {
            label: 'Radar megjelenítése',
            value: true,
          },
          hud: {
            label: 'HUD megjelenítése',
            value: true,
          },
          nemtom: {
            label: 'Nem tudom mi',
            value: false,
          },
        },
      };
    },
  };
</script>

<style scoped>
  ul {
    list-style: none;
  }
</style>
