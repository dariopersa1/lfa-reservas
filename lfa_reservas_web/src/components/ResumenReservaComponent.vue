<template >
  <div class="resumen-container">
    <h2>Resumen de la reserva</h2>
    <div class="resumen-reserva">
      <p><strong>Producto</strong></p>
      <img :src="evento.imagen" alt="imagen evento" width="50" height="50" style="border-radius: 50%;">
      <p>{{ evento.nombre }} - {{ evento.fecha }}</p>
      <input type="number" v-model="pers" aria-describedby="px" aria-label="Personas" :disabled="edit">
      <button v-if="edit" class="btn btn-secondary" @click="edit = false">Edit comensales</button>
      <button v-if="!edit" class="btn btn-primary" @click="edit = true">Save</button>
    </div>
  </div>
</template>
<script>
import firebase from '../firebaseInit';
import { getFirestore, doc, getDoc } from 'firebase/firestore'
export default {
  props: {
    px: Number,
    eventoId: String
  },
  data() {
    return {
      edit: true,
      pers: 0,
      evento: {}
    }
  },
  methods: {
    async getEvento() {
      const docRef = doc(this.db, "eventos", this.eventoId)
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

      console.log(this.evento)
    }
  },
  async mounted() {
    await this.getEvento()
  },
  created() {
    this.db = getFirestore(firebase)
    this.pers = this.px
  }
}
</script>
<style scoped>
  
</style>