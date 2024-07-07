<template>
  <div class="caption-join">
    <div id="filler" ></div>
    <div id="captions-text" v-bind:class="{'caption':true, 'textRight': isRightToLeft()}">
      <div id="text-filler"></div>
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
      if(router.currentRoute.query.langCode) {
        this.toLanguageCode = router.currentRoute.query.langCode;
        return false;
      } else {
        return true;
      }
    },
    isRightToLeft() {
      // Check for all right to left texts
      if(this.toLanguageCode === "ar" || this.toLanguageCode === "prs") {
        return true;
      } else {
        return false;
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
        // Scroll the caption pane.
        var elem = document.getElementById("captions-text");
        elem.scrollTop = elem.scrollHeight;
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

body {
  overflow-y: hidden;
  -ms-overflow-style: none;
  scrollbar-width: none;
}

body::-webkit-scrollbar {
  display: none;
}

#main {
  margin: 0px;
}


#caption-join {
  height: 95vh;
  background-color: black;
}

#filler{
  height: 45vh;
  background-color: black;
}

#text-filler {
  height: 100%;
}

#captions-text {
  background-color: black;
  height: 50vh;
  overflow-y: hidden;
  padding-top: 0px;
  padding-bottom: 0px;
  margin: 0px;
  /*color: rgb(220, 220, 220);*/
}

#captions-text:before {
  content:'';
  width:100%;
  height:100%;    
  position:absolute;
  left:0;
  top:0;
  background:linear-gradient(0deg, transparent,  transparent 30vh,rgba(0, 0, 0, 0.5) 35vh, rgb(0, 0, 0) 49vh );
}

.textRight {
  text-align: right;
}
</style>
