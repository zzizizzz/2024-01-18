<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
<title>커뮤니티</title>
</head>
<body>
<jsp:include page="include/navbar.jsp">
	<jsp:param value="register" name="menu"/>
</jsp:include>
<div class="container"> 
	<div class="row">
		<div class="col-12">
			<h1 class="mb-3">회원가입 폼</h1>
<%
 	/*
 		요청 URL
 			회원가입 링크를 클릭한 경우
 				localhost/comm/registerform.jsp
			회원가입 실패로 재요청하는 경우
 				localhost/comm/registerform.jsp?fail=id
 				localhost/comm/registerform.jsp?fail=email
 		요청파라미터
 			fail=xxx
 			* 정상적인 요청인 경우 fail의 요청파라미터값을 조회했을 떄 null이다.
 			* 가입실패로 인한 재요청인경우 fail의 요청파라미터값은 id혹은 eamil이다.
 	*/
 	
 	String fail= request.getParameter("fail");
%>
			
<%
	if("id".equals(fail)) {
%>
			<div class="alert alert-danger">
				<strong>회원가입 오류</strong> 이미사용중인아이디입니다.
			</div>
			
<%
	}
%>
			
			<form class="border bg-light p-3" method="post" action="register.jsp" onsubmit="checkRegisterForm(event)">
				<div class="form-group">
					<label class="form-label">아이디</label>
					<input type="text" class="form-control" name="id" onkeyup="checkId()"/>
					<div id="id-feedback" class="form-text">
					</div>
				</div>
				<div class="form-group mb-3">
					<label class="form-label">비밀번호</label>
					<input type="password" onkeyup="checkPassword()" class="form-control" name="password"/>
					<div id="password-valid-feedback" class="form-text text-success d-none">
						유효한 비밀번호입니다.
					</div>
					<div id="password-invalid-feedback" class="form-text text-danger d-none">
						비밀번호는 8글자이상, 영어 대소문자+숫자+특수문자 조합입니다.
					</div>
				</div>
				<div class="form-group">
					<label class="form-label">이름</label>
					<input type="text" class="form-control" name="name"/>
				</div>
				<div class="form-group">
					<label class="form-label">이메일</label>
					<input type="text" class="form-control" name="email"/>
				</div>
								<div class="form-group">
					<label class="form-label">전화번호</label>
					<input type="text" class="form-control" name="tel"/>
				</div>
				<div class="text-end">
				<a href="" class="btn btn-secondary">취소</a>
				<button type="submit" class="btn btn-primary">가입</button>
				
				</div>
			</form>
		</div>
	</div>
</div>
<script type="text/javascript">		
	function checkId() {
	  	let idRegExp = /^[a-zA-Z0-9]{3,}$/;

		let feedbackDiv = document.getElementById("id-feedback");
		let idInput = document.querySelector("input[name=id]");
		let id = idInput.value;
		
		if(!idRegExp.test(id)) { // 유효하지 않은 아이디는 서버로 보내지 않는다.
			feedbackDiv.textContent = "아이디는 3글자이상, 영어 대소문자+숫자조합입니다."
			feedbackDiv.classList.remove('text-success');
			feedbackDiv.classList.add('text-danger');
			return;
		}		
		
		let xhr = new XMLHttpRequest();
		xhr.onreadystatechange = function() {
			if(xhr.readyState === 4 && xhr.status===200) {
				// 서버가 보낸 응답데이터를 조회한다.
				// 응답데이터 -> {"exist":true, "id" :"hong"}
				let jsontext = xhr.responseText;
				
				//응답으로 받은 json 텍스트를 자바스크립트 객체나 배열로 변환하기
				// result -> {exist:true id:"hong"}
				// result에는 자바스크립트 객체가 대입된다.
				let result = JSON.parse(jsontext);
				
				
				if(result.exist) {
					feedbackDiv.textContent = "이미사용중인 아이디입니다!."
					feedbackDiv.classList.remove('text-success');
					feedbackDiv.classList.add('text-danger');
				}else {
					feedbackDiv.textContent = "사용가능한 아이디입니다!!!!!!!!!."
					feedbackDiv.classList.remove('text-danger');
					feedbackDiv.classList.add('text-success');
				}
			}
		}
		xhr.open('GET', 'checkId.jsp?id=' + id);
		xhr.send();
	}

	function checkPassword() {
      	let passwordRegExp = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,15}$/
      	
      	// ex) document.getElementById(id) = document.getElementById("password-valid-feedback)
      	// ex) document.querySelector(selector) = document.querySelector(#password-valid-feedback)
    	let passwordInput = document.querySelector("input[name=password]");
      	let validFeedbackDiv = document.getElementById("password-valid-feedback");
      	let invalidFeedbackDiv = document.getElementById("password-invalid-feedback");
      	
      	//유효한 - 피드백-클래스속성값과 안유효한-피드백-클래스속성값을 조회한다.
      	// validClassList -> ['help-text', 'text-success', 'd-none(보이지 않게)']
      	// invalidClassList -> ['help-text', 'text-danger', 'd-none']
      	let validClassList = validFeedbackDiv.classList
      	let invalidClassList = invalidFeedbackDiv.classList
      	
      	let password = passwordInput.value;
      	if(passwordRegExp.test(password)) {
      		validClassList.remove('d-none')
      		invalidClassList.add('d-none')
      	}else {
      		validClassList.add('d-none')
      		invalidClassList.remove('d-none')
      	}
	}
/*
	회원가입 폼 입력값 유효성 체크하기
		1.아이디, 비밀번호, 이름, 이메일, 전화번호는 필수 입력값이다.
		2.아이디는 6글자 이상, 영어대소문자/숫자 조합이다.
		3.비밀번호는 9글자이상 , 영어대소문자/숫자/특수문자 조합이다.
		4.이름을 2글자 이상, 한글이다.
		5. 이메일은 이멜형식에 맞는 문자열이다.
		6. 전화번호는 전화번호형식에 맞는 문자열이다.
 */
	function checkRegisterForm(event) {
		// 0. 정규 표현식 작성하기	
		
		//정규표현식 - 영어대소문자 + 숫자   조합
		// ^ :시작  / : 끝  {최소숫자, 최대숫자}
		let idRegExp = /^[a-zA-Z0-9]{3,}$/;
      	let nameRegExp = /^[가-힣]{2,}$/;
      	let emailRegExp = /^[a-z0-9\.\-_]+@([a-z0-9\-]+\.)+[a-z]{2,6}$/
      	let telRegExp = /^\d{3}-\d{3,4}-\d{4}$/;
		
		// 1. 입력필드 엘리먼트를 조회한다.
		let idInput = document.querySelector("input[name=id]");
		let passwordInput = document.querySelector("input[name=password]");
		let nameInput = document.querySelector("input[name=name]");
		let emailInput = document.querySelector("input[name=email]");
		let telInput = document.querySelector("input[name=tel]");
		
		//2. 입력필드의 입력값 조회하기
		let id = idInput.value;
		let password = passwordInput.value;
		let name = nameInput.value;
		let email = emailInput.value;
		let tel = telInput.value;
		
		//3 입력값 검증
		// 아이디 검증 - 필수 입력값 금증
		if(id==="") {
			event.preventDefault();
			alert("아이디는 필수입력값입니다.");
			idInput.focus();
			
			return;
		}
		// 아이디 검증 - 6글자 이상, 영어대소문자/ 숫자조합
		if(!idRegExp.test(id)) {
			event.preventDefault();
			alert("아이디는 영어대소문자+숫자조합, d글자 이상입니다.");
			idInput.focus();

			return;
		}
		// 비밀번호 검증
		//if(!password==="")같다
		if(!password) {
			event.preventDefault();
			alert("비밀번호는 필수입력값입니다.")
			passwordInput.focus();
			return;
			
			
		}
		// 비밀번호 검증 - 8글자이상, 영어 대소문자/숫자/ 특수문자 조합
		if(passwordRegExp.test(password)) {
			event.preventDefault();
			alert("비밀번호는 8글자이상, 영어대소문자/숫자/특수문자 조합입니다");
			passwordInput.focus();
			return;
		}
		// 이름검증
		// 이메일 검증
		// 전화번호 검증
		
	}
</script>
</body>
</html>