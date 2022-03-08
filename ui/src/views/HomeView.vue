<template>
  <div class="home">
    <h4>Clark Melton</h4>

    <div class="cards d-flex flex-wrap justify-content-center align-items-center">
      <div v-for="card in cards" :key="card" class="card p-2 m-2">
        <span class="title">{{ card.title }}</span>
        <span
          class="value"
          :style="{
            color: card.color ?? 'lightgray',
          }"
          >{{ card.value }}</span
        >
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'HomeView',
    data() {
      return {
        cards: [
          { title: 'ID', value: 1, color: 'red' },
          { title: 'Steam Név', value: 'Csoki', color: 'red' },
          { title: 'Születési Idő', value: '1900-01-01', color: 'green' },
          { title: 'Magasság', value: '200cm', color: 'green' },

          { title: 'Készpénz', value: '1$', color: 'green' },
          { title: 'Piszkos pénz', value: '1$', color: 'red' },
          { title: 'Banki egyenleg', value: '1$', color: 'orange' },
          { title: 'Járművek', value: '1db', color: 'orange' },

          { title: 'Group', value: 'admin', color: 'yellow' },
          { title: 'Job', value: 'police', color: 'lightgray' },
          { title: 'Job Grade', value: 'járőr', color: 'lightgray' },
          { title: 'Fizetésed', value: '-100$', color: 'lightgray' },

          { title: 'Identifier', value: '03475054c83371850aef1b58e686e623', color: 'lightgray' },
          { title: 'Játszott idő', value: '0 perc', color: 'lightgray' },
          { title: 'Online idő', value: '0 perc', color: 'lightgray' },
        ],
      };
    },
    async created() {
      const response = await fetch(`https://${GetParentResourceName()}/requestData`, {
        method: 'POST',
        body: JSON.stringify({
          name: 'cards',
        }),
      });
      const { cards } = await response.json();
      this.cards = cards;
    },
  };
</script>

<style scoped>
  .home {
    height: 100%;
  }

  .cards {
    height: 91.5%;
  }

  .card {
    background-color: rgb(40, 40, 40);
    min-width: 5em;
  }

  .card .title {
    color: gray;
    font-size: 1.1em;
    padding-right: 2.5em;
    padding-bottom: 1em;
  }

  .card .value {
    text-align: right;
    font-style: italic;
  }
</style>
