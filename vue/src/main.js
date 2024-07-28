
Vue.config.productionTip = false
import Vue from 'vue';
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import App from './App.vue';
import axios from 'axios';
const apiBaseUrl = window.appConfig.apiBaseUrl;

// Set axios base URL
axios.defaults.baseURL = apiBaseUrl;

Vue.config.productionTip = false;

Vue.use(ElementUI);

new Vue({
  el: '#app',
  render: h => h(App)
});

