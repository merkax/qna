import consumer from "./consumer"

$(document).on('turbolinks:load', function () {

  consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
    received(data) {
      this.appendAnswer(data);
    },
     
    appendAnswer(data) {
      if (gon.user_id == data.answer.user_id) return;
  
      const template = require('../views/answer.hbs');

      data.question_author = gon.user_id == gon.question_user_id;

      $('.answers').append(template(data));
    }
  })
});
