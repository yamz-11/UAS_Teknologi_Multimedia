// CourseLab Action plugin
//20160203

CKEDITOR.plugins.add( "cl_action",
{
	icons: "editaction",
	init: function (editor)
	{
		editor.addCommand( "editAction",
		{
			exec: function (editor)
			{
				CLRTE.EditAction();
			}
		});
		editor.ui.addButton( "EditAction",
		{
			label : g_oStrings["action"],
			command : "editAction",
			toolbar : "links"
		} );
	}
});