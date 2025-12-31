<?xml version="1.0" encoding="UTF-8"?>

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
                    #content {
                        max-width: 1400px;
                        margin: 0 auto;
                    }
                    .card {
                        margin-bottom: 25px;
                        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                        border: none;
                        border-radius: 12px;
                        overflow: hidden;
                        transition: transform 0.3s ease, box-shadow 0.3s ease;
                        height: 100%;
                    }
                    .card:hover {
                        transform: translateY(-5px);
                        box-shadow: 0 8px 15px rgba(0,0,0,0.2);
                    }
                    .card-title {
                        font-weight: bold;
                        font-size: 1.3rem;
                        margin-bottom: 10px;
                        color: #333;
                    }
                    .card-text {
                        color: #555;
                        margin-bottom: 8px;
                        font-size: 0.95rem;
                    }
                    .card-img-container {
                        height: 200px;
                        overflow: hidden;
                        background-color: #f0f0f0;
                    }
                    .card-img-container img {
                        width: 100%;
                        height: 100%;
                        object-fit: cover;
                        transition: transform 0.3s ease;
                    }
                    .card:hover .card-img-container img {
                        transform: scale(1.05);
                    }
                    .rating-badge {
                        display: inline-block;
                        background: linear-gradient(135deg, #5874eeff 0%, #945fcaff 100%);
                        color: white;
                        padding: 5px 12px;
                        border-radius: 20px;
                        font-weight: bold;
                        font-size: 0.9rem;
                        margin-top: 5px;
                    }
                    .category-badge {
                        display: inline-block;
                        background-color: #e9ecef;
                        color: #40464cff;
                        padding: 3px 8px;
                        border-radius: 12px;
                        font-size: 0.85rem;
                        margin-right: 5px;
                    }
                    .showMoreBut {
                        margin-top: 10px;
                        border-radius: 25px;
                        padding: 8px 20px;
                        font-weight: 500;
                        transition: all 0.3s ease;
                    }
                    .showMoreBut:hover {
                        transform: scale(1.05);
                    }
                    .location-icon, .chain-icon {
                        color: #79828aff;
                        margin-right: 5px;
                    }
                    @media (min-width: 1200px) {
                        .restaurant-card-wrapper {
                            flex: 0 0 48%;
                            max-width: 48%;
                        }
                    }
                    @media (min-width: 768px) and (max-width: 1199px) {
                        .restaurant-card-wrapper {
                            flex: 0 0 48%;
                            max-width: 48%;
                        }
                    }
                    @media (max-width: 767px) {
                        .restaurant-card-wrapper {
                            flex: 0 0 100%;
                            max-width: 100%;
                        }
                    }
                    .restaurant-card-wrapper {
                        padding: 0 15px;
                        box-sizing: border-box;
                    }
                    .restaurants-container {
                        width: 100%;
                        margin: 0 auto;
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
                    <xsl:value-of select="@source"/>
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
                <div id="sortOptionsMenu" class="d-flex justify-content-center flex-wrap gap-3 mb-5">
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
                        <button class="btn btn-info dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
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
                        <button class="btn btn-info dropdown-toggle" type="button"  data-bs-toggle="dropdown" aria-expanded="false">
                            Choose Category
                        </button>
                        <ul class="dropdown-menu">
                            <li>
                                <button onclick="filterBy('','')" class="dropdown-item">
                                    All categories
                                </button>
                            </li>

                            <li>
                                <button onclick="filterBy('category','fish')" class="dropdown-item">Fish</button>
                            </li>
                            <li>    
                                <button onclick="filterBy('category','vegan')" class="dropdown-item">Vegan</button>
                            </li>
                            <li>
                                <button onclick="filterBy('category','vegetarian')" class="dropdown-item">Vegetarian</button>
                            </li>
                            <li>
                                <button onclick="filterBy('category','asian')" class="dropdown-item">Asian</button>
                            </li>
                            <li>
                                <button onclick="filterBy('category','italian')" class="dropdown-item">Italian</button>
                            </li>
                            <li>
                                <button onclick="filterBy('category','bulgarian')" class="dropdown-item">Bulgarian</button>
                            </li>
                            <li>
                                <button onclick="filterBy('category','fastFood')" class="dropdown-item">Fast Food</button>
                            </li>
                            <li>
                                <button onclick="filterBy('category','grill')" class="dropdown-item">Grill</button>
                            </li>

                        </ul>
                    </div>

                    <div class="dropdown">
                        <button class="btn btn-info dropdown-toggle" type="button"  data-bs-toggle="dropdown" aria-expanded="false">
                            Choose Price Category
                        </button>
                        <ul class="dropdown-menu">
                            <li>        
                                <button onclick="filterBy('','')" class="dropdown-item">All price Categories</button>
                            </li>
                            <li>
                                <button onclick="filterBy('price','$')" class="dropdown-item">$</button>
                            </li>
                            <li>
                                <button onclick="filterBy('price','$$')" class="dropdown-item">$$</button>
                            </li>
                            <li>
                                <button onclick="filterBy('price','$$$')" class="dropdown-item">$$$</button>
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
                            <li>
                                <button onclick="orderBy('priceCategory','ascending','text')" class="dropdown-item">Price Category ↑</button>
                            </li>
                            <li>
                                <button onclick="orderBy('priceCategory','descending','text')" class="dropdown-item">Price Category ↓</button>
                            </li>
                            <li>
                                <button onclick="orderBy('chain','ascending','text')" class="dropdown-item">Chain ↑</button>
                            </li>
                            <li>
                                <button onclick="orderBy('chain','descending','text')" class="dropdown-item">Chain ↓</button>
                            </li>
                        </ul>
                    </div>
                </div>
                <xsl:call-template name="allRestaurantsTempl" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="oneRestaurantTempl" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="allRestaurantsTempl">
        <div class="restaurants-container d-flex flex-wrap justify-content-center">
            <xsl:choose>
                <xsl:when test="$sortOn='name'">
                    <xsl:for-each select="restaurantCatalogue/restaurants/restaurant">
                        <xsl:sort select="name" order="{$sortOrder}" data-type="text"/>
                        <xsl:call-template name="restaurantTempl" />
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="$sortOn='rating'">
                    <xsl:for-each select="restaurantCatalogue/restaurants/restaurant">
                        <xsl:sort select="number(rating)" order="{$sortOrder}" data-type="number"/>
                        <xsl:call-template name="restaurantTempl" />
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="$sortOn='priceCategory'">
                    <xsl:for-each select="restaurantCatalogue/restaurants/restaurant">
                        <xsl:sort select="priceCategory" order="{$sortOrder}" data-type="text"/>
                        <xsl:call-template name="restaurantTempl" />
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="$sortOn='chain'">
                    <xsl:for-each select="restaurantCatalogue/restaurants/restaurant">
                        <xsl:sort select="/restaurantCatalogue/chains/chain[@id=current()/@chain]" order="{$sortOrder}" data-type="text"/>
                        <xsl:call-template name="restaurantTempl" />
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="restaurantCatalogue/restaurants/restaurant">
                        <xsl:call-template name="restaurantTempl" />
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>

    <xsl:template name="restaurantTempl">
        <xsl:variable name="regId" select="@region" />
        <xsl:variable name="chainId" select="@chain" />
        <xsl:variable name="ratingVal" select="rating"/>
        
        <xsl:if test="(($filterOn = 'chain' and $filterValue = $chainId) or
               ($filterOn = 'region' and $filterValue = $regId) or
               ($filterOn = 'rating' and $ratingVal >= number($filterValue)) or
               ($filterOn = 'category' and categoryList/category = $filterValue) or
               ($filterOn = 'price' and priceCategory = $filterValue) or
               $filterOn = '')">

            <div class="restaurant-card-wrapper px-2" id="{@id}">
                <div class="card">
                    <div class="card-img-container">
                        <img src="{picture/@source}" class="img-fluid" alt="{name}" />
                    </div>
                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title">
                            <xsl:value-of select="name"/>
                        </h5>
                        <div class="mb-2">
                            <xsl:for-each select="categoryList/category">
                                <span class="restaurant-category">
                                    <xsl:call-template name="categoryLabel">
                                        <xsl:with-param name="cat" select="."/>
                                    </xsl:call-template>
                                </span>
                            </xsl:for-each>
                        </div>
                        <p class="card-text">
                            <i class="fa fa-map-marker location-icon"></i>
                            <xsl:call-template name="regionTempl">
                                <xsl:with-param name="regId" select="$regId"/>
                            </xsl:call-template>
                        </p>
                        <xsl:if test="$chainId != ''">
                            <p class="card-text">
                                <i class="fa fa-building chain-icon"></i>
                                <strong>Chain:</strong> <xsl:value-of select="/restaurantCatalogue/chains/chain[@id=$chainId]"/>
                            </p>
                        </xsl:if>
                        <p class="card-text">
                            <i class="fa fa-dollar"></i>
                            <strong> Price Category:</strong> <xsl:value-of select="priceCategory"/>
                        </p>
                        <div class="mt-auto">
                            <span class="restaurant-rating">
                                <i class="fa fa-star"></i> <xsl:value-of select="rating"/> / 10
                            </span>
                            <div class="mt-3">
                                <button class="btn btn-primary showMoreBut w-100" onclick="showInfoRestaurant('{@id}')">
                                    <i class="fa fa-info-circle"></i> Show More Details
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>   
        </xsl:if>
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
                        <xsl:call-template name="categoryLabel">
                            <xsl:with-param name="cat" select="."/>
                        </xsl:call-template>
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
                    <xsl:if test="$restaurant/phone != ''">
                        <p>
                            <strong>Phone:</strong> 
                            <xsl:value-of select="$restaurant/phone"/>
                        </p>
                    </xsl:if>
                    <xsl:if test="$restaurant/website != ''">
                        <p>
                            <strong>Website:</strong> 
                            <a href="{$restaurant/website}" target="_blank">
                                <xsl:value-of select="$restaurant/website"/>
                            </a>
                        </p>
                    </xsl:if>
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
            <xsl:value-of select="/restaurantCatalogue/regions/region[@id=$regId]/regionName" />
            <xsl:text>, </xsl:text>
            <xsl:value-of select="/restaurantCatalogue/regions/region[@id=$regId]/municipality" />
            <xsl:text>, </xsl:text>
            <xsl:value-of select="/restaurantCatalogue/regions/region[@id=$regId]/city" />
        </span>
    </xsl:template>

    <xsl:template name="categoryLabel">
        <xsl:param name="cat"/>

        <xsl:choose>
            <xsl:when test="$cat = 'fish'">Fish restaurant</xsl:when>
            <xsl:when test="$cat = 'vegan'">Vegan restaurant</xsl:when>
            <xsl:when test="$cat = 'vegetarian'">Vegetarian restaurant</xsl:when>
            <xsl:when test="$cat = 'asian'">Asian restaurant</xsl:when>
            <xsl:when test="$cat = 'italian'">Italian restaurant</xsl:when>
            <xsl:when test="$cat = 'bulgarian'">Bulgarian restaurant</xsl:when>
            <xsl:when test="$cat = 'fastFood'">Fast food</xsl:when>
            <xsl:when test="$cat = 'grill'">Grill restaurant</xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$cat"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


</xsl:stylesheet>