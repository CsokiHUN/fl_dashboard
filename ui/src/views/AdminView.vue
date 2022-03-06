<template>
  <div>
    <div class="container">
      <div class="row p-2 mb-1">
        <h6 class="title fw-bold pb-1 text-center mb-2">Elérhető Adminisztrátorok</h6>

        <div class="input-group input-group-sm">
          <span class="input-group-text" id="inputGroup-sizing-sm">
            <i class="fas fa-search text-secondary"></i>
          </span>
          <input
            v-model="search"
            type="text"
            class="form-control"
            placeholder="Keresés..."
            aria-label="Sizing example input"
            aria-describedby="inputGroup-sizing-sm"
          />
        </div>
      </div>
    </div>
    <div class="container">
      <div v-if="search && search.length > 0 && filteredAdmins.length <= 0" class="row p-2">
        <div class="col text-center">Nincs találat 😢</div>
      </div>

      <div v-if="!admins || admins.length <= 0" class="row p-2">
        <div class="col text-center">Nincs elérhető admin 😢</div>
      </div>

      <div v-for="user in filteredAdmins" :key="user" class="user-row row mb-1">
        <div class="col col-6">{{ user.id ?? 0 }}</div>
        <div class="col col-6 text-end">{{ user.name ?? 'Ismeretlen' }}</div>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'AdminView',
    data() {
      return {
        search: '',
        admins: [
          { id: 1, name: 'Csoki' },
          { id: 2, name: 'Adam' },
        ],
      };
    },
    computed: {
      filteredAdmins() {
        if (!this.search || this.search.length <= 0) return this.admins;

        return this.admins.filter((user) =>
          isNaN(parseInt(this.search)) ? user.name.toLowerCase().includes(this.search.toLowerCase()) : parseInt(this.search) == user.id
        );
      },
    },
  };
</script>

<style scoped>
  .container {
    width: 50%;
    max-height: 28em;
    overflow-y: auto;
  }

  .row {
    background-color: rgb(30, 30, 30);
    border-radius: 0.25em;
  }
  .title {
    border-bottom: 0.15em solid rgb(100, 100, 100);
  }

  .user-row {
    margin-left: 0;
    margin-right: 0.2em;
  }
</style>
