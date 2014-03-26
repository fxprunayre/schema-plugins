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
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:gml="http://www.opengis.net/gml/3.2"
  xmlns:gn="http://www.fao.org/geonetwork"
  xmlns:gn-fn-core="http://geonetwork-opensource.org/xsl/functions/core"
  xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
  xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
  xmlns:exslt="http://exslt.org/common" exclude-result-prefixes="#all">


  <!-- Readonly elements
  [parent::mds:metadataIdentifier and
                        mcc:codeSpace/gco:CharacterString='urn:uuid']|
                      mds:dateInfo/cit:CI_Date[cit:dateType/cit:CI_DateTypeCode
                        /@codeListValue='revision']
-->
  <xsl:template mode="mode-iso19115-1-2013"
                match="mds:metadataIdentifier/mcc:MD_Identifier/mcc:code|
                       mds:metadataIdentifier/mcc:MD_Identifier/mcc:codeSpace|
                       mds:metadataIdentifier/mcc:MD_Identifier/mcc:description"
                priority="2000">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:call-template name="render-element">
      <xsl:with-param name="label" select="gn-fn-metadata:getLabel($schema, name(), $labels)/label"/>
      <xsl:with-param name="value" select="*"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="gn-fn-metadata:getXPath(.)"/>
      <xsl:with-param name="type" select="gn-fn-metadata:getFieldType($editorConfig, name(), '')"/>
      <xsl:with-param name="name" select="''"/>
      <xsl:with-param name="editInfo" select="*/gn:element"/>
      <xsl:with-param name="parentEditInfo" select="gn:element"/>
      <xsl:with-param name="isDisabled" select="true()"/>
    </xsl:call-template>

  </xsl:template>

  
  <xsl:template mode="mode-iso19115-1-2013"
                match="gex:EX_GeographicBoundingBox"
                priority="2000">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>

    <xsl:call-template name="render-boxed-element">
      <xsl:with-param name="label"
        select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)/label"/>
      <xsl:with-param name="editInfo" select="gn:element"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="subTreeSnippet">
        <div gn-draw-bbox="" data-hleft="{gex:westBoundLongitude/gco:Decimal}"
          data-hright="{gex:eastBoundLongitude/gco:Decimal}" data-hbottom="{gex:southBoundLatitude/gco:Decimal}"
          data-htop="{gex:northBoundLatitude/gco:Decimal}" data-hleft-ref="_{gex:westBoundLongitude/gco:Decimal/gn:element/@ref}"
          data-hright-ref="_{gex:eastBoundLongitude/gco:Decimal/gn:element/@ref}"
          data-hbottom-ref="_{gex:southBoundLatitude/gco:Decimal/gn:element/@ref}"
          data-htop-ref="_{gex:northBoundLatitude/gco:Decimal/gn:element/@ref}"
          data-lang="lang"></div>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
