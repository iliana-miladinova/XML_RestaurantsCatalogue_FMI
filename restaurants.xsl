<?xml version="1.0" encoding="UTF-8"?>
<!--<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes" doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="http://www.w3.org/TR/html4/strict.dtd" /> -->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes" omit-xml-declaration="yes" />

    <xsl:param name="loadDocument">true</xsl:param>

    <xsl:param name="showAll">true</xsl:param>
    <xsl:param name="showId">true</xsl:param>

    <xsl:param name="sortOn"></xsl:param>
    <xsl:param name="sortOrder">ascending</xsl:param>
    <xsl:param name="sortType">text</xsl:param>

    <xsl:param name="filterOn"></xsl:param>
    <xsl:param name="filterValue"></xsl:param>

    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="$loadDocument = 'true'">
                <xsl:call-template name="loadDocument" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="loadContent" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="loadDocument">
        <html lang="en">
            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1" />
                <title>Restaurants Catalogue</title>
                <!--<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous"/> -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />
                <style>
                    body {
                        font-family: Inter, sans-serif;
                        background-color: #ffafbd;
                        margin: 0;
                        padding: 20px;
                    }
                    h1 {
                        text-align: center;
                        margin-bottom: 30px;
                    }
                    .card {
                        margin-bottom: 20px;
                        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                    }
                    .card-title {
                        font-weight: bold;
                    }

                    .card-text {
                        color: #555;
                    }

                    img {
                        max-width: 100%;
                        height: auto;
                    }
                </style>
            </head>
            <body>
                <h1>Restaurant Catalogue</h1>
                <p>Това е тестов изглед.</p>
                <style>
                    body {
                        font-family: Inter, sans-serif;
                        background-color: #ffafbd;
                        margin: 0;
                        padding: 20px;
                    }
                </style>
            </body>
        </html>
    </xsl:template>