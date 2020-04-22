import consumer from "./consumer"

$(document).on('turbolinks:load', function () {

  consumer.subscriptions.create({ channel: 'CommentsChannel', question_id: gon.question_id }, {
    received(data) {
      this.appendComment(data);
    },

    appendComment(data) {
      if (gon.user_id == data.comment.user_id) return;

      const template = require('../views/comment.hbs');
      const htmlComment = template(data);

      var resourceType = data.comment.commentable_type;
      var resourceId = data.comment.commentable_id;
      if (resourceType == 'Question') {
        $(`.question_${resourceId} .comments`).append(htmlComment);
      } else if (resourceType == 'Answer') {
        $(`.answer_${resourceId} .comments`).append(htmlComment);
      }
    }
  })
});

