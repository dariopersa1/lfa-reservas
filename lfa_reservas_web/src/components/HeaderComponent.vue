<template>
  <header id="lfa-header" class="lfa-header-class">
    <img class="lfa-logo" src="/unnamed.png" @click="this.$router.push('/')" alt="LFA Logo" style="cursor: pointer">
    <nav class="lfa-links">
      <router-link to="/eventos" class="lfa-link">Eventos</router-link>
    </nav>
  </header>
</template>
<script>
export default {
  watch: {
    '$route' (to, from) {
      if(to.name == 'home'){
        document.getElementById('lfa-header').style.display = "none";
      }else{
        document.getElementById('lfa-header').style.display = "flex";
      }
    }
  }
}
</script>
<style scoped>
  .lfa-header-class {
    position: fixed;
    width: 100%;
    height: 5rem;
    z-index: 1;
    display: flex;
    align-items: center;
    padding: 0 16px;
    background-color: #212121;
  }

  .lfa-logo {
    width: 110px;
  }

  .lfa-links {
    margin-left: 32px;
  }

  .lfa-link {
    color: white;
    text-decoration: none;
  }
</style>