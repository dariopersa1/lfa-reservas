<template>
  <div class="container">
    <div class="row">
      <div class="col-4">
        <img class="evento-img" :src="evento.imagen" alt="imagen evento">
      </div>
      <div class="col-8">
        <h3>{{ evento.nombre }}</h3>
        <p>{{ evento.descripcion.texto }}</p>
        <p>Hora de la cena: {{ evento.descripcion.cena }}</p>
        <p>Hora del concierto: {{ evento.descripcion.concierto }}</p>
        <p>Accesibilidad: {{ evento.descripcion.accesibilidad }}</p>
        <div class="comensales-input mb-3">
          <label for="comensales" class="form-label">Nº de comensales</label>
          <input type="number" name="comensales" class="form-control" v-model="px" id="comensales">
        </div>
        <button class="lfa-btn" @click="goToReservaForm">Reservar</button>
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
      evento: {
        nombre: '',
        descripcion: '',
        fecha: '',
        imagen: '',
        aforo: '',
        reservas: ''
      },
      px: 0
    }
  },
  methods: {
    async getEvento() {
      const docRef = doc(this.db, "eventos", this.id)
      const docSnap = await getDoc(docRef)
      
      if(docSnap.exists()){
        this.evento.nombre = docSnap.data().nombre,
        this.evento.descripcion = docSnap.data().descripcion,
        this.evento.fecha = docSnap.data().fecha,
        this.evento.imagen = docSnap.data().imagen,
        this.evento.aforo = docSnap.data().aforo
        this.evento.reservas = docSnap.data().reservas
      }else{
        console.log('No document')
      }
    },
    goToReservaForm() {
      if(this.px + this.evento.reservas <= this.evento.aforo){
        this.$router.push({name: 'reservaForm', params: {eventoId: this.id, px: this.px}})
      }else{
        this.$toast.warning('El aforo para este evento está completo, disculpe las molestias')
      }
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
   .container {
    top: 6rem;
    position: relative;
  }

  .evento-img {
    width: 95%;
    border-radius: 20px;
  }

  .form-control{
    max-width: 10rem;
  }
</style>