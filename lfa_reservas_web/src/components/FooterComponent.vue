<template>
  <div id="lfa-footer">
    <h3>Footer</h3>
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
  #lfa-footer {
    color: white;
    position: absolute;
    background-color: #212121;
    bottom: 0;
    width: 100%;
    height: 4rem;
  }
</style>