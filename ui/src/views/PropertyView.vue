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
        v-model="search"
        :disabled="!vehicles || vehicles.length <= 0"
        type="text"
        maxlength="30"
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
        <h5 v-if="search !== '' && filteredVehicles.length <= 0" class="text-light text-center mt-5">
          Nincs találat a következőre: {{ search }}
        </h5>

        <tr
          v-for="(vehicle, key) in filteredVehicles"
          :key="key"
          @click="select(vehicle.key || key)"
          :class="{ active: selected === key || selected === vehicle.key }"
          class="text-center"
        >
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
      <div class="container">
        <div class="row">
          <div class="col">
            <h5>
              {{ currentVehicle.label }}
            </h5>
            <ul class="current-vehicle">
              <li>
                Tárolva:
                <span :style="{ color: currentVehicle.stored === 1 ? 'green' : 'red' }">{{
                  currentVehicle.stored === 1 ? 'Igen' : 'Nem'
                }}</span>
              </li>
              <li>Rendszám: {{ currentVehicle.plate }}</li>
              <li v-if="currentVehicle?.vehicle?.color1 || currentVehicle?.vehicle?.color2">
                Szín 1: {{ currentVehicle.vehicle.color1 }} | Szín 2: {{ currentVehicle.vehicle.color2 }}
              </li>
              <li>Model: {{ currentVehicle.name }}</li>
              <li>
                Üzemanyag: <span :style="{ color: getColor(currentVehicle.fuel) }">{{ currentVehicle.fuel }}%</span>
              </li>
              <li>
                Motor állapot:
                <span :style="{ color: getColor(currentVehicle.vehicle.engineHealth / 10) }">
                  {{ Math.floor((currentVehicle?.vehicle?.engineHealth ?? 0) / 10) }}%
                </span>
              </li>
              <li>
                Kaszni állapot:
                <span :style="{ color: getColor(currentVehicle.vehicle.bodyHealth / 10) }">
                  {{ Math.floor((currentVehicle?.vehicle?.bodyHealth ?? 0) / 10) }}%
                </span>
              </li>
              <li>
                Tank állapot:
                <span :style="{ color: getColor(currentVehicle.vehicle.tankHealth / 10) }"
                  >{{ Math.floor((currentVehicle?.vehicle?.tankHealth ?? 0) / 10) }}%
                </span>
              </li>
            </ul>
          </div>
          <div class="col mt-4">
            <h6>Teljesítmény Tuningok</h6>
            <ul>
              <li v-for="(label, name) in performanceMods" :key="name" v-html="getMod(name)"></li>
            </ul>
          </div>
          <div class="col optical-tunings ms-3 mt-4">
            <h6>Optikai Tuningok</h6>
            <ul>
              <li v-for="(label, name) in opticalMods" :key="name" v-html="getMod(name)"></li>
            </ul>
          </div>
        </div>
      </div>
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
        search: '',

        performanceMods: {
          modArmor: 'Páncél',
          modBrakes: 'Fékek',
          modEngine: 'Motor',
          modSuspension: 'Felfüggesztés',
          modTransmission: 'Váltó',
          modTurbo: 'Turbó',
        },

        opticalMods: {
          modAerials: 'Antenna',
          modAirFilter: 'Levegőszűrő',
          modArchCover: 'Arch Cover',
          modExhaust: 'Kipufogó',
          modFrontBumper: 'Első lökhárító',
          modGrille: 'Rács',
          modHood: 'Motorháztető',
          modFender: 'Bal küszöb',
          modRightFender: 'Jobb küszöb',
        },
      };
    },
    computed: {
      filteredVehicles() {
        if (this.search === '') return this.vehicles;

        return this.vehicles.filter((vehicle, key) => {
          vehicle.key = key;
          return (
            vehicle.plate.toLowerCase().includes(this.search.toLowerCase()) ||
            vehicle.label.toLowerCase().includes(this.search.toLowerCase())
          );
        });
      },
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

      getMod(name) {
        let value = this.currentVehicle.vehicle[name];
        if (!value) value = `<span class="text-danger">Nincs</span>`;
        else value = value <= 0 ? `<span class="text-danger">Nincs</span>` : `<span class="text-primary">${value}</span>`;

        const label = this.performanceMods[name] ?? this.opticalMods[name] ?? 'Ismeretlen';
        return `${label}: ${value}`;
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
    height: 11rem;
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

  .optical-tunings {
    padding-right: 0.5em;
    max-height: 10em;
    overflow-y: auto;
  }
</style>
