/**
 * @license Copyright (c) 2003-2015, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 * Modified by WebSoft Ltd. Russia // 20150610
 */
CKEDITOR.editorConfig = function( config )
{
	config.language = g_sLang;
	config.font_names =	g_sFontPairs;
	config.specialChars = g_aSpecialChars;

	config.bodyId = "CLE_editable";
 	config.uiColor = "#dce7f5";
	//config.skin: "courselab";
	config.autoParagraph = false;
	config.browserContextMenuOnCtrl = true;
	config.contentsCss = g_aCKEditorAddCSS;
	config.removePlugins = "image";
	config.extraPlugins = "cl_image,cl_action,cl_bgswitch";
	config.removeDialogTabs = "link:advanced";
	config.dialog_noConfirmCancel = true;
	config.disableNativeSpellChecker = true;
	config.disableNativeTableHandles = false;
	config.startupFocus = true;
	config.dialog_backgroundCoverColor = "#ccc";
	config.allowedContent = 
	{
		"a":
		{
			attributes: "*",
			classes: true,
			styles: true
		},
		"abbr address b cite code dd dfn dl dt em i kbd pre samp section small span strong sub sup var":
		{
			attributes: [ "dir", "id", "lang", "title", "onclick", "ondblclick", "onmousedown", "onmouseover", "onmouseout", "onmouseup", "data-*" ],
			classes: true,
			styles: true
		},
		"article aside figure figcaption footer header mark wbr":
		{
			attributes: false,
			classes: false,
			styles: false
		},
		"blockquote q":
		{
			attributes: [ "cite", "dir", "id", "lang", "title", "onclick", "ondblclick", "onmousedown", "onmouseover", "onmouseout", "onmouseup", "data-*" ],
			classes: true,
			styles: true
		},
		"br":
		{
			attributes: [ "clear" ],
			classes: true,
			styles: true
		},
		"button":
		{
			attributes: [ "accesskey", "autofocus", "disabled", "form", "name", "type", "value", "dir", "id", "title", "onclick", "ondblclick", "onmousedown", "onmouseover", "onmouseout", "onmouseup", "data-*" ],
			classes: true,
			styles: true
		},
		"canvas":
		{
			attributes: [ "width", "height", "id", "data-*" ],
			classes: true,
			styles: true
		},
		"caption":
		{
			attributes: [ "align", "valign", "id", "onclick", "ondblclick", "onmousedown", "onmouseover", "onmouseout", "onmouseup", "data-*" ],
			classes: true,
			styles: true
		},
		"col colgroup":
		{
			attributes: [ "align", "span", "valign", "width", "dir", "id", "lang", "data-*" ],
			classes: false,
			styles: false
		},
		"del ins":
		{
			attributes: [ "cite", "datetime", "dir", "id", "lang", "title", "onclick", "ondblclick", "onmousedown", "onmouseover", "onmouseout", "onmouseup", "data-*" ],
			classes: true,
			styles: true
		},
		"div h1 h2 h3 h4 h5 h6 p":
		{
			attributes: [ "align", "title", "dir", "id", "lang", "onclick", "ondblclick", "onmousedown", "onmouseover", "onmouseout", "onmouseup", "data-*" ],
			classes: true,
			styles: true
		},
		"embed":
		{
			attributes: [ "align", "height", "hidden", "hspace", "pluginspage", "!src", "type", "vspace", "width", "id", "data-*" ],
			classes: true,
			styles: true
		},
		"fieldset":
		{
			attributes: [ "disabled", "form", "title", "dir", "id", "lang", "data-*" ],
			classes: true,
			styles: true
		},
		"form":
		{
			attributes: [ "accept-charset", "action", "autocomplete", "enctype", "method", "name", "target", "id", "dir", "lang", "title", "data-*" ],
			classes: true,
			styles: true
		},
		"hr":
		{
			attributes: [ "align", "color", "noshade", "size", "width", "id", "data-*" ],
			classes: true,
			styles: true
		},		
		"img":
		{
			attributes: [ "!src", "align", "alt", "height", "hspace", "vspace", "width", "id", "title", "onclick", "ondblclick", "onload", "onmousedown", "onmouseover", "onmouseout", "onmouseup", "data-*" ],
			classes: true,
			styles: true
		},
		"input":
		{
			attributes: [ "accept", "accesskey", "align", "alt", "autocomplete", "autofocus", "border", "checked", "disabled", "form*", "list", "max", "maxlength", "min", "multiple", "name", "pattern", "placeholder", "readonly", "required", "size", "src", "step", "tabindex", "!type", "value", "dir", "id", "lang", "title", "onblur", "onchange", "onclick", "ondblclick", "onfocus", "onkeydown", "onkeypress", "onkeyup", "onmousedown", "onmouseover", "onmouseout", "onmouseup", "data-*" ],
			classes: true,
			styles: true
		},
		"label":
		{
			attributes: [ "accesskey", "for", "dir", "id", "lang", "title", "onclick", "ondblclick", "onmousedown", "onmouseover", "onmouseout", "onmouseup", "data-*" ],
			classes: true,
			styles: true
		},		
		"legend":
		{
			attributes: [ "accesskey", "align", "dir", "id", "lang", "title", "onclick", "ondblclick", "onmousedown", "onmouseover", "onmouseout", "onmouseup", "data-*" ],
			classes: true,
			styles: true
		},		
		"li":
		{
			attributes: [ "type", "value", "dir", "id", "lang", "title", "onclick", "ondblclick", "onmousedown", "onmouseover", "onmouseout", "onmouseup", "data-*" ],
			classes: true,
			styles: true
		},		
		"object":
		{
			attributes: [ "!data", "align", "archive", "classid", "code", "codebase", "codetype", "height", "hspace", "tabindex", "type", "vspace", "width", "id", "title", "onclick", "ondblclick", "onload", "onmousedown", "onmouseover", "onmouseout", "onmouseup", "data-*" ],
			classes: true,
			styles: true
		},
		"ol":
		{
			attributes: [ "type", "reversed", "start", "dir", "id", "lang", "title", "onclick", "ondblclick", "onmousedown", "onmouseover", "onmouseout", "onmouseup", "data-*" ],
			classes: true,
			styles: true
		},		
		"optgroup":
		{
			attributes: [ "disabled", "label", "dir", "id", "lang", "onmouseover", "onmouseout", "title", "data-*" ],
			classes: true,
			styles: true
		},		
		"option":
		{
			attributes: [ "disabled", "label", "selected", "value", "dir", "id", "lang", "title", "onmouseover", "onmouseout", "data-*" ],
			classes: true,
			styles: true
		},		
		"param":
		{
			attributes: [ "name", "type", "value", "valuetype", "data-*" ],
			classes: false,
			styles: false
		},		
		"select":
		{
			attributes: [ "accesskey", "autofocus", "disabled", "form", "list", "multiple", "name", "required", "size", "tabindex", "dir", "id", "lang", "title", "onblur", "onchange", "onfocus", "data-*" ],
			classes: true,
			styles: true
		},
		"table":
		{
			attributes: [ "cols", "frame", "dir", "id", "lang", "title", "onclick", "ondblclick", "onmousedown", "onmouseover", "onmouseout", "onmouseup", "data-*" ],
			classes: true,
			styles: true
		},
		"tbody tfoot thead":
		{
			attributes: [ "align", "char", "charoff", "bgcolor", "valign", "dir", "id", "lang", "title", "onclick", "ondblclick", "onmousedown", "onmouseover", "onmouseout", "onmouseup", "data-*" ],
			classes: true,
			styles: true
		},
		"td th":
		{
			attributes: [ "abbr", "align", "background", "bgcolor", "bordercolor", "colspan", "headers", "height", "nowrap", "rowspan", "scope", "valign", "width", "dir", "id", "lang", "title", "onclick", "ondblclick", "onmousedown", "onmouseover", "onmouseout", "onmouseup", "data-*" ],
			classes: true,
			styles: true
		},
		"textarea":
		{
			attributes: [ "accesskey", "autofocus", "cols", "disabled", "form", "maxlength", "name", "placeholder", "readonly", "required", "rows", "tabindex", "wrap", "dir", "id", "lang", "title", "onblur", "onchange", "onclick", "ondblclick", "onfocus", "onkeydown", "onkeypress", "onkeyup", "onmousedown", "onmouseover", "onmouseout", "onmouseup", "data-*" ],
			classes: true,
			styles: true
		},
		"time":
		{
			attributes: [ "datetime", "pubdate", "data-*" ],
			classes: false,
			styles: false
		},		
		"tr":
		{
			attributes: [ "align", "bgcolor", "bordercolor", "valign", "dir", "id", "lang", "title", "onclick", "ondblclick", "onmousedown", "onmouseover", "onmouseout", "onmouseup", "data-*" ],
			classes: true,
			styles: true
		},
		"ul":
		{
			attributes: [ "type", "dir", "id", "lang", "title", "onclick", "ondblclick", "onmousedown", "onmouseover", "onmouseout", "onmouseup", "data-*" ],
			classes: true,
			styles: true
		}
	};
	config.disallowedContent = "table[cellspacing,cellpadding,border,align,summary,bgcolor,frame,rules,width]; td[axis,abbr,scope,align,bgcolor,char,charoff,height,nowrap,valign,width]; th[axis,abbr,align,bgcolor,char,charoff,height,nowrap,valign,width]; tbody[align,char,charoff,valign]; tfoot[align,char,charoff,valign]; thead[align,char,charoff,valign]; tr[align,bgcolor,char,charoff,valign]; col[align,char,charoff,valign,width]; colgroup[align,char,charoff,valign,width]";
	config.resize_enabled = false;
	config.toolbar =
	[
		{
			name: 	"clipboard",
			items: 	[ "SelectAll", "Cut", "Copy", "Paste", "PasteText", "PasteFromWord" ]
		},
		{
			name: 	"history",
			items: 	[ "Undo", "Redo" ]
		},
		{
			name: 	"insert",
			items: 	[ "SelectImage", "Table", "HorizontalRule", "SpecialChar" ]
		},
		{
			name: 	"links",
			items: 	[ "EditAction", "-", "Unlink" ]
		},
		{
			name: 	"editing",
			items: 	[ "Find", "Replace" ]
		},
		{
			name: 	"tools",
			items: [ "BidiLtr", "BidiRtl", "ShowBlocks" ]
		},
		"/",
		{
			name: 	"styles",
			items: 	[ "Font", "FontSize", "lineheight" ]
		},
		{
			name: 	"paragraph",
			items: 	[ "JustifyLeft", "JustifyCenter", "JustifyRight", "JustifyBlock", "-", "NumberedList", "BulletedList", "-", "Indent", "Outdent" ]
		},
		"/",
		{
			name: 	"basicstyles",
			items: 	[ "Bold", "Italic", "Underline", "Strike", "-", "Subscript", "Superscript", "-", "TextColor", "BGColor", "-", "RemoveFormat"  ]
		},
		{
			name: "texttransform",
			items: [ "TransformTextToUppercase", "TransformTextToLowercase", "TransformTextCapitalize" ]
		},
		{
			name: 	"document",
			items: [ "Source", "autoFormat", "CommentSelectedRange", "UncommentSelectedRange", "AutoComplete", "bgswitch" ]
		}
	];
	config.line_height = "0.4em;0.6em;0.8em;0.9em;1em;1.1em;1.2em;1.3em;1.4em;1.5em;1.6em;1.8em;2.0em;2.5em;3.0em;" ;
	config.codemirror =
	{
		theme: "default",
		lineNumbers: true,
		lineWrapping: true,
		matchBrackets: true,
		autoCloseTags: true,
		autoCloseBrackets: true,
		// Whether or not to enable search tools, CTRL+F (Find), CTRL+SHIFT+F (Replace), CTRL+SHIFT+R (Replace All), CTRL+G (Find Next), CTRL+SHIFT+G (Find Previous)
		enableSearchTools: true,
		enableCodeFolding: false,
		enableCodeFormatting: true,
		autoFormatOnStart: true,
		autoFormatOnModeChange: true,
		autoFormatOnUncomment: true,
		mode: "htmlmixed",
		showSearchButton: true,
		showTrailingSpace: false,
		highlightMatches: true,
		showFormatButton: true,
		showCommentButton: true,
		showUncommentButton: true,
		showAutoCompleteButton: true,
		styleActiveLine: true
	};
};
