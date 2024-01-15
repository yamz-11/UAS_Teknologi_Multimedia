<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:websoft="http://www.websoft.ru"
				version="1.0">
<!--
'*	splash_button_go.xsl
'*	Copyright (c) Websoft.  All rights reserved.
-->

<xsl:output method="xml" encoding="utf-8" omit-xml-declaration="yes"/>
<xsl:param name="objectID"></xsl:param>
<xsl:param name="imagesFolder"></xsl:param>
<xsl:param name="moduleImagesFolder"></xsl:param>
<xsl:param name="width"></xsl:param>
<xsl:param name="height"></xsl:param>

<xsl:template match="/"><xsl:apply-templates select="params"/></xsl:template>

<xsl:template match="params">

	<xsl:variable name="bg-color-fixed">
		<xsl:call-template name="fix-color">
			<xsl:with-param name="color" select="bg_color"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="border-color-fixed">
		<xsl:call-template name="fix-color">
			<xsl:with-param name="color" select="border_color"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="gradient-color-fixed">
		<xsl:call-template name="fix-color">
			<xsl:with-param name="color" select="gradient_color"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="font-color-fixed">
		<xsl:call-template name="fix-color">
			<xsl:with-param name="color" select="font_color"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="text-shadow-color-fixed">
		<xsl:call-template name="fix-color">
			<xsl:with-param name="color" select="text_shadow_color"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="_btn_inner_w" select="number($width)-2*number(border_width)"/>
	<xsl:variable name="_btn_inner_h" select="number($height)-2*number(border_width)"/>
	<xsl:variable name="_btn_font">
		<xsl:choose>
			<xsl:when test="font='custom'"><xsl:value-of select="font_custom"/></xsl:when>
			<xsl:otherwise><xsl:call-template name="font_selector"><xsl:with-param name="sFontID" select="font"/></xsl:call-template></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="_btn_gradient_color">
		<xsl:choose>
			<xsl:when test="bg_type='auto'">
				<xsl:call-template name="autogradient">
					<xsl:with-param name="color.base" select="$bg-color-fixed"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="bg_type='custom'"><xsl:value-of select="$gradient-color-fixed"/></xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="_shadow_string">
		<xsl:if test="shadow_strength!='none'">
			<xsl:call-template name="shadow_builder">
				<xsl:with-param name="sType">block</xsl:with-param>
				<xsl:with-param name="sColor"></xsl:with-param>
				<xsl:with-param name="sStrength" select="shadow_strength"/>
				<xsl:with-param name="sOpacity"></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="_css_font_style">
		<xsl:choose>
			<xsl:when test="font_style='bold'">font-weight: bold;</xsl:when>
			<xsl:when test="font_style='italic'">font-style: italic;</xsl:when>
			<xsl:when test="font_style='bolditalic'">font-weight: bold; font-style: italic;</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="_css_font">font-family: <xsl:value-of select="$_btn_font"/>; font-size: <xsl:value-of select="font_size"/>px; color: <xsl:value-of select="$font-color-fixed"/>; <xsl:value-of select="$_css_font_style"/></xsl:variable>
	<xsl:variable name="_text_shadow">
		<xsl:if test="text_shadow_strength!='none'">
			<xsl:call-template name="shadow_builder">
				<xsl:with-param name="sType">text</xsl:with-param>
				<xsl:with-param name="sColor" select="$text-shadow-color-fixed"/>
				<xsl:with-param name="sStrength" select="text_shadow_strength"/>
				<xsl:with-param name="sOpacity"></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="_css_bg_color">
		<xsl:choose>
			<xsl:when test="bg_type='transparent'"></xsl:when>
			<xsl:otherwise>background-color: <xsl:value-of select="$bg-color-fixed"/>;</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="_css_gradient_style"><xsl:if test="bg_type='auto' or bg_type='custom'">background-image: -o-linear-gradient(90deg, <xsl:value-of select="$bg-color-fixed"/> 0%, <xsl:value-of select="$_btn_gradient_color"/> 100%); background-image: -ms-linear-gradient(90deg, <xsl:value-of select="$bg-color-fixed"/> 0%, <xsl:value-of select="$_btn_gradient_color"/> 100%); background-image: -moz-linear-gradient(90deg, <xsl:value-of select="$bg-color-fixed"/> 0%, <xsl:value-of select="$_btn_gradient_color"/> 100%); background-image: -webkit-linear-gradient(90deg, <xsl:value-of select="$bg-color-fixed"/> 0%, <xsl:value-of select="$_btn_gradient_color"/> 100%); background-image: linear-gradient(0deg, <xsl:value-of select="$bg-color-fixed"/> 0%, <xsl:value-of select="$_btn_gradient_color"/> 100%);</xsl:if></xsl:variable>
	<xsl:variable name="_css_gradient_style_over"><xsl:if test="bg_type='auto' or bg_type='custom'">background-image: -o-linear-gradient(270deg, <xsl:value-of select="$bg-color-fixed"/> 0%, <xsl:value-of select="$_btn_gradient_color"/> 100%); background-image: -ms-linear-gradient(270deg, <xsl:value-of select="$bg-color-fixed"/> 0%, <xsl:value-of select="$_btn_gradient_color"/> 100%); background-image: -moz-linear-gradient(270deg, <xsl:value-of select="$bg-color-fixed"/> 0%, <xsl:value-of select="$_btn_gradient_color"/> 100%); background-image: -webkit-linear-gradient(270deg, <xsl:value-of select="$bg-color-fixed"/> 0%, <xsl:value-of select="$_btn_gradient_color"/> 100%); background-image: linear-gradient(180deg, <xsl:value-of select="$bg-color-fixed"/> 0%, <xsl:value-of select="$_btn_gradient_color"/> 100%);</xsl:if></xsl:variable>
	<xsl:variable name="_css_shadow">
		<xsl:if test="$_shadow_string!=''">-o-box-shadow: <xsl:value-of select="$_shadow_string"/>;-ms-box-shadow: <xsl:value-of select="$_shadow_string"/>;-moz-box-shadow: <xsl:value-of select="$_shadow_string"/>; -webkit-box-shadow: <xsl:value-of select="$_shadow_string"/>; box-shadow: <xsl:value-of select="$_shadow_string"/>;</xsl:if>
	</xsl:variable>
	<xsl:variable name="_css_border_radius">
		<xsl:if test="number(border_radius)!='0'">-o-border-radius: <xsl:value-of select="border_radius"/>px; -ms-border-radius: <xsl:value-of select="border_radius"/>px; -moz-border-radius: <xsl:value-of select="border_radius"/>px; -webkit-border-radius: <xsl:value-of select="border_radius"/>px; border-radius: <xsl:value-of select="border_radius"/>px;</xsl:if>
	</xsl:variable>
	<xsl:variable name="_css_border">
		<xsl:choose>
			<xsl:when test="number(border_width)=0 or btn_type='image'"></xsl:when>
			<xsl:otherwise>border-width: <xsl:value-of select="border_width"/>px; border-color: <xsl:value-of select="$border-color-fixed"/>; <xsl:value-of select="$_css_border_radius"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="_css_bg_img">
		<xsl:if test="content='image' or content='textimage'">background-image: url(<xsl:value-of select="bg_img_1"/>); background-position: <xsl:value-of select="bg_position"/> center; background-repeat: no-repeat;</xsl:if>
	</xsl:variable>

	<div>
		<xsl:attribute name="style">position: absolute; width: <xsl:value-of select="$width"/>px; height: <xsl:value-of select="$height"/>px; -webkit-touch-callout: none; -webkit-user-select: none; -khtml-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none;</xsl:attribute>
		<xsl:attribute name="title"><xsl:value-of select="btn_text"/></xsl:attribute>
		<xsl:choose>
			<xsl:when test="btn_type='image'">
				<div>
					<xsl:attribute name="style">position: absolute; width: <xsl:value-of select="$width"/>px; height: <xsl:value-of select="$height"/>px;</xsl:attribute>
					<img>
						<xsl:attribute name="style">position: absolute; left: 0; top: 0; cursor: pointer;</xsl:attribute>
						<xsl:if test="n2_img!=''">
						<xsl:attribute name="onmouseover">this.src='<xsl:value-of select="n2_img"/>';</xsl:attribute>
						<xsl:attribute name="onmouseout">this.src='<xsl:value-of select="n1_img"/>';</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="onclick">
							<xsl:choose>
								<xsl:when test="action='go'">CL.Start(); return false;</xsl:when>
								<xsl:when test="action='desc'">CLSplash.Open({ sId: '<xsl:value-of select="objectid"/>' }); return false;</xsl:when>
							</xsl:choose>
						</xsl:attribute>
						<xsl:attribute name="src"><xsl:value-of select="n1_img"/></xsl:attribute>
					</img>
					<img>
						<xsl:attribute name="style">display: none;</xsl:attribute>
						<xsl:attribute name="id"><xsl:value-of select="$objectID"/>_img_idle</xsl:attribute>
						<xsl:attribute name="src"><xsl:value-of select="n1_img"/></xsl:attribute>
					</img>
					<img>
						<xsl:attribute name="style">display: none;</xsl:attribute>
						<xsl:attribute name="id"><xsl:value-of select="$objectID"/>_img_over</xsl:attribute>
						<xsl:attribute name="src"><xsl:value-of select="n2_img"/></xsl:attribute>
					</img>
				</div>
			</xsl:when>
			<xsl:when test="btn_type='html'">
				<div>
					<xsl:attribute name="id"><xsl:value-of select="$objectID"/>_BTN</xsl:attribute>
					<xsl:attribute name="style">cursor: pointer; position: relative; left: 0; top: 0; box-sizing: border-box; width: <xsl:value-of select="$width"/>px; height: <xsl:value-of select="$height"/>px; border-style: solid; <xsl:value-of select="$_css_border"/> <xsl:value-of select="$_css_shadow"/>border-color: <xsl:value-of select="$border-color-fixed"/>; <xsl:value-of select="$_css_bg_color"/> <xsl:value-of select="$_css_gradient_style"/></xsl:attribute>
					<xsl:attribute name="onmouseover">this.setAttribute('style', this.getAttribute('data-style-over'));</xsl:attribute>
					<xsl:attribute name="onmouseout">this.setAttribute('style', this.getAttribute('data-style-idle'));</xsl:attribute>
					<xsl:attribute name="onclick">
							<xsl:choose>
								<xsl:when test="action='go'">CL.Start(); return false;</xsl:when>
								<xsl:when test="action='desc'">CLSplash.Open({ sId: '<xsl:value-of select="objectid"/>' }); return false;</xsl:when>
							</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="data-style-idle">cursor: pointer; position: relative; left: 0; top: 0; box-sizing: border-box; width: <xsl:value-of select="$width"/>px; height: <xsl:value-of select="$height"/>px; border-style: solid; <xsl:value-of select="$_css_border"/> <xsl:value-of select="$_css_shadow"/>border-color: <xsl:value-of select="$border-color-fixed"/>; <xsl:value-of select="$_css_bg_color"/> <xsl:value-of select="$_css_gradient_style"/></xsl:attribute>
					<xsl:attribute name="data-style-over">cursor: pointer; position: relative; left: 0; top: 0; box-sizing: border-box; width: <xsl:value-of select="$width"/>px; height: <xsl:value-of select="$height"/>px; border-style: solid; <xsl:value-of select="$_css_border"/> <xsl:value-of select="$_css_shadow"/>border-color: <xsl:value-of select="$border-color-fixed"/>; <xsl:value-of select="$_css_bg_color"/> <xsl:value-of select="$_css_gradient_style_over"/></xsl:attribute>
					<div>
						<xsl:attribute name="id"><xsl:value-of select="$objectID"/>_BTN_BG</xsl:attribute>
						<xsl:attribute name="style">position: relative; padding: 0; margin: 0; width: <xsl:value-of select="$_btn_inner_w"/>px; height: <xsl:value-of select="$_btn_inner_h"/>px; <xsl:value-of select="$_css_bg_img"/></xsl:attribute>
						<table>
							<xsl:attribute name="id"><xsl:value-of select="$objectID"/>_BTN_TABLE</xsl:attribute>
							<xsl:attribute name="style">border-spacing: 0; width: <xsl:value-of select="$_btn_inner_w"/>px; height: <xsl:value-of select="$_btn_inner_h"/>px;</xsl:attribute>
							<tr>
								<td>
									<xsl:attribute name="id"><xsl:value-of select="$objectID"/>_BTN_TABLE_CONTENT</xsl:attribute>
									<xsl:attribute name="style">text-align: center; vertical-align: middle; padding: 0; text-shadow: <xsl:value-of select="$_text_shadow"/>; width: <xsl:value-of select="$_btn_inner_w"/>px; height: <xsl:value-of select="$_btn_inner_h"/>px; <xsl:value-of select="$_css_font"/></xsl:attribute>
									<xsl:choose>
										<xsl:when test="content='image'">&#160;</xsl:when>
										<xsl:otherwise><xsl:value-of select="btn_text"/></xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
						</table>
					</div>
				</div>
			</xsl:when>
		</xsl:choose>
	</div>

</xsl:template>

<!-- COMMON TEMPLATES -->
<xsl:template name="shadow_builder">
	<xsl:param name="sType"/>
	<xsl:param name="sStrength"/>
	<xsl:param name="sColor"/>
	<xsl:param name="sOpacity"/>
	<xsl:variable name="sHexColor">
		<xsl:choose>
			<xsl:when test="$sType='text'">
				<xsl:choose>
					<xsl:when test="string-length($sColor)!=0"><xsl:value-of select="$sColor"/></xsl:when>
					<xsl:otherwise>#FFFFFF</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$sStrength='extralight'">#CCCCCC</xsl:when>
					<xsl:when test="$sStrength='light'">#999999</xsl:when>
					<xsl:when test="$sStrength='normal'">#666666</xsl:when>
					<xsl:when test="$sStrength='dark'">#333333</xsl:when>
					<xsl:when test="$sStrength='extradark'">#000000</xsl:when>
					<xsl:otherwise>#666666</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="sOp">
		<xsl:choose>
			<xsl:when test="$sType='text'">
				<xsl:choose>
					<xsl:when test="string-length($sOpacity)=0">
						<xsl:choose>
							<xsl:when test="$sStrength='extralight'">0.3</xsl:when>
							<xsl:when test="$sStrength='light'">0.5</xsl:when>
							<xsl:when test="$sStrength='normal'">0.66</xsl:when>
							<xsl:when test="$sStrength='dark'">0.9</xsl:when>
							<xsl:when test="$sStrength='extradark'">1.0</xsl:when>
							<xsl:otherwise>0.66</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$sOpacity"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$sStrength='extralight'">0.3</xsl:when>
					<xsl:when test="$sStrength='light'">0.5</xsl:when>
					<xsl:when test="$sStrength='normal'">0.66</xsl:when>
					<xsl:when test="$sStrength='dark'">0.9</xsl:when>
					<xsl:when test="$sStrength='extradark'">1.0</xsl:when>
					<xsl:otherwise>0.66</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="sRGB">
		<xsl:call-template name="hex2rgb">
			<xsl:with-param name="hexcolor" select="$sHexColor"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="sOffset">
		<xsl:choose>
			<xsl:when test="$sType='text'">
				<xsl:choose>
					<xsl:when test="$sStrength='extralight'">1px 1px 2px</xsl:when>
					<xsl:when test="$sStrength='light'">1px 1px 2px</xsl:when>
					<xsl:when test="$sStrength='normal'">1px 1px 2px</xsl:when>
					<xsl:when test="$sStrength='dark'">2px 2px 3px</xsl:when>
					<xsl:when test="$sStrength='extradark'">2px 2px 4px</xsl:when>
					<xsl:otherwise>1px 1px 2px</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$sStrength='extralight'">1px 1px 2px</xsl:when>
					<xsl:when test="$sStrength='light'">2px 2px 4px</xsl:when>
					<xsl:when test="$sStrength='normal'">2px 2px 6px</xsl:when>
					<xsl:when test="$sStrength='dark'">3px 3px 6px</xsl:when>
					<xsl:when test="$sStrength='extradark'">3px 3px 8px</xsl:when>
					<xsl:otherwise>1px 1px 2px</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:value-of select="concat($sOffset,' rgba(',$sRGB,',',$sOp,')')"/>
</xsl:template>
<xsl:template match="*" name="font_selector">
	<xsl:param name="sFontID"/>
	<xsl:choose>
		<xsl:when test="$sFontID='Arial'">Arial,'Helvetica Neue',Helvetica,sans-serif</xsl:when>
		<xsl:when test="$sFontID='ArialBlack'">'Arial Black','Arial Bold',Gadget,sans-serif</xsl:when>
		<xsl:when test="$sFontID='ArialNarrow'">'Arial Narrow',Arial,sans-serif</xsl:when>
		<xsl:when test="$sFontID='Comic Sans MS'">'Comic Sans MS', cursive, sans-serif</xsl:when>
		<xsl:when test="$sFontID='CourierNew'">'Courier New',Courier,'Lucida Sans Typewriter','Lucida Typewriter',monospace</xsl:when>
		<xsl:when test="$sFontID='Georgia'">Georgia,Times,'Times New Roman',serif</xsl:when>
		<xsl:when test="$sFontID='Impact'">Impact,Haettenschweiler,'Franklin Gothic Bold',Charcoal,'Helvetica Inserat','Bitstream Vera Sans Bold','Arial Black',sans-serif</xsl:when>
		<xsl:when test="$sFontID='LucidaConsole'">'Lucida Console','Lucida Sans Typewriter',monaco,'Bitstream Vera Sans Mono',monospace</xsl:when>
		<xsl:when test="$sFontID='LucidaSansUnicode'">'Lucida Sans Unicode', 'Lucida Grande', sans-serif</xsl:when>
		<xsl:when test="$sFontID='Palatino'">Palatino,'Palatino Linotype','Palatino LT STD','Book Antiqua',Georgia,serif</xsl:when>
		<xsl:when test="$sFontID='Tahoma'">Tahoma,Verdana,Segoe,sans-serif</xsl:when>
		<xsl:when test="$sFontID='Times'">TimesNewRoman,'Times New Roman',Times,Baskerville,Georgia,serif</xsl:when>
		<xsl:when test="$sFontID='TrebuchetMS'">'Trebuchet MS','Lucida Grande','Lucida Sans Unicode','Lucida Sans',Tahoma,sans-serif</xsl:when>
		<xsl:when test="$sFontID='Verdana'">Verdana,Geneva,sans-serif</xsl:when>
		<xsl:when test="$sFontID='clear_sans_lightregular'">clear_sans_lightregular, 'Arial Narrow', sans-serif</xsl:when>
		<xsl:when test="$sFontID='clear_sans_mediumregular'">clear_sans_mediumregular, Arial, sans-serif</xsl:when>
		<xsl:when test="$sFontID='clear_sansregular'">clear_sansregular, Arial, sans-serif</xsl:when>
		<xsl:when test="$sFontID='clear_sans_thinregular'">clear_sans_thinregular, 'Arial Narrow', sans-serif</xsl:when>
		<xsl:when test="$sFontID='droid_sans_monoregular'">droid_sans_monoregular, 'Lucida Console', Monaco, monospace</xsl:when>
		<xsl:when test="$sFontID='droid_sansregular'">droid_sansregular, Verdana, sans-serif</xsl:when>
		<xsl:when test="$sFontID='droid_serifregular'">droid_serifregular, Georgia, serif</xsl:when>
		<xsl:when test="$sFontID='Fira_Mono'">Fira_Mono, 'Lucida Console', monospace</xsl:when>
		<xsl:when test="$sFontID='Fira_Sans'">Fira_Sans, Arial, sans-serif</xsl:when>
		<xsl:when test="$sFontID='FiraSansLight'">FiraSansLight, Arial, sans-serif</xsl:when>
		<xsl:when test="$sFontID='FiraSansMedium'">FiraSansMedium, Arial, sans-serif</xsl:when>
		<xsl:when test="$sFontID='Fregat_Sans'">Fregat_Sans, Arial, sans-serif</xsl:when>
		<xsl:when test="$sFontID='Lato_Sans'">Lato_Sans, Arial, sans-serif</xsl:when>
		<xsl:when test="$sFontID='LatoSansLight'">LatoSansLight, Arial, sans-serif</xsl:when>
		<xsl:when test="$sFontID='nerisblack'">nerisblack, 'Arial Black', sans-serif</xsl:when>
		<xsl:when test="$sFontID='nerislight'">nerislight, Arial, sans-serif</xsl:when>
		<xsl:when test="$sFontID='nerissemibold'">nerissemibold, Arial, sans-serif</xsl:when>
		<xsl:when test="$sFontID='neristhin'">neristhin, Arial, sans-serif</xsl:when>
		<xsl:when test="$sFontID='noto_sansregular'">noto_sansregular, Arial, sans-serif</xsl:when>
		<xsl:when test="$sFontID='noto_serifregular'">noto_serifregular, Georgia, serif</xsl:when>
		<xsl:when test="$sFontID='open_sanscondensed_light'">open_sanscondensed_light, 'Arial Narrow', sans-serif</xsl:when>
		<xsl:when test="$sFontID='open_sansextrabold'">open_sansextrabold, 'Arial Black', sans-serif</xsl:when>
		<xsl:when test="$sFontID='open_sanslight'">open_sanslight, Arial, sans-serif</xsl:when>
		<xsl:when test="$sFontID='open_sansregular'">open_sansregular, Arial, sans-serif</xsl:when>
		<xsl:when test="$sFontID='open_sanssemibold'">open_sanssemibold, Arial, sans-serif</xsl:when>
		<xsl:when test="$sFontID='permiansanstypefaceregular'">permiansanstypefaceregular, Arial, sans-serif</xsl:when>
		<xsl:when test="$sFontID='permianseriftypefaceregular'">permianseriftypefaceregular, Georgia, serif</xsl:when>
		<xsl:when test="$sFontID='permianslabseriftypefaceRg'">permianslabseriftypefaceRg, Georgia, serif</xsl:when>
		<xsl:when test="$sFontID='robotoblack'">robotoblack, 'Arial Black', Gadget, sans-serif</xsl:when>
		<xsl:when test="$sFontID='roboto_condensedregular'">roboto_condensedregular, 'Arial Narrow', sans-serif</xsl:when>
		<xsl:when test="$sFontID='roboto_condensedlight'">roboto_condensedlight, 'Arial Narrow', sans-serif</xsl:when>
		<xsl:when test="$sFontID='robotolight'">robotolight, Arial, Helvetica, sans-serif</xsl:when>
		<xsl:when test="$sFontID='robotomedium'">robotomedium, Arial, Helvetica, sans-serif</xsl:when>
		<xsl:when test="$sFontID='robotoregular'">robotoregular, Arial, Helvetica, sans-serif</xsl:when>
		<xsl:when test="$sFontID='robotothin'">robotothin, Arial, Helvetica, sans-serif</xsl:when>
		<xsl:when test="$sFontID='roboto_slablight'">roboto_slablight, Georgia, serif</xsl:when>
		<xsl:when test="$sFontID='roboto_slabregular'">roboto_slabregular, Georgia, serif</xsl:when>
		<xsl:when test="$sFontID='roboto_slabthin'">roboto_slabthin, Georgia, serif</xsl:when>
		<xsl:otherwise>robotoregular, Arial, Helvetica, sans-serif</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<xsl:template name="fix-color">
	<xsl:param name="color"/>
	<xsl:choose>
		<xsl:when test="substring($color, 1, 1)='#'">
			<xsl:choose>
				<xsl:when test="string-length($color)=7"><xsl:value-of select="$color"/></xsl:when>
				<xsl:when test="string-length($color)=4">#<xsl:value-of select="substring($color, 2, 1)"/><xsl:value-of select="substring($color, 2, 1)"/><xsl:value-of select="substring($color, 3, 1)"/><xsl:value-of select="substring($color, 3, 1)"/><xsl:value-of select="substring($color, 4, 1)"/><xsl:value-of select="substring($color, 4, 1)"/></xsl:when>
				<xsl:otherwise>transparent</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>transparent</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--
	COLOR CONVERSION START
	Templates:
		hex2rgb (hexcolor: 7-character hex color value, starts with #) = 7-character hex color value, starts with #, returns comma-separated values r,g,b
		autogradient (color.base: 7-character hex color value, starts with #) = 7-character hex color value, starts with #
		lighten (color.base: 7-character hex color value, starts with #, ratio - 0-1 - darken, 1+ - lighten) = 7-character hex color value, starts with #
		getcolor (color.base: 7-character hex color value, starts with #, color.base.type - string [color1|color2], color.target.type - string [color1|color2|color3|color4\stroke|font]) = 7-character hex color value, starts with #
		hex2todec (hex2: 2-character hex value) = integer decimal value
		hex1todec (hex: 1-character hex value) = integer decimal value
		dectohex2 (dec2: 0-255 decimal value) = 2-character hex value
		dectohex1 (dec: 0-15 decimal value) = 1-character hex value
		hue (hexcolor: 7-character hex color value, starts with #) = 0-360 degrees integer decimal hue value
		saturation (hexcolor: 7-character hex color value, starts with #) = 0-100 percents integer decimal saturation value
		brightness (hexcolor: 7-character hex color value, starts with #) = 0-100 percents integer decimal brightness value
		inverted (hexcolor: 7-character hex color value, starts with #) = 7-character hex color value, starts with #
		max (C1,C2,C3: decimal values) = maximal from these 3 values
		min (C1,C2,C3: decimal values) = minimal from these 3 values
		RGBtoHex (R,G,B: decimal 0-255 color values) = 7-character hex color value, starts with #
		HSBtoHex (H: 0-360 degrees integer decimal hue value,S,B: decimal 0-100 percent saturation and brightness values) = 7-character hex color value, starts with #
-->
	<xsl:template match="*" name="hex2rgb">
		<xsl:param name="hexcolor"/>
		<xsl:variable name="rhex" select="substring($hexcolor, 2, 2)"/>
		<xsl:variable name="ghex" select="substring($hexcolor, 4, 2)"/>
		<xsl:variable name="bhex" select="substring($hexcolor, 6, 2)"/>
		<xsl:variable name="rdec">
			<xsl:call-template name="hex2todec">
				<xsl:with-param name="hex2" select="$rhex"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="gdec">
			<xsl:call-template name="hex2todec">
				<xsl:with-param name="hex2" select="$ghex"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="bdec">
			<xsl:call-template name="hex2todec">
				<xsl:with-param name="hex2" select="$bhex"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$rdec"/>,<xsl:value-of select="$gdec"/>,<xsl:value-of select="$bdec"/>
	</xsl:template>
	<xsl:template match="*" name="autogradient">

		<xsl:param name="color.base"/>
		<xsl:variable name="ratio">2</xsl:variable>
		<xsl:variable name="base.H">
			<xsl:call-template name="hue">
				<xsl:with-param name="hexcolor" select="$color.base"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="base.S">
			<xsl:call-template name="saturation">
				<xsl:with-param name="hexcolor" select="$color.base"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="base.B">
			<xsl:call-template name="brightness">
				<xsl:with-param name="hexcolor" select="$color.base"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="target.B">
			<xsl:choose>
				<xsl:when test="(number($base.B)*number($ratio)) &gt; 100">100</xsl:when>
				<xsl:otherwise><xsl:value-of select="round(number($base.B)*number($ratio))"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="target.S">
			<xsl:choose>
				<xsl:when test="number($target.B)=100"><xsl:value-of select="0.35*number($base.S)"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="0.5*number($base.S)"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="HSBtoHex">
			<xsl:with-param name="H" select="$base.H"/>
			<xsl:with-param name="S" select="$target.S"/>
			<xsl:with-param name="B" select="$target.B"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="*" name="lighten">

		<xsl:param name="color.base"/>
		<xsl:param name="ratio"/>
		<xsl:variable name="base.H">
			<xsl:call-template name="hue">
				<xsl:with-param name="hexcolor" select="$color.base"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="base.S">
			<xsl:call-template name="saturation">
				<xsl:with-param name="hexcolor" select="$color.base"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="base.B">
			<xsl:call-template name="brightness">
				<xsl:with-param name="hexcolor" select="$color.base"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="target.B">
			<xsl:choose>
				<xsl:when test="(number($base.B)*number($ratio)) &gt; 100">100</xsl:when>
				<xsl:otherwise><xsl:value-of select="round(number($base.B)*number($ratio))"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="HSBtoHex">
			<xsl:with-param name="H" select="$base.H"/>
			<xsl:with-param name="S" select="$base.S"/>
			<xsl:with-param name="B" select="$target.B"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="*" name="getcolor">

		<xsl:param name="color.base"/>
		<xsl:param name="color.base.type"/>
		<xsl:param name="color.target.type"/>

		<xsl:variable name="base.H">
			<xsl:call-template name="hue">
				<xsl:with-param name="hexcolor" select="$color.base"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="base.S">
			<xsl:call-template name="saturation">
				<xsl:with-param name="hexcolor" select="$color.base"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="base.B">
			<xsl:call-template name="brightness">
				<xsl:with-param name="hexcolor" select="$color.base"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="target.H" select="$base.H"/>
		<xsl:variable name="target.S">
			<xsl:choose>
				<xsl:when test="$color.base.type='color1'">
					<xsl:choose>
						<xsl:when test="$color.target.type='color2'"><xsl:value-of select="round(0.35*number($base.S))"/></xsl:when>
						<xsl:when test="$color.target.type='color3'"><xsl:value-of select="round(0.67 * number($base.S))"/></xsl:when>
						<xsl:when test="$color.target.type='color4'"><xsl:value-of select="round(0.56 * number($base.S))"/></xsl:when>
						<xsl:when test="$color.target.type='stroke' or $color.target.type='font'">
							<xsl:choose>
								<xsl:when test="round(1.2*number($base.S)) &gt; 100">100</xsl:when>
								<xsl:otherwise><xsl:value-of select="round(1.2*number($base.S))"/></xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise><xsl:value-of select="$base.S"/></xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$color.base.type='color2'">
					<xsl:choose>
						<xsl:when test="$color.target.type='color1'">
							<xsl:choose>
								<xsl:when test="(2.8*number($base.S)) &gt; 100">100</xsl:when>
								<xsl:otherwise><xsl:value-of select="round(2.8*number($base.S))"/></xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$color.target.type='color3'">
							<xsl:choose>
								<xsl:when test="(1.56*number($base.S)) &gt; 100">100</xsl:when>
								<xsl:otherwise><xsl:value-of select="round(1.56 * number($base.S))"/></xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$color.target.type='color4'">
							<xsl:choose>
								<xsl:when test="(1.88*number($base.S)) &gt; 100">100</xsl:when>
								<xsl:otherwise><xsl:value-of select="round(1.88 * number($base.S))"/></xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$color.target.type='stroke'">
							<xsl:choose>
								<xsl:when test="round(3.38*number($base.S)) &gt; 100">100</xsl:when>
								<xsl:otherwise><xsl:value-of select="round(3.38*number($base.S))"/></xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$color.target.type='font'">
							<xsl:choose>
								<xsl:when test="round(3.38*number($base.S)) &gt; 100">100</xsl:when>
								<xsl:otherwise><xsl:value-of select="round(3.38*number($base.S))"/></xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise><xsl:value-of select="$base.S"/></xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$base.S"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="target.B">
			<xsl:choose>
				<xsl:when test="$color.base.type='color1'">
					<xsl:choose>
						<xsl:when test="$color.target.type='color2'">
							<xsl:choose>
								<xsl:when test="number($base.B) &lt; 70">
									<xsl:choose>
										<xsl:when test="(number($base.B)*1.4) &gt; 100">100</xsl:when>
										<xsl:otherwise><xsl:value-of select="round(number($base.B)*1.4)"/></xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="(number($base.B)*1.2) &gt; 100">100</xsl:when>
										<xsl:otherwise><xsl:value-of select="round(number($base.B)*1.2)"/></xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$color.target.type='color3'">
							<xsl:choose>
								<xsl:when test="(number($base.B)*1.09) &gt; 100">100</xsl:when>
								<xsl:otherwise><xsl:value-of select="round(number($base.B)*1.08)"/></xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$color.target.type='color4'">
							<xsl:choose>
								<xsl:when test="(number($base.B)*1.13) &gt; 100">100</xsl:when>
								<xsl:otherwise><xsl:value-of select="round(number($base.B)*1.13)"/></xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$color.target.type='stroke'"><xsl:value-of select="round(0.75*number($base.B))"/></xsl:when>
						<xsl:when test="$color.target.type='font'"><xsl:value-of select="round(0.5*number($base.B))"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$base.B"/></xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$color.base.type='color2'">
					<xsl:choose>
						<xsl:when test="$color.target.type='color1'"><xsl:value-of select="round(0.83*number($base.B))"/></xsl:when>
						<xsl:when test="$color.target.type='color3'"><xsl:value-of select="round(0.91*number($base.B))"/></xsl:when>
						<xsl:when test="$color.target.type='color4'"><xsl:value-of select="round(0.94*number($base.B))"/></xsl:when>
						<xsl:when test="$color.target.type='stroke'"><xsl:value-of select="round(0.62*number($base.B))"/></xsl:when>
						<xsl:when test="$color.target.type='font'"><xsl:value-of select="round(0.53*number($base.B))"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$base.B"/></xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$base.B"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="HSBtoHex">
			<xsl:with-param name="H" select="$target.H"/>
			<xsl:with-param name="S" select="$target.S"/>
			<xsl:with-param name="B" select="$target.B"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="*" name="hex2todec">
		<xsl:param name="hex2"/>
		<xsl:variable name="d1">
			<xsl:call-template name="hex1todec">
				<xsl:with-param name="hex" select="substring(string($hex2), 1, 1)"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="d2">
			<xsl:call-template name="hex1todec">
				<xsl:with-param name="hex" select="substring(string($hex2), 2, 1)"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="number($d1)*16 + number($d2)"/>
	</xsl:template>
	<xsl:template match="*" name="hex1todec">
		<xsl:param name="hex"/>
		<xsl:choose>
			<xsl:when test="$hex='A' or $hex='a'">10</xsl:when>
			<xsl:when test="$hex='B' or $hex='b'">11</xsl:when>
			<xsl:when test="$hex='C' or $hex='c'">12</xsl:when>
			<xsl:when test="$hex='D' or $hex='d'">13</xsl:when>
			<xsl:when test="$hex='E' or $hex='e'">14</xsl:when>
			<xsl:when test="$hex='F' or $hex='f'">15</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="string(number($hex))='NaN'">0</xsl:when>
					<xsl:otherwise><xsl:value-of select="$hex"/></xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="*" name="dectohex2">
		<xsl:param name="dec2"/>
		<xsl:variable name="d1" select="floor(number($dec2) div 16)"/>
		<xsl:variable name="d2" select="number($dec2) - (number($d1)*16)"/>
		<xsl:variable name="h1">
			<xsl:call-template name="dectohex1">
				<xsl:with-param name="dec" select="$d1"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="h2">
			<xsl:call-template name="dectohex1">
				<xsl:with-param name="dec" select="$d2"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="concat(string($h1), string($h2))"/>
	</xsl:template>
	<xsl:template match="*" name="dectohex1">
		<xsl:param name="dec"/>
		<xsl:choose>
			<xsl:when test="number($dec)=10">A</xsl:when>
			<xsl:when test="number($dec)=11">B</xsl:when>
			<xsl:when test="number($dec)=12">C</xsl:when>
			<xsl:when test="number($dec)=13">D</xsl:when>
			<xsl:when test="number($dec)=14">E</xsl:when>
			<xsl:when test="number($dec)=15">F</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="string(number($dec))='NaN'">0</xsl:when>
					<xsl:otherwise><xsl:value-of select="$dec"/></xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="*" name="hue">
		<xsl:param name="hexcolor"/>
		<xsl:choose>
			<xsl:when test="string-length($hexcolor)=7">
				<xsl:choose>
					<xsl:when test="substring($hexcolor, 1, 1)='#'">
						<xsl:variable name="rhex" select="substring($hexcolor, 2, 2)"/>
						<xsl:variable name="ghex" select="substring($hexcolor, 4, 2)"/>
						<xsl:variable name="bhex" select="substring($hexcolor, 6, 2)"/>
						<xsl:variable name="rdec">
							<xsl:call-template name="hex2todec">
								<xsl:with-param name="hex2" select="$rhex"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="gdec">
							<xsl:call-template name="hex2todec">
								<xsl:with-param name="hex2" select="$ghex"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="bdec">
							<xsl:call-template name="hex2todec">
								<xsl:with-param name="hex2" select="$bhex"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="Rn" select="number($rdec) div 255"/>
						<xsl:variable name="Gn" select="number($gdec) div 255"/>
						<xsl:variable name="Bn" select="number($bdec) div 255"/>
						<xsl:variable name="Cmax">
							<xsl:call-template name="max">
								<xsl:with-param name="C1" select="$Rn"/>
								<xsl:with-param name="C2" select="$Gn"/>
								<xsl:with-param name="C3" select="$Bn"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="Cmin">
							<xsl:call-template name="min">
								<xsl:with-param name="C1" select="$Rn"/>
								<xsl:with-param name="C2" select="$Gn"/>
								<xsl:with-param name="C3" select="$Bn"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="Cdif" select="number($Cmax) - number($Cmin)"/>
						<xsl:choose>
							<xsl:when test="$Cdif='0'">0</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="(number($Cmax)=number($Rn)) and (number($Gn) &gt;= number($Bn))">
										<xsl:value-of select="round(60 * (number($Gn) - number($Bn)) div number($Cdif))"/>
									</xsl:when>
									<xsl:when test="(number($Cmax)=number($Rn)) and (number($Gn) &lt; number($Bn))">
										<xsl:value-of select="round(60 * (number($Gn) - number($Bn)) div number($Cdif)) + 360"/>
									</xsl:when>
									<xsl:when test="number($Cmax)=number($Gn)">
										<xsl:value-of select="round(60 * (number($Bn) - number($Rn)) div number($Cdif)) + 120"/>
									</xsl:when>
									<xsl:when test="number($Cmax)=number($Bn)">
										<xsl:value-of select="round(60 * (number($Rn) - number($Gn)) div number($Cdif)) + 240"/>
									</xsl:when>
									<xsl:otherwise>0</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="*" name="saturation">
		<xsl:param name="hexcolor"/>
		<xsl:choose>
			<xsl:when test="string-length($hexcolor)=7">
				<xsl:choose>
					<xsl:when test="substring($hexcolor, 1, 1)='#'">
						<xsl:variable name="rhex" select="substring($hexcolor, 2, 2)"/>
						<xsl:variable name="ghex" select="substring($hexcolor, 4, 2)"/>
						<xsl:variable name="bhex" select="substring($hexcolor, 6, 2)"/>
						<xsl:variable name="rdec">
							<xsl:call-template name="hex2todec">
								<xsl:with-param name="hex2" select="$rhex"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="gdec">
							<xsl:call-template name="hex2todec">
								<xsl:with-param name="hex2" select="$ghex"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="bdec">
							<xsl:call-template name="hex2todec">
								<xsl:with-param name="hex2" select="$bhex"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="Rn" select="number($rdec) div 255"/>
						<xsl:variable name="Gn" select="number($gdec) div 255"/>
						<xsl:variable name="Bn" select="number($bdec) div 255"/>
						<xsl:variable name="Cmax">
							<xsl:call-template name="max">
								<xsl:with-param name="C1" select="$Rn"/>
								<xsl:with-param name="C2" select="$Gn"/>
								<xsl:with-param name="C3" select="$Bn"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="Cmin">
							<xsl:call-template name="min">
								<xsl:with-param name="C1" select="$Rn"/>
								<xsl:with-param name="C2" select="$Gn"/>
								<xsl:with-param name="C3" select="$Bn"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="(number($Cmax) - number($Cmin))=0">0</xsl:when>
							<xsl:otherwise><xsl:value-of select="round(100*(1 - (number($Cmin) div number($Cmax))))"/></xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="*" name="brightness">
		<xsl:param name="hexcolor"/>
		<xsl:choose>
			<xsl:when test="string-length($hexcolor)=7">
				<xsl:choose>
					<xsl:when test="substring($hexcolor, 1, 1)='#'">
						<xsl:variable name="rhex" select="substring($hexcolor, 2, 2)"/>
						<xsl:variable name="ghex" select="substring($hexcolor, 4, 2)"/>
						<xsl:variable name="bhex" select="substring($hexcolor, 6, 2)"/>
						<xsl:variable name="rdec">
							<xsl:call-template name="hex2todec">
								<xsl:with-param name="hex2" select="$rhex"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="gdec">
							<xsl:call-template name="hex2todec">
								<xsl:with-param name="hex2" select="$ghex"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="bdec">
							<xsl:call-template name="hex2todec">
								<xsl:with-param name="hex2" select="$bhex"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="Rn" select="number($rdec) div 255"/>
						<xsl:variable name="Gn" select="number($gdec) div 255"/>
						<xsl:variable name="Bn" select="number($bdec) div 255"/>
						<xsl:variable name="Cmax">
							<xsl:call-template name="max">
								<xsl:with-param name="C1" select="$Rn"/>
								<xsl:with-param name="C2" select="$Gn"/>
								<xsl:with-param name="C3" select="$Bn"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="Cmin">
							<xsl:call-template name="min">
								<xsl:with-param name="C1" select="$Rn"/>
								<xsl:with-param name="C2" select="$Gn"/>
								<xsl:with-param name="C3" select="$Bn"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:value-of select="round(100*number($Cmax))"/>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="*" name="inverted">
		<xsl:param name="hexcolor"/>
		<xsl:choose>
			<xsl:when test="string-length($hexcolor)=7">
				<xsl:choose>
					<xsl:when test="substring($hexcolor, 1, 1)='#'">
						<xsl:variable name="rhex" select="substring($hexcolor, 2, 2)"/>
						<xsl:variable name="ghex" select="substring($hexcolor, 4, 2)"/>
						<xsl:variable name="bhex" select="substring($hexcolor, 6, 2)"/>
						<xsl:variable name="rdec">
							<xsl:call-template name="hex2todec">
								<xsl:with-param name="hex2" select="$rhex"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="gdec">
							<xsl:call-template name="hex2todec">
								<xsl:with-param name="hex2" select="$ghex"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="bdec">
							<xsl:call-template name="hex2todec">
								<xsl:with-param name="hex2" select="$bhex"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:call-template name="RGBtoHex">
							<xsl:with-param name="R" select="255 - number($rdec)"/>
							<xsl:with-param name="G" select="255 - number($gdec)"/>
							<xsl:with-param name="B" select="255 - number($bdec)"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>#000000</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>#000000</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="*" name="max">
		<xsl:param name="C1"/>
		<xsl:param name="C2"/>
		<xsl:param name="C3"/>
		<xsl:choose>
			<xsl:when test="number($C1) &gt;= number($C2)">
				<xsl:choose>
					<xsl:when test="number($C1) &gt;= number($C3)"><xsl:value-of select="$C1"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$C3"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="number($C2) &gt;= number($C3)"><xsl:value-of select="$C2"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$C3"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="*" name="min">
		<xsl:param name="C1"/>
		<xsl:param name="C2"/>
		<xsl:param name="C3"/>
		<xsl:choose>
			<xsl:when test="(number($C1) &lt;= number($C2)) and (number($C1) &lt;= number($C3))"><xsl:value-of select="$C1"/></xsl:when>
			<xsl:when test="(number($C2) &lt;= number($C1)) and (number($C2) &lt;= number($C3))"><xsl:value-of select="$C2"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$C3"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="*" name="RGBtoHex">
		<xsl:param name="R"/>
		<xsl:param name="G"/>
		<xsl:param name="B"/>
		<xsl:variable name="Rhex">
			<xsl:call-template name="dectohex2">
				<xsl:with-param name="dec2" select="$R"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="Ghex">
			<xsl:call-template name="dectohex2">
				<xsl:with-param name="dec2" select="$G"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="Bhex">
			<xsl:call-template name="dectohex2">
				<xsl:with-param name="dec2" select="$B"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="concat('#',$Rhex,$Ghex,$Bhex)"/>
	</xsl:template>
	<xsl:template match="*" name="HSBtoHex">
		<xsl:param name="H"/>
		<xsl:param name="S"/>
		<xsl:param name="B"/>
		<xsl:variable name="hsector" select="floor(number($H) div 60)"/>
		<xsl:variable name="hdiff" select="(number($H) div 60) - number($hsector)"/>
		<xsl:variable name="sdec" select="number($S) div 100"/>
		<xsl:variable name="bdec" select="number($B) div 100"/>
		<xsl:variable name="c1" select="number($bdec) * (1 - number($sdec))"/>
		<xsl:variable name="c2" select="number($bdec) * (1 - (number($sdec) * number($hdiff)))"/>
		<xsl:variable name="c3" select="number($bdec) * (1 - ((1 - number($hdiff)) * number($sdec)))"/>
		<xsl:choose>
			<xsl:when test="number($hsector)=0">
				<xsl:call-template name="RGBtoHex">
					<xsl:with-param name="R" select="round(number($bdec) * 255)"/>
					<xsl:with-param name="G" select="round(number($c3) * 255)"/>
					<xsl:with-param name="B" select="round(number($c1) * 255)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="number($hsector)=1">
				<xsl:call-template name="RGBtoHex">
					<xsl:with-param name="R" select="round(number($c2) * 255)"/>
					<xsl:with-param name="G" select="round(number($bdec) * 255)"/>
					<xsl:with-param name="B" select="round(number($c1) * 255)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="number($hsector)=2">
				<xsl:call-template name="RGBtoHex">
					<xsl:with-param name="R" select="round(number($c1) * 255)"/>
					<xsl:with-param name="G" select="round(number($bdec) * 255)"/>
					<xsl:with-param name="B" select="round(number($c3) * 255)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="number($hsector)=3">
				<xsl:call-template name="RGBtoHex">
					<xsl:with-param name="R" select="round(number($c1) * 255)"/>
					<xsl:with-param name="G" select="round(number($c2) * 255)"/>
					<xsl:with-param name="B" select="round(number($bdec) * 255)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="number($hsector)=4">
				<xsl:call-template name="RGBtoHex">
					<xsl:with-param name="R" select="round(number($c3) * 255)"/>
					<xsl:with-param name="G" select="round(number($c1) * 255)"/>
					<xsl:with-param name="B" select="round(number($bdec) * 255)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="number($hsector)=5">
				<xsl:call-template name="RGBtoHex">
					<xsl:with-param name="R" select="round(number($bdec) * 255)"/>
					<xsl:with-param name="G" select="round(number($c1) * 255)"/>
					<xsl:with-param name="B" select="round(number($c2) * 255)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="RGBtoHex">
					<xsl:with-param name="R" select="round(number($bdec) * 255)"/>
					<xsl:with-param name="G" select="round(number($c3) * 255)"/>
					<xsl:with-param name="B" select="round(number($c1) * 255)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
<!--COLOR CONVERSION END-->
</xsl:stylesheet>
