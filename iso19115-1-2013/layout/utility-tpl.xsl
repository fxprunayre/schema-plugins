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
  xmlns:gn="http://www.fao.org/geonetwork"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all">

  <xsl:include href="utility-tpl-multilingual.xsl"/>

  <xsl:template name="get-iso19115-1-2013-geopublisher-config">
    <xsl:call-template name="get-iso19139-geopublisher-config"/>
  </xsl:template>
</xsl:stylesheet>
