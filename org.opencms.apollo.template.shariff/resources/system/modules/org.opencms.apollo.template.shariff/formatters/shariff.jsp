<%@page buffer="none" session="false" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<cms:formatter var="content" val="value" rdfa="rdfa">
<fmt:setLocale value="${cms.locale}" />
<cms:bundle basename="org.opencms.apollo.template.schemas.shariff">
	<div class="ap-shariff ${cms.element.setting.wrapperclass.isSet ? cms.element.setting.wrapperclass : 'mb-20' }">
		<c:choose>
			<c:when test="${cms.element.inMemoryOnly}">
				<div class="alert alert-danger"><fmt:message key="apollo.shariff.message.new" /></div>
			</c:when>
			<c:when test="${cms.edited}">
				<div>${cms.enableReload}</div>
				<div class="alert alert-danger"><fmt:message key="apollo.shariff.message.edited" /></div>
			</c:when>
			<c:otherwise>
				<c:if test="${cms.element.settings.hidetitle ne 'true'}"><div class="headline"><h2 ${rdfa.Title}>${value.Title}</h2></div></c:if>
				<c:set var="services">[&quot;${fn:replace(value.Services, ',', '&quot;,&quot;')}&quot;]</c:set>
				<c:set var="theme">
					<c:choose>
						<c:when test="${value.Theme.isSet}">${value.Theme}</c:when>
						<c:otherwise>standard</c:otherwise>
					</c:choose>
				</c:set>
				<c:set var="orientation">
					<c:choose>
						<c:when test="${value.Orientation.isSet}">${value.Orientation}</c:when>
						<c:otherwise>horizontal</c:otherwise>
					</c:choose>
				</c:set>
				<c:set var="lang">en</c:set>
				<c:if test="${fn:contains('bg,de,en,es,fi,hr,hu,ja,ko,no,pl,pt,ro,ru,sk,sl,sr,sv,tr,zh', cms.locale)}">
					<c:set var="lang">${cms.locale}</c:set>
				</c:if>
				<div class="shariff" data-services="${services}" data-theme="${theme}" data-orientation="${orientation}" data-lang="${lang}"></div>
			</c:otherwise>
		</c:choose>
	</div>
</cms:bundle>
</cms:formatter>