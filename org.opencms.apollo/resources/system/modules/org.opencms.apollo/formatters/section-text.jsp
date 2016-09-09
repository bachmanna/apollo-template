<%@ page buffer="none" session="false" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ taglib prefix="apollo" tagdir="/WEB-INF/tags/apollo" %>

<cms:formatter var="content">
<apollo:text 
    setting="${cms.element.setting}" 
    text="${content.value.Text}" 
    link="${content.value.Link}" />
</cms:formatter>