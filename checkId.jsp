<%@page import="com.google.gson.Gson"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="vo.User"%>
<%@page import="dao.UserDao"%>
<%@ page language="java" contentType="text/plain; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
	/*
		요청 URL
			localhost/comm/checkId.jsp?id =eungsulee
		요청 파라미터
			id=xxx
		응답 데이터
			JSON Object 구조의 텍스트
			{"exist":true, "id":"hong"}
			{"exist":false, "id":"hong"}
	*/
	
	String id = request.getParameter("id");

	UserDao userDao = new UserDao();
	User savedUser = userDao.getUserById(id);
	
	//Map객체에 id 중복체크 결과를 저장한다.
	Map<String, Object> map = new HashMap<>();
	map.put("id", id);
	
	if(savedUser != null){
		map.put("exist", true);
	}else {
		map.put("exist", false);
	}
	
	// Gson을 이용해서 Map객체의 JSON Object 구조의 텍스트로 변환한다.
	Gson gson = new Gson();
	String jsonText = gson.toJson(map);
	
	//JSON 텍스트를 응답으로 보낸다.
	out.write(jsonText);
	
	
	
	
	
	
	
	
	
	
%>