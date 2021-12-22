/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
  config.extraPlugins = 'widget,lineutils,mjAccordion,youtube,iframe,abbr';
  config.filebrowserImageBrowseLinkUrl = "/ckeditor/pictures";
  config.filebrowserImageBrowseUrl = "/ckeditor/pictures";
  config.filebrowserImageUploadUrl = "/ckeditor/pictures?";
  config.filebrowserUploadMethod = "form";
  CKEDITOR.dtd.$removeEmpty.span = 0;
  CKEDITOR.dtd.$removeEmpty.i = 0;

  config.allowedContent = true;
  config.format_tags = "p;h2;h3;h4;h5;h6";

  config.stylesSet = 'columns';
  config.enterMode = CKEDITOR.ENTER_BR;

  config.removePlugins = "balloonpanel,balloontoolbar,copyformatting,scayt,wsc";

  config.mjAccordion_managePopupTitle = true;
  config.mjAccordion_managePopupContent = true;
  config.mj_variables_allow_html = false;

  // Rails CSRF token
  config.filebrowserParams = function(){
    var csrf_token, csrf_param, meta,
        metas = document.getElementsByTagName("meta"),
        params = new Object();

    for ( var i = 0 ; i < metas.length ; i++ ){
      meta = metas[i];

      switch(meta.name) {
        case "csrf-token":
          csrf_token = meta.content;
          break;
        case "csrf-param":
          csrf_param = meta.content;
          break;
        default:
          continue;
      }
    }

    if (csrf_param !== undefined && csrf_token !== undefined) {
      params[csrf_param] = csrf_token;
    }

    return params;
  };

  config.addQueryString = function( url, params ){
    var queryString = [];

    if ( !params ) {
      return url;
    } else {
      for ( var i in params )
        queryString.push( i + "=" + encodeURIComponent( params[ i ] ) );
    }

    return url + ( ( url.indexOf( "?" ) != -1 ) ? "&" : "?" ) + queryString.join( "&" );
  };

  // Integrate Rails CSRF token into file upload dialogs (link, image, attachment and flash)
  CKEDITOR.on( "dialogDefinition", function( ev ){
    // Take the dialog name and its definition from the event data.
    var dialogName = ev.data.name;
    var dialogDefinition = ev.data.definition;
    var content, upload;

    if (CKEDITOR.tools.indexOf(["link", "image", "attachment", "flash"], dialogName) > -1) {
      content = (dialogDefinition.getContents("Upload") || dialogDefinition.getContents("upload"));
      upload = (content == null ? null : content.get("upload"));

      if (upload && upload.filebrowser && upload.filebrowser["params"] === undefined) {
        upload.filebrowser["params"] = config.filebrowserParams();
        upload.action = config.addQueryString(upload.action, upload.filebrowser["params"]);
      }
    }
  });

  // Toolbar groups configuration.
  config.toolbar = [
    { name: "document", groups: [ "mode", "document", "doctools" ], items: [ "Source"] },
    { name: "clipboard", groups: [ "clipboard", "undo" ], items: [ "Cut", "Copy", "Paste", "PasteText", "PasteFromWord", "-", "Undo", "Redo" ] },
    // { name: "editing", groups: [ "find", "selection", "spellchecker" ], items: [ "Find", "Replace", "-", "SelectAll", "-", "Scayt" ] },
    // { name: "forms", items: [ "Form", "Checkbox", "Radio", "TextField", "Textarea", "Select", "Button", "ImageButton", "HiddenField" ] },
    { name: "links", items: [ "Link", "Unlink", "Anchor" ] },
    { name: "insert", items: [ "Image", "Flash", "Table", "HorizontalRule", "SpecialChar" ] },
    { name: "paragraph", groups: [ "list", "indent", "blocks", "align", "bidi" ], items: [ "NumberedList", "BulletedList", "-", "Outdent", "Indent", "-", "Blockquote", "-", "JustifyLeft", "JustifyCenter", "JustifyRight", "JustifyBlock" ] },
    "/",
    { name: "styles", items: [ "Styles", "Format", "Font", "FontSize" ] },
    { name: "colors", items: [ "TextColor", "BGColor" ] },
    { name: "basicstyles", groups: [ "basicstyles", "cleanup" ], items: [ "Bold", "Italic", "Underline", "Strike", "Subscript", "Superscript", "-", "RemoveFormat" ] }
  ];

  config.toolbar_mini = [
    { name: "paragraph", groups: [ "list", "indent", "blocks", "align", "bidi" ], items: [ "NumberedList", "BulletedList", "-", "Outdent", "Indent", "-", "Blockquote", "-", "JustifyLeft", "JustifyCenter", "JustifyRight", "JustifyBlock" ] },
    { name: "links", items: [ "Link", "Unlink" ] },
    { name: "styles", items: [ "Format" ] },
    { name: "basicstyles", groups: [ "basicstyles", "cleanup" ], items: [ "Bold", "Italic", "Underline", "Strike", "Subscript", "Superscript", "-", "RemoveFormat" ] },
  ];

  config.toolbar_extended_user = [
    { name: "paragraph", groups: [ "list", "indent", "blocks", "align", "bidi" ], items: [ "NumberedList", "BulletedList", "-", "Outdent", "Indent", "-", "Blockquote", "-", "JustifyLeft", "JustifyCenter", "JustifyRight", "JustifyBlock" ] },
    { name: "links", items: [ "Link", "Unlink", "Anchor" ] },
    { name: "styles", items: [ "Format", "Styles" ] },
    { name: "basicstyles", groups: [ "basicstyles", "cleanup" ], items: [ "Bold", "Italic", "Underline", "Strike", "Subscript", "Superscript", "-", "RemoveFormat" ] },
    { name: "colors", items: [ "TextColor", "BGColor" ] },
    { name: "insert", items: [ "Image", "Table", "MJAccordion", "HorizontalRule", "SpecialChar" ] },
  ];

  config.toolbar_extended_admin = [
    { name: "paragraph", groups: [ "list", "indent", "blocks", "align", "bidi" ], items: [ "NumberedList", "BulletedList", "-", "Outdent", "Indent", "-", "Blockquote", "-", "JustifyLeft", "JustifyCenter", "JustifyRight", "JustifyBlock" ] },
    { name: "links", items: [ "Link", "Unlink", "Anchor", "Abbr" ] },
    { name: "styles", items: [ "Format", "Font", "FontSize", "Styles" ] },
    { name: "basicstyles", groups: [ "basicstyles", "cleanup" ], items: [ "Bold", "Italic", "Underline", "Strike", "Subscript", "Superscript", "-", "RemoveFormat" ] },
    { name: "colors", items: [ "TextColor", "BGColor" ] },
    { name: "insert", items: [ "Image", "Table", "MJAccordion", "Source", "HorizontalRule", "SpecialChar", 'Iframe', 'Youtube'  ] },
  ];

  config.toolbar = "mini";
};
