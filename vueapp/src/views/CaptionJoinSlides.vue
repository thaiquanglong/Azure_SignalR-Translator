<template>
  <div class="caption-join">
    <div id="filler" ></div>
    <div id="captions-text" class="caption">
      <div v-for="caption in captions" :key="caption.offset">{{ caption.text }}</div>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import axios from 'axios'
import constants from '../lib/constants'
import * as signalR from '@aspnet/signalr'
import languageListMixin from '../lib/language-list-mixin'
import router from '../router'

export default {
  mixins: [ languageListMixin ],
  props: {
    clientId: String
  },
  data() {
    return {
      code: '',
      captions: [],
      toLanguageCode: 'prs'
    }
  },
  computed: {
    toLanguageCodes() {
      return this.toLanguages.map(l => l.split("-")[0]).sort()
    }
  },
  methods: {
    async updateLanguageSubscription(languageCode) {        
      await axios.post(`${constants.apiBaseUrl}/api/selectlanguage`, {
        languageCode,
        userId: this.clientId
      })
    },
    getLanguageCode() {
      console.log(router.currentRoute.query)
      if(router.currentRoute.query.langCode) {
        console.log(router.currentRoute.query.langCode)
        this.toLanguageCode = router.currentRoute.query.langCode;
        return false;
      } else {
        return true;
      }
    }
  },
  watch: {
    toLanguageCode: {
      handler() {
        return this.updateLanguageSubscription(this.toLanguageCode)
      },
      immediate: true
    }
  },
  async mounted() {
    this.getLanguageCode()
    this.connection = new signalR.HubConnectionBuilder()
      .withUrl(`${constants.apiBaseUrl}/api/${this.clientId}`)
      .build()

    this.connection.on('newCaption', onNewCaption.bind(this))

    await this.connection.start()
    console.log('connection started')

    const captionsMap = {}
    function onNewCaption(caption) {
      let localCaption = captionsMap[caption.offset]
      if (!localCaption) {
        localCaption = captionsMap[caption.offset] = {
          offset: caption.offset,
          text: ''
        }
        this.captions.push(localCaption)
      }
      localCaption.text = caption.text

      Vue.nextTick(function() {
        window.scrollTo(0, document.body.scrollHeight || document.documentElement.scrollHeight)
      })
    }
  },
  async beforeDestroy() {
    if (this.connection) {
      await Promise.all([
        this.connection.stop(),
        this.updateLanguageSubscription(null)
      ])
      console.log('connection stopped')
    }
  }
}
</script>

<style scoped>

#caption-join {
  height: 100vh;
  background-color: black;
}

#filler{
  height: 75vh;
  background-color: black;
}

#captions-text {
  background-color: black;
  /* padding-top: 80px;
  padding-bottom: 60px; */
  /*color: rgb(220, 220, 220);*/
}
</style>
