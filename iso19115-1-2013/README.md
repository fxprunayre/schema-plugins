# ISO 19115-1:2014 schema plugin

This is the ISO19115-1:2014 schema plugin for GeoNetwork 2.11.x or greater version.

## Warning:

The XML schema is not the final version.

## Reference documents:

* http://www.iso.org/iso/catalogue_detail.htm?csnumber=53798

## Description:

This plugin supports:

* indexing, editing/viewing, CSW
* works in classic editor or Angular editor (not ExtJS editor)
* some functions still to be checked
* no localization for languages other than english
* no labels for element names (this is deliberate as the aim here is to get this schema available in GeoNetwork for understanding of 19115-1:2013)
* lots of editor functions have basic or no support at present

## GeoNetwork version to use with this plugin

This is a draft implementation for testing mainly. It's not working at present in 2.10.2
so don't plug it into your production instance! 2.10.3 and develop should support it.
Alternatively you can download the ANZMEST installer (a patched version of 2.10.2 with these changes
and ISO19115-1:2013 as an install option) from: http://bluenetdev.its.utas.edu.au/download/geonetwork-2.10.2-anzmest-installer-withiso19115-1-2013.jar

Comments and questions to geonetwork-developers or geonetwork-users mailing lists.
