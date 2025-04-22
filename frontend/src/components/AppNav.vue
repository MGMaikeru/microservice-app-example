<template>
  <nav class="navbar navbar-toggleable-md navbar-custom fixed-top">
    <a class="navbar-brand" href="#">70d0 0v3r3n61n33r1n6</a>
    <ul class="navbar-nav mr-auto">
      <li class="nav-item" v-show="isAdmin()">
        <a class="btn btn-admin mr-sm-2" href="#/admin">Admin</a>
      </li>
    </ul>

    <ul class="navbar-nav">
      <li class="nav-item" v-show="!isLoggedIn()">
        <a class="btn btn-login mr-sm-2" href="#/login">Login</a>
      </li>
      <li class="nav-item" v-show="isLoggedIn()">
        <button class="btn btn-logout mr-sm-2" href="#" @click="logout()">
          Logout
        </button>
      </li>
    </ul>
  </nav>
</template>

<script>
import Auth from "@/auth";

export default {
  name: "app-nav",

  methods: {
    logout() {
      Auth.logout();
    },
    isLoggedIn() {
      return Auth.isLoggedIn();
    },
    isAdmin() {
      return Auth.isAdmin();
    },
  },
};
</script>

<style>
.navbar-custom {
  background-color: #34495e !important; /* Dark blue background */
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.navbar-brand {
  color: #ecf0f1 !important; /* Light text for better contrast */
  font-weight: bold;
}

.btn-admin {
  background-color: #3498db !important; /* Blue */
  color: white !important;
  border: none;
}

.btn-login {
  background-color: #9b59b6 !important; /* Purple */
  color: white !important;
  border: none;
}

.btn-logout {
  background-color: #e74c3c !important; /* Red */
  color: white !important;
  border: none;
}

/* Hover effects */
.btn-admin:hover,
.btn-login:hover,
.btn-logout:hover {
  opacity: 0.9;
  transform: translateY(-1px);
  transition: all 0.2s;
}
</style>
