<script>
import { RouterView } from 'vue-router'
import Header from './components/HeaderComponent.vue'
import Footer from './components/FooterComponent.vue'
export default {
  components: {
    Header,
    Footer
  }
}
</script>

<template>
  <Header></Header>
  <RouterView />
  <Footer></Footer>
</template>
