<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 세션 체크
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>환영합니다</title>
    <link rel="stylesheet" href="css/styles.css">
    <script>
        // 2초 후 메인 페이지로 자동 이동
        setTimeout(function() {
            window.location.href = "index.jsp";
        }, 2000);
    </script>
</head>
<body>
    <div class="cloud-bg"></div>
    <div class="container">
        <div class="header">
            <h1>회원 등록 완료</h1>
        </div>
        
        <div class="card">
            <div class="welcome-container" style="text-align: center;">
                <p class="welcome-message" style="font-size: 1.5em;"><strong><%= username %></strong>님</p>
                <p class="welcome-message" style="font-size: 1.5em; margin-top: 10px;">회원 등록을 환영합니다!</p>
                <p style="margin-top: 20px; color: #666;">잠시 후 메인 페이지로 이동합니다...</p>
            </div>
        </div>
    </div>
</body>
</html> 