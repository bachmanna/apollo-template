<%@page buffer="none" session="false" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="${cms.locale}" />
<cms:bundle basename="org.opencms.apollo.template.extensions.imagegallery">
	<cms:formatter var="content">
		<div id="imagegallery" class="mb-20 clearfix">
			<c:choose>
				<c:when test="${cms.element.inMemoryOnly}">
					<div class="alert danger">
						<fmt:message key="apollo.imagegallery.message.new" />
					</div>
				</c:when>
				<c:when test="${cms.edited}">
					<div class="alert warning">
						<div class="alert">
							<fmt:message key="apollo.imagegallery.message.edit" />
						</div>
						${cms.enableReload}
					</div>
				</c:when>
				<c:otherwise>
					<div id="links"></div>
					<div class="spinner mt-20 animated">
						<i class="fa fa-spinner"></i>
					</div>
					<button class="btn btn-primary col-xs-12 mt-5 mb-20 animated"
						id="more">
						<fmt:message key="apollo.imagegallery.message.more" />
					</button>



				</c:otherwise>
			</c:choose>



			<c:set var="solrParamType">fq=type:"image"</c:set>
			<c:set var="solrParamDirs">&fq=parent-folders:"${cms.requestContext.siteRoot}${content.value.ImageFolder}"</c:set>
			<c:set var="extraSolrParams">${solrParamType}${solrParamDirs}&sort=path asc</c:set>
			<c:set var="searchConfig">
		{ "ignorequery" : true,
		  "extrasolrparams" : "${fn:replace(extraSolrParams,'"','\\"')}",
		  pagesize: 500			  
		 }
</c:set>

			<!-- Root element of PhotoSwipe. Must have class pswp. -->
			<div class="pswp" tabindex="-1" role="dialog" aria-hidden="true">

				<!-- Background of PhotoSwipe. 
    It's a separate element, as animating opacity is faster than rgba(). -->
				<div class="pswp__bg"></div>
				<!-- Slides wrapper with overflow:hidden. -->
				<div class="pswp__scroll-wrap">
					<!-- Container that holds slides. PhotoSwipe keeps only 3 slides in DOM to save memory. -->
					<div class="pswp__container">
						<!-- don't modify these 3 pswp__item elements, data is added later on -->
						<div class="pswp__item"></div>
						<div class="pswp__item"></div>
						<div class="pswp__item"></div>
					</div>
					<!-- Default (PhotoSwipeUI_Default) interface on top of sliding area. Can be changed. -->
					<div class="pswp__ui pswp__ui--hidden">

						<div class="pswp__top-bar">
							<!--  Controls are self-explanatory. Order can be changed. -->
							<div class="pswp__counter"></div>
							<button class="pswp__button pswp__button--close"
								title="Close (Esc)"></button>
							<button class="pswp__button pswp__button--zoom"
								title="Zoom in/out"></button>
							<!-- Preloader demo http://codepen.io/dimsemenov/pen/yyBWoR -->
							<!-- element will get class pswp__preloader--active when preloader is running -->
							<div class="pswp__preloader">
								<div class="pswp__preloader__icn">
									<div class="pswp__preloader__cut">
										<div class="pswp__preloader__donut"></div>
									</div>
								</div>
							</div>
						</div>
						<div
							class="pswp__share-modal pswp__share-modal--hidden pswp__single-tap">
							<div class="pswp__share-tooltip"></div>
						</div>
						<button class="pswp__button pswp__button--arrow--left"
							title="Previous (arrow left)"></button>
						<button class="pswp__button pswp__button--arrow--right"
							title="Next (arrow right)"></button>
						<div class="pswp__caption">
							<div class="pswp__caption__center"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<c:set var="linkInnerPage">
			<cms:link>%(link.strong:/system/modules/org.opencms.apollo.template.extensions/elements/imagegallery-inner.jsp:9bb25674-8f80-11e5-a6ad-0242ac11002b)</cms:link>
		</c:set>
		<script>
			var autoload = false;
			var page = 1;
			var items = ${not empty cms.element.settings.imagesPerPage ? cms.element.settings.imagesPerPage:20};	
			var css = '${cms.element.settings.cssClass}';			

			function loadImages() {
				if(page == 2){					
					autoload = true;
				}
				$('#more').removeClass('fadeIn').addClass('fadeOut');
				$('.spinner').removeClass('bounceOut').addClass('bounceIn');

				$.get("${linkInnerPage}?items=" + items + "&page=" + page
						+ "&path=\"${cms.requestContext.siteRoot}${content.value.ImageFolder}\"&title=${cms.element.settings.showTitle}&css="+css,
						function(images) {
							if (images.length == 0) {
								$('#more').remove();
							} else {
								$("#links").append(images);
								$(".image-gallery").each(function(index){									
									$(this).click(function(e){
									 e.preventDefault();
								     openPhotoSwipe(index);	
								});
								});					
								 
								if($('.hideMore').length == 0){
									$('#more').removeClass('fadeOut').addClass('fadeIn');
								}else{
									$('#more').remove();
								}
							}
							$('.spinner').removeClass('bounceIn').addClass('bounceOut');							
						});
					page++;	
				}

			function init() {
				loadImages();
				$('#more').click(function() {
					loadImages();
				});
				$(window).scroll(function() {
					if(autoload && $('#more').visible() && $('.hideMore').length == 0){
						loadImages();
					}
				});
			}
		</script>
		<c:set var="items"></c:set>

		<cms:search configString="${searchConfig}" var="search">
			<c:if test="${search.numFound > 0 }">
				<c:forEach var="result" items="${search.searchResults}"
					varStatus="status">
					<c:set var="image" value="${result.searchResource}" />
					<c:set var="title">${fn:trim(result.fields['Title_dprop_s'])}</c:set>
					<c:set var="items">${items}
   						{
        					src: '<cms:link>${image.rootPath}</cms:link>',
        					${result.fields['image.size_dprop_s']}
    					},
					</c:set>
				</c:forEach>
			</c:if>
		</cms:search>
		<script>
			var openPhotoSwipe = function(index) {
    			var pswpElement = document.querySelectorAll('.pswp')[0];
			    var items = [${items}];			    
			    var options = {
			           history: true,
			           focus: true,
			           showAnimationDuration: 0,
			           hideAnimationDuration: 0,
			           index: index
			       };
       			new PhotoSwipe( pswpElement, PhotoSwipeUI_Default, items, options).init();
   			};
		</script>
	</cms:formatter>
</cms:bundle>