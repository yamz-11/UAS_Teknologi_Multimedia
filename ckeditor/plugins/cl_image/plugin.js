// CourseLab Image plugin
//20160203

CKEDITOR.plugins.add( "cl_image",
{
	icons: "selectimage",
	init: function (editor)
	{
		editor.addCommand( "selectImage",
		{
			exec: function (editor)
			{
				CLRTE.SendMsg({ evt: "CKEditor.selectImage" });
			}
		});
		editor.ui.addButton( "SelectImage",
		{
			label : editor.lang.common.image,
			command : "selectImage",
			toolbar : "insert"
		} );
	}
});