<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AWS의 세계에 오신 것을 환영합니다</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <div class="cloud-bg"></div>
    <div class="container">
        <div class="header">
            <h1>AWS의 세계에 오신 것을 환영합니다</h1>
        </div>
        
        <div class="card">
            <c:choose>
                <c:when test="${empty sessionScope.username}">
                    <p>AWS 클라우드 서비스의 세계로 오신 것을 환영합니다. 로그인하시거나 회원가입을 통해 더 많은 서비스를 이용하실 수 있습니다.</p>
                    <div style="display: flex; justify-content: center; gap: 20px; margin-top: 30px;">
                        <a href="login.jsp" class="btn btn-primary">로그인</a>
                        <a href="register.jsp" class="btn btn-secondary">회원가입</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="welcome-container">
                        <p class="welcome-message">${sessionScope.username}님 환영합니다!</p>
                        <p>AWS 클라우드 서비스를 이용해 주셔서 감사합니다.</p>
                        <a href="logout.jsp" class="btn btn-primary" style="margin-top: 20px;">로그아웃</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html> 