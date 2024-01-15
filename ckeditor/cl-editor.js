// WebSoft Ltd. Russia // 20150610
var CLRTE =
{
	iTimer:0,
	sInitialValue: "",
	sText: "",
	xHyperlinks: null,
	xDoc: null,
	Decode: function (oArgs)
	{
		return String(oArgs.txt).replace(/&/g, "&amp;").replace(/"/g, "&quot;").replace(/'/g, "&#39;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
	},
	EditAction: function (oArgs)
	{
		var oSelection = CKEDITOR.instances.CLE.getSelection(true);
		var oSelectedElem = oSelection.getSelectedElement();
		var sSelectedText = oSelection.getSelectedText();
		//debugger;
		if(oSelectedElem==null && sSelectedText=="")
		{
			// bubble to find A
			var oParent = oSelection.getStartElement().$;
			while(oParent.nodeName.toLowerCase()!="a")
			{
				if($(oParent).attr("contenteditable")!=null)
				{
					break;
				}
				oParent = oParent.parentNode;
			}
			if(oParent.nodeName.toLowerCase()=="a")
			{
				var sHyper = $(oParent).attr("_hyper");
				if(sHyper==null)
				{
					return false;
				}
				var ckA =new CKEDITOR.dom.element(oParent);
				var ckRange = new CKEDITOR.dom.range(CKEDITOR.instances.CLE.document);
				ckRange.selectNodeContents(ckA);
				oSelection.selectRanges([ckRange]);
				var jxHL = $(CLRTE.xHyperlinks).find("hyperlink[id='" + sHyper + "']");
				//alert(CLRTE.SerializeXML({ xXml: jxHL[0] }));
				if(jxHL.length!=0)
				{
					CLRTE.SendMsg({ evt: "CKEditor.editAction", param: CLRTE.SerializeXML({ xXml: jxHL[0] }) });
				}
			}
			return false; // empty selection, parent a not found
		}
		else if(oSelectedElem==null && sSelectedText!="")
		{
			// bubble to find A
			var oParent = oSelection.getStartElement().$;
			while(oParent.nodeName.toLowerCase()!="a")
			{
				if($(oParent).attr("contenteditable")!=null)
				{
					break;
				}
				oParent = oParent.parentNode;
			}
			if(oParent.nodeName.toLowerCase()=="a")
			{
				var sHyper = $(oParent).attr("_hyper");
				if(sHyper==null)
				{
					return false; // this is not action link, stays untouched
				}
				var ckA = new CKEDITOR.dom.element(oParent);
				var ckRange = new CKEDITOR.dom.range(CKEDITOR.instances.CLE.document);
				ckRange.selectNodeContents(ckA);
				oSelection.selectRanges([ckRange]);
				var jxHL = (CLRTE.xHyperlinks).find("hyperlink[id='" + sHyper + "']");
				if(jxHL.length!=0)
				{
					CLRTE.SendMsg({ evt: "CKEditor.editAction", param: CLRTE.SerializeXML({ xXml: jxHL[0] }) });
				}
				return false;
			}
			CLRTE.SendMsg({ evt: "CKEditor.editAction", param: '<hyperlink id="' + CLRTE.HyperLinkId() + '"><events></events></hyperlink>' });
			return false; 
		}
		else if(oSelectedElem!=null)
		{
			// bubble to find A
			if(oSelectedElem.$.nodeName.toLowerCase()=="a")
			{
				var sHyper = $(oParent).attr("_hyper");
				if(sHyper==null)
				{
					return false;
				}
				var jxHL = (CLRTE.xHyperlinks).find("hyperlink[id='" + sHyper + "']");
				CLRTE.SendMsg({ evt: "CKEditor.editAction", param: CLRTE.SerializeXML({ xXml: jxHL[0] }) });
				return false;
			}
			var oParent = oSelectedElem.$;
			while(oParent.nodeName.toLowerCase()!="a")
			{
				if($(oParent).attr("contenteditable")!=null)
				{
					break;
				}
				oParent = oParent.parentNode;
			}
			if(oParent.nodeName.toLowerCase()=="a")
			{
				var sHyper = $(oParent).attr("_hyper");
				if(sHyper==null)
				{
					return false;
				}
				var ckA =new CKEDITOR.dom.element(oParent);
				var ckRange = new CKEDITOR.dom.range(CKEDITOR.instances.CLE.document);
				ckRange.selectNodeContents(ckA);
				oSelection.selectRanges([ckRange]);
				var jxHL = (CLRTE.xHyperlinks).find("hyperlink[id='" + sHyper + "']");
				if(jxHL.length!=0)
				{
					CLRTE.SendMsg({ evt: "CKEditor.editAction", param: CLRTE.SerializeXML({ xXml: jxHL[0] }) });
				}
				return false;
			}
			CLRTE.SendMsg({ evt: "CKEditor.editAction", param: '<hyperlink id="' + CLRTE.HyperLinkId() + '"><events></events></hyperlink>' });
			return false; 
		}		
	},
	FilterLinks: function (oArgs)
	{
		var sHTML = oArgs.evt.data.dataValue;
		var jDiv = $(document.createElement("div")).html(sHTML);
		var jAs = jDiv.find("a[_hyper]");
		for(var i=jAs.length-1; i>=0; i--)
		{
			var jA = $(jAs[i]);
			var sInner = jA.html();
			jA.replaceWith(sInner);
		}
		sHTML = jDiv.html();
		jDiv.remove();
		return sHTML;
	},
	HandleCallback: function (oArgs)
	{
		switch(oArgs.evt)
		{
			case "CKEditor.editAction":
			{
				if(oArgs.txt==null || oArgs.txt=="")
				{
					break;
				}
				//$("#eMessage").text("B " + oArgs.txt);
				CKEDITOR.instances.CLE.focus();
				var oSelection = CKEDITOR.instances.CLE.getSelection(true);
				var xHLDoc = CLRTE.ParseXML({ txt: "<data>" + oArgs.txt + "</data>" });
				var xHL = $(oArgs.txt);
				var sHyperId = $(xHL).attr("id");
				var jAs = $(CKEDITOR.instances.CLE.document.$).find("a[_hyper='" + sHyperId + "']");
				var jxEvents = $(xHLDoc).find("events");
				var jxChildren = jxEvents.children();
				if(jxChildren.length==0)
				{
					// remove selection, remove links if any and break
					oSelection.removeAllRanges();
					oSelection.reset();
					if($(CLRTE.xHyperlinks).find("hyperlink[id='" + sHyperId + "']").length>0)
					{
						$(CLRTE.xHyperlinks).find("hyperlink[id='" + sHyperId + "']").remove();
						for(var i=jAs.length-1; i>=0; i--)
						{
							var jA = $(jAs[i]);
							var sInner = jA.html();
							jA.replaceWith(sInner);
						}
					}
					return false;
				}
				if($(CLRTE.xHyperlinks).find("hyperlink[id='" + sHyperId + "']").length>0 )
				{
					$(CLRTE.xHyperlinks).find("hyperlink[id='" + sHyperId + "']").remove();
					$(CLRTE.xHyperlinks)[0].appendChild($(xHLDoc).find("hyperlink")[0]);
					var jAttributes = $.map(jAs[0].attributes, function(item) { return item.name; });
					$.each(jAttributes, function(i, item) { jAs.removeAttr(item); });
					jAs.attr({ "href": "javascript:void(0)", "_hyper": sHyperId });
					jxChildren.each(function () { jAs.attr($(this)[0].nodeName.toLowerCase(), "processEvent('" + $(this).attr("id") + "'); return false;" ); });
				}
				else
				{
					$(CLRTE.xHyperlinks)[0].appendChild($(xHLDoc).find("hyperlink")[0]);
					var aRanges = oSelection.getRanges();
					var oRange = aRanges[0];
					var oParams = { element: "a", attributes: { href: "javascript: void(0)", _hyper: $(xHL).attr("id") } };
					jxChildren.each(function () { oParams.attributes[$(this)[0].nodeName.toLowerCase()] = "processEvent('" + $(this).attr("id") + "'); return false;"; });
					var oStyle = new CKEDITOR.style(oParams);
					oStyle.type = CKEDITOR.STYLE_INLINE;
					oStyle.applyToRange(oRange);
					oRange.select();
				}
				//alert($(CLRTE.xHyperlinks).find("hyperlink").html());
				break;
			}
			case "CKEditor.instanceReady":
			{
				//alert(oArgs.txt);
				CLRTE.sInitialValue = oArgs.txt;
				CLRTE.xDoc = CLRTE.ParseXML({ txt: oArgs.txt });
				CLRTE.sText = $(CLRTE.xDoc).find("text").text();
				var jHL = $(CLRTE.xDoc).find("hyperlinks");
				if(jHL.length==0)
				{
					jHL = $("hyperlinks").insertAfter($(CLRTE.xDoc).find("text"));
				}
				CLRTE.xHyperlinks = jHL[0];
				//$("#eMessage").text(CLRTE.SerializeXML({ xXml: CLRTE.xHyperlinks }));
				CKEDITOR.instances.CLE.setData( CLRTE.sText );
				break;
			}
			case "CKEditor.getText":
			{
				CLRTE.sText = CKEDITOR.instances.CLE.getData();
				var sHL 
				var sToSave =  "<ietext><text>" + CLRTE.Decode({ txt: CLRTE.sText }) + "</text>" + CLRTE.SerializeXML({ xXml: CLRTE.xHyperlinks }) + "</ietext>";
				//alert(CLRTE.SerializeXML({ xXml: CLRTE.xHyperlinks }));
				CLRTE.SendMsg({ evt: "CKEditor.returnText", param: sToSave });
				break;
			}
			case "CKEditor.selectImage":
			{
				if(oArgs.txt==null || oArgs.txt=="")
				{
					break;
				}
				var oElement = CKEDITOR.dom.element.createFromHtml( '<img src="' + oArgs.txt + '" border="0" />' );
				CKEDITOR.instances.CLE.insertElement( oElement );
				break;
			}
		}
	},
	HyperLinkId: function (oArgs)
	{
		var jxHL = $(CLRTE.xHyperlinks).find("hyperlink");
		var iId = 0;
		//alert(jxHL.length);
		jxHL.each(function ()
		{
			var iHLId = +$(this).attr("id");
			if(iHLId>iId)
			{
				iId = iHLId;
			}
		});
		iId++;
		return iId;
	},
	Init: function (oArgs)
	{
		CKEDITOR.on( "dialogDefinition", function( ev )
		{
			ev.data.definition.resizable = CKEDITOR.DIALOG_RESIZE_NONE;
			var sDialogName = ev.data.name;
			var oDialogDefinition = ev.data.definition;
			if(sDialogName == "link")
			{
				var oInfoTab = oDialogDefinition.getContents("info");
				var oLinktypeField = oInfoTab.get("linkType");
				oLinktypeField["items"].splice(1, 1);
				var oTargetTab = oDialogDefinition.getContents("target");
				var oLinkTargetType = oTargetTab.get("linkTargetType");
				oLinkTargetType["items"].splice(6, 1);
				oLinkTargetType["items"].splice(4, 1);
				oLinkTargetType["items"].splice(0, 2);
				oLinkTargetType["default"] = "_blank";
			}
		});
		CKEDITOR.replace( "CLE",
		{
			on:
			{
				instanceReady: function (evt)
				{
					evt.editor.execCommand("maximize"); 
					CLRTE.SendMsg({ evt: "CKEditor.instanceReady" });
				},
				paste: function (evt)
				{
					evt.data.dataValue = CLRTE.FilterLinks({ evt: evt });
				}
			}
		});		
	},
	ParseXML: function (oArgs)
	{
        return ( new window.DOMParser() ).parseFromString(oArgs.txt, "text/xml");
    },
	SendMsg: function (oArgs)
	{
		/* msgs:
		"CKEditor.instanceReady"
		"CKEditor.returnText"
		"CKEditor.selectImage"
		"CKEditor.editAction"
		*/
		var aParams = (oArgs.param==null) ? null: [ oArgs.param ];
		app.sendMessage(oArgs.evt, aParams);
		//$("#eMessage").html(oArgs.evt);
	},
	SerializeXML: function (oArgs)
	{
		return (new XMLSerializer()).serializeToString(oArgs.xXml);
	}
};
	
// CALLBACKS

app.setMessageCallback("CKEditor.instanceReady", function(name, args)
{
	CLRTE.HandleCallback({ evt: "CKEditor.instanceReady", txt: args[0] });
});
app.setMessageCallback("CKEditor.getText", function(name, args)
{
	CLRTE.HandleCallback({ evt: "CKEditor.getText" });
});
app.setMessageCallback("CKEditor.selectImage", function(name, args)
{
	CLRTE.HandleCallback({ evt: "CKEditor.selectImage", txt: args[0] });
});
app.setMessageCallback("CKEditor.editAction", function(name, args)
{
	CLRTE.HandleCallback({ evt: "CKEditor.editAction", txt: args[0] });
});

// CALLBACKS END

