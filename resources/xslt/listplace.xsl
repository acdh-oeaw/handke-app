<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:param name="id"/>
    <xsl:template match="/">
        <style>
            #mapid { height: 500px; }
        </style>
        <script src="$app-root/resources/js/leaflet/leaflet.js"/>
        <link rel="stylesheet" href="$app-root/resources/js/leaflet/leaflet.css"/>
        <div class="panel panel-default">
            <div class="panel-heading">
                <h1 style="text-align:center;">
                    <xsl:value-of select="$id"/>
                </h1>
            </div>
            <div class="panel-body">
                <div class="row">
                    <div class="col-md-6">
                        <div class="panel-group">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <h4 class="panel-title" style="text-align:center;">
                                        <a data-toggle="collapse" href="#collapse2">Affiliated Persons</a>
                                    </h4>
                                </div>
                                <div id="collapse2" class="panel-collapse">
                                    <div class="panel-body" id="chart2">
                                        <xsl:for-each select=".//tei:person[normalize-space(.//tei:country[1]//text()[1])=$id]">
                                            <xsl:sort select=".//tei:surname"/>
                                            <strong>
                                                <xsl:value-of select=".//tei:persName"/>
                                            </strong>
                                            <br/>
                                            <a>
                                                <xsl:attribute name="href">
                                                    <xsl:value-of select="concat('show.html?document=listperson.xml&amp;directory=indices&amp;stylesheet=listorg&amp;id=', normalize-space(.//tei:orgName))"/>
                                                </xsl:attribute>
                                                <small>
                                                    <xsl:value-of select=".//tei:orgName"/>
                                                </small>
                                            </a>
                                            <ul class="list-unstyled">
                                                <xsl:for-each select=".//tei:title">
                                                    <li>
                                                        <xsl:apply-templates/>&#160;
                                                        <a target="_blank">
                                                            <xsl:attribute name="href">
                                                                <xsl:value-of select="concat('show.html?document=',./@key)"/>
                                                            </xsl:attribute>
                                                            <span class="glyphicon glyphicon-new-window" aria-hidden="true"/>
                                                        </a>
                                                    </li>
                                                </xsl:for-each>
                                            </ul>
                                        </xsl:for-each>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="panel-group">
                            <div class="panel panel-default">
                                <!--<div class="panel-heading">
                                    <h4 class="panel-title" style="text-align:center;">
                                        <a data-toggle="collapse" href="#collapse1">located in
                                            <strong>
                                                <xsl:value-of select="(.//tei:affiliation[normalize-space(.//tei:country/text())=$id])[1]//tei:country"/>
                                            </strong>
                                        </a>
                                    </h4>
                                </div>-->
                                <div id="collapse1" class="panel-collapse">
                                    <div class="panel-body" id="chart1">
                                        <div id="mapid"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script>
            var geo = [<xsl:value-of select="(.//tei:affiliation[normalize-space(.//tei:country/text())=$id])[1]//tei:geo"/>];
            var reverseGeo = [geo[1], geo[0]];
            var map = L.map('mapid').setView(reverseGeo, 3); 
            L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
            attribution: 'Map data &lt;a href="http://openstreetmap.org"&gt;OpenStreetMap&lt;/a&gt; contributors, &lt;a href="http://creativecommons.org/licenses/by-sa/2.0/"&gt;CC-BY-SA&lt;/a&gt;, Imagery © &lt;a href="http://mapbox.com"&gt;Mapbox&lt;/a&gt;',
            maxZoom: 18,
            id: 'mapbox.light',
            accessToken: 'pk.eyJ1Ijoic2VubmllcmVyIiwiYSI6ImNpbHk1YWV0bDAwZnB2dW01d2l1Y3phdmkifQ.OljQLEhqeAygai2y6VoSwQ'
            }).addTo(map);
            
            var marker = L.marker(reverseGeo).addTo(map);
        </script>
        
        
    </xsl:template>
    <xsl:template match="tei:gi">
        <code>
            <xsl:apply-templates/>
        </code>
    </xsl:template>
    
</xsl:stylesheet>