<template>
  <div id="app">
    <router-view></router-view>
  </div>
</template>

<script>
export default {
  name: "app",
};
</script>

<style>
#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #8e44ad; /* Changed from #2c3e50 to a purple color */
  margin-top: 60px;
  background-color: #f9f9f9; /* Light background color */
}
</style>
