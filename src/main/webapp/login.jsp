<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.naming.*, javax.sql.*, java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 - AWS 웹 애플리케이션</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <div class="cloud-bg"></div>
    <div class="container">
        <div class="header">
            <h1>로그인</h1>
        </div>
        
        <div class="card">
            <%
                // 디버깅을 위한 로그 출력
                System.out.println("로그인 페이지 접근");
                System.out.println("세션 ID: " + session.getId());
                System.out.println("현재 세션 username: " + session.getAttribute("username"));
                
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String errorMessage = null;
                
                if (email != null && password != null) {
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    
                    try {
                        Context initContext = new InitialContext();
                        Context envContext = (Context) initContext.lookup("java:comp/env");
                        DataSource ds = (DataSource) envContext.lookup("jdbc/mydb");
                        conn = ds.getConnection();
                        
                        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
                        pstmt = conn.prepareStatement(sql);
                        pstmt.setString(1, email);
                        pstmt.setString(2, password);
                        rs = pstmt.executeQuery();
                        
                        if (rs.next()) {
                            // 로그인 성공
                            String username = rs.getString("username");
                            session.setAttribute("username", username);
                            
                            // 디버깅을 위한 로그 출력
                            System.out.println("로그인 성공: " + username);
                            System.out.println("세션에 username 저장 후 세션 ID: " + session.getId());
                            
                            // URL 파라미터를 통해 username 전달
                            response.sendRedirect("index.jsp?login=success&username=" + java.net.URLEncoder.encode(username, "UTF-8"));
                            return;
                        } else {
                            errorMessage = "이메일 또는 비밀번호가 올바르지 않습니다.";
                            System.out.println("로그인 실패: 이메일 또는 비밀번호가 올바르지 않음");
                        }
                    } catch (Exception e) {
                        errorMessage = "데이터베이스 오류: " + e.getMessage();
                        System.out.println("로그인 중 오류 발생: " + e.getMessage());
                        e.printStackTrace();
                    } finally {
                        try {
                            if (rs != null) rs.close();
                            if (pstmt != null) pstmt.close();
                            if (conn != null) conn.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                }
            %>
            
            <% if (errorMessage != null) { %>
                <div class="message message-error">
                    <%= errorMessage %>
                </div>
            <% } %>
            
            <form action="login.jsp" method="post">
                <div class="form-group">
                    <label for="email">이메일</label>
                    <input type="email" id="email" name="email" required>
                </div>
                
                <div class="form-group">
                    <label for="password">비밀번호</label>
                    <input type="password" id="password" name="password" required>
                </div>
                
                <div style="text-align: center;">
                    <button type="submit" class="btn btn-primary">로그인</button>
                </div>
            </form>
            
            <div style="text-align: center; margin-top: 20px;">
                <p>계정이 없으신가요? <a href="register.jsp">회원가입</a></p>
                <p><a href="index.jsp">메인 페이지로 돌아가기</a></p>
            </div>
        </div>
    </div>
</body>
</html> 