<template>
  <div id="lfa-footer">
    <h1>Footer</h1>
  </div>
</template>
<script>
export default {
  watch: {
    '$route' (to, from) {
      if(to.name == 'home'){
        document.getElementById('lfa-footer').style.display = "none";
      }else{
        document.getElementById('lfa-footer').style.display = "flex";
      }
    }
  }
}
</script>
<style scoped>
  
</style>