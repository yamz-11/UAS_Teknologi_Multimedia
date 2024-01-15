<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 xmlns:websoft="http://www.websoft.ru"
                 version="1.0">
<xsl:output method="xml" encoding="utf-8" omit-xml-declaration="yes"/>

<xsl:param name="moduleImagesFolder"></xsl:param>
<xsl:param name="imagesFolder"></xsl:param>
<xsl:param name="objectID"></xsl:param>
<xsl:param name="width"></xsl:param>
<xsl:param name="height"></xsl:param>

<xsl:template match="/"><xsl:apply-templates select="params"/></xsl:template>

<xsl:template match="params">

	<xsl:variable name="theme">
		<xsl:choose>
			<xsl:when test="theme!=''"><xsl:value-of select="theme"/></xsl:when>
			<xsl:otherwise>light</xsl:otherwise>
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

	<xsl:variable name="style-scroll">
		<xsl:choose>
			<xsl:when test="overflow='auto'">overflow: auto;</xsl:when>
			<xsl:when test="overflow='scroll'">overflow: scroll;</xsl:when>
			<xsl:when test="overflow='scroll-y'">overflow-x: hidden; overflow-y: scroll;</xsl:when>
			<xsl:when test="overflow='scroll-x'">overflow-x: scroll; overflow-y: hidden;</xsl:when>
			<xsl:when test="overflow='hidden'">overflow: hidden;</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="style-box-shadow"><xsl:if test="$_shadow_string!=''">-moz-box-shadow: <xsl:value-of select="$_shadow_string"/>; -webkit-box-shadow: <xsl:value-of select="$_shadow_string"/>; box-shadow: <xsl:value-of select="$_shadow_string"/>;</xsl:if></xsl:variable>

	<div>
		<xsl:attribute name="class">cl-container cl-theme-<xsl:value-of select="$theme"/> unselectable</xsl:attribute>
		<xsl:choose>
			<xsl:when test="$theme='simple'">
				<xsl:variable name="bg-color-simple" select="$bg-color-fixed"/>
				<xsl:variable name="border-color-main-simple" select="$border-color-fixed"/>
				<xsl:variable name="border-color-outer-simple">
					<xsl:call-template name="getcolor">
						<xsl:with-param name="color.base" select="$border-color-main-simple"/>
						<xsl:with-param name="color.base.type">color1</xsl:with-param>
						<xsl:with-param name="color.target.type">stroke</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="border-color-inner-simple">
					<xsl:call-template name="getcolor">
						<xsl:with-param name="color.base" select="$border-color-outer-simple"/>
						<xsl:with-param name="color.base.type">color1</xsl:with-param>
						<xsl:with-param name="color.target.type">color3</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="simple-box-height" select="number($height) - 2*number(text_padding) - 8"/>
				<xsl:variable name="simple-box-min-height">
					<xsl:choose>
						<xsl:when test="number($simple-box-height) &gt; 0"><xsl:value-of select="$simple-box-height"/></xsl:when>
						<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="css-simple-cl-outer-box">width: <xsl:value-of select="number($width) - 2"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($height) - 2"/>px; </xsl:if>background-color: <xsl:value-of select="$border-color-outer-simple"/>; <xsl:value-of select="$style-box-shadow"/></xsl:variable>
				<xsl:variable name="css-simple-cl-middle-box">width: <xsl:value-of select="number($width) - 6"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($height) - 6"/>px; </xsl:if>background-color: <xsl:value-of select="$border-color-main-simple"/>;</xsl:variable>
				<xsl:variable name="css-simple-cl-inner-box">width: <xsl:value-of select="number($width) - 8"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($height) - 8"/>px; overflow: hidden; </xsl:if>background-color: <xsl:value-of select="$border-color-inner-simple"/>;</xsl:variable>
				<xsl:variable name="css-simple-cl-txt-container">width: <xsl:value-of select="number($width) - 2*number(text_padding) - 8"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="$simple-box-min-height"/>px;</xsl:if> background-color: <xsl:value-of select="$bg-color-simple"/>; padding: <xsl:value-of select="text_padding"/>px;</xsl:variable>
				<xsl:variable name="css-simple-cl-txt-box">width: <xsl:value-of select="number($width) - 2*number(text_padding) - 8"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="$simple-box-min-height"/>px; <xsl:value-of select="$style-scroll"/></xsl:if></xsl:variable>
				<xsl:variable name="css-simple-cl-txt-box-table">width: 100%; border-spacing: 0; <xsl:if test="size_to='container'">min-height: <xsl:value-of select="$simple-box-min-height"/>px;</xsl:if></xsl:variable>
				<xsl:variable name="css-simple-cl-txt-box-cell">width: 100%; padding: 0; <xsl:if test="size_to='container'">vertical-align: <xsl:value-of select="valign"/>; min-height: <xsl:value-of select="$simple-box-min-height"/>px;</xsl:if></xsl:variable>

				<div>
					<xsl:attribute name="class">cl-outer-box <xsl:if test="hide_on_click='yes'">cl-btn-close-object</xsl:if> unselectable</xsl:attribute>
					<xsl:attribute name="style"><xsl:value-of select="$css-simple-cl-outer-box"/></xsl:attribute>
					<xsl:if test="hide_on_click='yes'">
						<xsl:attribute name="title"><xsl:value-of select="close_title"/></xsl:attribute>
					</xsl:if>
					<div>
						<xsl:attribute name="class">cl-middle-box</xsl:attribute>
						<xsl:attribute name="style"><xsl:value-of select="$css-simple-cl-middle-box"/></xsl:attribute>
						<div>
							<xsl:attribute name="class">cl-inner-box</xsl:attribute>
							<xsl:attribute name="style"><xsl:value-of select="$css-simple-cl-inner-box"/></xsl:attribute>
							<div>
								<xsl:attribute name="class">cl-txt-container</xsl:attribute>
								<xsl:attribute name="style"><xsl:value-of select="$css-simple-cl-txt-container"/></xsl:attribute>
								<div>
									<xsl:attribute name="class">cl-txt-box</xsl:attribute>
									<xsl:attribute name="style"><xsl:value-of select="$css-simple-cl-txt-box"/></xsl:attribute>
									<table>
										<xsl:attribute name="class">cl-txt-box-table</xsl:attribute>
										<xsl:attribute name="style"><xsl:value-of select="$css-simple-cl-txt-box-table"/></xsl:attribute>
										<tr>
											<td>
												<xsl:attribute name="class">cl-txt-box-cell <xsl:if test="size_to='container' and valign='bottom'">cl-txt-box-cell-clipped</xsl:if></xsl:attribute>
												<xsl:attribute name="style"><xsl:value-of select="$css-simple-cl-txt-box-cell"/></xsl:attribute>
												<xsl:value-of select="text_main" disable-output-escaping="yes"/>
											</td>
										</tr>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</xsl:when>
			<xsl:when test="$theme='light'">
				<xsl:variable name="border-color-light" select="$border-color-fixed"/>
				<xsl:variable name="bg-color-light" select="$bg-color-fixed"/>

				<xsl:variable name="light-box-height" select="number($height) - 2*number(text_padding) - 10"/>
				<xsl:variable name="light-box-min-height">
					<xsl:choose>
						<xsl:when test="number($light-box-height) &gt; 0"><xsl:value-of select="$light-box-height"/></xsl:when>
						<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="css-light-cl-outer-box">width: <xsl:value-of select="number($width) - 2"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($height) - 2"/>px; </xsl:if>background-color: <xsl:value-of select="$bg-color-light"/>; border-color: <xsl:value-of select="$border-color-light"/>; -moz-border-radius: 5px; -webkit-border-radius: 5px; border-radius: 5px; <xsl:value-of select="$style-box-shadow"/></xsl:variable>
				<xsl:variable name="css-light-cl-inner-box">width: <xsl:value-of select="number($width) - 10"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($height) - 10"/>px; overflow: hidden;</xsl:if> padding: 4px; -moz-border-radius: 4px; -webkit-border-radius: 4px; border-radius: 4px;</xsl:variable>
				<xsl:variable name="css-light-cl-txt-container">width: <xsl:value-of select="number($width) - 2*number(text_padding) - 10"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="$light-box-min-height"/>px;</xsl:if> padding: <xsl:value-of select="text_padding"/>px;</xsl:variable>
				<xsl:variable name="css-light-cl-txt-box">width: <xsl:value-of select="number($width) - 2*number(text_padding) - 10"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="$light-box-min-height"/>px; <xsl:value-of select="$style-scroll"/></xsl:if></xsl:variable>
				<xsl:variable name="css-light-cl-txt-box-table">width: 100%; border-spacing: 0; <xsl:if test="size_to='container'">min-height: <xsl:value-of select="$light-box-min-height"/>px;</xsl:if></xsl:variable>
				<xsl:variable name="css-light-cl-txt-box-cell">width: 100%; padding: 0; <xsl:if test="size_to='container'">vertical-align: <xsl:value-of select="valign"/>; min-height: <xsl:value-of select="$light-box-min-height"/>px;</xsl:if></xsl:variable>

				<div>
					<xsl:attribute name="class">cl-outer-box <xsl:if test="hide_on_click='yes'">cl-btn-close-object</xsl:if> unselectable</xsl:attribute>
					<xsl:attribute name="style"><xsl:value-of select="$css-light-cl-outer-box"/></xsl:attribute>
					<xsl:if test="hide_on_click='yes'">
						<xsl:attribute name="title"><xsl:value-of select="close_title"/></xsl:attribute>
					</xsl:if>
					<div>
						<xsl:attribute name="class">cl-inner-box</xsl:attribute>
						<xsl:attribute name="style"><xsl:value-of select="$css-light-cl-inner-box"/></xsl:attribute>
						<div>
							<xsl:attribute name="class">cl-txt-container</xsl:attribute>
							<xsl:attribute name="style"><xsl:value-of select="$css-light-cl-txt-container"/></xsl:attribute>
							<div>
								<xsl:attribute name="class">cl-txt-box</xsl:attribute>
								<xsl:attribute name="style"><xsl:value-of select="$css-light-cl-txt-box"/></xsl:attribute>
								<table>
									<xsl:attribute name="class">cl-txt-box-table</xsl:attribute>
									<xsl:attribute name="style"><xsl:value-of select="$css-light-cl-txt-box-table"/></xsl:attribute>
									<tr>
										<td>
											<xsl:attribute name="class">cl-txt-box-cell <xsl:if test="size_to='container' and valign='bottom'">cl-txt-box-cell-clipped</xsl:if></xsl:attribute>
											<xsl:attribute name="style"><xsl:value-of select="$css-light-cl-txt-box-cell"/></xsl:attribute>
											<xsl:value-of select="text_main" disable-output-escaping="yes"/>
										</td>
									</tr>
								</table>
							</div>
						</div>
					</div>
				</div>
			</xsl:when>
			<xsl:when test="$theme='standard'">
				<xsl:variable name="border-color-standard" select="$border-color-fixed"/>
				<xsl:variable name="bg-color-standard" select="$bg-color-fixed"/>

				<xsl:variable name="standard-box-height" select="number($height) - 2*number(text_padding) - 20"/>
				<xsl:variable name="standard-box-min-height">
					<xsl:choose>
						<xsl:when test="number($standard-box-height) &gt; 0"><xsl:value-of select="$standard-box-height"/></xsl:when>
						<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="css-standard-cl-outer-box">width: <xsl:value-of select="number($width) - 4"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($height) - 4"/>px; </xsl:if>background-color: <xsl:value-of select="$bg-color-standard"/>; border-color: <xsl:value-of select="$border-color-standard"/>; -moz-border-radius: 10px; -webkit-border-radius: 10px; border-radius: 10px; <xsl:value-of select="$style-box-shadow"/></xsl:variable>
				<xsl:variable name="css-standard-cl-inner-box">width: <xsl:value-of select="number($width) - 4"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($height) - 4"/>px; overflow: hidden;</xsl:if> -moz-border-radius: 8px; -webkit-border-radius: 8px; border-radius: 8px;</xsl:variable>
				<xsl:variable name="css-standard-cl-txt-container">width: <xsl:value-of select="number($width) - 2*number(text_padding) - 20"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="$standard-box-min-height"/>px;</xsl:if> padding: <xsl:value-of select="number(text_padding) + 8"/>px;</xsl:variable>
				<xsl:variable name="css-standard-cl-txt-box">width: <xsl:value-of select="number($width) - 2*number(text_padding) - 20"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="$standard-box-min-height"/>px; <xsl:value-of select="$style-scroll"/></xsl:if></xsl:variable>
				<xsl:variable name="css-standard-cl-txt-box-table">width: 100%; border-spacing: 0; <xsl:if test="size_to='container'">min-height: <xsl:value-of select="$standard-box-min-height"/>px;</xsl:if></xsl:variable>
				<xsl:variable name="css-standard-cl-txt-box-cell">width: 100%; padding: 0; <xsl:if test="size_to='container'">vertical-align: <xsl:value-of select="valign"/>; min-height: <xsl:value-of select="$standard-box-min-height"/>px;</xsl:if></xsl:variable>

				<div>
					<xsl:attribute name="class">cl-outer-box <xsl:if test="hide_on_click='yes'">cl-btn-close-object</xsl:if> unselectable</xsl:attribute>
					<xsl:attribute name="style"><xsl:value-of select="$css-standard-cl-outer-box"/></xsl:attribute>
					<xsl:if test="hide_on_click='yes'">
						<xsl:attribute name="title"><xsl:value-of select="close_title"/></xsl:attribute>
					</xsl:if>
					<div>
						<xsl:attribute name="class">cl-inner-box</xsl:attribute>
						<xsl:attribute name="style"><xsl:value-of select="$css-standard-cl-inner-box"/></xsl:attribute>
						<div>
							<xsl:attribute name="class">cl-txt-container</xsl:attribute>
							<xsl:attribute name="style"><xsl:value-of select="$css-standard-cl-txt-container"/></xsl:attribute>
							<div>
								<xsl:attribute name="class">cl-txt-box</xsl:attribute>
								<xsl:attribute name="style"><xsl:value-of select="$css-standard-cl-txt-box"/></xsl:attribute>
								<table>
									<xsl:attribute name="class">cl-txt-box-table</xsl:attribute>
									<xsl:attribute name="style"><xsl:value-of select="$css-standard-cl-txt-box-table"/></xsl:attribute>
									<tr>
										<td>
											<xsl:attribute name="class">cl-txt-box-cell <xsl:if test="size_to='container' and valign='bottom'">cl-txt-box-cell-clipped</xsl:if></xsl:attribute>
											<xsl:attribute name="style"><xsl:value-of select="$css-standard-cl-txt-box-cell"/></xsl:attribute>
											<xsl:value-of select="text_main" disable-output-escaping="yes"/>
										</td>
									</tr>
								</table>
							</div>
						</div>
					</div>
				</div>
			</xsl:when>
			<xsl:when test="$theme='curve'">
				<xsl:variable name="bg-color-curve" select="$bg-color-fixed"/>
				<xsl:variable name="border-color-curve" select="$border-color-fixed"/>
				<xsl:variable name="shape.0.radius">23</xsl:variable>
				<xsl:variable name="box-height" select="number($height) - 2*number(text_padding) - 46"/>
				<xsl:variable name="box-min-height">
					<xsl:choose>
						<xsl:when test="number($box-height) &gt; 0"><xsl:value-of select="$box-height"/></xsl:when>
						<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="curve-box-height" select="number($height) - 2*number(text_padding) - 46"/>
				<xsl:variable name="curve-box-min-height">
					<xsl:choose>
						<xsl:when test="number($curve-box-height) &gt; 0"><xsl:value-of select="$curve-box-height"/></xsl:when>
						<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="css-curve-cl-outer-box">width: <xsl:value-of select="$width"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="$height"/>px; </xsl:if> -moz-border-radius: <xsl:value-of select="$shape.0.radius"/>px; -webkit-border-radius: <xsl:value-of select="$shape.0.radius"/>px; border-radius: <xsl:value-of select="$shape.0.radius"/>px; <xsl:value-of select="$style-box-shadow"/></xsl:variable>
				<xsl:variable name="css-curve-cl-inner-box">width: <xsl:value-of select="number($width) - 16"/>px; padding: 8px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($height) - 16"/>px; overflow: hidden;</xsl:if> background-color: <xsl:value-of select="$bg-color-curve"/>; -moz-border-radius: <xsl:value-of select="$shape.0.radius"/>px; -webkit-border-radius: <xsl:value-of select="$shape.0.radius"/>px; border-radius: <xsl:value-of select="$shape.0.radius"/>px; -moz-box-shadow: inset 8px 8px 8px rgba(255,255,255,0.3), inset -8px -8px 8px rgba(0,0,0,0.2); -moz-box-shadow: inset 8px 8px 8px rgba(255,255,255,0.3), inset -8px -8px 8px rgba(0,0,0,0.2); box-shadow: inset 8px 8px 8px rgba(255,255,255,0.3), inset -8px -8px 8px rgba(0,0,0,0.2);</xsl:variable>
				<xsl:variable name="css-curve-cl-txt-container">width: <xsl:value-of select="number($width) - 2*number(text_padding) - 46"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="$curve-box-min-height"/>px;</xsl:if> padding: <xsl:value-of select="number(text_padding) + 16"/>px;</xsl:variable>
				<xsl:variable name="css-curve-cl-txt-box">width: <xsl:value-of select="number($width) - 2*number(text_padding) - 46"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="$curve-box-min-height"/>px; <xsl:value-of select="$style-scroll"/></xsl:if></xsl:variable>
				<xsl:variable name="css-curve-cl-txt-box-table">width: 100%; border-spacing: 0; <xsl:if test="size_to='container'">min-height: <xsl:value-of select="$curve-box-min-height"/>px;</xsl:if></xsl:variable>
				<xsl:variable name="css-curve-cl-txt-box-cell">width: 100%; padding: 0; <xsl:if test="size_to='container'">vertical-align: <xsl:value-of select="valign"/>; min-height: <xsl:value-of select="$curve-box-min-height"/>px;</xsl:if></xsl:variable>

				<div>
					<xsl:attribute name="class">cl-outer-box <xsl:if test="close_by='click'">cl-btn-close-object</xsl:if> unselectable</xsl:attribute>
					<xsl:attribute name="style"><xsl:value-of select="$css-curve-cl-outer-box"/></xsl:attribute>
					<xsl:if test="hide_on_click='yes'">
						<xsl:attribute name="title"><xsl:value-of select="close_title"/></xsl:attribute>
					</xsl:if>
					<div>
						<xsl:attribute name="class">cl-inner-box</xsl:attribute>
						<xsl:attribute name="style"><xsl:value-of select="$css-curve-cl-inner-box"/></xsl:attribute>
						<div>
							<xsl:attribute name="class">cl-txt-container</xsl:attribute>
							<xsl:attribute name="style"><xsl:value-of select="$css-curve-cl-txt-container"/></xsl:attribute>
							<div>
								<xsl:attribute name="class">cl-txt-box</xsl:attribute>
								<xsl:attribute name="style"><xsl:value-of select="$css-curve-cl-txt-box"/></xsl:attribute>
								<table>
									<xsl:attribute name="class">cl-txt-box-table</xsl:attribute>
									<xsl:attribute name="style"><xsl:value-of select="$css-curve-cl-txt-box-table"/></xsl:attribute>
									<tr>
										<td>
											<xsl:attribute name="class">cl-txt-box-cell <xsl:if test="size_to='container' and valign='bottom'">cl-txt-box-cell-clipped</xsl:if></xsl:attribute>
											<xsl:attribute name="style"><xsl:value-of select="$css-curve-cl-txt-box-cell"/></xsl:attribute>
											<xsl:value-of select="text_main" disable-output-escaping="yes"/>
										</td>
									</tr>
								</table>
							</div>
						</div>
					</div>
				</div>
			</xsl:when>
			<xsl:when test="$theme='gradient'">
				<xsl:variable name="bg-color-gradient" select="$bg-color-fixed"/>
				<xsl:variable name="border-color-gradient" select="$border-color-fixed"/>
				<xsl:variable name="grad.color.1"><xsl:value-of select="$bg-color-gradient"/></xsl:variable>
				<xsl:variable name="color.h">
					<xsl:call-template name="hue">
						<xsl:with-param name="hexcolor" select="$grad.color.1"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="color.s">
					<xsl:call-template name="saturation">
						<xsl:with-param name="hexcolor" select="$grad.color.1"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="color.b">
					<xsl:call-template name="brightness">
						<xsl:with-param name="hexcolor" select="$grad.color.1"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="s.2">
					<xsl:choose>
						<xsl:when test="(number($color.s) - 1) &gt; 5"><xsl:value-of select="number($color.s) - 1"/></xsl:when>
						<xsl:otherwise>5</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="b.2">
					<xsl:choose>
						<xsl:when test="(number($color.b) + 1) &lt; 100"><xsl:value-of select="number($color.b) + 1"/></xsl:when>
						<xsl:otherwise>100</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="grad.color.2">
					<xsl:call-template name="HSBtoHex">
						<xsl:with-param name="H" select="$color.h"/>
						<xsl:with-param name="S" select="$s.2"/>
						<xsl:with-param name="B" select="$b.2"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="s.3">
					<xsl:choose>
						<xsl:when test="(number($color.s) - 2) &gt; 5"><xsl:value-of select="number($color.s) - 2"/></xsl:when>
						<xsl:otherwise>5</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="b.3">
					<xsl:choose>
						<xsl:when test="(number($color.b) + 2) &lt; 100"><xsl:value-of select="number($color.b) + 2"/></xsl:when>
						<xsl:otherwise>100</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="grad.color.3">
					<xsl:call-template name="HSBtoHex">
						<xsl:with-param name="H" select="$color.h"/>
						<xsl:with-param name="S" select="$s.3"/>
						<xsl:with-param name="B" select="$b.3"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="s.4">
					<xsl:choose>
						<xsl:when test="(number($color.s) - 3) &gt; 5"><xsl:value-of select="number($color.s) - 3"/></xsl:when>
						<xsl:otherwise>5</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="b.4">
					<xsl:choose>
						<xsl:when test="(number($color.b) + 3) &lt; 100"><xsl:value-of select="number($color.b) + 3"/></xsl:when>
						<xsl:otherwise>100</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="grad.color.4">
					<xsl:call-template name="HSBtoHex">
						<xsl:with-param name="H" select="$color.h"/>
						<xsl:with-param name="S" select="$s.4"/>
						<xsl:with-param name="B" select="$b.4"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="s.5">
					<xsl:choose>
						<xsl:when test="(number($color.s) - 4) &gt; 5"><xsl:value-of select="number($color.s) - 4"/></xsl:when>
						<xsl:otherwise>5</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="b.5">
					<xsl:choose>
						<xsl:when test="(number($color.b) + 4) &lt; 100"><xsl:value-of select="number($color.b) + 4"/></xsl:when>
						<xsl:otherwise>100</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="grad.color.5">
					<xsl:call-template name="HSBtoHex">
						<xsl:with-param name="H" select="$color.h"/>
						<xsl:with-param name="S" select="$s.5"/>
						<xsl:with-param name="B" select="$b.5"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="s.6">
					<xsl:choose>
						<xsl:when test="(number($color.s) - 5) &gt; 5"><xsl:value-of select="number($color.s) - 5"/></xsl:when>
						<xsl:otherwise>5</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="b.6">
					<xsl:choose>
						<xsl:when test="(number($color.b) + 5) &lt; 100"><xsl:value-of select="number($color.b) + 5"/></xsl:when>
						<xsl:otherwise>100</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="grad.color.6">
					<xsl:call-template name="HSBtoHex">
						<xsl:with-param name="H" select="$color.h"/>
						<xsl:with-param name="S" select="$s.6"/>
						<xsl:with-param name="B" select="$b.6"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="s.7">
					<xsl:choose>
						<xsl:when test="(number($color.s) - 6) &gt; 5"><xsl:value-of select="number($color.s) - 6"/></xsl:when>
						<xsl:otherwise>5</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="b.7">
					<xsl:choose>
						<xsl:when test="(number($color.b) + 6) &lt; 100"><xsl:value-of select="number($color.b) + 6"/></xsl:when>
						<xsl:otherwise>100</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="grad.color.7">
					<xsl:call-template name="HSBtoHex">
						<xsl:with-param name="H" select="$color.h"/>
						<xsl:with-param name="S" select="$s.7"/>
						<xsl:with-param name="B" select="$b.7"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="s.8">
					<xsl:choose>
						<xsl:when test="(number($color.s) - 8) &gt; 5"><xsl:value-of select="number($color.s) - 8"/></xsl:when>
						<xsl:otherwise>5</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="b.8">
					<xsl:choose>
						<xsl:when test="(number($color.b) + 7) &lt; 100"><xsl:value-of select="number($color.b) + 7"/></xsl:when>
						<xsl:otherwise>100</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="grad.color.8">
					<xsl:call-template name="HSBtoHex">
						<xsl:with-param name="H" select="$color.h"/>
						<xsl:with-param name="S" select="$s.8"/>
						<xsl:with-param name="B" select="$b.8"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="s.9">
					<xsl:choose>
						<xsl:when test="(number($color.s) - 10) &gt; 5"><xsl:value-of select="number($color.s) - 10"/></xsl:when>
						<xsl:otherwise>5</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="b.9">
					<xsl:choose>
						<xsl:when test="(number($color.b) + 8) &lt; 100"><xsl:value-of select="number($color.b) + 8"/></xsl:when>
						<xsl:otherwise>100</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="grad.color.9">
					<xsl:call-template name="HSBtoHex">
						<xsl:with-param name="H" select="$color.h"/>
						<xsl:with-param name="S" select="$s.9"/>
						<xsl:with-param name="B" select="$b.9"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="s.10">
					<xsl:choose>
						<xsl:when test="(number($color.s) - 12) &gt; 5"><xsl:value-of select="number($color.s) - 12"/></xsl:when>
						<xsl:otherwise>5</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="b.10">
					<xsl:choose>
						<xsl:when test="(number($color.b) + 9) &lt; 100"><xsl:value-of select="number($color.b) + 9"/></xsl:when>
						<xsl:otherwise>100</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="grad.color.10">
					<xsl:call-template name="HSBtoHex">
						<xsl:with-param name="H" select="$color.h"/>
						<xsl:with-param name="S" select="$s.10"/>
						<xsl:with-param name="B" select="$b.10"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="s.11">
					<xsl:choose>
						<xsl:when test="(number($color.s) - 14) &gt; 5"><xsl:value-of select="number($color.s) - 14"/></xsl:when>
						<xsl:otherwise>5</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="b.11">
					<xsl:choose>
						<xsl:when test="(number($color.b) + 10) &lt; 100"><xsl:value-of select="number($color.b) + 10"/></xsl:when>
						<xsl:otherwise>100</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="grad.color.11">
					<xsl:call-template name="HSBtoHex">
						<xsl:with-param name="H" select="$color.h"/>
						<xsl:with-param name="S" select="$s.11"/>
						<xsl:with-param name="B" select="$b.11"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="s.12">
					<xsl:choose>
						<xsl:when test="(number($color.s) - 16) &gt; 5"><xsl:value-of select="number($color.s) - 16"/></xsl:when>
						<xsl:otherwise>5</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="b.12">
					<xsl:choose>
						<xsl:when test="(number($color.b) + 11) &lt; 100"><xsl:value-of select="number($color.b) + 11"/></xsl:when>
						<xsl:otherwise>100</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="grad.color.12">
					<xsl:call-template name="HSBtoHex">
						<xsl:with-param name="H" select="$color.h"/>
						<xsl:with-param name="S" select="$s.12"/>
						<xsl:with-param name="B" select="$b.12"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="s.13">
					<xsl:choose>
						<xsl:when test="(number($color.s) - 18) &gt; 5"><xsl:value-of select="number($color.s) - 18"/></xsl:when>
						<xsl:otherwise>5</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="b.13">
					<xsl:choose>
						<xsl:when test="(number($color.b) + 12) &lt; 100"><xsl:value-of select="number($color.b) + 12"/></xsl:when>
						<xsl:otherwise>100</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="grad.color.13">
					<xsl:call-template name="HSBtoHex">
						<xsl:with-param name="H" select="$color.h"/>
						<xsl:with-param name="S" select="$s.13"/>
						<xsl:with-param name="B" select="$b.13"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="s.14">
					<xsl:choose>
						<xsl:when test="(number($color.s) - 20) &gt; 5"><xsl:value-of select="number($color.s) - 20"/></xsl:when>
						<xsl:otherwise>5</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="b.14">
					<xsl:choose>
						<xsl:when test="(number($color.b) + 13) &lt; 100"><xsl:value-of select="number($color.b) + 13"/></xsl:when>
						<xsl:otherwise>100</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="grad.color.14">
					<xsl:call-template name="HSBtoHex">
						<xsl:with-param name="H" select="$color.h"/>
						<xsl:with-param name="S" select="$s.14"/>
						<xsl:with-param name="B" select="$b.14"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="s.15">
					<xsl:choose>
						<xsl:when test="(number($color.s) - 22) &gt; 5"><xsl:value-of select="number($color.s) - 22"/></xsl:when>
						<xsl:otherwise>5</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="b.15">
					<xsl:choose>
						<xsl:when test="(number($color.b) + 14) &lt; 100"><xsl:value-of select="number($color.b) + 14"/></xsl:when>
						<xsl:otherwise>100</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="grad.color.15">
					<xsl:call-template name="HSBtoHex">
						<xsl:with-param name="H" select="$color.h"/>
						<xsl:with-param name="S" select="$s.15"/>
						<xsl:with-param name="B" select="$b.15"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="s.16">
					<xsl:choose>
						<xsl:when test="(number($color.s) - 24) &gt; 5"><xsl:value-of select="number($color.s) - 24"/></xsl:when>
						<xsl:otherwise>5</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="b.16">
					<xsl:choose>
						<xsl:when test="(number($color.b) + 15) &lt; 100"><xsl:value-of select="number($color.b) + 15"/></xsl:when>
						<xsl:otherwise>100</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="grad.color.16">
					<xsl:call-template name="HSBtoHex">
						<xsl:with-param name="H" select="$color.h"/>
						<xsl:with-param name="S" select="$s.16"/>
						<xsl:with-param name="B" select="$b.16"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="s.17">
					<xsl:choose>
						<xsl:when test="(number($color.s) - 26) &gt; 5"><xsl:value-of select="number($color.s) - 26"/></xsl:when>
						<xsl:otherwise>5</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="b.17">
					<xsl:choose>
						<xsl:when test="(number($color.b) + 16) &lt; 100"><xsl:value-of select="number($color.b) + 16"/></xsl:when>
						<xsl:otherwise>100</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="grad.color.17">
					<xsl:call-template name="HSBtoHex">
						<xsl:with-param name="H" select="$color.h"/>
						<xsl:with-param name="S" select="$s.17"/>
						<xsl:with-param name="B" select="$b.17"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="s.18">
					<xsl:choose>
						<xsl:when test="(number($color.s) - 28) &gt; 5"><xsl:value-of select="number($color.s) - 28"/></xsl:when>
						<xsl:otherwise>5</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="b.18">
					<xsl:choose>
						<xsl:when test="(number($color.b)+18) &lt; 100"><xsl:value-of select="number($color.b) + 18"/></xsl:when>
						<xsl:otherwise>100</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="grad.color.18">
					<xsl:call-template name="HSBtoHex">
						<xsl:with-param name="H" select="$color.h"/>
						<xsl:with-param name="S" select="$s.18"/>
						<xsl:with-param name="B" select="$b.18"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="radius.1">18</xsl:variable>
				<xsl:variable name="radius.2">17</xsl:variable>
				<xsl:variable name="radius.3">16</xsl:variable>
				<xsl:variable name="radius.4">15</xsl:variable>
				<xsl:variable name="radius.5">14</xsl:variable>
				<xsl:variable name="radius.6">13</xsl:variable>
				<xsl:variable name="radius.7">12</xsl:variable>
				<xsl:variable name="radius.8">11</xsl:variable>
				<xsl:variable name="radius.9">10</xsl:variable>
				<xsl:variable name="radius.10">9</xsl:variable>
				<xsl:variable name="radius.11">8</xsl:variable>
				<xsl:variable name="radius.12">7</xsl:variable>
				<xsl:variable name="radius.13">6</xsl:variable>
				<xsl:variable name="radius.14">5</xsl:variable>
				<xsl:variable name="radius.15">4</xsl:variable>
				<xsl:variable name="radius.16">3</xsl:variable>
				<xsl:variable name="radius.17">2</xsl:variable>
				<xsl:variable name="radius.18">1</xsl:variable>

				<xsl:variable name="box-width" select="$width"/>
				<xsl:variable name="box-height" select="$height"/>

				<xsl:variable name="gradient-box-height" select="number($height) - 2*number(text_padding) - 36"/>
				<xsl:variable name="gradient-box-min-height">
					<xsl:choose>
						<xsl:when test="number($gradient-box-height) &gt; 0"><xsl:value-of select="$gradient-box-height"/></xsl:when>
						<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="css-gradient-cl-outer-box">width: <xsl:value-of select="$box-width"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="$box-height"/>px;</xsl:if> background-color: <xsl:value-of select="$grad.color.1"/>; -moz-border-radius: <xsl:value-of select="$radius.1"/>px; -webkit-border-radius: <xsl:value-of select="$radius.1"/>px; border-radius: <xsl:value-of select="$radius.1"/>px; <xsl:value-of select="$style-box-shadow"/></xsl:variable>
				<xsl:variable name="css-gradient-cl-inner-box-2">width: <xsl:value-of select="number($box-width) - 2"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($box-height) - 2"/>px;</xsl:if> background-color: <xsl:value-of select="$grad.color.2"/>; -moz-border-radius: <xsl:value-of select="$radius.2"/>px; -webkit-border-radius: <xsl:value-of select="$radius.2"/>px; border-radius: <xsl:value-of select="$radius.2"/>px;</xsl:variable>
				<xsl:variable name="css-gradient-cl-inner-box-3">width: <xsl:value-of select="number($box-width) - 4"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($box-height) - 4"/>px;</xsl:if> background-color: <xsl:value-of select="$grad.color.3"/>; -moz-border-radius: <xsl:value-of select="$radius.3"/>px; -webkit-border-radius: <xsl:value-of select="$radius.3"/>px; border-radius: <xsl:value-of select="$radius.3"/>px;</xsl:variable>
				<xsl:variable name="css-gradient-cl-inner-box-4">width: <xsl:value-of select="number($box-width) - 6"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($box-height) - 6"/>px;</xsl:if> background-color: <xsl:value-of select="$grad.color.4"/>; -moz-border-radius: <xsl:value-of select="$radius.4"/>px; -webkit-border-radius: <xsl:value-of select="$radius.4"/>px; border-radius: <xsl:value-of select="$radius.4"/>px;</xsl:variable>
				<xsl:variable name="css-gradient-cl-inner-box-5">width: <xsl:value-of select="number($box-width) - 8"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($box-height) - 8"/>px;</xsl:if> background-color: <xsl:value-of select="$grad.color.5"/>; -moz-border-radius: <xsl:value-of select="$radius.5"/>px; -webkit-border-radius: <xsl:value-of select="$radius.5"/>px; border-radius: <xsl:value-of select="$radius.5"/>px;</xsl:variable>
				<xsl:variable name="css-gradient-cl-inner-box-6">width: <xsl:value-of select="number($box-width) - 10"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($box-height) - 10"/>px;</xsl:if> background-color: <xsl:value-of select="$grad.color.6"/>; -moz-border-radius: <xsl:value-of select="$radius.6"/>px; -webkit-border-radius: <xsl:value-of select="$radius.6"/>px; border-radius: <xsl:value-of select="$radius.6"/>px;</xsl:variable>
				<xsl:variable name="css-gradient-cl-inner-box-7">width: <xsl:value-of select="number($box-width) - 12"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($box-height) - 12"/>px;</xsl:if> background-color: <xsl:value-of select="$grad.color.7"/>; -moz-border-radius: <xsl:value-of select="$radius.7"/>px; -webkit-border-radius: <xsl:value-of select="$radius.7"/>px; border-radius: <xsl:value-of select="$radius.7"/>px;</xsl:variable>
				<xsl:variable name="css-gradient-cl-inner-box-8">width: <xsl:value-of select="number($box-width) - 14"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($box-height) - 14"/>px;</xsl:if> background-color: <xsl:value-of select="$grad.color.8"/>; -moz-border-radius: <xsl:value-of select="$radius.8"/>px; -webkit-border-radius: <xsl:value-of select="$radius.8"/>px; border-radius: <xsl:value-of select="$radius.8"/>px;</xsl:variable>
				<xsl:variable name="css-gradient-cl-inner-box-9">width: <xsl:value-of select="number($box-width) - 16"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($box-height) - 16"/>px;</xsl:if> background-color: <xsl:value-of select="$grad.color.9"/>; -moz-border-radius: <xsl:value-of select="$radius.9"/>px; -webkit-border-radius: <xsl:value-of select="$radius.9"/>px; border-radius: <xsl:value-of select="$radius.9"/>px;</xsl:variable>
				<xsl:variable name="css-gradient-cl-inner-box-10">width: <xsl:value-of select="number($box-width) - 18"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($box-height) - 18"/>px;</xsl:if> background-color: <xsl:value-of select="$grad.color.10"/>; -moz-border-radius: <xsl:value-of select="$radius.10"/>px; -webkit-border-radius: <xsl:value-of select="$radius.10"/>px; border-radius: <xsl:value-of select="$radius.10"/>px;</xsl:variable>
				<xsl:variable name="css-gradient-cl-inner-box-11">width: <xsl:value-of select="number($box-width) - 20"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($box-height) - 20"/>px;</xsl:if> background-color: <xsl:value-of select="$grad.color.11"/>; -moz-border-radius: <xsl:value-of select="$radius.11"/>px; -webkit-border-radius: <xsl:value-of select="$radius.11"/>px; border-radius: <xsl:value-of select="$radius.11"/>px;</xsl:variable>
				<xsl:variable name="css-gradient-cl-inner-box-12">width: <xsl:value-of select="number($box-width) - 22"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($box-height) - 22"/>px;</xsl:if> background-color: <xsl:value-of select="$grad.color.12"/>; -moz-border-radius: <xsl:value-of select="$radius.12"/>px; -webkit-border-radius: <xsl:value-of select="$radius.12"/>px; border-radius: <xsl:value-of select="$radius.12"/>px;</xsl:variable>
				<xsl:variable name="css-gradient-cl-inner-box-13">width: <xsl:value-of select="number($box-width) - 24"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($box-height) - 24"/>px;</xsl:if> background-color: <xsl:value-of select="$grad.color.13"/>; -moz-border-radius: <xsl:value-of select="$radius.13"/>px; -webkit-border-radius: <xsl:value-of select="$radius.13"/>px; border-radius: <xsl:value-of select="$radius.13"/>px;</xsl:variable>
				<xsl:variable name="css-gradient-cl-inner-box-14">width: <xsl:value-of select="number($box-width) - 26"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($box-height) - 26"/>px;</xsl:if> background-color: <xsl:value-of select="$grad.color.14"/>; -moz-border-radius: <xsl:value-of select="$radius.14"/>px; -webkit-border-radius: <xsl:value-of select="$radius.14"/>px; border-radius: <xsl:value-of select="$radius.14"/>px;</xsl:variable>
				<xsl:variable name="css-gradient-cl-inner-box-15">width: <xsl:value-of select="number($box-width) - 28"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($box-height) - 28"/>px;</xsl:if> background-color: <xsl:value-of select="$grad.color.15"/>; -moz-border-radius: <xsl:value-of select="$radius.15"/>px; -webkit-border-radius: <xsl:value-of select="$radius.15"/>px; border-radius: <xsl:value-of select="$radius.15"/>px;</xsl:variable>
				<xsl:variable name="css-gradient-cl-inner-box-16">width: <xsl:value-of select="number($box-width) - 30"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($box-height) - 30"/>px;</xsl:if> background-color: <xsl:value-of select="$grad.color.16"/>; -moz-border-radius: <xsl:value-of select="$radius.16"/>px; -webkit-border-radius: <xsl:value-of select="$radius.16"/>px; border-radius: <xsl:value-of select="$radius.16"/>px;</xsl:variable>
				<xsl:variable name="css-gradient-cl-inner-box-17">width: <xsl:value-of select="number($box-width) - 32"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($box-height) - 32"/>px;</xsl:if> background-color: <xsl:value-of select="$grad.color.17"/>; -moz-border-radius: <xsl:value-of select="$radius.17"/>px; -webkit-border-radius: <xsl:value-of select="$radius.17"/>px; border-radius: <xsl:value-of select="$radius.17"/>px;</xsl:variable>
				<xsl:variable name="css-gradient-cl-inner-box-18">width: <xsl:value-of select="number($box-width) - 34"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($box-height) - 34"/>px;</xsl:if> background-color: <xsl:value-of select="$grad.color.18"/>; -moz-border-radius: <xsl:value-of select="$radius.18"/>px; -webkit-border-radius: <xsl:value-of select="$radius.18"/>px; border-radius: <xsl:value-of select="$radius.18"/>px;</xsl:variable>
				<xsl:variable name="css-gradient-cl-inner-part">width: <xsl:value-of select="number($box-width) - 36"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($box-height) - 36"/>px;</xsl:if></xsl:variable>
				<xsl:variable name="css-gradient-cl-txt-container">width: <xsl:value-of select="number($box-width) - 2*number(text_padding) - 36"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="$gradient-box-min-height"/>px;</xsl:if> padding: <xsl:value-of select="text_padding"/>px;</xsl:variable>
				<xsl:variable name="css-gradient-cl-txt-box">width: <xsl:value-of select="number($box-width) - 2*number(text_padding) - 36"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="$gradient-box-min-height"/>px; <xsl:value-of select="$style-scroll"/></xsl:if></xsl:variable>
				<xsl:variable name="css-gradient-cl-txt-box-table">width: 100%; border-spacing: 0; <xsl:if test="size_to='container'">min-height: <xsl:value-of select="$gradient-box-min-height"/>px;</xsl:if></xsl:variable>
				<xsl:variable name="css-gradient-cl-txt-box-cell">width: 100%; padding: 0; <xsl:if test="size_to='container'">vertical-align: <xsl:value-of select="valign"/>; min-height: <xsl:value-of select="$gradient-box-min-height"/>px;</xsl:if></xsl:variable>

				<div>
					<xsl:attribute name="class">cl-outer-box cl-div-rounded <xsl:if test="close_by='click'">cl-btn-close-object</xsl:if> unselectable</xsl:attribute>
					<xsl:attribute name="style"><xsl:value-of select="$css-gradient-cl-outer-box"/></xsl:attribute>
					<xsl:if test="hide_on_click='yes'">
						<xsl:attribute name="title"><xsl:value-of select="close_title"/></xsl:attribute>
					</xsl:if>
					<div>
						<xsl:attribute name="class">cl-inner-box-2 cl-div-rounded</xsl:attribute>
						<xsl:attribute name="style"><xsl:value-of select="$css-gradient-cl-inner-box-2"/></xsl:attribute>
						<div>
							<xsl:attribute name="class">cl-inner-box-3 cl-div-rounded</xsl:attribute>
							<xsl:attribute name="style"><xsl:value-of select="$css-gradient-cl-inner-box-3"/></xsl:attribute>
							<div>
								<xsl:attribute name="class">cl-inner-box-4 cl-div-rounded</xsl:attribute>
								<xsl:attribute name="style"><xsl:value-of select="$css-gradient-cl-inner-box-4"/></xsl:attribute>
								<div>
									<xsl:attribute name="class">cl-inner-box-5 cl-div-rounded</xsl:attribute>
									<xsl:attribute name="style"><xsl:value-of select="$css-gradient-cl-inner-box-5"/></xsl:attribute>
									<div>
										<xsl:attribute name="class">cl-inner-box-6 cl-div-rounded</xsl:attribute>
										<xsl:attribute name="style"><xsl:value-of select="$css-gradient-cl-inner-box-6"/></xsl:attribute>
										<div>
											<xsl:attribute name="class">cl-inner-box-7 cl-div-rounded</xsl:attribute>
											<xsl:attribute name="style"><xsl:value-of select="$css-gradient-cl-inner-box-7"/></xsl:attribute>
											<div>
												<xsl:attribute name="class">cl-inner-box-8 cl-div-rounded</xsl:attribute>
												<xsl:attribute name="style"><xsl:value-of select="$css-gradient-cl-inner-box-8"/></xsl:attribute>
												<div>
													<xsl:attribute name="class">cl-inner-box-9 cl-div-rounded</xsl:attribute>
													<xsl:attribute name="style"><xsl:value-of select="$css-gradient-cl-inner-box-9"/></xsl:attribute>
													<div>
														<xsl:attribute name="class">cl-inner-box-10 cl-div-rounded</xsl:attribute>
														<xsl:attribute name="style"><xsl:value-of select="$css-gradient-cl-inner-box-10"/></xsl:attribute>
														<div>
															<xsl:attribute name="class">cl-inner-box-11 cl-div-rounded</xsl:attribute>
															<xsl:attribute name="style"><xsl:value-of select="$css-gradient-cl-inner-box-11"/></xsl:attribute>
															<div>
																<xsl:attribute name="class">cl-inner-box-12 cl-div-rounded</xsl:attribute>
																<xsl:attribute name="style"><xsl:value-of select="$css-gradient-cl-inner-box-12"/></xsl:attribute>
																<div>
																	<xsl:attribute name="class">cl-inner-box-13 cl-div-rounded</xsl:attribute>
																	<xsl:attribute name="style"><xsl:value-of select="$css-gradient-cl-inner-box-13"/></xsl:attribute>
																	<div>
																		<xsl:attribute name="class">cl-inner-box-14 cl-div-rounded</xsl:attribute>
																		<xsl:attribute name="style"><xsl:value-of select="$css-gradient-cl-inner-box-14"/></xsl:attribute>
																		<div>
																			<xsl:attribute name="class">cl-inner-box-15 cl-div-rounded</xsl:attribute>
																			<xsl:attribute name="style"><xsl:value-of select="$css-gradient-cl-inner-box-15"/></xsl:attribute>
																			<div>
																				<xsl:attribute name="class">cl-inner-box-16 cl-div-rounded</xsl:attribute>
																				<xsl:attribute name="style"><xsl:value-of select="$css-gradient-cl-inner-box-16"/></xsl:attribute>
																				<div>
																					<xsl:attribute name="class">cl-inner-box-17 cl-div-rounded</xsl:attribute>
																					<xsl:attribute name="style"><xsl:value-of select="$css-gradient-cl-inner-box-17"/></xsl:attribute>
																					<div>
																						<xsl:attribute name="class">cl-inner-box-18 cl-div-rounded</xsl:attribute>
																						<xsl:attribute name="style"><xsl:value-of select="$css-gradient-cl-inner-box-18"/></xsl:attribute>
																						<div>
																							<xsl:attribute name="class">cl-inner-part</xsl:attribute>
																							<xsl:attribute name="style"><xsl:value-of select="$css-gradient-cl-inner-part"/></xsl:attribute>
																							<div>
																								<xsl:attribute name="class">cl-txt-container</xsl:attribute>
																								<xsl:attribute name="style"><xsl:value-of select="$css-gradient-cl-txt-container"/></xsl:attribute>
																								<div>
																									<xsl:attribute name="class">cl-txt-box</xsl:attribute>
																									<xsl:attribute name="style"><xsl:value-of select="$css-gradient-cl-txt-box"/></xsl:attribute>
																									<table>
																										<xsl:attribute name="class">cl-txt-box-table</xsl:attribute>
																										<xsl:attribute name="style"><xsl:value-of select="$css-gradient-cl-txt-box-table"/></xsl:attribute>
																										<tr>
																											<td>
																												<xsl:attribute name="class">cl-txt-box-cell <xsl:if test="size_to='container' and valign='bottom'">cl-txt-box-cell-clipped</xsl:if></xsl:attribute>
																												<xsl:attribute name="style"><xsl:value-of select="$css-gradient-cl-txt-box-cell"/></xsl:attribute>
																												<xsl:value-of select="text_main" disable-output-escaping="yes"/>
																											</td>
																										</tr>
																									</table>
																								</div>
																							</div>
																						</div>
																					</div>
																				</div>
																			</div>
																		</div>
																	</div>
																</div>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</xsl:when>
			<xsl:when test="$theme='relief'">
				<xsl:variable name="border-color-relief" select="$border-color-fixed"/>
				<xsl:variable name="bg-color-relief" select="$bg-color-fixed"/>
				<xsl:variable name="color.h">
					<xsl:call-template name="hue">
						<xsl:with-param name="hexcolor" select="$border-color-relief"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="color.s">
					<xsl:call-template name="saturation">
						<xsl:with-param name="hexcolor" select="$border-color-relief"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="color.b">
					<xsl:call-template name="brightness">
						<xsl:with-param name="hexcolor" select="$border-color-relief"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="s.light">
					<xsl:choose>
						<xsl:when test="(number($color.s) - 10) &gt; 5"><xsl:value-of select="number($color.s) - 10"/></xsl:when>
						<xsl:otherwise>5</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="b.light">
					<xsl:choose>
						<xsl:when test="(number($color.b) + 10) &lt; 100"><xsl:value-of select="number($color.b) + 10"/></xsl:when>
						<xsl:otherwise>100</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="s.dark">
					<xsl:choose>
						<xsl:when test="(number($color.s) + 10) &lt; 100"><xsl:value-of select="number($color.s) + 10"/></xsl:when>
						<xsl:otherwise>100</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="b.dark">
					<xsl:choose>
						<xsl:when test="(number($color.b) - 10) &gt; 5"><xsl:value-of select="number($color.b) - 10"/></xsl:when>
						<xsl:otherwise>5</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="s.lighter">
					<xsl:choose>
						<xsl:when test="(number($color.s) - 20) &gt; 5"><xsl:value-of select="number($color.s) - 20"/></xsl:when>
						<xsl:otherwise>5</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="b.lighter">
					<xsl:choose>
						<xsl:when test="(number($color.b) + 20) &lt; 100"><xsl:value-of select="number($color.b) + 20"/></xsl:when>
						<xsl:otherwise>100</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="s.darker">
					<xsl:choose>
						<xsl:when test="(number($color.s) + 20) &lt; 100"><xsl:value-of select="number($color.s) + 20"/></xsl:when>
						<xsl:otherwise>100</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="b.darker">
					<xsl:choose>
						<xsl:when test="(number($color.b) - 20) &gt; 5"><xsl:value-of select="number($color.b) - 20"/></xsl:when>
						<xsl:otherwise>5</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="color.light">
					<xsl:call-template name="HSBtoHex">
						<xsl:with-param name="H" select="$color.h"/>
						<xsl:with-param name="S" select="$s.light"/>
						<xsl:with-param name="B" select="$b.light"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="color.dark">
					<xsl:call-template name="HSBtoHex">
						<xsl:with-param name="H" select="$color.h"/>
						<xsl:with-param name="S" select="$s.dark"/>
						<xsl:with-param name="B" select="$b.dark"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="color.lighter">
					<xsl:call-template name="HSBtoHex">
						<xsl:with-param name="H" select="$color.h"/>
						<xsl:with-param name="S" select="$s.lighter"/>
						<xsl:with-param name="B" select="$b.lighter"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="color.darker">
					<xsl:call-template name="HSBtoHex">
						<xsl:with-param name="H" select="$color.h"/>
						<xsl:with-param name="S" select="$s.darker"/>
						<xsl:with-param name="B" select="$b.darker"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="relief-box-height" select="number($height) - 2*number(text_padding) - 26"/>
				<xsl:variable name="relief-box-min-height">
					<xsl:choose>
						<xsl:when test="number($relief-box-height) &gt; 0"><xsl:value-of select="$relief-box-height"/></xsl:when>
						<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="css-relief-cl-outer-box">width: <xsl:value-of select="number($width) - 2"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($height) - 2"/>px; </xsl:if>background-color: <xsl:value-of select="$color.lighter"/>; background-image: -o-linear-gradient(-45deg,<xsl:value-of select="$color.lighter"/> 0%,<xsl:value-of select="$color.darker"/> 100%); background-image: -ms-linear-gradient(-45deg,<xsl:value-of select="$color.lighter"/> 0%,<xsl:value-of select="$color.darker"/> 100%); background-image: -moz-linear-gradient(-45deg,<xsl:value-of select="$color.lighter"/> 0%,<xsl:value-of select="$color.darker"/> 100%); background-image: -webkit-linear-gradient(-45deg,<xsl:value-of select="$color.lighter"/> 0%,<xsl:value-of select="$color.darker"/> 100%); background-image: linear-gradient(135deg,<xsl:value-of select="$color.lighter"/> 0%,<xsl:value-of select="$color.darker"/> 100%); -moz-border-radius: 13px; -webkit-border-radius: 13px; border-radius: 13px;<xsl:value-of select="$style-box-shadow"/></xsl:variable>
				<xsl:variable name="css-relief-cl-middle-box-1">width: <xsl:value-of select="number($width) - 4"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($height) - 4"/>px; </xsl:if>background-color: <xsl:value-of select="$border-color-relief"/>;background-image: -o-linear-gradient(-45deg,<xsl:value-of select="$border-color-relief"/> 0%,<xsl:value-of select="$color.dark"/> 100%); background-image: -ms-linear-gradient(-45deg,<xsl:value-of select="$border-color-relief"/> 0%,<xsl:value-of select="$color.dark"/> 100%); background-image: -moz-linear-gradient(-45deg,<xsl:value-of select="$border-color-relief"/> 0%,<xsl:value-of select="$color.dark"/> 100%); background-image: -webkit-linear-gradient(-45deg,<xsl:value-of select="$border-color-relief"/> 0%,<xsl:value-of select="$color.dark"/> 100%); background-image: linear-gradient(135deg,<xsl:value-of select="$border-color-relief"/> 0%,<xsl:value-of select="$color.dark"/> 100%); -moz-border-radius: 12px; -webkit-border-radius: 12px; border-radius: 12px;</xsl:variable>
				<xsl:variable name="css-relief-cl-middle-box-2">width: <xsl:value-of select="number($width) - 6"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($height) - 6"/>px; </xsl:if>background-color: <xsl:value-of select="$border-color-relief"/>; -moz-border-radius: 11px; -webkit-border-radius: 11px; border-radius: 11px;</xsl:variable>
				<xsl:variable name="css-relief-cl-middle-box-3">width: <xsl:value-of select="number($width) - 8"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($height) - 8"/>px; </xsl:if>background-color: <xsl:value-of select="$color.darker"/>; background-image: -o-linear-gradient(-45deg,<xsl:value-of select="$color.darker"/> 0%,<xsl:value-of select="$color.lighter"/> 100%); background-image: -ms-linear-gradient(-45deg,<xsl:value-of select="$color.darker"/> 0%,<xsl:value-of select="$color.lighter"/> 100%); background-image: -moz-linear-gradient(-45deg,<xsl:value-of select="$color.darker"/> 0%,<xsl:value-of select="$color.lighter"/> 100%); background-image: -webkit-linear-gradient(-45deg,<xsl:value-of select="$color.darker"/> 0%,<xsl:value-of select="$color.lighter"/> 100%); background-image: linear-gradient(135deg,<xsl:value-of select="$color.darker"/> 0%,<xsl:value-of select="$color.lighter"/> 100%); -moz-border-radius: 10px; -webkit-border-radius: 10px; border-radius: 10px;</xsl:variable>
				<xsl:variable name="css-relief-cl-inner-box">width: <xsl:value-of select="number($width) - 8"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($height) - 8"/>px; overflow: hidden;</xsl:if>background-color: <xsl:value-of select="$bg-color-relief"/>; -moz-border-radius: 9px; -webkit-border-radius: 9px; border-radius: 9px;</xsl:variable>
				<xsl:variable name="css-relief-cl-txt-container">width: <xsl:value-of select="number($width) - 2*number(text_padding) - 26"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="$relief-box-min-height"/>px;</xsl:if>padding: <xsl:value-of select="number(text_padding) + 9"/>px;</xsl:variable>
				<xsl:variable name="css-relief-cl-txt-box">width: <xsl:value-of select="number($width) - 2*number(text_padding) - 26"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="$relief-box-min-height"/>px; <xsl:value-of select="$style-scroll"/></xsl:if></xsl:variable>
				<xsl:variable name="css-relief-cl-txt-box-table">width: 100%; border-spacing: 0; <xsl:if test="size_to='container'">min-height: <xsl:value-of select="$relief-box-min-height"/>px;</xsl:if></xsl:variable>
				<xsl:variable name="css-relief-cl-txt-box-cell">width: 100%; padding: 0; <xsl:if test="size_to='container'">vertical-align: <xsl:value-of select="valign"/>; min-height: <xsl:value-of select="$relief-box-min-height"/>px;</xsl:if></xsl:variable>

				<div class="style-custom" data-ie9="1" style="display: none">
					<div class="rule">
						<xsl:attribute name="data-name">#<xsl:value-of select="$objectID"/> .cl-outer-box</xsl:attribute>
						<span class="rule-dynamic">
							<xsl:attribute name="data-type">linear-gradient</xsl:attribute>
							<xsl:attribute name="data-angle">135</xsl:attribute>
							<xsl:attribute name="data-colors"><xsl:value-of select="$color.lighter"/>|0;<xsl:value-of select="$color.darker"/>|100</xsl:attribute>
							<xsl:attribute name="data-ie9">1</xsl:attribute>
						</span>
					</div>
					<div class="rule">
						<xsl:attribute name="data-name">#<xsl:value-of select="$objectID"/> .cl-middle-box-1</xsl:attribute>
						<span class="rule-dynamic">
							<xsl:attribute name="data-type">linear-gradient</xsl:attribute>
							<xsl:attribute name="data-angle">135</xsl:attribute>
							<xsl:attribute name="data-colors"><xsl:value-of select="$border-color-relief"/>|0;<xsl:value-of select="$color.dark"/>|100</xsl:attribute>
							<xsl:attribute name="data-ie9">1</xsl:attribute>
						</span>
					</div>
					<div class="rule">
						<xsl:attribute name="data-name">#<xsl:value-of select="$objectID"/> .cl-middle-box-3</xsl:attribute>
						<span class="rule-dynamic">
							<xsl:attribute name="data-type">linear-gradient</xsl:attribute>
							<xsl:attribute name="data-angle">135</xsl:attribute>
							<xsl:attribute name="data-colors"><xsl:value-of select="$color.darker"/>|0;<xsl:value-of select="$color.lighter"/>|100</xsl:attribute>
							<xsl:attribute name="data-ie9">1</xsl:attribute>
						</span>
					</div>
				</div>

				<div>
					<xsl:attribute name="class">cl-div-rounded cl-outer-box <xsl:if test="hide_on_click='yes'">cl-btn-close-object</xsl:if> unselectable</xsl:attribute>
					<xsl:attribute name="style"><xsl:value-of select="$css-relief-cl-outer-box"/></xsl:attribute>
					<xsl:if test="hide_on_click='yes'">
						<xsl:attribute name="title"><xsl:value-of select="close_title"/></xsl:attribute>
					</xsl:if>
					<div>
						<xsl:attribute name="class">cl-div-rounded cl-middle-box-1</xsl:attribute>
						<xsl:attribute name="style"><xsl:value-of select="$css-relief-cl-middle-box-1"/></xsl:attribute>
						<div>
							<xsl:attribute name="class">cl-div-rounded cl-middle-box-2</xsl:attribute>
							<xsl:attribute name="style"><xsl:value-of select="$css-relief-cl-middle-box-2"/></xsl:attribute>
							<div>
								<xsl:attribute name="class">cl-div-rounded cl-middle-box-3</xsl:attribute>
								<xsl:attribute name="style"><xsl:value-of select="$css-relief-cl-middle-box-3"/></xsl:attribute>
								<div>
									<xsl:attribute name="class">cl-inner-box</xsl:attribute>
									<xsl:attribute name="style"><xsl:value-of select="$css-relief-cl-inner-box"/></xsl:attribute>
									<div>
										<xsl:attribute name="class">cl-txt-container</xsl:attribute>
										<xsl:attribute name="style"><xsl:value-of select="$css-relief-cl-txt-container"/></xsl:attribute>
										<div>
											<xsl:attribute name="class">cl-txt-box</xsl:attribute>
											<xsl:attribute name="style"><xsl:value-of select="$css-relief-cl-txt-box"/></xsl:attribute>
											<table>
												<xsl:attribute name="class">cl-txt-box-table</xsl:attribute>
												<xsl:attribute name="style"><xsl:value-of select="$css-relief-cl-txt-box-table"/></xsl:attribute>
												<tr>
													<td>
														<xsl:attribute name="class">cl-txt-box-cell <xsl:if test="size_to='container' and valign='bottom'">cl-txt-box-cell-clipped</xsl:if></xsl:attribute>
														<xsl:attribute name="style"><xsl:value-of select="$css-relief-cl-txt-box-cell"/></xsl:attribute>
														<xsl:value-of select="text_main" disable-output-escaping="yes"/>
													</td>
												</tr>
											</table>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</xsl:when>
			<xsl:when test="$theme='text'">
				<xsl:variable name="bg-color-text" select="$bg-color-fixed"/>
				<xsl:variable name="bg-color-text-gradient">
					<xsl:call-template name="getcolor">
						<xsl:with-param name="color.base" select="$bg-color-text"/>
						<xsl:with-param name="color.base.type">color1</xsl:with-param>
						<xsl:with-param name="color.target.type">color2</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="border-color-text">
					<xsl:call-template name="getcolor">
						<xsl:with-param name="color.base" select="$bg-color-text"/>
						<xsl:with-param name="color.base.type">color1</xsl:with-param>
						<xsl:with-param name="color.target.type">stroke</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="border-width">
					<xsl:choose>
						<xsl:when test="border_style='none'">0</xsl:when>
						<xsl:otherwise><xsl:value-of select="stroke_weight"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="radius_inner">
					<xsl:choose>
						<xsl:when test="(number(border_radius)-number($border-width)) &lt; 0">0</xsl:when>
						<xsl:otherwise><xsl:value-of select="number(border_radius)-number($border-width)"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="padding-text" select="number(text_padding) + number($radius_inner)"/>

				<xsl:variable name="text-box-height" select="number($height) - 2*number($border-width) - 2*number($padding-text)"/>
				<xsl:variable name="text-box-min-height">
					<xsl:choose>
						<xsl:when test="number($text-box-height) &gt; 0"><xsl:value-of select="$text-box-height"/></xsl:when>
						<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="css-text-cl-outer-box">width: <xsl:value-of select="number($width) - 2*number($border-width)"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($height) - 2*number($border-width)"/>px; overflow: hidden;</xsl:if> background-color: <xsl:value-of select="$bg-color-text"/>; background-image: -o-linear-gradient(<xsl:value-of select="90-number(gradient_angle)"/>deg,<xsl:value-of select="$bg-color-text"/> 0%,<xsl:value-of select="$bg-color-text-gradient"/> 100%); background-image: -ms-linear-gradient(<xsl:value-of select="90-number(gradient_angle)"/>deg,<xsl:value-of select="$bg-color-text"/> 0%,<xsl:value-of select="$bg-color-text-gradient"/> 100%); background-image: -moz-linear-gradient(<xsl:value-of select="90-number(gradient_angle)"/>deg,<xsl:value-of select="$bg-color-text"/> 0%,<xsl:value-of select="$bg-color-text-gradient"/> 100%); background-image: -webkit-linear-gradient(<xsl:value-of select="90-number(gradient_angle)"/>deg,<xsl:value-of select="$bg-color-text"/> 0%,<xsl:value-of select="$bg-color-text-gradient"/> 100%); background-image: linear-gradient(<xsl:value-of select="gradient_angle"/>deg,<xsl:value-of select="$bg-color-text"/> 0%,<xsl:value-of select="$bg-color-text-gradient"/> 100%); border-style: <xsl:value-of select="border_style"/> !important; border-width: <xsl:value-of select="$border-width"/>px; border-color: <xsl:value-of select="$border-color-text"/>; -moz-border-radius: <xsl:value-of select="border_radius"/>px; -webkit-border-radius: <xsl:value-of select="border_radius"/>px; border-radius: <xsl:value-of select="border_radius"/>px;<xsl:value-of select="$style-box-shadow"/></xsl:variable>
				<xsl:variable name="css-text-cl-txt-container">width: <xsl:value-of select="number($width) - 2*number($border-width) - 2*number($padding-text)"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="$text-box-min-height"/>px;</xsl:if> padding: <xsl:value-of select="$padding-text"/>px;</xsl:variable>
				<xsl:variable name="css-text-cl-txt-box">width: <xsl:value-of select="number($width) - 2*number($border-width) - 2*number($padding-text)"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="$text-box-min-height"/>px; <xsl:value-of select="$style-scroll"/></xsl:if></xsl:variable>
				<xsl:variable name="css-text-cl-txt-box-table">width: 100%; border-spacing: 0; <xsl:if test="size_to='container'">min-height: <xsl:value-of select="$text-box-min-height"/>px;</xsl:if></xsl:variable>
				<xsl:variable name="css-text-cl-txt-box-cell">width: 100%; padding: 0; <xsl:if test="size_to='container'">vertical-align: <xsl:value-of select="valign"/>; min-height: <xsl:value-of select="$text-box-min-height"/>px;</xsl:if></xsl:variable>

				<div class="style-custom" data-ie9="1" style="display: none">
					<div class="rule">
						<xsl:attribute name="data-name">#<xsl:value-of select="$objectID"/> .cl-outer-box</xsl:attribute>
						<span class="rule-dynamic">
							<xsl:attribute name="data-type">linear-gradient</xsl:attribute>
							<xsl:attribute name="data-angle"><xsl:value-of select="gradient_angle"/></xsl:attribute>
							<xsl:attribute name="data-colors"><xsl:value-of select="$bg-color-text"/>|0;<xsl:value-of select="$bg-color-text-gradient"/>|100</xsl:attribute>
							<xsl:attribute name="data-ie9">1</xsl:attribute>
						</span>
					</div>
				</div>

				<div>
					<xsl:attribute name="class">cl-outer-box <xsl:if test="hide_on_click='yes'">cl-btn-close-object</xsl:if> unselectable</xsl:attribute>
					<xsl:attribute name="style"><xsl:value-of select="$css-text-cl-outer-box"/></xsl:attribute>
					<xsl:if test="hide_on_click='yes'">
						<xsl:attribute name="title"><xsl:value-of select="close_title"/></xsl:attribute>
					</xsl:if>
					<div>
						<xsl:attribute name="class">cl-txt-container</xsl:attribute>
						<xsl:attribute name="style"><xsl:value-of select="$css-text-cl-txt-container"/></xsl:attribute>
						<div>
							<xsl:attribute name="class">cl-txt-box</xsl:attribute>
							<xsl:attribute name="style"><xsl:value-of select="$css-text-cl-txt-box"/></xsl:attribute>
							<table>
								<xsl:attribute name="class">cl-txt-box-table</xsl:attribute>
								<xsl:attribute name="style"><xsl:value-of select="$css-text-cl-txt-box-table"/></xsl:attribute>
								<tr>
									<td>
										<xsl:attribute name="class">cl-txt-box-cell <xsl:if test="size_to='container' and valign='bottom'">cl-txt-box-cell-clipped</xsl:if></xsl:attribute>
										<xsl:attribute name="style"><xsl:value-of select="$css-text-cl-txt-box-cell"/></xsl:attribute>
										<xsl:value-of select="text_main" disable-output-escaping="yes"/>
									</td>
								</tr>
							</table>
						</div>
					</div>
				</div>
			</xsl:when>
			<xsl:when test="$theme='custom'">
				<xsl:variable name="bg-color-custom" select="$bg-color-fixed"/>
				<xsl:variable name="bg-gradient-custom" select="$gradient-color-fixed"/>
				<xsl:variable name="border-color-custom" select="$border-color-fixed"/>
				<xsl:variable name="border-width">
					<xsl:choose>
						<xsl:when test="border_style='none'">0</xsl:when>
						<xsl:otherwise><xsl:value-of select="stroke_weight"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="radius_inner">
					<xsl:choose>
						<xsl:when test="(number(border_radius)-number($border-width)) &lt; 0">0</xsl:when>
						<xsl:otherwise><xsl:value-of select="number(border_radius)-number($border-width)"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="padding-custom" select="number(text_padding) + number($radius_inner)"/>

				<xsl:variable name="custom-box-height" select="number($height) - 2*number($border-width) - 2*number($padding-custom)"/>
				<xsl:variable name="custom-box-min-height">
					<xsl:choose>
						<xsl:when test="number($custom-box-height) &gt; 0"><xsl:value-of select="$custom-box-height"/></xsl:when>
						<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="css-custom-cl-outer-box">width: <xsl:value-of select="number($width) - 2*number($border-width)"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="number($height) - 2*number($border-width)"/>px; overflow: hidden; </xsl:if> background-color: <xsl:value-of select="$bg-color-custom"/>; border-width: <xsl:value-of select="$border-width"/>px; border-style: <xsl:value-of select="border_style"/>; border-color: <xsl:value-of select="$border-color-custom"/>; background-image: -o-linear-gradient(<xsl:value-of select="90-number(gradient_angle)"/>deg,<xsl:value-of select="$bg-color-custom"/> 0%,<xsl:value-of select="$bg-gradient-custom"/> 100%); background-image: -ms-linear-gradient(<xsl:value-of select="90-number(gradient_angle)"/>deg,<xsl:value-of select="$bg-color-custom"/> 0%,<xsl:value-of select="$bg-gradient-custom"/> 100%); background-image: -moz-linear-gradient(<xsl:value-of select="90-number(gradient_angle)"/>deg,<xsl:value-of select="$bg-color-custom"/> 0%,<xsl:value-of select="$bg-gradient-custom"/> 100%); background-image: -webkit-linear-gradient(<xsl:value-of select="90-number(gradient_angle)"/>deg,<xsl:value-of select="$bg-color-custom"/> 0%,<xsl:value-of select="$bg-gradient-custom"/> 100%); background-image: linear-gradient(<xsl:value-of select="gradient_angle"/>deg,<xsl:value-of select="$bg-color-custom"/> 0%,<xsl:value-of select="$bg-gradient-custom"/> 100%); -moz-border-radius: <xsl:value-of select="border_radius"/>px; -webkit-border-radius: <xsl:value-of select="border_radius"/>px; border-radius: <xsl:value-of select="border_radius"/>px;<xsl:value-of select="$style-box-shadow"/></xsl:variable>
				<xsl:variable name="css-custom-cl-txt-container">width: <xsl:value-of select="number($width) - 2*number($border-width) - 2*number($padding-custom)"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="$custom-box-min-height"/>px;</xsl:if> padding: <xsl:value-of select="$padding-custom"/>px;</xsl:variable>
				<xsl:variable name="css-custom-cl-txt-box">width: <xsl:value-of select="number($width) - 2*number($border-width) - 2*number($padding-custom)"/>px; <xsl:if test="size_to='container'">height: <xsl:value-of select="$custom-box-min-height"/>px; <xsl:value-of select="$style-scroll"/></xsl:if></xsl:variable>
				<xsl:variable name="css-custom-cl-txt-box-table">width: 100%; border-spacing: 0; <xsl:if test="size_to='container'">min-height: <xsl:value-of select="$custom-box-min-height"/>px;</xsl:if></xsl:variable>
				<xsl:variable name="css-custom-cl-txt-box-cell">width: 100%; padding: 0; <xsl:if test="size_to='container'">vertical-align: <xsl:value-of select="valign"/>; min-height: <xsl:value-of select="$custom-box-min-height"/>px;</xsl:if></xsl:variable>

				<div class="style-custom" data-ie9="1" style="display: none">
					<div class="rule">
						<xsl:attribute name="data-name">#<xsl:value-of select="$objectID"/> .cl-outer-box</xsl:attribute>
						<span class="rule-dynamic">
							<xsl:attribute name="data-type">linear-gradient</xsl:attribute>
							<xsl:attribute name="data-angle"><xsl:value-of select="gradient_angle"/></xsl:attribute>
							<xsl:attribute name="data-colors"><xsl:value-of select="$bg-color-custom"/>|0;<xsl:value-of select="$bg-gradient-custom"/>|100</xsl:attribute>
							<xsl:attribute name="data-ie9">1</xsl:attribute>
						</span>
					</div>
				</div>

				<div>
					<xsl:attribute name="class">cl-outer-box <xsl:if test="hide_on_click='yes'">cl-btn-close-object</xsl:if> unselectable</xsl:attribute>
					<xsl:attribute name="style"><xsl:value-of select="$css-custom-cl-outer-box"/></xsl:attribute>
					<xsl:if test="hide_on_click='yes'">
						<xsl:attribute name="title"><xsl:value-of select="close_title"/></xsl:attribute>
					</xsl:if>
					<div>
						<xsl:attribute name="class">cl-txt-container</xsl:attribute>
						<xsl:attribute name="style"><xsl:value-of select="$css-custom-cl-txt-container"/></xsl:attribute>
						<div>
							<xsl:attribute name="class">cl-txt-box</xsl:attribute>
							<xsl:attribute name="style"><xsl:value-of select="$css-custom-cl-txt-box"/></xsl:attribute>
							<table>
								<xsl:attribute name="class">cl-txt-box-table</xsl:attribute>
								<xsl:attribute name="style"><xsl:value-of select="$css-custom-cl-txt-box-table"/></xsl:attribute>
								<tr>
									<td>
										<xsl:attribute name="class">cl-txt-box-cell <xsl:if test="size_to='container' and valign='bottom'">cl-txt-box-cell-clipped</xsl:if></xsl:attribute>
										<xsl:attribute name="style"><xsl:value-of select="$css-custom-cl-txt-box-cell"/></xsl:attribute>
										<xsl:value-of select="text_main" disable-output-escaping="yes"/>
									</td>
								</tr>
							</table>
						</div>
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
