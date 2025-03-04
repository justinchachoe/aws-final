<%@ page import="javax.naming.*, javax.sql.*, java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<html>
<head>
    <title>Login Page</title>
    <link rel="stylesheet" type="text/css" href="/css/styles.css">
</head>
<body>
    <div class="container">
        <h2>Login</h2>
        <form action="login.jsp" method="post">
            <label for="email">Email:</label>
            <input type="email" name="email" required>

            <label for="password">Password:</label>
            <input type="password" name="password" required>

            <input type="submit" value="Login">
        </form>
        <a href="register.jsp" class="register-link">Create an Account</a>
    </div>

    <%
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String msg = null;

        if (email != null && password != null) {
            Connection con = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                Context initCtx = new InitialContext();
                Context envCtx = (Context) initCtx.lookup("java:comp/env");
                DataSource ds = (DataSource) envCtx.lookup("jdbc/mydb");

                con = ds.getConnection();

                String query = "SELECT * FROM users WHERE email = ? AND password = ?";
                pstmt = con.prepareStatement(query);
                pstmt.setString(1, email);
                pstmt.setString(2, password);

                rs = pstmt.executeQuery();

                if (rs.next()) {
                    msg = "Login Successful!";
                } else {
                    msg = "Login Failed. Invalid Email or Password.";
                }
            } catch (Exception e) {
                msg = "Error: " + e.getMessage();
                e.printStackTrace();
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (con != null) con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }

            if (msg != null) {
                out.println("<h3>" + msg + "</h3>");
            }
        }
    %>
</body>
</html>