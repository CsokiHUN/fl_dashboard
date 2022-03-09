<template>
  <div>
    <h4>Beállítások</h4>

    <ul>
      <li v-for="(data, name) in settings" :key="name">
        <div class="form-check form-switch">
          <input class="form-check-input" type="checkbox" v-model="data.value" @change="updateSetting($event, name)" checked />
          {{ data.label }}
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
  export default {
    name: 'SettingsView',
    computed: {
      settings() {
        return this.$root.settings;
      },
    },
    methods: {
      updateSetting(event, name) {
        const { checked } = event.target;

        fetch(`https://${GetParentResourceName()}/updateSetting`, {
          method: 'POST',
          body: JSON.stringify({
            name,
            checked,
          }),
        });

        localStorage.setItem('dashboard:' + name, checked);
      },
    },
  };
</script>

<style scoped>
  ul {
    list-style: none;
  }
</style>
