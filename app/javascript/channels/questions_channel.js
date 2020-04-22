import consumer from "./consumer"

document.addEventListener('turbolinks:load', function () {
  consumer.subscriptions.create( "QuestionsChannel" , {
    received(data) {
      this.appendQuestion(data);
    },

    appendQuestion(data) {
      $('.questions-list').append(data);
    }
  })
});

