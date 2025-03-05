<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 디버깅을 위한 로그 출력
    System.out.println("로그아웃 처리");
    System.out.println("로그아웃 전 세션 ID: " + session.getId());
    System.out.println("로그아웃 전 세션 username: " + session.getAttribute("username"));
    
    // 세션 무효화
    session.invalidate();
    System.out.println("세션 무효화 완료");
    
    // 메인 페이지로 리다이렉트
    response.sendRedirect("index.jsp");
%> 