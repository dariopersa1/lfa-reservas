<template>
  <div>
    <img class="home-poster" src="/home-poster.jpg" alt="Home poster lfa">
    <div class="lfa-init">
      <img class="lfa-logo" src="/unnamed.png" width="500" alt="LFA Logo">
      <button class="lfa-btn" @click="$router.push('eventos')">Reservar</button>
    </div>
  </div>
</template>
<script>
import '../assets/main.css'
export default {
}
</script>
<style scoped>
  .home-poster {
    position: absolute;
    width: 100vw;
    height: 100vh;
  }

  .lfa-init {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -60%);
    display: flex;
    flex-direction: column;
    align-items: center;
  }
</style>
