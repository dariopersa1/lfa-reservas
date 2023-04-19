<template >
  <div class="resumen-container">
    <h2>Resumen de la reserva</h2>
    <div class="resumen-reserva">
      <p><strong>Producto</strong></p>
      <div class="resumen-item">
        <img :src="evento.imagen" alt="imagen evento" width="50" height="50" style="border-radius: 50%;">
        <span class="resumen-item-text">{{ evento.nombre }} - {{ evento.fecha }}</span>
      </div>
      <div class="comensales-edit-form">
        <input type="number" class="form-control" v-model="pers" aria-describedby="px" aria-label="Personas" :disabled="edit">
        <button v-if="edit" class="lfa-btn" @click="{edit = false; $emit('onEdit')}">Edit comensales</button>
        <button v-if="!edit" class="lfa-btn" @click="{edit = true; $emit('editPx', pers)}">Save</button>
      </div>
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
      evento: {},
      db: ''
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
  .resumen-item{
    display: flex;
    align-items: center;
    margin-bottom: 16px;
  }

  .resumen-item-text{
    margin-left: 8px;
  }

  .comensales-edit-form {
    display: flex;
    align-items: center;
  }

  .form-control{
    max-width: 10rem;
  }

  .lfa-btn {
    margin-left: 1rem;
  }
</style>