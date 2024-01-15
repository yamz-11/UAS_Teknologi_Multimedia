/**
 * @license Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 * Modified by WebSoft Ltd. Russia // 20150610
 */

( function() {
	var defaultToPixel = CKEDITOR.tools.cssLength;
	var commitValue = function( data ) {
			var id = this.id;
			if ( !data.info )
				data.info = {};
			data.info[ id ] = this.getValue();
		};
	function invertColor(hexTripletColor)
	{
		var color = hexTripletColor;
		color = color.substring(1); 
		color = parseInt(color, 16);
		color = 0xFFFFFF ^ color;
		color = color.toString(16);
		color = ("000000" + color).slice(-6);
		color = "#" + color;
		return color;
	}
	function convertColor(sColor)
	{
		// # found -> hex2rgb, rgb found -> rgb2hex
		var sConverted = sColor;
		if(sColor.indexOf("#")==0)
		{
			var sToConvert = sColor;
			if(sColor.length==4)
			{
				sToConvert = "#";
				for(var i=1; i<4; i++)
				{
					sToConvert += sColor.charAt(i) + sColor.charAt(i);
				}
			}
			var aResult = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(sToConvert);
			if(aResult)
			{
				sConverted = "rgb(" + parseInt(aResult[1], 16) + "," + parseInt(aResult[2], 16) + "," + parseInt(aResult[3], 16) + ")";
			}
		}
		else if(sColor.indexOf("rgb")==0)
		{
			var sPart = sColor.substr(sColor.indexOf("(")+1);
			var aParts = sPart.split(",");
			if(aParts.length>=3)
			{
				var aHex = [];
				for(var i=0; i<3; i++)
				{
					aHex[i] = parseInt(aParts[i],10);
					aHex[i] = aHex[i].toString(16);
					if(aHex[i].length==1) aHex[i] = "0" + aHex[i];
				}
				sConverted = "#" + aHex.join("");
			}
		}
		return sConverted;
	}
	function tableColumns( table ) {
		var cols = 0,
			maxCols = 0;
		for ( var i = 0, row, rows = table.$.rows.length; i < rows; i++ ) {
			row = table.$.rows[ i ], cols = 0;
			for ( var j = 0, cell, cells = row.cells.length; j < cells; j++ ) {
				cell = row.cells[ j ];
				cols += cell.colSpan;
			}

			cols > maxCols && ( maxCols = cols );
		}

		return maxCols;
	}


	// Whole-positive-integer validator.
	function validatorNum( msg ) {
		return function() {
			var value = this.getValue(),
				pass = !!( CKEDITOR.dialog.validate.integer()( value ) && value > 0 );

			if ( !pass ) {
				alert( msg );
				this.select();
			}

			return pass;
		};
	}

	function tableDialog( editor, command ) {
		
		var colorDialog = editor.plugins.colordialog;
		var spacer = { type: 'html', html: '&nbsp;' };
		
		var makeElement = function( name )
		{
				return new CKEDITOR.dom.element( name, editor.document );
		};

		var editable = editor.editable();

		var dialogadvtab = editor.plugins.dialogadvtab;

		return {
			title: editor.lang.table.title,
			minWidth: 450,
			minHeight: CKEDITOR.env.ie ? 230 : 200,

			onLoad: function() {
				var dialog = this;

				var styles = dialog.getContentElement( 'advanced', 'advStyles' );

				if ( styles ) {
					styles.on( 'change', function( evt ) {
						// Synchronize width value.
						var width = this.getStyle( 'width', '' ),
							txtWidth = dialog.getContentElement( 'info', 'txtWidth' );

						txtWidth && txtWidth.setValue( width, true );

						// Synchronize height value.
						var height = this.getStyle( 'height', '' ),
							txtHeight = dialog.getContentElement( 'info', 'txtHeight' );

						txtHeight && txtHeight.setValue( height, true );
					} );
				}
			},

			onShow: function() {
				// Detect if there's a selected table.
				var selection = editor.getSelection(),
					ranges = selection.getRanges(),
					table;

				var rowsInput = this.getContentElement( 'info', 'txtRows' ),
					colsInput = this.getContentElement( 'info', 'txtCols' ),
					widthInput = this.getContentElement( 'info', 'txtWidth' ),
					heightInput = this.getContentElement( 'info', 'txtHeight' );

				if ( command == 'tableProperties' ) {
					var selected = selection.getSelectedElement();
					if ( selected && selected.is( 'table' ) )
						table = selected;
					else if ( ranges.length > 0 ) {
						// Webkit could report the following range on cell selection (#4948):
						// <table><tr><td>[&nbsp;</td></tr></table>]
						if ( CKEDITOR.env.webkit )
							ranges[ 0 ].shrink( CKEDITOR.NODE_ELEMENT );

						table = editor.elementPath( ranges[ 0 ].getCommonAncestor( true ) ).contains( 'table', 1 );
					}

					// Save a reference to the selected table, and push a new set of default values.
					this._.selectedElement = table;
				}

				// Enable or disable the row, cols, width fields.
				if ( table ) {
					this.setupContent( table );
					rowsInput && rowsInput.disable();
					colsInput && colsInput.disable();
				} else {
					rowsInput && rowsInput.enable();
					colsInput && colsInput.enable();
				}

				// Call the onChange method for the widht and height fields so
				// they get reflected into the Advanced tab.
				widthInput && widthInput.onChange();
				heightInput && heightInput.onChange();
			},
			onOk: function()
			{
				var selection = editor.getSelection(),
					bms = this._.selectedElement && selection.createBookmarks();

				var table = this._.selectedElement || makeElement( 'table' ),
					me = this,
					data = {};

				this.commitContent( data, table );

				if ( data.info )
				{
					var info = data.info;

					// Generate the rows and cols.
					if ( !this._.selectedElement )
					{
						var tbody = table.append( makeElement( 'tbody' ) ),
							rows = parseInt( info.txtRows, 10 ) || 0,
							cols = parseInt( info.txtCols, 10 ) || 0;

						for ( var i = 0; i < rows; i++ )
						{
							var row = tbody.append( makeElement( 'tr' ) );
							for ( var j = 0; j < cols; j++ )
							{
								var cell = row.append( makeElement( 'td' ) );
								cell.appendBogus();
							}
						}
					}

					// Modify the table headers. Depends on having rows and cols generated
					// correctly so it can't be done in commit functions.

					// Should we make a <thead>?
					var headers = info.selHeaders;
					if ( !table.$.tHead && ( headers == 'row' || headers == 'both' ) )
					{
						var thead = new CKEDITOR.dom.element( table.$.createTHead() );
						tbody = table.getElementsByTag( 'tbody' ).getItem( 0 );
						var theRow = tbody.getElementsByTag( 'tr' ).getItem( 0 );

						// Change TD to TH:
						for ( i = 0; i < theRow.getChildCount(); i++ )
						{
							var th = theRow.getChild( i );
							// Skip bookmark nodes. (#6155)
							if ( th.type == CKEDITOR.NODE_ELEMENT && !th.data( 'cke-bookmark' ) )
							{
								th.renameNode( 'th' );
								th.setAttribute( 'scope', 'col' );
							}
						}
						thead.append( theRow.remove() );
					}

					if ( table.$.tHead !== null && !( headers == 'row' || headers == 'both' ) )
					{
						// Move the row out of the THead and put it in the TBody:
						thead = new CKEDITOR.dom.element( table.$.tHead );
						tbody = table.getElementsByTag( 'tbody' ).getItem( 0 );

						var previousFirstRow = tbody.getFirst();
						while ( thead.getChildCount() > 0 )
						{
							theRow = thead.getFirst();
							for ( i = 0; i < theRow.getChildCount(); i++ )
							{
								var newCell = theRow.getChild( i );
								if ( newCell.type == CKEDITOR.NODE_ELEMENT )
								{
									newCell.renameNode( 'td' );
									newCell.removeAttribute( 'scope' );
								}
							}
							theRow.insertBefore( previousFirstRow );
						}
						thead.remove();
					}

					// Should we make all first cells in a row TH?
					if ( !this.hasColumnHeaders && ( headers == 'col' || headers == 'both' ) )
					{
						for ( row = 0; row < table.$.rows.length; row++ )
						{
							newCell = new CKEDITOR.dom.element( table.$.rows[ row ].cells[ 0 ] );
							newCell.renameNode( 'th' );
							newCell.setAttribute( 'scope', 'row' );
						}
					}

					// Should we make all first TH-cells in a row make TD? If 'yes' we do it the other way round :-)
					if ( ( this.hasColumnHeaders ) && !( headers == 'col' || headers == 'both' ) )
					{
						for ( i = 0; i < table.$.rows.length; i++ )
						{
							row = new CKEDITOR.dom.element( table.$.rows[ i ] );
							if ( row.getParent().getName() == 'tbody' )
							{
								newCell = new CKEDITOR.dom.element( row.$.cells[ 0 ] );
								newCell.renameNode( 'td' );
								newCell.removeAttribute( 'scope' );
							}
						}
					}

					// Set the width and height.
					info.txtHeight ? table.setStyle( 'height', info.txtHeight ) : table.removeStyle( 'height' );
					info.txtWidth ? table.setStyle( 'width', info.txtWidth ) : table.removeStyle( 'width' );

					if ( !table.getAttribute( 'style' ) )
						table.removeAttribute( 'style' );
				}
				
				//////////////////////////// Patched By Stephen ////////////////////////////

				for ( row = 0; row < table.$.rows.length; row++ )
				{ 
					for (index = 0, len = table.$.rows[ row ].cells.length; index < len; ++index)
					{
						newCell = new CKEDITOR.dom.element( table.$.rows[ row ].cells[ index ] );
						if(table.getStyle('border-width'))
						{
							newCell.setStyle('border-width', table.getStyle('border-width'));
						}
						else
						{
							newCell.removeStyle('border');
						}		
						if(table.getAttribute('cellPadding')>0)
						{
							newCell.setStyle('padding', table.getAttribute('cellPadding')+'px');
						}
						else
						{
						  newCell.removeStyle('padding');
						}
						if(table.getStyle('border-color'))
						{
							newCell.setStyle('border-color', table.getStyle('border-color'));
						}
						else
						{
							newCell.removeStyle('border-color');
						}
						if(table.getStyle('border-style'))
						{
							newCell.setStyle('border-style', table.getStyle('border-style'));  
						}
						else
						{
							newCell.removeStyle('border-style');
						}
					}
				}
				table.removeAttribute('cellPadding');
        //////////////////////////// Patched By Stephen ////////////////////////////

				// Insert the table element if we're creating one.
				if ( !this._.selectedElement ) {
					editor.insertElement( table );
					// Override the default cursor position after insertElement to place
					// cursor inside the first cell (#7959), IE needs a while.
					setTimeout( function() {
						var firstCell = new CKEDITOR.dom.element( table.$.rows[ 0 ].cells[ 0 ] );
						var range = editor.createRange();
						range.moveToPosition( firstCell, CKEDITOR.POSITION_AFTER_START );
						range.select();
					}, 0 );
				}
				// Properly restore the selection, (#4822) but don't break
				// because of this, e.g. updated table caption.
				else
					try {
					selection.selectBookmarks( bms );
				} catch ( er ) {}
			},
			contents:
			[
				{
					id: 'info',
					label: editor.lang.table.title,
					elements:
					[
						{
							type: 'hbox',
							widths: [ "50%", "50%" ],
							styles: [ "vertical-align:top;" ],
							children:
							[
								{
									type: 'vbox',
									padding: 0,
									children:
									[
										{
											type: 'hbox',
											widths: [ "100%", null ],
											className: "cl-cke-dialog-hbox",
											children:
											[
												{
													type: 'html',
													html: editor.lang.table.rows,
													className: "cl-cke-required"
												},
												{
													type: 'text',
													id: 'txtRows',
													'default': 3,
													required: true,
													controlStyle: 'width:5em',
													validate: validatorNum( editor.lang.table.invalidRows ),
													setup: function( selectedElement )
													{
														this.setValue( selectedElement.$.rows.length );
													},
													commit: commitValue
												}
											]
										},
										{
											type: 'hbox',
											widths: [ "100%", null ],
											className: "cl-cke-dialog-hbox",
											children:
											[
												{
													type: 'html',
													html: editor.lang.table.columns,
													className: "cl-cke-required"
												},
												{
													type: 'text',
													id: 'txtCols',
													'default': 2,
													required: true,
													controlStyle: 'width:5em',
													validate: validatorNum( editor.lang.table.invalidCols ),
													setup: function( selectedTable )
													{
														this.setValue( tableColumns( selectedTable ) );
													},
													commit: commitValue
												},
											]
										},
										{
											type: 'hbox',
											widths: [ "100%", null ],
											className: "cl-cke-dialog-hbox",
											children:
											[
												{
													type: 'html',
													html: editor.lang.table.cellPad,
													className: "cl-cke-simple-param"
												},
												{
													type: 'text',
													id: 'txtCellPad',
													requiredContent: 'table[cellpadding]',
													controlStyle: 'width:5em',
													////////////////////////////// Patched By Stephen //////////////////////////////////
													//'default': editor.filter.check( 'table[cellpadding]' ) ? 1 : 0,
													'default': editor.filter.check( 'table[cellpadding]' ) ? 5 : 0,
													////////////////////////////// Patched By Stephen //////////////////////////////////
													validate: CKEDITOR.dialog.validate.number( editor.lang.table.invalidCellPadding ),
													setup: function( selectedTable )
													{
														////////////////////////////// Patched By Stephen //////////////////////////////////
														if(selectedTable.getAttribute('cellpadding'))
														{
															this.setValue(selectedTable.getAttribute('cellpadding'));
														}
														else if(selectedTable.getElementsByTag('tbody').getItem(0))
														{
															var cellpadding=0;
															var tbody = selectedTable.getElementsByTag('tbody').getItem(0);
															var theRow = tbody.getElementsByTag('tr').getItem(0);
															var td = theRow.getChild(0);
															if(td.getStyle('padding'))
															{
																this.setValue(td.getStyle('padding').replace('px','')); 
															}
															else
															{
																if(selectedTable.getElementsByTag('thead').getItem(0))
																{
																	var thead = selectedTable.getElementsByTag('thead').getItem(0);
																	var thead = tbody.getElementsByTag('tr').getItem(0);
																	var th = theRow.getChild(0);
																	if(th.getStyle('padding'))
																	{
																		this.setValue(th.getStyle('padding').replace('px','')); 
																	}
																	else
																	{
																		this.setValue('');
																	}
																}
																else
																{
																	this.setValue('');
																}
															}
														}
														////////////////////////////// Patched By Stephen //////////////////////////////////
													},
													commit: function( data, selectedTable )
													{
														if ( this.getValue() )
														{
															selectedTable.setAttribute( 'cellPadding', this.getValue() );
														}
														else
														{
															selectedTable.removeAttribute( 'cellPadding' );
														}
													}
												}
											]
										},
										{
											type: 'hbox',
											widths: [ "100%", null ],
											className: "cl-cke-dialog-hbox",
											children:
											[
												{
													type: 'html',
													html: editor.lang.table.border,
													className: "cl-cke-simple-param"
												},
												{
													type: 'text',
													id: 'txtBorder',
													requiredContent: 'table[border]',
													// Avoid setting border which will then disappear.
													'default': editor.filter.check( 'table[border]' ) ? 1 : 0,
													controlStyle: 'width:5em',
													validate: CKEDITOR.dialog.validate[ 'number' ]( editor.lang.table.invalidBorder ),
													setup: function( selectedTable )
													{
														////////////////////////////// Patched By Stephen //////////////////////////////////
														//this.setValue( selectedTable.getAttribute( 'border' ) || '' );
														if(selectedTable.getStyle('border-width'))
														{
															this.setValue(selectedTable.getStyle('border-width').replace('px', ''));
														}
														else if(selectedTable.getAttribute('border'))
														{
															this.setValue(selectedTable.getAttribute('border'));
															selectedTable.setStyle('border-style', 'solid'); 
														}
														else
														{
														  this.setValue('');
														}
														////////////////////////////// Patched By Stephen //////////////////////////////////
													},
													commit: function( data, selectedTable )
													{
														////////////////////////////// Patched By Stephen //////////////////////////////////
														//if ( this.getValue() ) // removed
														//	selectedTable.setAttribute( 'border', this.getValue() ); // removed
														//else // removed
														//	selectedTable.removeAttribute( 'border' ); // removed
														if(this.getValue())
														{
															if(this.getValue()>0)
															{
																selectedTable.setStyle('border-width', this.getValue()+'px');
															}
															else
															{
																selectedTable.removeStyle('border');
															}
														}
														else
														{
															selectedTable.removeStyle('border');
														}	
														selectedTable.removeAttribute('border');
													  ////////////////////////////// Patched By Stephen //////////////////////////////////
													}
												}
											]
										},
										spacer
									]
								},
								{
									type: 'vbox',
									padding: 0,
									children:
									[
										{
											type: 'hbox',
											widths: [ "100%", null ],
											className: "cl-cke-dialog-hbox",
											children:
											[
												{
													type: 'html',
													html: editor.lang.common.width,
													className: "cl-cke-simple-param"
												},
												{
													type: 'text',
													id: 'txtWidth',
													requiredContent: 'table{width}',
													controlStyle: 'width:5em',
													title: editor.lang.common.cssLengthTooltip,
													// Smarter default table width. (#9600)
													'default': editor.filter.check( 'table{width}' ) ? ( editable.getSize( 'width' ) < 500 ? '100%' : '50%' ) : 0,
													getValue: defaultToPixel,
													validate: CKEDITOR.dialog.validate.cssLength( editor.lang.common.invalidCssLength.replace( '%1', editor.lang.common.width ) ),
													onChange: function()
													{
														var styles = this.getDialog().getContentElement( 'advanced', 'advStyles' );
														styles && styles.updateStyle( 'width', this.getValue() );
													},
													setup: function( selectedTable )
													{
														var val = selectedTable.getStyle( 'width' );
														this.setValue( val );
													},
													commit: commitValue
												}
											]
										},
										{
											type: 'hbox',
											widths: [ "100%", null ],
											className: "cl-cke-dialog-hbox",
											children:
											[
												{
													type: 'html',
													html: editor.lang.common.height,
													className: "cl-cke-simple-param"
												},
												{
													type: 'text',
													id: 'txtHeight',
													requiredContent: 'table{height}',
													controlStyle: 'width:5em',
													title: editor.lang.common.cssLengthTooltip,
													'default': '',
													getValue: defaultToPixel,
													validate: CKEDITOR.dialog.validate.cssLength( editor.lang.common.invalidCssLength.replace( '%1', editor.lang.common.height ) ),
													onChange: function()
													{
														var styles = this.getDialog().getContentElement( 'advanced', 'advStyles' );
														styles && styles.updateStyle( 'height', this.getValue() );
													},
													setup: function( selectedTable )
													{
														var val = selectedTable.getStyle( 'height' );
														val && this.setValue( val );
													},
													commit: commitValue
												}
											]
										},
										{
											type: 'hbox',
											widths: [ "100%", null ],
											className: "cl-cke-dialog-hbox",
											children:
											[
												{
													type: 'html',
													html: editor.lang.table.cellSpace,
													className: "cl-cke-simple-param"
												},
												{
													type: 'text',
													id: 'txtCellSpace',
													requiredContent: 'table[cellspacing]',
													controlStyle: 'width:5em',
													////////////////////////////// Patched By Stephen //////////////////////////////////
													//'default': editor.filter.check( 'table[cellspacing]' ) ? 1 : 0,
													'default': editor.filter.check( 'table[cellspacing]' ) ? 0 : 0,
													////////////////////////////// Patched By Stephen //////////////////////////////////
													validate: CKEDITOR.dialog.validate.number( editor.lang.table.invalidCellSpacing ),
													setup: function( selectedTable )
													{
														////////////////////////////// Patched By Stephen //////////////////////////////////
														//this.setValue( selectedTable.getAttribute( 'cellSpacing' ) || '' );
														if(selectedTable.getStyle('border-spacing'))
														{
															this.setValue(selectedTable.getStyle('border-spacing').replace('px','')); 
														}
														else if(selectedTable.getAttribute('cellspacing'))
														{
															this.setValue(selectedTable.getAttribute('cellspacing'));
														}
														else
														{
															this.setValue('');  
														}
														////////////////////////////// Patched By Stephen //////////////////////////////////
													},
													commit: function( data, selectedTable )
													{
													  ////////////////////////////// Patched By Stephen //////////////////////////////////
														//if ( this.getValue() )
														//	selectedTable.setAttribute( 'cellSpacing', this.getValue() );
														//else
														//	selectedTable.removeAttribute( 'cellSpacing' );
														if(this.getValue())
														{
															if(this.getValue()>0)
															{
																selectedTable.setStyle('border-collapse', 'separate');
															}
															else
															{
																selectedTable.setStyle('border-collapse', 'collapse');
															}
															selectedTable.setStyle('border-spacing', this.getValue()+'px');
														}
														else
														{
															selectedTable.setStyle('border-collapse', 'collapse');
															selectedTable.removeStyle('border-spacing');
														}
														selectedTable.removeAttribute('cellSpacing');
													  ////////////////////////////// Patched By Stephen //////////////////////////////////
													}
												}
											]
										},
										{
											type: 'hbox',
											widths: [ null, "100%" ],
											children:
											[
												////////////////////////////// Patched By Stephen //////////////////////////////////
												{
													id: 'cmbBorderstyle',
													type: 'select',
													requiredContent: 'table{border-style}',
													'default': 'solid',
													className: "cl-cke-border-style",
													label: editor.lang.common.borderstyle,
													items:
													[
														[ editor.lang.common.notSet, '' ],
														[ editor.lang.common.borderstyleNone, 'none' ],
														[ editor.lang.common.borderstyleSolid, 'solid' ],
														[ editor.lang.common.borderstyleDotted, 'dotted' ],
														[ editor.lang.common.borderstyleDashed, 'dashed' ],
														[ editor.lang.common.borderstyleDouble, 'double' ],
														[ editor.lang.common.borderstyleGroove, 'groove' ],
														[ editor.lang.common.borderstyleRidge, 'ridge' ],
														[ editor.lang.common.borderstyleInset, 'inset' ],
														[ editor.lang.common.borderstyleOutset, 'outset' ]
													],
													setup: function( selectedTable )
													{
														if(this.getValue(selectedTable.getStyle('border-style')))
														{
															this.setValue(selectedTable.getStyle('border-style'));
														}
													  //else{
													  //  this.setValue('solid');
													  //}
													},
													commit: function( data, selectedTable )
													{
														if (this.getValue())
														{
															selectedTable.setStyle('border-style', this.getValue());
														}
														else
														{
															selectedTable.setStyle('border-style', '');
														}
													}
												}, 
												////////////////////////////// Patched By Stephen //////////////////////////////////
												spacer
											]
										},
										{
											type: 'hbox',
											widths: [ null, null, "100%" ],
											className: "cl-cke-color-box-2",
											children:
											[
												////////////////////////////// Patched By Stephen //////////////////////////////////
												{
													type: 'text',
													id: 'txtBordercolor',
													requiredContent: 'table',
													controlStyle: 'width:6em',
													'default': '#cccccc',
													setup: function( selectedTable )
													{
														var sColorStyle = selectedTable.getStyle('border-color');
														var sColorAttr = selectedTable.getAttribute('bordercolor');
														var oInputElem = this.getInputElement();
														if(sColorStyle)
														{
															if(sColorStyle.indexOf("rgb")!=-1) sColorStyle = convertColor(sColorStyle);
															this.setValue(sColorStyle);
															oInputElem.setStyle("background-color", sColorStyle);
															oInputElem.setStyle("color", invertColor(sColorStyle));
														}
														else if(sColorAttr)
														{
															if(sColorAttr.indexOf("rgb")!=-1) sColorAttr = convertColor(sColorAttr);
															this.setValue(sColorAttr);
															selectedTable.removeAttribute('bordercolor');
															oInputElem.setStyle("background-color", sColorAttr);
															oInputElem.setStyle("color", invertColor(sColorAttr));
														}
														else if(this.default)
														{
															var sColor = this.default;
															if(sColor.indexOf("rgb")!=-1) sColor = convertColor(sColor);
															this.setValue(sColor);
															selectedTable.removeAttribute('bordercolor');
															oInputElem.setStyle("background-color", sColor);
															oInputElem.setStyle("color", invertColor(sColor));
														}
														else
														{
															this.setValue(''); 
															oInputElem.setStyle("background-color", "#fff");
															oInputElem.setStyle("color", "#333");
														}
													},
													commit: function( data, selectedTable )
													{
														var sColor = this.getValue()
														if(sColor)
														{
															if(sColor.indexOf("rgb")!=-1) sColor = convertColor(sColor);
															selectedTable.setStyle('border-color', sColor);  
														}
														else
														{
															selectedTable.removeStyle('border-color');
														} 
													}
												},
												colorDialog ? {
													type: 'button',
													id: 'txtBorderColorChoose',
													'class': 'colorChooser', // jshint ignore:line
													label: editor.lang.table.cell.chooseColor,
													onLoad: function() {
														// Stick the element to the bottom (#5587)
														//this.getElement().getParent().setStyle( 'vertical-align', 'bottom' );
													},
													onClick: function() {
														editor.getColorFromDialog( function( color )
														{
															if ( color )
															{
																var sColor = color;
																if(sColor.indexOf("rgb")!=-1) sColor = convertColor(sColor);
																var sInverted = invertColor(sColor);
																var oContentElem = this.getDialog().getContentElement( 'info', 'txtBordercolor' );
																oContentElem.setValue( sColor );
																var oInputElem = oContentElem.getInputElement();
																oInputElem.setStyle("background-color", sColor);
																oInputElem.setStyle("color", sInverted);
															}
															this.focus();
														}, this );
													}
												} : spacer,
												////////////////////////////// Patched By Stephen //////////////////////////////////
												spacer
											]
										}
									]
								}
							]
						},
						{
							type: 'vbox',
							padding: 0,
							children:
							[
								{
									type: 'hbox',
									widths: [ "140px", null ],
									className: "cl-cke-dialog-hbox",
									children:
									[
										{
											type: 'html',
											html: editor.lang.table.headers,
											className: "cl-cke-simple-param"
										},
										{
											type: 'select',
											id: 'selHeaders',
											requiredContent: 'th',
											className: "cl-cke-table-select",
											'default': '',
											items:
											[
												[ editor.lang.table.headersNone, '' ],
												[ editor.lang.table.headersRow, 'row' ],
												[ editor.lang.table.headersColumn, 'col' ],
												[ editor.lang.table.headersBoth, 'both' ]
											],
											setup: function( selectedTable )
											{
												// Fill in the headers field.
												var dialog = this.getDialog();
												dialog.hasColumnHeaders = true;
												// Check if all the first cells in every row are TH
												for ( var row = 0; row < selectedTable.$.rows.length; row++ )
												{
													// If just one cell isn't a TH then it isn't a header column
													var headCell = selectedTable.$.rows[ row ].cells[ 0 ];
													if ( headCell && headCell.nodeName.toLowerCase() != 'th' )
													{
														dialog.hasColumnHeaders = false;
														break;
													}
												}
												// Check if the table contains <thead>.
												if ( ( selectedTable.$.tHead !== null ) )
												{
													this.setValue( dialog.hasColumnHeaders ? 'both' : 'row' );
												}
												else
												{
													this.setValue( dialog.hasColumnHeaders ? 'col' : '' );
												}
											},
											commit: commitValue
										}
									]
								},
								{
									type: 'hbox',
									widths: [ "140px", null ],
									className: "cl-cke-dialog-hbox",
									children:
									[
										{
											type: 'html',
											html: editor.lang.common.align,
											className: "cl-cke-simple-param"
										},
										{
											id: 'cmbAlign',
											type: 'select',
											requiredContent: 'table[align]',
											className: "cl-cke-table-select",
											////////////////////////////// Patched By Stephen //////////////////////////////////
											//'default': '',
											'default': 'center',
											////////////////////////////// Patched By Stephen //////////////////////////////////
											items:
											[
												[ editor.lang.common.notSet, '' ],
												[ editor.lang.common.alignLeft, 'left' ],
												[ editor.lang.common.alignCenter, 'center' ],
												[ editor.lang.common.alignRight, 'right' ]
											],
											setup: function( selectedTable )
											{
												////////////////////////////// Patched By Stephen //////////////////////////////////
												//this.setValue( selectedTable.getAttribute( 'align' ) || '' );
												if(selectedTable.getStyle('float'))
												{
													this.setValue(selectedTable.getStyle('float'));
												}
												else if(selectedTable.getStyle('margin-left'))
												{
													this.setValue('center');
												}
												else if(selectedTable.getAttribute('align'))
												{
													this.setValue(selectedTable.getAttribute('align'));
												}
												else
												{
													this.setValue('');
												}
												////////////////////////////// Patched By Stephen //////////////////////////////////
											},
											commit: function( data, selectedTable ) {
											  ////////////////////////////// Patched By Stephen ////////////////////////////////// 
												//if ( this.getValue() )
												//	selectedTable.setAttribute( 'align', this.getValue() );
												//else
												//	selectedTable.removeAttribute( 'align' );
												if(this.getValue())
												{
													if(this.getValue()=='left')
													{
														selectedTable.setStyle('float', 'left');
														selectedTable.removeStyle('margin-left');
														selectedTable.removeStyle('margin-right');
													}
													else if(this.getValue()=='right')
													{
														selectedTable.setStyle('float', 'right');
														selectedTable.removeStyle('margin-left');
														selectedTable.removeStyle('margin-right');
													}
													else if(this.getValue()=='center')
													{
														selectedTable.setStyle('margin-left', 'auto');
														selectedTable.setStyle('margin-right', 'auto');
														selectedTable.removeStyle('float');
													}
												}
												else
												{
													selectedTable.removeStyle('margin-left');
													selectedTable.removeStyle('margin-right');
													selectedTable.removeStyle('float');
												}
												selectedTable.removeAttribute('align'); 
												////////////////////////////// Patched By Stephen //////////////////////////////////
											}
										}
									]
								}
							]
						}
					]
				},
				//dialogadvtab && dialogadvtab.createAdvancedTab( editor, null, 'table' )
			]
		};
	}

	CKEDITOR.dialog.add( 'table', function( editor ) {
		return tableDialog( editor, 'table' );
	} );
	CKEDITOR.dialog.add( 'tableProperties', function( editor ) {
		return tableDialog( editor, 'tableProperties' );
	} );
} )();
