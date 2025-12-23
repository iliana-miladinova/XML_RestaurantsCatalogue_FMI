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
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous"/>
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
                <h1 class="text-center mt-5 mb-3 display-4">Restaurants catalogue</h1>
                <div id="content" class="p-5">
                    <xsl:call-template name="loadContent" />
                </div>
            </body>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
            <script defer="true">
                let picUrlsMap = [
                <xsl:for-each select="//*[boolean(@source)]">
                    <xsl:text>["</xsl:text>
                    <xsl:value-of select="@source"/>
                    <xsl:text>" , "</xsl:text>
                    <xsl:value-of select="unparsed-entity-uri(@source)"/>
                    <xsl:text>"], </xsl:text>
                </xsl:for-each>
                ];

                const updatePicSource = () => {
                    picUrlsMap.forEach(e => { document.querySelectorAll(`[src="${e[0]}"]`).forEach(el => el.setAttribute("src",e[1]));
                    });
                };

                let state = {
                    loadDocument: "false",
                    showAll: "true",
                    showId: "",
                    sortOn: "",
                    sortOrder: "ascending",
                    sortType: "text",
                    filterOn: "",
                    filterValue: ""
                };

                const xmlDocPath = "restaurants.xml";
                const xslDocPath = "restaurants.xsl";

                let xsltProcessor;
                let xmlDoc;

                const init = async () => {
                    try {
                        const parser = new DOMParser();
                        xsltProcessor = new XSLTProcessor();

                        const xslResponse = await fetch(xslDocPath);
                        const xslText = await xslResponse.text();
                        const xslStylesheet = parser.parseFromString(xslText, "application/xml");
                        xsltProcessor.importStylesheet(xslStylesheet);

                        const xmlResponse = await fetch(xmlDocPath);
                        const xmlText = await xmlResponse.text();
                        xmlDoc = parser.parseFromString(xmlText, "application/xml");
                    } catch(e) {
                        console.error("Failed initialization:", e);
                        document.body.innerHTML =
                            "<h2 style='color:red;text-align:center'>Failed to load data</h2>";
                    }

                    updatePicSource();
                };

                const updateContent = () => {
                    if (!xmlDoc || !xsltProcessor){
                        return;
                    }

                    xsltProcessor.clearParameters();

                    Object.entries(state).forEach(([paramName, paramValue]) => {
                        xsltProcessor.setParameter(null, paramName, paramValue);
                    });

                    let frag = xsltProcessor.transformToFragment(xmlDoc, document);

                    const contentDiv = document.getElementById("content");
                    contentDiv.replaceChildren(frag); // replaceChildren вместо innerHTML+append

                    updatePicSource();
                };

                const filterBy = (filterOn, filterValue) => {
                    state.filterOn = filterOn;
                    state.filterValue = filterValue;

                    updateContent();
                };

                const orderBy = (sortOn, sortOrder, sortType) => {
                    state.sortOn = sortOn;
                    state.sortOrder = sortOrder;
                    state.sortType = sortType;

                    updateContent();
                };

                const showInfoRestaurant = (showId) => {
                    state.showAll = "false";
                    state.showId = showId;

                    updateContent();
                };

                const showAllRestaurants = () => {
                    state.showAll = "true";
                    state.showId = "";

                    updateContent();
                };

                init();
            </script>
        </html>
    </xsl:template>

    <xsl:template name="loadContent">
        <xsl:choose>
            <xsl:when test="$showAll = 'true'">
                <div id="sortOptionsMenu" class="d-flex col-4 offset-4 justify-content-around mb-5">
                    <div class="dropdown">
                        <button class="btn btn-info dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                            Choose Region
                        </button>
                        <ul class="dropdown-menu">
                            <li>
                                <button onclick="filterBy('','')" class="dropdown-item">All regions</button>
                            </li>
                            <xsl:for-each select="restaurantCatalogue/regions/region">
                                <li>
                                    <button onclick="filterBy('region','{@id}')" class="dropdown-item">
                                        <xsl:call-template name="regionTempl">
                                            <xsl:with-param name="regId" select="@id" />
                                        </xsl:call-template>
                                    </button>
                                </li>
                            </xsl:for-each>

                        </ul>
                    </div>

                    <div class="dropdown">
                        <button class="btn btn-info dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                            Choose Chain
                        </button>
                        <ul class="dropdown-menu">
                            <li>
                                <button onclick="filterBy('','')" class="dropdown-item">All restaurants</button>
                            </li>
                            <xsl:for-each select="restaurantCatalogue/chains/chain">
                                <li>
                                    <button onclick="filterBy('chain','{@id}')" class="dropdown-item">
                                        <xsl:value-of select="." />
                                    </button>
                                </li>
                            </xsl:for-each>

                        </ul>
                    </div>

                    <div class="dropdown">
                        <button class="btn btn-info dropdown-toggle" type="button" data-bs-toggle="dropdown">
                            Choose Rating
                        </button>
                        <ul class="dropdown-menu">
                            <li>
                                <button onclick="filterBy('','')" class="dropdown-item">All ratings</button>
                            </li>
                            <li>
                                <button onclick="filterBy('rating','9')" class="dropdown-item">9 &amp; up</button>
                            </li>
                            <li>
                                <button onclick="filterBy('rating','8')" class="dropdown-item">8 &amp; up</button>
                            </li>
                            <li>
                                <button onclick="filterBy('rating','7')" class="dropdown-item">7 &amp; up</button>
                            </li>
                            <li>
                                <button onclick="filterBy('rating','6')" class="dropdown-item">6 &amp; up</button>
                            </li>
                            <li>
                                <button onclick="filterBy('rating','5')" class="dropdown-item">5 &amp; up</button>
                            </li>
                        </ul>
                    </div>

                    <div class="dropdown">
                        <button class="btn btn-info dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                            Order by
                        </button>
                        <ul class="dropdown-menu">
                            <li>
                                <button onclick="orderBy('','ascending','text')" class="dropdown-item">Default</button>
                            </li>
                            <li>
                                <button onclick="orderBy('rating','ascending','text')" class="dropdown-item">Rating ↑</button>
                            </li>
                            <li>
                                <button onclick="orderBy('rating','descending','text')" class="dropdown-item">Rating ↓</button>
                            </li>
                            <li>
                                <button onclick="orderBy('name','ascending','text')" class="dropdown-item">A-Z</button>
                            </li>
                            <li>
                                <button onclick="orderBy('name','descending','text')" class="dropdown-item">Z-A</button>
                            </li>
                        </ul>
                    </div>
                    <xsl:call-template name="allRestaurantsTempl" />
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="oneRestaurantTempl" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="allRestaurantsTempl">
        <div class="d-flex flex-wrap">
            <xsl:for-each select="restaurantCatalogue/restaurants/restaurant">
                <xsl:choose>
                    <xsl:when test="$sortOn='name'">
                        <xsl:sort select="name" order="$sortOrder" data-type="text"/>
                    </xsl:when>
                    <xsl:when test="$sortOn='rating'">
                        <xsl:sort select="number(rating)" order="$sortOrder" data-type="number"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Default, no sorting -->
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:variable name="regId" select="@region" />
                <xsl:variable name="chainId" select="@chain" />
                <xsl:variable name="ratingVal" select="rating"/>
                
                <xsl:if test="(($filterOn = 'chain' and $filterValue = $chainId) or
                       ($filterOn = 'region' and $filterValue = $regId) or
                       ($filterOn = 'rating' and $ratingVal >= number($filterValue)) or
                       $filterOn = '')">

                    <div class="col-6" id="{@id}">
                        <div class="card m-3 align-self-stretch">
                            <div class="row g-0">
                                <div class="col-md-4">
                                    <img src="{picture/@source}" class="img-fluid rounded-start" />
                                </div>
                                <div class="col-md-8">
                                    <div class="card-body h-100">
                                        <h5 class="card-title">
                                            <xsl:value-of select="name"/>
                                            <small class="text-body-secondary">
                                                (<xsl:for-each select="categoryList/category">
                                                    <xsl:value-of select="."/>
                                                    <xsl:if test="position() != last()">, </xsl:if>
                                                </xsl:for-each>)
                                            </small>
                                        </h5>
                                        <p class="card-text">
                                            <xsl:call-template name="regionTempl">
                                                <xsl:with-param name="regId" select="$regId"/>
                                            </xsl:call-template>
                                        </p>
                                        <xsl:if test="$chainId != ''">
                                            <p class="card-text">
                                                Part of: <xsl:value-of select="/restaurantCatalogue/chains/chain[@id=$chainId]"/>
                                            </p>
                                        </xsl:if>
                                        <p class="card-text text-body-secondary">
                                            Rating: <xsl:value-of select="rating"/> / 10
                                        </p>
                                        <div class="align-bottom-right">
                                            <button class="btn btn-primary showMoreBut" onclick="showInfoRestaurant('{@id}')">
                                                Show more info
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>   
                </xsl:if>
            </xsl:for-each>
        </div>

    </xsl:template>

    <xsl:template name="oneRestaurantTempl">
        <xsl:variable name="restaurant" select="/restaurantCatalogue/restaurants/restaurant[@id=$showId]" />
        <xsl:variable name="regId" select="$restaurant/@region" />
        <xsl:variable name="chainId" select="$restaurant/@chain" />

        <div>
            <h1 class="text-center mb-4">
                <xsl:value-of select="$restaurant/name"/>
                <small class="text-body-secondary">
                    (<xsl:for-each select="$restaurant/categoryList/category">
                        <xsl:value-of select="."/>
                        <xsl:if test="position()!=last()">, </xsl:if>
                    </xsl:for-each>)
                </small>
            </h1>

            <div class="d-flex">
                <div id="carouselRestaurant" class="carousel slide col-6" data-bs-ride="carousel">
                    <div class="carousel-inner">
                        <div class="carousel-item active">
                            <img src="{$restaurant/picture/@source}" class="d-block w-100" style="max-height:70vh"/>
                        </div>
                        <xsl:for-each select="$restaurant/gallery/image">
                            <div class="carousel-item">
                                <img src="{@source}" class="d-block w-100" style="max-height:70vh"/>
                            </div>
                        </xsl:for-each>
                    </div>
                    <button class="carousel-control-prev" type="button" data-bs-target="#carouselRestaurant" data-bs-slide="prev">
                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                        <span class="visually-hidden">Previous</span>

                    </button>
                    <button class="carousel-control-next" type="button" data-bs-target="#carouselRestaurant" data-bs-slide="next">
                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                        <span class="visually-hidden">Previous</span>
                    </button>
                </div>

                <div class="col-5 ms-4">
                    <p>
                        <strong>Located in:</strong>
                        <xsl:call-template name="regionTempl">
                            <xsl:with-param name="regId" select="$regId"/>
                        </xsl:call-template>
                    </p>
                    <p>
                        <strong>Address:</strong> 
                        <xsl:value-of select="$restaurant/address"/>
                    </p>
                    <xsl:if test="$restaurant/@chain != ''">
                        <p>
                            <strong>Part of:</strong> 
                            <xsl:value-of select="/restaurantCatalogue/chains/chain[@id=$chainId]"/>
                        </p>
                    </xsl:if>
                    <p>
                        <strong>Capacity:</strong> 
                        <xsl:value-of select="$restaurant/capacity"/>
                    </p>
                    <xsl:if test="$restaurant/workingHours != ''">
                        <p>
                            <strong>Working hours:</strong> 
                            <xsl:value-of select="$restaurant/workingHours"/>
                        </p>
                    </xsl:if>
                    <p>
                        <strong>Rating:</strong> 
                        <xsl:value-of select="$restaurant/rating"/> / 10
                    </p>
                    <p>
                        <strong>Price:</strong> 
                        <xsl:value-of select="$restaurant/priceCategory"/>
                    </p>
                    <p>
                        <xsl:value-of select="$restaurant/description"/>
                    </p>

                    <div class="d-flex justify-content-end">
                        <button class="btn btn-primary" onclick="showAllRestaurants()">Show all restaurants</button>
                    </div>
                </div>
            </div>

            <div class="col-10 offset-1 my-3">
                <div class="d-flex flex-wrap justify-content-around">
                    <xsl:for-each select="$restaurant/services/@*">
                        <div class="btn btn-outline-dark mx-2 my-1 disabled">
                            <xsl:value-of select="name()"/>
                            <xsl:choose>
                                <xsl:when test=".='true'">
                                    <span class="fa fa-check text-success"></span>
                                </xsl:when>
                                <xsl:otherwise>
                                    <span class="fa fa-times text-danger"></span>
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>
                    </xsl:for-each>
                </div>
            </div>

            <xsl:call-template name="menuTemplate">
                <xsl:with-param name="menu" select="$restaurant/menu"/>
            </xsl:call-template>  
        </div>
    </xsl:template>

    <xsl:template name="menuTemplate">
        <xsl:param name="menu"/>

        <div class="col-10 offset-1 my-4">
            <h3>Menu</h3>
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Dish</th>
                        <th>Price</th>
                        <th>Ingredients</th>
                        <th>Allergens</th>
                        <th>Diet</th>
                    </tr>
                </thead>
                <tbody>
                    <xsl:for-each select="$menu/dish">
                        <xsl:sort select="number(price)" data-type="number" order="ascending"/>
                        <tr>
                            <td><xsl:value-of select="name"/></td>
                            <td><xsl:value-of select="price"/></td>
                            <td><xsl:value-of select="ingredients"/></td>
                            <td>
                                <xsl:for-each select="alergens/@*">
                                    <xsl:value-of select="name()"/>
                                    <xsl:choose>
                                        <xsl:when test=".='true' or .='1'">
                                            <span class="fa fa-check text-success"></span>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <span class="fa fa-times text-danger"></span>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:text> </xsl:text>
                                </xsl:for-each>
                            </td>
                            <td>
                                <xsl:for-each select="diet/@*">
                                    <xsl:value-of select="name()"/>
                                    <xsl:choose>
                                        <xsl:when test=".='true' or .='1'">
                                            <span class="fa fa-check text-success"></span>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <span class="fa fa-times text-danger"></span>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:text> </xsl:text>
                                </xsl:for-each>
                            </td>
                        </tr>
                    </xsl:for-each>
                </tbody>
            </table>
        </div>
    </xsl:template>

    <xsl:template name="regionTempl">
        <xsl:param name="regId"/>
        <span>
            <xsl:value-of select="/restaurantCatalogue/regions/region[@id=$regId]/country" />
            <xsl:text>, </xsl:text>
            <xsl:value-of select="/restaurantCatalogue/regions/region[@id=$regId]/municipality" />
            <xsl:text>, </xsl:text>
            <xsl:value-of select="/restaurantCatalogue/regions/region[@id=$regId]/city" />
        </span>
    </xsl:template>

</xsl:stylesheet>