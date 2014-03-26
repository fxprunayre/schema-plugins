<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:srv="http://www.isotc211.org/2005/srv/2.0/2013-03-28"
  xmlns:mds="http://www.isotc211.org/2005/mds/1.0/2013-03-28"
  xmlns:mcc="http://www.isotc211.org/2005/mcc/1.0/2013-03-28"
  xmlns:mri="http://www.isotc211.org/2005/mri/1.0/2013-03-28"
  xmlns:mrs="http://www.isotc211.org/2005/mrs/1.0/2013-03-28"
  xmlns:mrd="http://www.isotc211.org/2005/mrd/1.0/2013-03-28"
  xmlns:mco="http://www.isotc211.org/2005/mco/1.0/2013-03-28"
  xmlns:msr="http://www.isotc211.org/2005/msr/1.0/2013-03-28"
  xmlns:lan="http://www.isotc211.org/2005/lan/1.0/2013-03-28"
  xmlns:gcx="http://www.isotc211.org/2005/gcx/1.0/2013-03-28"
  xmlns:gex="http://www.isotc211.org/2005/gex/1.0/2013-03-28"
  xmlns:dqm="http://www.isotc211.org/2005/dqm/1.0/2013-03-28"
  xmlns:cit="http://www.isotc211.org/2005/cit/1.0/2013-03-28"
  xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:gmx="http://www.isotc211.org/2005/gmx"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:gml="http://www.opengis.net/gml/3.2"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:gn="http://www.fao.org/geonetwork"
  xmlns:gn-fn-core="http://geonetwork-opensource.org/xsl/functions/core" 
  xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
  xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
  xmlns:exslt="http://exslt.org/common" exclude-result-prefixes="#all">

  <xsl:include href="utility-tpl.xsl"/>
  <xsl:include href="layout-custom-fields.xsl"/>

  <!-- Visit all XML tree recursively -->
  <xsl:template mode="mode-iso19115-1-2013"
                match="mds:*|mcc:*|mri:*|mrs:*|mrd:*|mco:*|msr:*|lan:*|
                       gcx:*|gex:*|dqm:*|cit:*|srv:*"
                priority="2">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:apply-templates mode="mode-iso19115-1-2013" select="*|@*">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="labels" select="$labels"/>
    </xsl:apply-templates>
    <!--&lt;!&ndash; Check if a layout-<schema_identifier> mode is defined-->
    <!--for current element. &ndash;&gt;-->
    <!--<xsl:variable name="profileElements">-->
      <!--<xsl:apply-templates mode="mode-iso19115-1-2013" select=".">-->
        <!--<xsl:with-param name="schema" select="$schema"/>-->
        <!--<xsl:with-param name="labels" select="$labels"/>-->
      <!--</xsl:apply-templates>-->
    <!--</xsl:variable>-->

    <!--<xsl:choose>-->
      <!--<xsl:when test="count($profileElements/*)>0">-->
        <!--<xsl:copy-of select="$profileElements"/>-->
      <!--</xsl:when>-->
      <!--<xsl:otherwise>-->
        <!--&lt;!&ndash; If not delegate to ISO19139 &ndash;&gt;-->
        <!--<xsl:apply-templates mode="mode-iso19139" select="."/>-->
      <!--</xsl:otherwise>-->
    <!--</xsl:choose>-->
  </xsl:template>

  <!-- Ignore all gn element -->
  <xsl:template mode="mode-iso19115-1-2013" match="gn:*|@gn:*|@*" priority="1000"/>


  <!-- Template to display non existing element ie. geonet:child element
	of the metadocument. Display in editing mode only and if
  the editor mode is not flat mode. -->
  <xsl:template mode="mode-iso19115-1-2013" match="gn:child" priority="2000">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <!-- TODO: this should be common to all schemas -->
    <xsl:if test="$isEditing and
      not($isFlatMode)">

      <xsl:variable name="name" select="concat(@prefix, ':', @name)"/>
      <xsl:variable name="directive" select="gn-fn-metadata:getFieldAddDirective($editorConfig, $name)"/>

      <xsl:call-template name="render-element-to-add">
        <!-- TODO: add xpath and isoType to get label ? -->
        <xsl:with-param name="label"
                        select="gn-fn-metadata:getLabel($schema, $name, $labels, name(..), '', '')/label"/>
        <xsl:with-param name="directive" select="if($directive != 'text') then $directive else ''"/>
        <xsl:with-param name="childEditInfo" select="."/>
        <xsl:with-param name="parentEditInfo" select="../gn:element"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- Boxed element

      Details about the last line :
      * namespace-uri(.) != $gnUri: Only take into account profile's element
      * and $isFlatMode = false(): In flat mode, don't box any
      * and gmd:*: Match all elements having gmd child elements
      * and not(gco:CharacterString): Don't take into account those having gco:CharacterString (eg. multilingual elements)
  -->
  <xsl:template mode="mode-iso19115-1-2013" priority="200"
                match="*[name() = $editorConfig/editor/fieldsWithFieldset/name
                          or @gco:isoType = $editorConfig/editor/fieldsWithFieldset/name]|
                        *[namespace-uri(.) != $gnUri and $isFlatMode = false() and
                        not(gco:CharacterString)]">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>

    <xsl:variable name="attributes">
      <!-- Create form for all existing attribute (not in gn namespace)
      and all non existing attributes not already present. -->
      <xsl:apply-templates mode="render-for-field-for-attribute"
                           select="
        @*|
        gn:attribute[not(@name = parent::node()/@*/name())]">
        <xsl:with-param name="ref" select="gn:element/@ref"/>
        <xsl:with-param name="insertRef" select="gn:element/@ref"/>
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:variable name="errors">
      <xsl:if test="$showValidationErrors">
        <xsl:call-template name="get-errors"/>
      </xsl:if>
    </xsl:variable>

    <xsl:call-template name="render-boxed-element">
      <xsl:with-param name="label"
                      select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)/label"/>
      <xsl:with-param name="editInfo" select="gn:element"/>
      <xsl:with-param name="errors" select="$errors"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <xsl:with-param name="attributesSnippet" select="$attributes"/>
      <xsl:with-param name="subTreeSnippet">
        <!-- Process child of those element. Propagate schema
        and labels to all subchilds (eg. needed like iso19110 elements
        contains gmd:* child. -->
        <xsl:apply-templates mode="mode-iso19115-1-2013" select="*">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="labels" select="$labels"/>
        </xsl:apply-templates>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Render simple element which usually match a form field -->
  <xsl:template mode="mode-iso19115-1-2013" priority="200"
                match="*[gco:CharacterString|gco:Integer|gco:Decimal|
       gco:Boolean|gco:Real|gco:Measure|gco:Length|gco:Distance|gco:Angle|gmx:FileName|
       gco:Scale|gco:RecordType|gmx:MimeFileType|gco:LocalName]">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="elementName" select="name()"/>

    <!--<xsl:variable name="hasPTFreeText" select="count(gmd:PT_FreeText) > 0"/>-->
    <xsl:variable name="hasPTFreeText" select="false"/>

    <xsl:variable name="isMultilingualElement"
                  select="$metadataIsMultilingual and
              count($editorConfig/editor/multilingualFields/exclude[name = $elementName]) = 0"/>
    <xsl:variable name="isMultilingualElementExpanded"
                  select="count($editorConfig/editor/multilingualFields/expanded[name = $elementName]) > 0"/>

    <!-- For some fields, always display attributes.
    TODO: move to editor config ? -->
    <xsl:variable name="forceDisplayAttributes" select="count(gmx:FileName) > 0"/>

    <!-- TODO: Support gmd:LocalisedCharacterString -->
    <xsl:variable name="theElement" select="gco:CharacterString|gco:Integer|gco:Decimal|
      gco:Boolean|gco:Real|gco:Measure|gco:Length|gco:Distance|gco:Angle|gmx:FileName|
      gco:Scale|gco:RecordType|gmx:MimeFileType|gco:LocalName"/>

    <!--
      This may not work if node context is lost eg. when an element is rendered
      after a selection with copy-of.
      <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>-->
    <xsl:variable name="xpath" select="gn-fn-metadata:getXPathByRef(gn:element/@ref, $metadata, false())"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>
    <xsl:variable name="labelConfig"
                  select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)"/>
    <xsl:variable name="helper" select="gn-fn-metadata:getHelper($labelConfig/helper, .)"/>

    <xsl:variable name="attributes">

      <!-- Create form for all existing attribute (not in gn namespace)
      and all non existing attributes not already present for the
      current element and its children (eg. @uom in gco:Distance).
      A list of exception is defined in form-builder.xsl#render-for-field-for-attribute. -->
      <xsl:apply-templates mode="render-for-field-for-attribute"
                           select="
            @*|
            gn:attribute[not(@name = parent::node()/@*/name())]">
        <xsl:with-param name="ref" select="gn:element/@ref"/>
        <xsl:with-param name="insertRef" select="$theElement/gn:element/@ref"/>
      </xsl:apply-templates>
      <xsl:apply-templates mode="render-for-field-for-attribute"
                           select="
        */@*|
        */gn:attribute[not(@name = parent::node()/@*/name())]">
        <xsl:with-param name="ref" select="*/gn:element/@ref"/>
        <xsl:with-param name="insertRef" select="$theElement/gn:element/@ref"/>
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:variable name="errors">
      <xsl:if test="$showValidationErrors">
        <xsl:call-template name="get-errors">
          <xsl:with-param name="theElement" select="$theElement"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="values">
      <xsl:if test="$isMultilingualElement">

        <values>
          <!-- Or the PT_FreeText element matching the main language -->
          <value ref="{$theElement/gn:element/@ref}" lang="{$metadataLanguage}"><xsl:value-of select="gco:CharacterString"/></value>

          <!-- the existing translation
          <xsl:for-each select="gmd:PT_FreeText/gmd:textGroup/gmd:LocalisedCharacterString">
            <value ref="{gn:element/@ref}" lang="{substring-after(@locale, '#')}"><xsl:value-of select="."/></value>
          </xsl:for-each>
          FIXME
          -->

          <!-- and create field for none translated language -->
          <xsl:for-each select="$metadataOtherLanguages/lang">
            <xsl:variable name="currentLanguageId" select="@id"/>
            <!-- FIXME
            <xsl:if test="count($theElement/parent::node()/
                gmd:PT_FreeText/gmd:textGroup/
                gmd:LocalisedCharacterString[@locale = concat('#',$currentLanguageId)]) = 0">
              <value ref="lang_{@id}_{$theElement/parent::node()/gn:element/@ref}" lang="{@id}"></value>
            </xsl:if>
            -->
          </xsl:for-each>
        </values>
      </xsl:if>
    </xsl:variable>

    <xsl:call-template name="render-element">
      <xsl:with-param name="label" select="$labelConfig/label"/>
      <xsl:with-param name="value" select="if ($isMultilingualElement) then $values else *"/>
      <xsl:with-param name="errors" select="$errors"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <!--<xsl:with-param name="widget"/>
        <xsl:with-param name="widgetParams"/>-->
      <xsl:with-param name="xpath" select="$xpath"/>
      <xsl:with-param name="attributesSnippet" select="$attributes"/>
      <xsl:with-param name="type"
                      select="gn-fn-metadata:getFieldType($editorConfig, name(),
        name($theElement))"/>
      <xsl:with-param name="name" select="if ($isEditing) then $theElement/gn:element/@ref else ''"/>
      <xsl:with-param name="editInfo" select="$theElement/gn:element"/>
      <xsl:with-param name="parentEditInfo" select="gn:element"/>
      <!-- TODO: Handle conditional helper -->
      <xsl:with-param name="listOfValues" select="$helper"/>
      <xsl:with-param name="toggleLang" select="$isMultilingualElementExpanded"/>
      <xsl:with-param name="forceDisplayAttributes" select="$forceDisplayAttributes"/>
    </xsl:call-template>
  </xsl:template>



  <xsl:template mode="mode-iso19115-1-2013" priority="200"
                match="*[gco:Date|gco:DateTime]">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="labelConfig"
                  select="gn-fn-metadata:getLabel($schema, name(), $labels)"/>

    <div data-gn-date-picker="{gco:Date|gco:DateTime}"
         data-label="{$labelConfig/label}"
         data-element-name="{name(gco:Date|gco:DateTime)}"
         data-element-ref="{concat('_X', gn:element/@ref)}">
    </div>
  </xsl:template>

  <!--
  <xsl:template mode="mode-iso19115-1-2013" match="*|@*" priority="0"/>
-->
  <!-- Codelists -->
  <xsl:template mode="mode-iso19115-1-2013" priority="200"
                match="mds:*[*/@codeList]|mcc:*[*/@codeList]|
                       mri:*[*/@codeList]|mrs:*[*/@codeList]|
                       mrd:*[*/@codeList]|mco:*[*/@codeList]|
                       msr:*[*/@codeList]|lan:*[*/@codeList]|
                       gcx:*[*/@codeList]|gex:*[*/@codeList]|
                       dqm:*[*/@codeList]|cit:*[*/@codeList]|
                       srv:*[*/@codeList]">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>
    <xsl:param name="codelists" select="$codelists" required="no"/>

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>

    <xsl:call-template name="render-element">
      <xsl:with-param name="label"
                      select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)/label"/>
      <xsl:with-param name="value" select="*/@codeListValue"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <xsl:with-param name="type" select="gn-fn-iso19139:getCodeListType(name())"/>
      <xsl:with-param name="name"
                      select="concat(*/gn:element/@ref, '_codeListValue')"/>
      <xsl:with-param name="editInfo" select="*/gn:element"/>
      <xsl:with-param name="parentEditInfo" select="gn:element"/>
      <xsl:with-param name="listOfValues"
                      select="gn-fn-metadata:getCodeListValues($schema, name(*[@codeListValue]), $codelists, .)"/>
    </xsl:call-template>
  </xsl:template>


  <!--
    Take care of enumerations.

    In the metadocument an enumeration provide the list of possible values:
  <gmd:topicCategory>
    <gmd:MD_TopicCategoryCode>
    <geonet:element ref="69" parent="68" uuid="gmd:MD_TopicCategoryCode_0073afa8-bc8f-4c52-94f3-28d3aa686772" min="1" max="1">
      <geonet:text value="farming"/>
      <geonet:text value="biota"/>
      <geonet:text value="boundaries"/
  -->
  <xsl:template mode="mode-iso19115-1-2013"
                match="*[gn:element/gn:text]"
                priority="2000">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>
    <xsl:param name="codelists" select="$codelists" required="no"/>
<xsl:message>### ENUM ? </xsl:message>
    <xsl:call-template name="render-element">
      <xsl:with-param name="label"
                      select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), '', '')/label"/>
      <xsl:with-param name="value" select="text()"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="type" select="gn-fn-iso19139:getCodeListType(name())"/>
      <xsl:with-param name="name" select="gn:element/@ref"/>
      <xsl:with-param name="editInfo" select="*/gn:element"/>
      <xsl:with-param name="listOfValues"
                      select="gn-fn-metadata:getCodeListValues($schema, name(), $codelists, .)"/>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
