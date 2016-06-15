<%@page buffer="none" session="false" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="apollo" tagdir="/WEB-INF/tags/apollo" %>	
<fmt:setLocale value="${cms.locale}" />
<cms:bundle basename="org.opencms.apollo.template.schemas.blog">

	<cms:formatter var="content" val="value" rdfa="rdfa">

		<div class="mb-20">
			<c:choose>
				<c:when test="${cms.element.inMemoryOnly}">
					<div class="alert">
						<fmt:message key="apollo.blog.message.edit" />
					</div>
				</c:when>
				<c:otherwise>
					<%-- create author link --%>
					<c:set var="author" value="${fn:trim(value.Author)}" />
					<c:choose>
						<c:when test="${fn:length(author) > 3 && value.AuthorMail.exists}">
							<c:set var="author">
								<a href="mailto:${value.AuthorMail}" title="${author}">${author}</a>
							</c:set>
						</c:when>
						<c:when test="${fn:length(author) > 3}">
							<c:set var="author">${author}</c:set>
						</c:when>
						<c:when test="${value.AuthorMail.exists}">
							<c:set var="author">
								<a href="mailto:${value.AuthorMail}" title="${value.AuthorMail}">${value.AuthorMail}</a>
							</c:set>
						</c:when>
						<c:otherwise>
							<c:set var="author" value=""></c:set>
						</c:otherwise>
					</c:choose>
					<%-- //END create author link --%>
					<!-- blog header -->
					<div class="blog-page">
						<div class="blog">
							<div class="hidden-xs pull-right">
								<a class="btn ap-btn-xs"
									href="<cms:pdf format='%(link.weak:/system/modules/org.opencms.apollo.template.formatters/pages/blog-pdf.jsp:ca595340-57ca-11e5-a989-0242ac11002b)' content='${content.filename}' locale='en'/>"
									target="pdf"> <i class="fa fa-file-pdf-o"></i> Download PDF
								</a>
							</div>

							<div class="headline">
								<h2 ${rdfa.Title}>${value.Title}</h2>
							</div>

							<div class="visible-xs margin-bottom-20">
								<a class="btn ap-btn-red"
									href="<cms:pdf format='%(link.weak:/system/modules/org.opencms.apollo.template.formatters/pages/blog-pdf.jsp:ca595340-57ca-11e5-a989-0242ac11002b)' content='${content.filename}' locale='en'/>"
									target="pdf"> <i class="fa fa-file-pdf-o"></i> Download PDF
								</a>
							</div>

							<ul class="list-unstyled list-inline blog-info">
								<li><i class="icon-calendar"></i> <fmt:formatDate
										value="${cms:convertDate(value.Date)}" dateStyle="SHORT"
										timeStyle="SHORT" type="both" /></li>
								<c:if test="${author ne ''}">
									<li><i class="icon-pencil"></i> ${author}</li>
								</c:if>
							</ul>
							<c:set var="categories" value="${content.readCategories}" />
							<c:if test="${not categories.isEmpty}">
								<ul class="pull-left list-unstyled list-inline blog-tags">
									<li><i class="fa fa-tag"></i>&nbsp; <c:forEach var="category"
											items="${categories.leafItems}"
											varStatus="status">
											<span class="label rounded label-light">${category.title}</span>
										</c:forEach></li>
								</ul>
							</c:if>
						</div>
					</div>
					<!-- //END blog header -->

					<!-- paragraphs -->
					<c:forEach var="paragraph" items="${content.valueList.Paragraph}"
						varStatus="status">

						<div class="paragraph margin-bottom-20">

							<c:set var="imgalign">noimage</c:set>
							<c:if test="${paragraph.value.Image.exists}">
								<c:set var="imgalign">
									<cms:elementsetting name="imgalign" default="left" />
								</c:set>
							</c:if>

							<c:if test="${paragraph.value.Headline.isSet}">
								<div class="headline">
									<h4 ${paragraph.rdfa.Headline}>${paragraph.value.Headline}</h4>
								</div>
							</c:if>

							<c:choose>
								<c:when test="${imgalign == 'noimage'}">
									<span ${paragraph.rdfa.Image}></span>
									<div ${paragraph.rdfa.Text}>${paragraph.value.Text}</div>
									<c:if test="${paragraph.value.Link.exists}">
										<p>
											<a class="btn ap-btn-sm"
												href="<cms:link>${paragraph.value.Link.value.URI}</cms:link>">${paragraph.value.Link.value.Text}</a>
										</p>
									</c:if>
								</c:when>
								<c:when test="${imgalign == 'left' or imgalign == 'right'}">

                                    <c:set var="copyright">${paragraph.value.Image.value.Copyright}</c:set>
									<%@include file="%(link.strong:/system/modules/org.opencms.apollo.template.formatters/elements/copyright.jsp:fd92c207-89fe-11e5-a24e-0242ac11002b)" %>

									<div class="row">
										<div class="col-md-4 pull-${imgalign}">
										
											<apollo:image-kenburn image="${paragraph.value.Image}"
														setting="${cms.element.setting}"
														width="400"
														content="${content}" />
											
										</div>
										<div class="col-md-8">
											<div ${paragraph.rdfa.Text}>${paragraph.value.Text}</div>
											<c:if test="${paragraph.value.Link.exists}">
												<p>
													<a class="btn ap-btn-sm"
														href="<cms:link>${paragraph.value.Link.value.URI}</cms:link>">${paragraph.value.Link.value.Text}</a>
												</p>
											</c:if>
										</div>
									</div>
								</c:when>
							</c:choose>
						</div>

					</c:forEach>
					<!-- //END paragraphs -->

					<c:if test="${content.isEditable}">
						<a
							href="<cms:link>${cms.subSitePath}blog/post-a-new-blog-entry/</cms:link>?fileId=${content.id}">
							<button type="button" class="btn btn-default">Edit this
								blog entry</button>
						</a>
					</c:if>
				</c:otherwise>
			</c:choose>
		</div>
	</cms:formatter>
</cms:bundle>
