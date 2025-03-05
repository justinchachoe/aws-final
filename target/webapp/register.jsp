<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.naming.*, javax.sql.*, java.sql.*, java.util.regex.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 - AWS 웹 애플리케이션</title>
    <link rel="stylesheet" href="css/styles.css">
    <script>
        function validateForm() {
            var email = document.getElementById("email").value;
            var password = document.getElementById("password").value;
            var confirmPassword = document.getElementById("confirmPassword").value;
            
            // 이메일 정규식 검사
            var emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
            if (!emailRegex.test(email)) {
                alert("유효한 이메일 주소를 입력해주세요.");
                return false;
            }
            
            // 비밀번호 일치 검사
            if (password !== confirmPassword) {
                alert("비밀번호가 일치하지 않습니다.");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <div class="cloud-bg"></div>
    <div class="container">
        <div class="header">
            <h1>회원가입</h1>
        </div>
        
        <div class="card">
            <%
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String confirmPassword = request.getParameter("confirmPassword");
                String message = null;
                String messageType = null;
                
                if (email != null && password != null && confirmPassword != null) {
                    // 서버 측 이메일 정규식 검사
                    Pattern emailPattern = Pattern.compile("^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}$");
                    Matcher matcher = emailPattern.matcher(email);
                    
                    if (!matcher.matches()) {
                        message = "유효한 이메일 주소를 입력해주세요.";
                        messageType = "error";
                    } else if (!password.equals(confirmPassword)) {
                        message = "비밀번호가 일치하지 않습니다.";
                        messageType = "error";
                    } else {
                        Connection conn = null;
                        PreparedStatement pstmt = null;
                        
                        try {
                            Context initContext = new InitialContext();
                            Context envContext = (Context) initContext.lookup("java:comp/env");
                            DataSource ds = (DataSource) envContext.lookup("jdbc/mydb");
                            conn = ds.getConnection();
                            
                            // 이메일 존재 여부 확인
                            String checkEmailSql = "SELECT COUNT(*) FROM users WHERE email = ?";
                            pstmt = conn.prepareStatement(checkEmailSql);
                            pstmt.setString(1, email);
                            ResultSet rs = pstmt.executeQuery();
                            rs.next();
                            int emailCount = rs.getInt(1);
                            rs.close();
                            pstmt.close();
                            
                            if (emailCount > 0) {
                                message = "이미 사용 중인 이메일입니다.";
                                messageType = "error";
                            } else {
                                // 새 사용자 등록 - username에 이메일 전체 저장
                                String insertSql = "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";
                                pstmt = conn.prepareStatement(insertSql);
                                pstmt.setString(1, email); // username에 이메일 전체 저장
                                pstmt.setString(2, email);
                                pstmt.setString(3, password);
                                pstmt.executeUpdate();
                                
                                // 세션에 사용자 정보 저장
                                session.setAttribute("username", email);
                                
                                // 디버깅을 위한 로그 출력
                                System.out.println("회원가입 성공: " + email);
                                System.out.println("세션 ID: " + session.getId());
                                System.out.println("세션 username: " + session.getAttribute("username"));
                                
                                // welcome.jsp로 리다이렉트 (URL 파라미터 추가)
                                response.sendRedirect("welcome.jsp?username=" + java.net.URLEncoder.encode(email, "UTF-8") + "&registered=true");
                                return;
                            }
                        } catch (Exception e) {
                            message = "데이터베이스 오류: " + e.getMessage();
                            messageType = "error";
                            e.printStackTrace();
                        } finally {
                            try {
                                if (pstmt != null) pstmt.close();
                                if (conn != null) conn.close();
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        }
                    }
                }
            %>
            
            <% if (message != null) { %>
                <div class="message message-<%= messageType %>">
                    <%= message %>
                </div>
            <% } %>
            
            <form action="register.jsp" method="post" onsubmit="return validateForm()">
                <div class="form-group">
                    <label for="email">이메일</label>
                    <input type="email" id="email" name="email" value="<%= email != null ? email : "" %>" required>
                </div>
                
                <div class="form-group">
                    <label for="password">비밀번호</label>
                    <input type="password" id="password" name="password" required>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">비밀번호 확인</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required>
                </div>
                
                <div style="text-align: center;">
                    <button type="submit" class="btn btn-primary">회원가입</button>
                </div>
            </form>
            
            <div style="text-align: center; margin-top: 20px;">
                <p>이미 계정이 있으신가요? <a href="login.jsp">로그인</a></p>
                <p><a href="index.jsp">메인 페이지로 돌아가기</a></p>
            </div>
        </div>
    </div>
</body>
</html> 