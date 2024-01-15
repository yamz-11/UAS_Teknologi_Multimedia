// CourseLab BG switch plugin
//20160203

CKEDITOR.plugins.add( "cl_bgswitch",
{
	icons: "bgswitch",
	init: function (editor)
	{
		editor.addCommand( "bgswitch",
		{
			exec: function (editor)
			{
				var oDiv = editor.editable().$; 
				if(oDiv.style.backgroundColor=="" || oDiv.style.backgroundColor=="white")
				{
					oDiv.style.backgroundColor = "black";
				}
				else
				{
					oDiv.style.backgroundColor = "white";
				}
			}
		});
		editor.ui.addButton( "bgswitch",
		{
			label : g_oStrings["switch_bg"],
			command : "bgswitch",
			toolbar : "document"
		} );
	}
});