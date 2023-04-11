<template>
  <div class="container">
    <h2>Proximos eventos</h2>
    <div class="events-list">
      <div class="card text-bg-dark" v-for="e in eventos" @click="$router.push({name: 'evento', params: {id: e.id}})">
        <img :src="e.imagen" class="card-img" alt="imagen evento">
        <div class="card-lfa-overlay">
          <h5 class="card-title">{{ e.nombre }}</h5>
          <p>{{ e.fecha }}</p>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import firebase from '../firebaseInit';
import { getFirestore, collection, query, getDocs } from 'firebase/firestore'
export default {
  data() {
    return {
      eventos: [],
      db: ''
    }
  },
  methods: {
    async getEventos() {
      var q = query(collection(this.db, "eventos"))
      const querySnapshot = await getDocs(q)
      querySnapshot.forEach((doc) => {
        this.eventos.push({
          id: doc.id,
          nombre: doc.data().nombre,
          descripcion: doc.data().descripcion,
          fecha: doc.data().fecha,
          imagen: doc.data().imagen,
          aforo: doc.data().aforo
        })
      })
    }
  },
  mounted() {
    this.getEventos()
  },
  created() {
    this.db = getFirestore(firebase)
  },
}
</script>
<style scoped>
  .container {
    top: 6rem;
    position: relative;
  }

  .events-list {
    margin-top: 16px;
    display: flex;
  }

  .card {
    width: 19rem;
    height: 16rem;
    cursor: pointer;
    margin-right: 16px;
  }

  .card-img{
    width: 19rem;
    height: 16rem;
  }

  .card-lfa-overlay {
    position: absolute;
    /* top: 0; */
    right: 0;
    bottom: 0;
    padding-left: 16px;
    left: 0;
    /* padding: var(--bs-card-img-overlay-padding); */
    border-radius: var(--bs-card-inner-border-radius);
  }
</style>