<template>
  <div class="container">
    <h1>Eventos</h1>
    <div class="events-list">
      <div class="card" style="width: 28rem;" v-for="e in eventos">
        <img :src="e.imagen" alt="imagen evento" class="card-img-top">
        <div class="card-body">
          <h5 class="card-title">{{ e.nombre }}</h5>
          <p class="card-text">{{ e.descripcion }}</p>
          <router-link :to="'/evento/'+e.id" class="btn btn-primary">Ver más</router-link>
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
    margin-top: 6rem;
  }
</style>