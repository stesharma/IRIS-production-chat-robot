<template>
  <div id="app">
    <el-container>
      <el-header>IRIS production chat robot</el-header>
      <el-main>
        <el-row class="message-container">
          <el-col :span="24">
            <div
              v-for="message in messages"
              :key="message.id"
              :class="['message', message.type]"
            >
              <img
                :src="message.type === 'user' ? userAvatar : aiAvatar"
                :alt="message.type"
                class="avatar"
              />
              <div class="message-text" v-html="formatMessage(message.text)"></div>
            </div>
          </el-col>
        </el-row>
      </el-main>
      <el-footer>
        <div class="input-container">
          <el-input
            v-model="newMessage"
            placeholder="Type a message"
            @change="sendMessage"
          />
          <el-button type="primary" @click="sendMessage">Send</el-button>
        </div>
      </el-footer>
    </el-container>
  </div>
</template>

<script>
import axios from 'axios';
import marked from 'marked';

export default {
  data() {
    return {
      messages: [],
      newMessage: '',
      userAvatar: require('@/assets/user.png'),
      aiAvatar: require('@/assets/bot.png'),
      userId: '' // Store the unique user ID
    };
  },
  created() {
    // Generate or retrieve the unique user ID
    this.userId = localStorage.getItem('userId') || this.generateUniqueId();
    if (!localStorage.getItem('userId')) {
      localStorage.setItem('userId', this.userId);
    }

    // Fetch chat history when the component is created
    this.fetchChatHistory();
  },
  methods: {
    generateUniqueId() {
      return 'user-' + Math.random().toString(36).substr(2, 9);
    },
    fetchChatHistory() {
      axios.post('/api/Vector/Search', {
        user: this.userId
      })
      .then(response => {
        if (response.data && response.data.code === "200") {
          this.messages = response.data.data.map(msg => ({
            id: Date.now() + Math.random(),
            text: msg.message, // Assuming the API returns a simple text array; adjust if necessary
            type: msg.Name?.startsWith('robot:') ? 'ai' : 'user' // or 'ai' based on the source of the message
          }));
        } else {
          console.error('Unexpected response structure:', response.data);
        }
      })
      .catch(error => {
        console.error('Error fetching chat history:', error);
      });
    },
    sendMessage() {
      if (this.newMessage.trim()) {
        this.messages.push({ id: Date.now(), text: this.newMessage, type: 'user' });

        const messageContent = this.newMessage;
        this.newMessage = '';

        axios.post('/api/Chat/add', {
          user: this.userId,
          message: messageContent
        })
        .then(response => {
          if (response.data && response.data.code === "200") {
            this.messages.push({
              id: Date.now(),
              text: response.data.data,
              type: 'ai'
            });
          } else {
            console.error('Unexpected response structure:', response.data);
            this.messages.push({
              id: Date.now(),
              text: 'Error: Unexpected response from the server.',
              type: 'ai'
            });
          }
        })
        .catch(error => {
          console.error('Error sending message:', error);
          this.messages.push({
            id: Date.now(),
            text: 'Error: Unable to send message. Please try again later.',
            type: 'ai'
          });
        });
      }
    },
    formatMessage(text) {
      // Replace \n with <br> for HTML rendering
      return `${text}`.replace(/\r\n|\n|\r/g, '<br>');
    },
    formatMarkdown(text) {
      return marked(text);
    },
  },  
};
</script>

<style>
#app {
  height: 100vh;
  display: flex;
  flex-direction: column;
}
.el-container {
  height: 100%;
}
.el-header {
  background-color: #409eff;
  color: white;
  text-align: center;
  font-size: 20px;
  padding: 10px;
}
.message-container {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
  background-color: #f0f2f5;
}
.message {
  display: flex;
  align-items: flex-start;
  margin: 10px 0;
}
.message.user {
  flex-direction: row-reverse;
}
.message.ai {
  flex-direction: row;
}
.avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  margin: 0 10px;
}
.message-text {
  max-width: 70%;
  padding: 10px 15px;
  border-radius: 15px;
  word-wrap: break-word;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}
.message.user .message-text {
  background-color: #409eff;
  color: white;
}
.message.ai .message-text {
  background-color: #f5f5f5;
  color: #333;
}
.message-text a {
  color: #409eff;
  text-decoration: none;
}
.message-text a:hover {
  text-decoration: underline;
}
.input-container {
  display: flex;
  padding: 10px;
  background-color: white;
  border-top: 1px solid #ddd;
}
.input-container .el-input {
  flex: 1;
}
.input-container .el-button {
  margin-left: 10px;
}
</style>
