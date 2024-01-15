/**
 * @license Copyright (c) 2003-2015, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 * Modified by WebSoft Ltd. Russia // 20150610 // 180605
 */

CKEDITOR.dialog.add( 'cellProperties', function( editor ) {
	var langTable = editor.lang.table,
		langCell = langTable.cell,
		langCommon = editor.lang.common,
		validate = CKEDITOR.dialog.validate,
		widthPattern = /^(\d+(?:\.\d+)?)(px|%)$/,
		spacer = { type: 'html', html: '&nbsp;' },
		rtl = editor.lang.dir == 'rtl',
		colorDialog = editor.plugins.colordialog;

	// Returns a function, which runs regular "setup" for all selected cells to find out
	// whether the initial value of the field would be the same for all cells. If so,
	// the value is displayed just as if a regular "setup" was executed. Otherwise,
	// i.e. when there are several cells of different value of the property, a field
	// gets empty value.
	//
	// * @param {Function} setup Setup function which returns a value instead of setting it.
	// * @returns {Function} A function to be used in dialog definition.
	function setupCells( setup ) {
		return function( cells ) {
			var fieldValue = setup( cells[ 0 ] );

			// If one of the cells would have a different value of the
			// property, set the empty value for a field.
			for ( var i = 1; i < cells.length; i++ )
			{
				if ( setup( cells[ i ] ) !== fieldValue ) {
					fieldValue = null;
					break;
				}
			}

			// Setting meaningful or empty value only makes sense
			// when setup returns some value. Otherwise, a *default* value
			// is used for that field.
			if(this.id=="borderColor" || this.id=="bgColor")
			{
				var oInputElem = this.getInputElement();
				if(typeof fieldValue == 'undefined' || fieldValue==null || fieldValue=="")
				{
					this.setValue("");
					oInputElem.setStyle("background-color", "#fff");
					oInputElem.setStyle("color", "#333");
				}
				else
				{
					var sColor = fieldValue;
					if(sColor.indexOf("rgb")!=-1)
					{
						sColor = convertColor(sColor);
					}
					this.setValue(sColor);
					oInputElem.setStyle("background-color", sColor);
					oInputElem.setStyle("color", invertColor(sColor));
				}
			}
			else if ( typeof fieldValue != 'undefined' )
			{
				this.setValue( fieldValue );

				// The only way to have an empty select value in Firefox is
				// to set a negative selectedIndex.
				if ( CKEDITOR.env.gecko && this.type == 'select' && !fieldValue )
					this.getInputElement().$.selectedIndex = -1;
			}
		};
	}

	// Reads the unit of width property of the table cell.
	//
	// * @param {CKEDITOR.dom.element} cell An element representing table cell.
	// * @returns {String} A unit of width: 'px', '%' or undefined if none.
	function getCellWidthType( cell ) {
		var match = widthPattern.exec(
			cell.getStyle( 'width' ) || cell.getAttribute( 'width' ) );

		if ( match )
			return match[ 2 ];
	}
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
	return {
		title: langCell.title,
		minWidth: CKEDITOR.env.ie && CKEDITOR.env.quirks ? 450 : 450,
		minHeight: CKEDITOR.env.ie && ( CKEDITOR.env.ie7Compat || CKEDITOR.env.quirks ) ? 230 : 220,
		contents:
		[
			{
				id: 'info',
				label: langCell.title,
				accessKey: 'I',
				elements:
				[
					{
						type: 'hbox',
						widths: [ "50%", "50%" ],
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
												html: langCommon.width,
												className: "cl-cke-simple-param"
											},
											{
												type: 'text',
												id: 'width',
												controlStyle: 'width:5em',
												validate: function()
												{
													var sValue = this.getValue();
													if(sValue!="")
													{
														var nValue = parseInt(sValue,10);
														if(isNaN(nValue))
														{
															alert( langCell.invalidWidth );
															return false;
														}
													}
												},
												// Extra labelling of width unit type.
												onLoad: function()
												{
													//var widthType = this.getDialog().getContentElement( 'info', 'widthType' ),
														//labelElement = widthType.getElement(),
													var inputElement = this.getInputElement();
													var ariaLabelledByAttr = inputElement.getAttribute( 'aria-labelledby' );
													//inputElement.setAttribute( 'aria-labelledby', [ ariaLabelledByAttr, labelElement.$.id ].join( ' ' ) );
												},
												setup: setupCells( function( element )
												{
													var nValue = "";
													var bPercent = false;
													var sAttrW = element.getAttribute( 'width' );
													if(sAttrW!=null && sAttrW!="")
													{
														nValue = parseInt( sAttrW, 10 );
														bPercent = (sAttrW.toString().indexOf("%")!=-1);
													}
													var sStyleW = element.getStyle( 'width' );
													if(sStyleW!=null && sStyleW!="")
													{
														nValue = parseInt( sStyleW, 10 );
														bPercent = (sStyleW.toString().indexOf("%")!=-1);
													}
													return  bPercent ? (nValue + "%") : nValue;
												}),
												commit: function( element )
												{
													var sValue = this.getValue();
													var value = parseInt( sValue, 10 ),
					
														// There might be no widthType value, i.e. when multiple cells are
														// selected but some of them have width expressed in pixels and some
														// of them in percent. Try to re-read the unit from the cell in such
														// case (#11439).
														unit = (sValue.indexOf("%")==-1) ? "px" : "%";//this.getDialog().getValueOf( 'info', 'widthType' ) || getCellWidthType( element );
					
													if ( !isNaN( value ) )
														element.setStyle( 'width', value + unit );
													else
														element.removeStyle( 'width' );
					
													element.removeAttribute( 'width' );
												},
												'default': ''
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
												html: langCell.rowSpan,
												className: "cl-cke-simple-param"
											},
											{
												type: 'text',
												id: 'rowSpan',
												controlStyle: 'width:5em',
												'default': '',
												validate: validate.integer( langCell.invalidRowSpan ),
												setup: setupCells( function( selectedCell )
												{
													var attrVal = parseInt( selectedCell.getAttribute( 'rowSpan' ), 10 );
													if ( attrVal && attrVal != 1 )
														return attrVal;
												}),
												commit: function( selectedCell )
												{
													var value = parseInt( this.getValue(), 10 );
													if ( value && value != 1 )
														selectedCell.setAttribute( 'rowSpan', this.getValue() );
													else
														selectedCell.removeAttribute( 'rowSpan' );
												}
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
										widths: [ "100%", null ],
										className: "cl-cke-dialog-hbox",
										children:
										[
											{
												type: 'html',
												html: langCommon.height,
												className: "cl-cke-simple-param"
											},
											{
												type: 'text',
												id: 'height',
												controlStyle: 'width:5em',
												'default': '',
												validate: validate.number( langCell.invalidHeight ),				
												// Extra labelling of height unit type.
												onLoad: function()
												{
													//var heightType = this.getDialog().getContentElement( 'info', 'htmlHeightType' ),
													//	labelElement = heightType.getElement(),
													var inputElement = this.getInputElement();
													var ariaLabelledByAttr = inputElement.getAttribute( 'aria-labelledby' );
					
													//inputElement.setAttribute( 'aria-labelledby', [ ariaLabelledByAttr, labelElement.$.id ].join( ' ' ) );
												},
												setup: setupCells( function( element ) {
													var heightAttr = parseInt( element.getAttribute( 'height' ), 10 ),
														heightStyle = parseInt( element.getStyle( 'height' ), 10 );
					
													return !isNaN( heightStyle ) ? heightStyle :
														!isNaN( heightAttr ) ? heightAttr : '';
												}),
												commit: function( element )
												{
													var value = parseInt( this.getValue(), 10 );
					
													if ( !isNaN( value ) )
														element.setStyle( 'height', CKEDITOR.tools.cssLength( value ) );
													else
														element.removeStyle( 'height' );
					
													element.removeAttribute( 'height' );
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
												html: langCell.colSpan,
												className: "cl-cke-simple-param"
											},
											{
												type: 'text',
												id: 'colSpan',
												controlStyle: 'width:5em',
												'default': '',
												validate: validate.integer( langCell.invalidColSpan ),
												setup: setupCells( function( element )
												{
													var attrVal = parseInt( element.getAttribute( 'colSpan' ), 10 );
													if ( attrVal && attrVal != 1 )
														return attrVal;
												}),
												commit: function( selectedCell )
												{
													var value = parseInt( this.getValue(), 10 );
													if ( value && value != 1 )
														selectedCell.setAttribute( 'colSpan', this.getValue() );
													else
														selectedCell.removeAttribute( 'colSpan' );
												}
											}
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
								widths: [ "210px", null, null ],
								className: "cl-cke-dialog-hbox cl-cke-color-box",
								children:
								[
									{
										type: 'html',
										html: langCell.bgColor,
										className: "cl-cke-simple-param"
									},
									{
										type: 'text',
										id: 'bgColor',
										'default': '',
										controlStyle: 'width:6em',
										className: "cl-cke-color-field-cell",
										setup: setupCells( function( element )
										{
											var bgColorAttr = element.getAttribute( 'bgColor' ),
												bgColorStyle = element.getStyle( 'background-color' );
			
											return bgColorStyle || bgColorAttr;
										} ),
										commit: function( selectedCell )
										{
											var value = this.getValue();
			
											if ( value )
											{
												var sColor = value;
												if(sColor.indexOf("rgb")!=-1) sColor = convertColor(sColor);
												selectedCell.setStyle( 'background-color', sColor );
											}
											else
											{
												selectedCell.removeStyle( 'background-color' );
											}
											selectedCell.removeAttribute( 'bgColor' );
										}
									},
									colorDialog ? {
										type: 'button',
										id: 'bgColorChoose',
										'class': 'colorChooser', // jshint ignore:line
										label: langCell.chooseColor,
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
													var oContentElem = this.getDialog().getContentElement( 'info', 'bgColor' );
													oContentElem.setValue( sColor );
													var oInputElem = oContentElem.getInputElement();
													oInputElem.setStyle("background-color", sColor);
													oInputElem.setStyle("color", sInverted);
												}
												this.focus();
											}, this );
										}
									} : spacer
								]
							},
							{
								type: 'hbox',
								widths: [ "210px", null, null ],
								className: "cl-cke-dialog-hbox cl-cke-color-box",
								children:
								[
									{
										type: 'html',
										html: langCell.borderColor,
										className: "cl-cke-simple-param"
									},
									{
										type: 'text',
										id: 'borderColor',
										'default': '',
										controlStyle: 'width:6em',
										setup: setupCells( function( element )
										{
											var borderColorAttr = element.getAttribute( 'borderColor' ),
												borderColorStyle = element.getStyle( 'border-color' );
											return borderColorStyle || borderColorAttr;
										} ),
										commit: function( selectedCell )
										{
											var value = this.getValue();
											if ( value )
											{
												var sColor = value;
												if(sColor.indexOf("rgb")!=-1) sColor = convertColor(sColor);
												selectedCell.setStyle( 'border-color', sColor );
											}
											else
											{
												selectedCell.removeStyle( 'border-color' );
											}					
											selectedCell.removeAttribute( 'borderColor' );
										}
									},
									colorDialog ? {
										type: 'button',
										id: 'borderColorChoose',
										'class': 'colorChooser', // jshint ignore:line
										label: langCell.chooseColor,
										style: ( rtl ? 'margin-right' : 'margin-left' ) + ': 10px',
										onLoad: function()
										{
											// Stick the element to the bottom (#5587)
											//this.getElement().getParent().setStyle( 'vertical-align', 'bottom' );
										},
										onClick: function()
										{
											editor.getColorFromDialog( function( color ) {
												if ( color )
												{
													var sColor = color;
													if(sColor.indexOf("rgb")!=-1) sColor = convertColor(sColor);
													var sInverted = invertColor(sColor);
													var oContentElem = this.getDialog().getContentElement( 'info', 'borderColor' );
													oContentElem.setValue( sColor );
													var oInputElem = oContentElem.getInputElement();
													oInputElem.setStyle("background-color", sColor);
													oInputElem.setStyle("color", sInverted);
												}
												this.focus();
											}, this );
										}
									} : spacer
								]
							},
							{
								type: 'hbox',
								widths: [ "210px", null ],
								className: "cl-cke-dialog-hbox",
								children:
								[
									{
										type: 'html',
										html: langCell.hAlign,
										className: "cl-cke-simple-param"
									},
									{
										type: 'select',
										id: 'hAlign',
										'default': '',
										className: "cl-cke-table-select",
										items:
										[
											[ langCommon.notSet, '' ],
											[ langCommon.alignLeft, 'left' ],
											[ langCommon.alignCenter, 'center' ],
											[ langCommon.alignRight, 'right' ]/*,
											[ langCommon.alignJustify, 'justify' ]*/
										],
										setup: setupCells( function( element )
										{
											var alignAttr = element.getAttribute( 'align' ),
												textAlignStyle = element.getStyle( 'text-align' );
				
											return textAlignStyle || alignAttr || '';
										} ),
										commit: function( selectedCell )
										{
											var value = this.getValue();
				
											if ( value )
												selectedCell.setStyle( 'text-align', value );
											else
												selectedCell.removeStyle( 'text-align' );
				
											selectedCell.removeAttribute( 'align' );
										}
									}
								]
							},
							{
								type: 'hbox',
								widths: [ "210px", null ],
								className: "cl-cke-dialog-hbox",
								children:
								[
									{
										type: 'html',
										html: langCell.vAlign,
										className: "cl-cke-simple-param"
									},
									{
										type: 'select',
										id: 'vAlign',
										'default': '',
										className: "cl-cke-table-select",
										items:
										[
											[ langCommon.notSet, '' ],
											[ langCommon.alignTop, 'top' ],
											[ langCommon.alignMiddle, 'middle' ],
											[ langCommon.alignBottom, 'bottom' ]
										],
										setup: setupCells( function( element )
										{
											var vAlignAttr = element.getAttribute( 'vAlign' ),
												vAlignStyle = element.getStyle( 'vertical-align' );
				
											switch ( vAlignStyle ) {
												// Ignore all other unrelated style values..
												case 'top':
												case 'middle':
												case 'bottom':
												case 'baseline':
													break;
												default:
													vAlignStyle = '';
											}
				
											return vAlignStyle || vAlignAttr || '';
										}),
										commit: function( element )
										{
											var value = this.getValue();
				
											if ( value )
												element.setStyle( 'vertical-align', value );
											else
												element.removeStyle( 'vertical-align' );
				
											element.removeAttribute( 'vAlign' );
										}
									}
								]
							},
							{
								type: 'hbox',
								widths: [ "210px", null ],
								className: "cl-cke-dialog-hbox",
								children:
								[
									{
										type: 'html',
										html: langCell.cellType,
										className: "cl-cke-simple-param"
									},
									{
										type: 'select',
										id: 'cellType',
										className: "cl-cke-table-select",
										'default': 'td',
										items:
										[
											[ langCell.data, 'td' ],
											[ langCell.header, 'th' ]
										],
										setup: setupCells( function( selectedCell )
										{
											return selectedCell.getName();
										}),
										commit: function( selectedCell )
										{
											selectedCell.renameNode( this.getValue() );
										}
									}
								]
							},
							{
								type: 'hbox',
								widths: [ "210px", null ],
								className: "cl-cke-dialog-hbox",
								children:
								[
									{
										type: 'html',
										html: langCell.wordWrap,
										className: "cl-cke-simple-param"
									},
									{
										type: 'select',
										id: 'wordWrap',
										'default': 'yes',
										className: "cl-cke-table-select",
										items:
										[
											[ langCell.yes, 'yes' ],
											[ langCell.no, 'no' ]
										],
										setup: setupCells( function( element )
										{
											var wordWrapAttr = element.getAttribute( 'noWrap' ),
												wordWrapStyle = element.getStyle( 'white-space' );
				
											if ( wordWrapStyle == 'nowrap' || wordWrapAttr )
												return 'no';
										}),
										commit: function( element )
										{
											if ( this.getValue() == 'no' )
												element.setStyle( 'white-space', 'nowrap' );
											else
												element.removeStyle( 'white-space' );
				
											element.removeAttribute( 'noWrap' );
										}
									}
								]
							}
						]
					}
					
				]
			}
		],
		onShow: function()
		{
			this.cells = CKEDITOR.plugins.tabletools.getSelectedCells( this._.editor.getSelection() );
			this.setupContent( this.cells );
		},
		onOk: function()
		{
			var selection = this._.editor.getSelection(),
				bookmarks = selection.createBookmarks();

			var cells = this.cells;
			for ( var i = 0; i < cells.length; i++ )
				this.commitContent( cells[ i ] );

			this._.editor.forceNextSelectionCheck();
			selection.selectBookmarks( bookmarks );
			this._.editor.selectionChange();
		},
		onLoad: function()
		{
			var saved = {};

			// Prevent from changing cell properties when the field's value
			// remains unaltered, i.e. when selected multiple cells and dialog loaded
			// only the properties of the first cell (#11439).
			this.foreach( function( field )
			{
				if ( !field.setup || !field.commit )
					return;

				// Save field's value every time after "setup" is called.
				field.setup = CKEDITOR.tools.override( field.setup, function( orgSetup ) {
					return function() {
						orgSetup.apply( this, arguments );
						saved[ field.id ] = field.getValue();
					};
				} );

				// Compare saved value with actual value. Update cell only if value has changed.
				field.commit = CKEDITOR.tools.override( field.commit, function( orgCommit ) {
					return function() {
						if ( saved[ field.id ] !== field.getValue() )
							orgCommit.apply( this, arguments );
					};
				} );
			} );
		}
	};
} );
