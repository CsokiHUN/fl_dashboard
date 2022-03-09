<template>
  <div>
    <h4 class="text-center">
      Járműveim
      <h6>({{ vehicles.length }}db)</h6>
    </h4>

    <div class="input-group input-group-sm mb-3">
      <span class="input-group-text" id="inputGroup-sizing-sm">
        <i class="fas fa-search text-secondary"></i>
      </span>
      <input
        type="text"
        class="form-control"
        placeholder="Keresés..."
        aria-label="Sizing example input"
        aria-describedby="inputGroup-sizing-sm"
      />
    </div>

    <table class="table">
      <thead>
        <tr class="text-center">
          <td class="id">Rendszám</td>
          <td class="vehicle-name fw-bold">Jármű</td>
          <td class="state">Állapot</td>
          <td class="fuel">Üzemanyag</td>
        </tr>
      </thead>
      <tbody>
        <h5 v-if="!vehicles || vehicles.length <= 0" class="text-light text-center mt-5">Nincs járműved 😢</h5>

        <tr v-for="(vehicle, key) in vehicles" :key="key" @click="select(key)" :class="{ active: selected === key }" class="text-center">
          <td class="id">{{ vehicle.plate ?? 'Ismeretlen' }}</td>
          <td class="vehicle-name fw-bold">{{ vehicle.label ?? 'Ismeretlen' }}</td>
          <td
            :style="{
              color: getColor(vehicle.state),
            }"
            class="state"
          >
            {{ vehicle.state ?? 0 }}%
          </td>
          <td :style="{ color: getColor(vehicle.fuel) }" class="fuel">{{ vehicle.fuel ?? 0 }}%</td>
        </tr>
      </tbody>
    </table>
    <h6 v-if="vehicles.length >= 0 && currentVehicle !== undefined" class="fw-bold">
      <h5>
        {{ currentVehicle.label }}
      </h5>

      <ul class="current-vehicle">
        <li>
          Tárolva:
          <span :style="{ color: currentVehicle.stored === 1 ? 'green' : 'red' }">{{ currentVehicle.stored === 1 ? 'Igen' : 'Nem' }}</span>
        </li>
        <li>Rendszám: {{ currentVehicle.plate }}</li>
        <li>Szín 1: {{ currentVehicle.vehicle.color1 }} | Szín 2: {{ currentVehicle.vehicle.color2 }}</li>
        <li>Model: {{ currentVehicle.vehicle.model }} | {{ currentVehicle.name }}</li>
        <li>
          Üzemanyag: <span :style="{ color: getColor(currentVehicle.fuel) }">{{ currentVehicle.fuel }}%</span>
        </li>
        <li>
          Motor állapot:
          <span :style="{ color: getColor(currentVehicle.vehicle.engineHealth / 10) }">
            {{ Math.floor(currentVehicle.vehicle.engineHealth / 10) }}%
          </span>
        </li>
        <li>
          Kaszni állapot:
          <span :style="{ color: getColor(currentVehicle.vehicle.bodyHealth / 10) }">
            {{ Math.floor(currentVehicle.vehicle.bodyHealth / 10) }}%
          </span>
        </li>
        <li>
          Tank állapot:
          <span :style="{ color: getColor(currentVehicle.vehicle.tankHealth / 10) }"
            >{{ Math.floor(currentVehicle.vehicle.tankHealth / 10) }}%
          </span>
        </li>
      </ul>
    </h6>
  </div>
</template>

<script>
  export default {
    name: 'PropertyView',
    data() {
      return {
        selected: 0,

        vehicles: [],
      };
    },
    computed: {
      currentVehicle() {
        return this.vehicles[this.selected];
      },
    },
    methods: {
      select(key) {
        if (!this.vehicles[key]) return;

        this.selected = key;
      },

      getColor(value) {
        value = value ?? 0;
        if (value <= 25) return 'red';
        if (value > 25 && value <= 75) return 'orange';

        return 'green';
      },
    },
    async created() {
      this.selected = 0;

      const response = await fetch(`https://${GetParentResourceName()}/requestData`, {
        method: 'POST',
        body: JSON.stringify({
          name: 'property',
        }),
      });
      const { vehicles } = await response.json();
      this.vehicles = vehicles;
    },
  };
</script>

<style scoped>
  td {
    color: white;
  }

  table {
    border: 2px solid rgb(55, 55, 55);
  }

  table .id {
    width: 5.5em;
  }

  table .state,
  table .fuel {
    width: 6em;
  }

  table .vehicle-name {
    width: 30em;
  }

  thead .vehicle-name {
    width: 29.5em;
  }

  tr {
    border-bottom: 2px solid rgb(55, 55, 55);
  }

  tbody {
    display: block;
    overflow: auto;
    height: 12rem;
    width: 100%;
  }

  thead tr {
    display: block;
  }

  .active {
    background-color: rgb(35, 35, 35);
  }

  .current-vehicle {
    font-size: 0.9em;
  }
</style>
