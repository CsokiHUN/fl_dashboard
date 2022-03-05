<template>
  <div>
    <h4 class="text-center">Járműveim (1/1db)</h4>

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
        <tr v-for="vehicle in vehicles" :key="vehicle" class="text-center">
          <td class="id">{{ vehicle.plate }}</td>
          <td class="vehicle-name fw-bold">{{ vehicle.name }}</td>
          <td
            :style="{
              color: getColor(vehicle.state),
            }"
            class="state"
          >
            {{ vehicle.state }}%
          </td>
          <td :style="{ color: getColor(vehicle.state) }" class="fuel">{{ vehicle.fuel }}%</td>
        </tr>
      </tbody>
    </table>
    <h6 class="fw-bold">
      Kilóméteróra állása, Rendszám, Motor, Lámpa, Kézifék, Nitro, AirRide, Neon Motor, Fék, Turbo, ECU, Váltó, Kerék, Súlycsökkentés,
      Felfüggesztés
    </h6>
  </div>
</template>

<script>
  export default {
    name: 'PropertyView',
    data() {
      return {
        vehicles: [
          {
            plate: 'AAA-001',
            name: 'Lada 2102',
            state: 100,
            fuel: 100,
          },
          {
            plate: 'AAA-002',
            name: 'Suzuki Swift',
            state: 100,
            fuel: 100,
          },
          {
            plate: 'AAA-002',
            name: 'Suzuki Swift',
            state: 100,
            fuel: 100,
          },
          {
            plate: 'AAA-002',
            name: 'Suzuki Swift',
            state: 100,
            fuel: 100,
          },
          {
            plate: 'AAA-002',
            name: 'Suzuki Swift',
            state: 100,
            fuel: 100,
          },
          {
            plate: 'AAA-002',
            name: 'Suzuki Swift',
            state: 100,
            fuel: 100,
          },
          {
            plate: 'AAA-002',
            name: 'Suzuki Swift',
            state: 100,
            fuel: 100,
          },
          {
            plate: 'AAA-002',
            name: 'Suzuki Swift',
            state: 100,
            fuel: 100,
          },
          {
            plate: 'AAA-100',
            name: 'Suzuki Swift',
            state: 100,
            fuel: 100,
          },
        ],
      };
    },
    methods: {
      getColor(value) {
        if (value <= 25) return 'red';
        if (value > 25 && value <= 75) return 'orange';

        return 'green';
      },
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
    width: 5em;
  }

  table .state,
  table .fuel {
    width: 6em;
  }

  table .vehicle-name {
    width: 30em;
  }

  thead .vehicle-name {
    width: 28em;
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
</style>
