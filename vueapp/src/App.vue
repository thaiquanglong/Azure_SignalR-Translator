<template>
  <div id="app">
    <div id="main">
      <router-view :client-id="clientId" />
    </div>
  </div>
</template>

<script>
import uuidv4 from 'uuid/v4'
import constants from './lib/constants'

export default {
  data() {
    return {
      clientId: uuidv4(),
      title: constants.title
    }
  }
}
</script>

<style>
html {
  background-color: black;
}

body {
  margin: 0px;
  padding: 0px;
}

#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #f3f3f3;
  width: 100%;
}
#nav {
  position: fixed;
  top: 0;
  width: 100%;
  min-height: 100px;
  z-index: 1000;
}

#nav a {
  font-weight: bold;
}

#nav h1 a {
  text-decoration: none;
  padding-top: 12px;
}

#main {
  margin: 0px;
}

button {
  padding: 12px;
  border-radius: 8px;
  width: 200px;
  font-size: 16px;
  background-color: #202020;
  color:#f3f3f3;
}

select {
  background-color: #202020;
  color:#f3f3f3;
}

input[type=text], input[type=password], select {
  padding: 0px;
  margin: 12px;
  border-radius: 8px;
  height: 48px;
  width: 200px;
  font-size: 18px;
  text-align: center;
}

.caption {
  margin: 48px auto;
  max-width: 1920px;
  font-size: 60px;
  text-align: left;
  padding: 24px;
}
</style>
