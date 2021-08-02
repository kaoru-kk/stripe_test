// import consumer from "./consumer"

// const Message = consumer.subscriptions.create("MessageChannel", {
//   connected() {
//     // Called when the subscription is ready for use on the server
//   },

//   disconnected() {
//     // Called when the subscription has been terminated by the server
//   },

//   received(data) {
//     return alert(data['message']);
//   },

//   speak: function(message) {
//     console.log(message)
//     console.log('speak js');
//     return this.perform('speak', {message: message});
//   },
// });

// window.addEventListener('keypress', function(e) {
//   if (e.keyCode === 13 ){
//     console.log(e.target.value);
//     Message.speak(e.target.value);
//     e.target.value = '';
//     e.preventDefault();
//   }
// });

// import consumer from "./consumer"

// consumer.subscriptions.create("MessageChannel", {
//   received(data) {
//     // 以下で使用
//     console.log(data);
//     const html = `<p>${data.content.id} | ${data.content.text}</p>`;
//     const messages = document.getElementById('messages');
//     const newMessage = document.getElementById('message_text');
//     messages.insertAdjacentHTML('afterbegin', html);
//     newMessage.value='';
//   }
// });