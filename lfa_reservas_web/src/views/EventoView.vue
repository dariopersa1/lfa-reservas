<template>
  <div class="container">
    <div class="row">
      <div class="col-5">
        <img :src="evento.imagen" alt="imagen evento">
      </div>
      <div class="col-7">
        <h3>{{ evento.nombre }}</h3>
        <p>{{ evento.descripcion }}</p>
        <div class="comensales-input">
          <label for="comensales">Nº de comensales</label>
          <input type="number" name="comensales" v-model="px" id="comensales">
        </div>
        <button class="btn btn-secondary" @click="goToReservaForm">Reservar</button>
      </div>
    </div>
  </div>
</template>
<script>
import firebase from '../firebaseInit';
import { getFirestore, doc, getDoc } from 'firebase/firestore'
export default {
  data() {
    return {
      id: '',
      db: '',
      evento: {},
      px: 0
    }
  },
  methods: {
    async getEvento() {
      const docRef = doc(this.db, "eventos", this.id)
      const docSnap = await getDoc(docRef)
      
      if(docSnap.exists()){
        this.evento = {
          nombre: docSnap.data().nombre,
          descripcion: docSnap.data().descripcion,
          fecha: docSnap.data().fecha,
          imagen: docSnap.data().imagen,
          aforo: docSnap.data().aforo
        }
      }else{
        console.log('No document')
      }
    },
    goToReservaForm() {
      this.$router.push({name: 'reservaForm', params: {evento: this.id, px: this.px}})
    }
  },
  mounted() {
    this.getEvento()
  },
  created() {
    this.db = getFirestore(firebase)
    if(this.$route.params.id){
      this.id = this.$route.params.id
    }
  },
}
</script>
<style scoped>
  
</style>