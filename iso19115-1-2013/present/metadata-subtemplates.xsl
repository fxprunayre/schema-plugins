<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:mds="http://www.isotc211.org/2005/mds/1.0/2013-03-28" 
  xmlns:mri="http://www.isotc211.org/2005/mri/1.0/2013-03-28"
  xmlns:cit="http://www.isotc211.org/2005/cit/1.0/2013-03-28"
  xmlns:mrd="http://www.isotc211.org/2005/mrd/1.0/2013-03-28" 
  xmlns:mco="http://www.isotc211.org/2005/mco/1.0/2013-03-28" 
  xmlns:gex="http://www.isotc211.org/2005/gex/1.0/2013-03-28"
  xmlns:geonet="http://www.fao.org/geonetwork" 
  exclude-result-prefixes="mds mri cit mrd mco gex gco geonet">
  
  <!-- Compute title for all type of subtemplates. If none defined, 
  the title from the metadata title column is used. -->
  <xsl:template name="iso19115-1-2013-subtemplate">
    
    <xsl:variable name="subTemplateTitle">
      <xsl:apply-templates mode="iso19115-1-2013-subtemplate" select="."/>
    </xsl:variable>
    
    <title>
      <xsl:choose>
        <xsl:when test="normalize-space($subTemplateTitle)!=''">
          <xsl:value-of select="$subTemplateTitle"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="geonet:info/title"/>
        </xsl:otherwise>
      </xsl:choose>
    </title>
  </xsl:template>
  
  <!-- Subtemplate mode -->
  <xsl:template mode="iso191115-1-2013-subtemplate" match="cit:CI_Responsibility">
    <!-- TODO : multilingual subtemplate are not supported. There is
      no locale element -->
    <xsl:variable name="langId">
      <xsl:call-template name="getLangId">
        <xsl:with-param name="langGui" select="/root/gui/language"/>
        <xsl:with-param name="md" select="."/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:apply-templates mode="localised" select="cit:name[ancestor::cit:CI_Organisation]">
      <xsl:with-param name="langId" select="$langId"/>
    </xsl:apply-templates>
    
    <!-- Concatenate email or name -->
    <xsl:choose>
      <xsl:when test="count(cit:party/*/cit:contactInfo/cit:CI_Contact/cit:address/cit:CI_Address/cit:electronicMailAddress/gco:CharacterString[normalize-space(.)!='']) > 0">
        <xsl:text> > </xsl:text>
        <xsl:value-of select="string-join(cit:party/*/cit:contactInfo/cit:CI_Contact/cit:address/cit:CI_Address/cit:electronicMailAddress/gco:CharacterString, ',')"/>
      </xsl:when>
      <xsl:when test="normalize-space(cit:party/*/cit:name/gco:CharacterString)!=''">
        <xsl:text> > </xsl:text>
        <xsl:apply-templates mode="localised" select="cit:party/*/cit:name">
          <xsl:with-param name="langId" select="$langId"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="normalize-space(cit:party/cit:CI_Individual/cit:positionName/gco:CharacterString)!=''">
        <xsl:text> > </xsl:text>
        <xsl:apply-templates mode="localised" select="cit:party/cit:CI_Individual/cit:positionName">
          <xsl:with-param name="langId" select="$langId"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template mode="iso191115-1-2013-subtemplate" match="gex:EX_Extent">
    <!-- TODO : multilingual subtemplate are not supported. There is
      no gmd:language element or gmd:locales -->
    <xsl:variable name="langId">
      <xsl:call-template name="getLangId">
        <xsl:with-param name="langGui" select="/root/gui/language"/>
        <xsl:with-param name="md" select="."/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:apply-templates mode="localised" select="gex:description">
      <xsl:with-param name="langId" select="$langId"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template mode="iso191115-1-2013-subtemplate" match="mri:MD_Keywords">
    <xsl:variable name="langId">
      <xsl:call-template name="getLangId">
        <xsl:with-param name="langGui" select="/root/gui/language"/>
        <xsl:with-param name="md" select="."/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:for-each select="mri:keyword">
      <xsl:apply-templates mode="localised" select=".">
        <xsl:with-param name="langId" select="$langId"/>
      </xsl:apply-templates>
      <xsl:if test="position() != last()">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template mode="iso191115-1-2013-subtemplate" match="mrd:MD_Distribution">
    <xsl:value-of
      select="string-join(mrd:transferOptions/mrd:MD_DigitalTransferOptions/mrd:onLine/cit:CI_OnlineResource/cit:linkage/*, ' ,')"
    />
  </xsl:template>
  
  <xsl:template mode="iso191115-1-2013-subtemplate" match="mco:MD_LegalConstraints">
    <xsl:value-of
      select="if (mco:useLimitation) then mco:useLimitation/* else mco:otherConstraints/*"
    />
  </xsl:template>
  
  
  <xsl:template mode="iso191115-1-2013-subtemplate" match="*"/>
  
</xsl:stylesheet>
