<template >
  <div class="resumen-container">
    <h2>Resumen de la reserva</h2>
    <div class="resumen-reserva">
      <p><strong>Producto</strong></p>
      <p>Reservas Jazz & Wine</p>
      <input type="number" v-model="pers" aria-describedby="px" aria-label="Personas" :disabled="edit">
      <button v-if="edit" class="btn btn-secondary" @click="edit = false">Edit comensales</button>
      <button v-if="!edit" class="btn btn-primary" @click="edit = true">Save</button>
    </div>
  </div>
</template>
<script>
export default {
  props: {
    px: Number
  },
  data() {
    return {
      edit: true,
      pers: 0
    }
  },
  created() {
    this.pers = this.px
  }
}
</script>
<style scoped>
  
</style>