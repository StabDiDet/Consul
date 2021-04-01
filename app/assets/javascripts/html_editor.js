(function() {
  "use strict";
  App.HTMLEditor = {
    initialize: function() {
      $("textarea.html-area").each(function() {
        if ($(this).hasClass("extended")) {
          CKEDITOR.replace(this.name, { language: $("html").attr("lang"), toolbar: "extended", height: 500 });
        } else {
          CKEDITOR.replace(this.name, { language: $("html").attr("lang") });
        }
      });
    },
    destroy: function() {
      for (var name in CKEDITOR.instances) {
        CKEDITOR.instances[name].destroy();
      }
    }
  };
}).call(this);
