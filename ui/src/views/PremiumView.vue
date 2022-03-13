<template>
  <div>
    <h6>Prémium Shop</h6>

    <p class="current-amount">
      Elérhető egyenleg:
      <span :style="{ color: currentPP > 0 ? 'green' : 'red' }">
        {{ currentPP ?? 'Nincs' }}
      </span>
      PP
    </p>

    <div class="row">
      <div class="col">
        <button @click="select('items')" class="btn btn-secondary w-100">Tárgyak</button>
      </div>
      <div class="col">
        <button @click="select('vehicles')" class="btn btn-secondary w-100">Járművek</button>
      </div>
      <div class="col">
        <button @click="select('money')" class="btn btn-secondary w-100">Pénz</button>
      </div>
    </div>
    <input
      v-if="selectedType != 'money'"
      v-model="search"
      type="text"
      class="form-control form-control-sm mt-2"
      placeholder="Keresés..."
      maxlength="30"
    />

    <h6 v-if="search.length > 0 && filteredCards.length <= 0" class="mt-3 text-center">
      Nincs találat a következőre:
      <span class="fst-italic"> ({{ search }}) </span>
    </h6>

    <div class="card-container mt-3 d-flex justify-content-center flex-wrap">
      <div v-for="item in filteredCards" :key="item" class="p-2 pt-0">
        <div class="card">
          <div v-if="item.img" class="card-img-top">
            <img :src="item.img" />
          </div>
          <div class="card-body">
            <div class="card-title fw-bold text-center m-0">{{ item.label }}</div>
            <div class="card-text text-center fst-italic mb-2">{{ item.price }}PP</div>
            <button @click="buyItem(item)" :class="getItemClass(item)" :disabled="(currentPP || 0) <= 0" class="btn w-100">Vásárlás</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'PremiumView',
    data() {
      return {
        selectedType: 'items',
        search: '',

        currentPP: 0,

        items: [],
        vehicles: [],
        money: [],
      };
    },
    computed: {
      filteredCards() {
        return this[this.selectedType].filter((elem) => {
          return isNaN(parseInt(this.search))
            ? elem.label.toLowerCase().includes(this.search.toLowerCase())
            : elem.price <= parseInt(this.search);
        });
      },
    },
    methods: {
      select(typ) {
        this.selectedType = typ;
        this.search = '';
      },

      getItemClass(item) {
        let { price } = item;
        price = price || 0;

        const currentPP = this.currentPP || 0;

        return {
          ['btn-success']: currentPP >= price,
          ['btn-danger']: currentPP < price,
        };
      },

      async buyItem(item) {
        const response = await fetch(`https://${GetParentResourceName()}/buyPremiumItem`, {
          method: 'POST',
          body: JSON.stringify({
            item,
            typ: this.selectedType,
          }),
        });

        const { currentPP } = await response.json();
        if (currentPP) this.currentPP = currentPP;
      },
    },

    async created() {
      const response = await fetch(`https://${GetParentResourceName()}/getPremiumStuff`);
      const { currentPP, items, vehicles, money } = await response.json();

      this.currentPP = currentPP;
      this.items = items;
      this.vehicles = vehicles;
      this.money = money;
    },
  };
</script>

<style scoped>
  .card-container {
    height: 23em;
    overflow-y: auto;
  }

  .current-amount {
    font-size: 0.9em;
  }

  .card {
    color: #ccc;
    background: rgba(76, 76, 76, 0.4);
    border-radius: 0.8em;
  }

  .card-img-top {
    width: 4em;
    height: 4em;

    position: relative;
    left: 50%;
    top: 0.25em;
    transform: translate(-50%, 0);
  }

  .card-img-top img {
    width: 100%;
  }
</style>
