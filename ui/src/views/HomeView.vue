<template>
  <div class="home">
    <h4>{{ playerName }}</h4>

    <h4 v-if="cards.length <= 0" class="text-center mt-5">Betöltés...</h4>

    <div class="cards d-flex flex-wrap justify-content-center align-items-center">
      <div v-for="card in cards" :key="card" class="card p-2 m-2">
        <span class="title">{{ card.title }}</span>
        <span
          class="value"
          :class="{ blur: card.blur }"
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
        cards: [],
        playerName: '',
      };
    },
    async created() {
      const response = await fetch(`https://${GetParentResourceName()}/requestData`, {
        method: 'POST',
        body: JSON.stringify({
          name: 'cards',
        }),
      });
      const { cards, playerName } = await response.json();
      this.cards = cards;
      this.playerName = playerName;
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

  .blur {
    filter: blur(0.25em);
  }

  .blur:hover {
    filter: blur(0);
  }
</style>
