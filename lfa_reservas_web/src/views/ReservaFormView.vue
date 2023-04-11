<template>
  <div class="container" style="display: flex; flex-direction: column; align-items: center;">
    <div class="row">
      <div class="col-8">
        <h2>Datos de la reserva</h2>
        <form>
          <div class="row">
            <div class="col-6">
              <div class="mb-3">
                <label for="name" class="form-label">Nombre</label>
                <input type="text" class="form-control" v-model="reserva.nombre" id="name" name="name" aria-describedby="name">
              </div>
              <div class="mb-3">
                <label for="surname" class="form-label">Apellidos</label>
                <input type="text" class="form-control" v-model="reserva.apellidos" id="surname" name="surname" aria-describedby="surname">
              </div>
              <div class="mb-3">
                <label for="email" name="email" class="form-label">Email</label>
                <input type="email" class="form-control" v-model="reserva.email" id="email" name="email" aria-describedby="emailHelp">
              </div>
              <div class="mb-3">
                <label for="tel" class="form-label">Telefono</label>
                <input type="tel" class="form-control" v-model="reserva.tlf" id="tel" name="tel" aria-describedby="tel">
              </div>
            </div>
            <div class="col-6">
              <div class="mb-3">
                <label for="date" class="form-label">Fecha</label>
                <input type="text" :value="evento.fecha" class="form-control" id="date" name="date" aria-describedby="date" disabled>
              </div>
              <div class="mb-3">
                <label for="time-slots" class="form-label">Hora de llegada</label>
                <div class="row">
                  <div class="slot-card" name="time-slots" id="time-slots" v-for="slot in slots">
                    <button type="button" :class="slot.selected ? 'btn btn-primary slot-card-selected' : 'btn btn-link'" @click="slotSelected(slot.time)" :disabled="slot.selected">{{ slot.time }}</button>
                  </div>
                </div>
              </div>
              <div class="reserva-alergenos">
                <label class="form-label">Alergias y preferencias alimenticias</label>
                <div class="row">
                  <div class="col-6">
                    <div class="form-check">
                      <input class="form-check-input" type="checkbox" v-model="reserva.alergenos" id="gluten" value="Glúten">
                      <label class="form-check-label" for="gluten">
                        Glúten
                      </label>
                    </div>
                    <div class="form-check">
                      <input class="form-check-input" type="checkbox" v-model="reserva.alergenos" id="vegetarian" value="Vegetariano">
                      <label class="form-check-label" for="vegetarian">
                        Vegetariano
                      </label>
                    </div>
                    <div class="form-check">
                      <input class="form-check-input" type="checkbox" v-model="reserva.alergenos" id="vegan" value="Vegano">
                      <label class="form-check-label" for="vegan">
                        Vegano
                      </label>
                    </div>
                    <div class="form-check">
                      <input class="form-check-input" type="checkbox" v-model="reserva.alergenos" id="Marisco" value="Marisco">
                      <label class="form-check-label" for="Marisco">
                        Marisco
                      </label>
                    </div>
                  </div>
                  <div class="col-6">
                    <div class="form-check">
                      <input class="form-check-input" type="checkbox" v-model="reserva.alergenos" id="nuts" value="Frutos secos">
                      <label class="form-check-label" for="nuts">
                        Frutos secos
                      </label>
                    </div>
                    <div class="form-check">
                      <input class="form-check-input" type="checkbox" v-model="reserva.alergenos" id="lactose" value="Lactosa">
                      <label class="form-check-label" for="lactose">
                        Lactosa
                      </label>
                    </div>
                    <div class="form-check">
                      <input class="form-check-input" type="checkbox" v-model="reserva.alergenos" id="eggs" value="Huevos">
                      <label class="form-check-label" for="eggs">
                        Huevos
                      </label>
                    </div>
                    <div class="form-check">
                      <input class="form-check-input" type="checkbox" v-model="reserva.alergenos" id="soya" value="Soja">
                      <label class="form-check-label" for="soya">
                        Soja
                      </label>
                    </div>
                  </div>
                </div>
              </div>
              <div class="mb-3">
                <label for="exampleFormControlTextarea1" class="form-label">Comentario</label>
                <textarea class="form-control" v-model="reserva.comentario" placeholder="Añada aquí un comentario que quiera indicar al restaurante" 
                  id="exampleFormControlTextarea1" rows="3"></textarea>
              </div>
            </div>
          </div>
        </form>
      </div>
      <div class="col-4">
        <ResumenReserva :px="Number(px)" :evento-id="eventoId" @onEdit="onEditPx = true" @editPx="(pers) => {px = pers; onEditPx = false}"></ResumenReserva>
      </div>
    </div>
    <button class="btn btn-primary" @click="reservar" style="width: fit-content;" :disabled="onEditPx">Reservar</button>
  </div>
</template>
<script>
import ResumenReserva from '../components/ResumenReservaComponent.vue'
import firebase from '../firebaseInit';
import { collection, getFirestore, doc, getDoc, addDoc } from 'firebase/firestore'
export default {
  props: ['eventoId', 'px'],
  data() {
    return {
      slots: [
        {
          time: '20:30',
          selected: false
        },
        {
          time: '21:00',
          selected: false
        },
        {
          time: '21:30',
          selected: false
        },
        {
          time: '22:00',
          selected: false
        },
        {
          time: '22:30',
          selected: false
        },
        {
          time: '23:00',
          selected: false
        },
        {
          time: '23:30',
          selected: false
        }
      ],
      evento: {},
      db: '',
      reserva: {
        nombre: '',
        apellidos: '',
        email: '',
        hora: '',
        tlf: '',
        alergenos: [],
        comentario: '',
        px: 0,
        eventoId: '',
        timestamp: ''
      },
      onEditPx: false
    }
  },
  methods: {
    slotSelected(time) {
      this.slots.forEach((slot) => {
        if(slot.time === time){
          slot.selected = true
          this.reserva.hora = time
        }else{
          slot.selected = false
        }
      })
    },
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
    },
    async reservar() {
      this.reserva.fecha = this.evento.fecha
      this.reserva.px = Number(this.px)
      this.reserva.eventoId = this.eventoId
      this.reserva.timestamp = Date.now()
      const docRef = await addDoc(collection(this.db, "reservas"), this.reserva)
    }
  },
  components: {
    ResumenReserva
  },
  async mounted() {
    await this.getEvento()
  },
  created() {
    this.db = getFirestore(firebase)
  }
}
</script>
<style scoped>
  .slot-card {
    width: fit-content;
    height: fit-content;
    padding: 2px 2px;
    margin: 4px 4px;
    border: 1px solid grey;
    border-radius: 5px;
  }
</style>