<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="contextPath" value="${pageContext.request.contextPath }"/>
<c:set var="recipe" value="${recipe}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>레시피 상세</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/recipe_Detail.css">
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
</head>
	
<body>

<div class="container recipe-container">
    <div class="row">
    	
        <!-- 레시피 정보 (작성자, 이미지, 제목, 시간 등) -->
        <div class="col-md-8">
            <!-- 작성자 닉네임 -->
            <div class="mb-4">
                <span class="badge bg-warning text-dark custom-badge">작성자: ${recipe.nickname}</span>
            </div>
            
            <!-- 레시피 제목 -->
            <div class="mb-4">
                <h2>${recipe.title}</h2>
            </div>

            <!-- 레시피 사진 -->
            <div class="mb-4">
                <img  src="${pageContext.request.contextPath}/resources/images/${recipe.mainimg_path}" alt="Recipe Image">
            </div>

            <!--  음식 이름 -->
            <div class="mb-4">
                <h2>${recipe.food_name}</h2>
            </div>
			
			<article class="category">
			    <div id="category_text">
			        카테고리 : 
			        <c:choose>
			            <c:when test="${not empty category}">
			                <c:forEach var="cat" items="${category}" varStatus="status">
			                    ${cat.name} 
			                    <c:if test="${not status.last}"> > </c:if> 
			                    <!-- 마지막 요소가 아니면 ">" 추가 -->
			                </c:forEach>
			            </c:when>
			            <c:otherwise>
			                전체
			            </c:otherwise>
			        </c:choose>
			    </div> 
			</article> 
			
			<br>
			
            <!-- 소요시간 -->
            <div class="mb-4">
                <span class="badge bg-warning text-dark custom-badge-req_time">소요시간: ${recipe.req_time}</span>
            </div>

            <!-- 레시피 소개글 -->
            <div class="mb-4">
                <h2 class="recipe-section-title">레시피 소개</h2>
                <p>${recipe.description}</p>
            </div>
        </div>
        
    </div>
	
    <!-- 재료 목록 불러오기 -->
    <div class="mb-4">
		<h2 class="recipe-section-title">기본재료</h2>
			<div class="ingredients-box">
			    <c:forEach var="ingredient" items="${ingredients}">
			        <div class="ingredient-card">
			            <div class="ingredient-text">
			                ${ingredient.ingrd_name} ${ingredient.ingrd_qty}${ingredient.unit}
			            </div>
			        </div>
			    </c:forEach>
			</div>
	<button type="button" class="submit-btn" data-toggle="modal" data-target="#purchaseModal">
	    식재료 통합 구매
	</button>
	</div>
	
	<!-- 버튼 두개 나오는 모달 -->
	<div class="modal fade" id="purchaseModal" tabindex="-1" aria-labelledby="purchaseModalLabel" aria-hidden="true">
	    <div class="modal-dialog modal-dialog-centered">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="purchaseModalLabel">구매 옵션 선택</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	                    <span aria-hidden="true">&times;</span>
	                </button>
	            </div>
	            <div class="modal-body text-center">
	                <button type="button" class="btn btn-primary w-100 mb-2" 
	                        onclick="location.href='${contextPath}/product/startcompare?rcp_id=${recipe.rcp_id}'">
	                    쇼핑몰에서 구매
	                </button>
	                <button type="button" class="btn btn-success w-100" id="localMarketBtn"
	                onclick="location.href='${contextPath}/product/findgrocery?rcp_id=${recipe.rcp_id}'">
	                    주변 식료품점 찾아보기
	                </button>
	            </div>
	        </div>
	    </div>
	</div>
	
	<!-- 조리법 -->
	<div class="mb-4">
	    <h2 class="recipe-section-title">조리법</h2><br>
	    <div class="cooking-steps-box">
	        <c:forEach var="step" items="${steps}">
	            <div class="cooking-step-card">
	                <div class="cooking-step-image">
	                    <img src="${pageContext.request.contextPath}/resources/images/${step.stepimg_path}" alt="Step ${step.rcp_step}" class="step-image">
	                </div>
	                <div class="cooking-step-text">
	                    <h5>Step ${step.rcp_step}</h5>                   
	                    <p>${step.step_desc}</p>
	                </div>
	            </div>
	        </c:forEach>
	    </div>
	</div>


    <!-- 공유하기 아이콘 -->
    <div class="share-buttons mb-4">
                <h2 class="recipe-section-title">공유하기</h2>
                <a href="https://www.kakao.com/" target="_blank" class="share-icon ms-3">
                    <img src="${pageContext.request.contextPath}/resources/images/kakaotalk.png" alt="카카오톡" class="social-icon">
                </a>
                <a href="https://www.instagram.com/" target="_blank" class="share-icon ms-3">
                    <img src="${pageContext.request.contextPath}/resources/images/instagram.png" alt="인스타그램" class="social-icon"> 
                </a>
                <a href="https://www.facebook.com/" target="_blank" class="share-icon ms-3">
                    <img src="${pageContext.request.contextPath}/resources/images/facebook.png" alt="페이스북" class="social-icon">
                </a>
    </div>

   	<div class="comment-section">
	    <h2 class="recipe-section-title">레시피 평</h2>
	
	    <!-- 후기 작성하면 메시지로 알려줌 -->
	    <c:if test="${not empty message}">
	        <script>
	            alert("${message}");
	        </script>
	    </c:if>
	    <c:if test="${not empty error}">
	        <script>
	            alert("${error}");
	        </script>
	    </c:if>
	
	    <!-- 후기 작성 폼 -->
	    <form method="post" action="${pageContext.request.contextPath}/recipe/addRecipeRating?rcp_id=${param.rcp_id}">
	        <!-- 평점 숫자로 표시 -->
	        <div class="rating-display">
	            <span id="rating-text">4</span> / <span>5</span>
	        </div>
	
	        <!-- 평점 별 선택 -->
			<div>
			    <c:forEach var="i" begin="1" end="5">
			        <span class="star" onclick="setRating(${i})">★</span>
			    </c:forEach>
			</div>
	
	        <!-- 선택된 평점 값 hidden 처리로 서버에 넘기기 -->
	        <input type="hidden" id="rating" name="rating" value=4 readonly>
	
	        <!-- 댓글 입력 -->
	        <div>         
	            <label for="comments"></label>
	            <textarea id="comments" class="form-control" rows="3" name="comments" placeholder="레시피 후기를 남겨주세요..." required></textarea>                     
	            	<button class="w-btn-outline w-btn-red-outline" type="submit">후기 작성</button> <!-- 후기작성 맵핑이 로그인처리가 되어있어야 가능하도록 해놓음 -->
	        </div>
	    </form>
	    <hr class="comment-separator">
	<!-- ▲여기까지 후기작성 기능 -->

	<!-- ▼여기부터 후기출력 및 수정 기능 -->
	
	
	<!-- 전체 댓글 보기 버튼 -->
	<button class="w-btn-outline w-btn-red-outline" type="button" onclick="toggleCommentList()">전체 댓글 보기</button>
	
	    <!-- 후기 리스트 -->
	<div id="commentListForm" class="comment-list mt-4" style="display: none;">

		<!-- ▼전체 후기 데이터 리스트 테이블에서 가져온 것 -->
	    <c:forEach var="rating" items="${ratingList}">
	        <div class="comment">
	            <div class="comment-header">
	                <div class="profile-image">										  <!--▼댓글작성자 프로필사진 -->	
	                    <img src="${pageContext.request.contextPath}/resources/images/${rating.img_path}" alt="Profile Image">
	                </div>
	                <div class="comment-details"> <!--▼댓글작성자 닉네임 -->	
	                    <span class="username">${rating.nickname}</span>
	                    
									<span class="date-time">
									    <!-- ▼수정일이 없으면 작성일 표시 댓글작성 및 수정일자가 출력이 안되면 taglib uri fmt 체크해주세요-->
									    <c:if test="${empty rating.update_date}">
									        <fmt:formatDate value="${rating.create_date}" pattern="yyyy-MM-dd HH:mm" />
									    </c:if>
			
									    <!-- ▼수정일이 존재할 때만 수정일 표시 -->
									    <c:if test="${not empty rating.update_date}">
									        <fmt:formatDate value="${rating.update_date}" pattern="yyyy-MM-dd HH:mm" />
									        (수정됨)
									    </c:if>
									</span>
									
		                    <div class="rating-stars">
							    <c:forEach var="i" begin="1" end="${rating.rating}">
							        <span class="star_filled">★</span> <!-- 채워진 별 -->
							    </c:forEach>
							    <c:forEach var="i" begin="${rating.rating + 1}" end="5">
							        <span class="star_filled">☆</span> <!-- 빈 별 -->
							    </c:forEach>
							</div>			
												<br>
												<!--▼후기 댓글 내용-->
												<p>${rating.comments}</p>
	                </div>
	            </div>
	     
	            <div class="comment-content">	            	
				    <!-- 수정 버튼 (작성자만 보이도록 조건 추가) -->
				    <c:if test="${rating.byr_id eq buyerInfo.byr_id}">
                    <button class="w-btn-outline w-btn-red-outline" type="button" data-id="${rating.cmt_rcp_rating_id}" onclick="editComment(${rating.cmt_rcp_rating_id})">수정</button>
                    <button class="w-btn-outline w-btn-red-outline" type="button" data-id="${rating.cmt_rcp_rating_id}" onclick="confirmDeleteRating(${rating.cmt_rcp_rating_id}, ${rating.rcp_id})">삭제</button>
				    </c:if>			
				    
					    <div id="edit_ratingForm-${rating.cmt_rcp_rating_id}" class="edit-form" style="display:none;">
			                	<!-- 후기 수정 폼 -->
							    <form method="post" action="${pageContext.request.contextPath}/recipe/updateRecipeRating">
							    	
							    	<input type="hidden" name="rcp_id" value="${rating.rcp_id}">	    
								    <input type="hidden" name="cmt_rcp_rating_id" value="${rating.cmt_rcp_rating_id}">
	        						<!-- 선택된 평점 값 hidden 처리로 서버에 넘기기 -->
	        						<input type="hidden" id="edit_rating" name="rating" value="${rating.rating}" readonly>
							        <!-- 평점 숫자로 표시 -->
							        <div class="edit_rating-display">
							            <span id="edit_rating-text">${rating.rating}</span> / <span>5</span>
							        </div>
							
							        <!-- 평점 별 선택 -->
									<div>
									    <c:forEach var="i" begin="1" end="5">
									        <span class="edit_star" onclick="edit_setRating(${i})">★</span>
									    </c:forEach>
									</div>							
							
							        <!-- 댓글 입력 -->
							        <div>         
							            <label for="comments"></label>
							            <textarea id="comments" class="form-control" rows="3" name="comments" placeholder="수정할 내용을 입력하세요" required>${rating.comments}</textarea>                     
							            	<button class="w-btn-outline w-btn-red-outline" type="submit">수정완료</button>
							        </div>
							    </form>
				  		 </div>
				    	    
				</div>
			</div>
	    </c:forEach>
	</div>
	

		<script>
		    //▼ 전체 댓글 보기 버튼
			function toggleCommentList() {
			    var commentForm = document.getElementById("commentListForm");
			    var button = document.querySelector("button[onclick='toggleCommentList()']");
	
			    if (commentForm.style.display === "none" || commentForm.style.display === "") {
			        commentForm.style.display = "block";   
			        button.textContent = "전체 댓글 닫기";  
			    } else {
			        commentForm.style.display = "none";   
			        button.textContent = "전체 댓글 보기"; 
			    }
			}
		
			 //▼평점 등록 (별 채우기)
		    function setRating(value, isEdit = false) {
		        let stars = document.querySelectorAll('.star'); // 모든 별(span) 요소 가져오기
		
		        // 별 색상 업데이트
		        stars.forEach((star, index) => {
		            star.style.color = index < value ? "gold" : "gray";
		        });
		
		        // 별점 숫자 및 hidden input 업데이트 (수정 모드가 아닐 때만)
		        if (!isEdit) {
		            document.getElementById('rating-text').textContent = value; // 별점 숫자 업데이트
		            document.getElementById('rating').value = value; // hidden input 값 저장
		        }
		    }	
		    

		    
		  	//▼평점 수정 (별 채우기)
		    function edit_setRating(value, isEdit = false) {
		        let edit_stars = document.querySelectorAll('.edit_star'); // 모든 별(span) 요소 가져오기
		
		        // 별 색상 업데이트
		        edit_stars.forEach((edit_star, index) => {
		        	edit_star.style.color = index < value ? "gold" : "gray";
		        });
		
		        // 별점 숫자 및 hidden input 업데이트 (수정 모드가 아닐 때만)
		        if (!isEdit) {
		            document.getElementById('edit_rating-text').textContent = value; // 별점 숫자 업데이트
		            document.getElementById('edit_rating').value = value; // hidden input 값 저장
		        }
		    }
		    
			 // ▼수정 폼이 열릴 때 기본 별점 설정
		    function loadEditForm(ratingValue) {
		        edit_setRating(ratingValue); // 기본 별점을 채워준다.
		    }
			 
			 // ▼답변 수정 폼 관리 
		    function editComment(ratingId) {
	            // 해당 답변 폼 ID 찾기
	            var form = document.getElementById("edit_ratingForm-" + ratingId);
	            
	            // 현재 폼이 보이는 상태라면 숨기고, 숨겨져 있다면 보이게 함
	            if (form.style.display === "none" || form.style.display === "") {
	                form.style.display = "block"; // 폼 보이게 하기
	                var ratingValue = document.getElementById("edit_rating-" + ratingId).value; // 해당 후기의 별점 값 가져오기
	                loadEditForm(ratingValue); // 수정 폼에 기본 별점 채우기
	            } else {
	                form.style.display = "none";  // 폼 숨기기
	            }
	        }
		    
			 // ▼후기 삭제 확인 함수
		    function confirmDeleteRating(cmt_rcp_rating_id, rcp_id) {
		        // 사용자가 삭제를 확인했는지 확인
		        const isConfirmed = confirm("정말로 이 후기를 삭제하시겠습니까?");
		        
		        if (isConfirmed) {
		            // 삭제 요청을 서버로 전송
		            window.location.href = "${pageContext.request.contextPath}/recipe/deleteRecipeRating?cmt_rcp_rating_id=" + cmt_rcp_rating_id + "&rcp_id=" + rcp_id;
		        }
		    }
		    
			</script>
			

            
           <!-- 레시피QNA -->
			<div class="comment-section">
			    <h2 class="recipe-section-title">레시피 관련 질문</h2>
			
			    <c:if test="${not empty qna_message}">
			        <script>
			            alert("${qna_message}");
			        </script>
			    </c:if>
			    <c:if test="${not empty qna_error}">
			        <script>
			            alert("${qna_error}");
			        </script>
			    </c:if>
			
			    <!-- 질문 작성 폼 -->
			    <form method="post" action="${pageContext.request.contextPath}/recipe/addRecipeQna?rcp_id=${param.rcp_id}">
			        <div>
			            <textarea class="form-control" rows="3" name="comments" placeholder="레시피에 대한 질문을 남겨주세요..." required></textarea>
			        </div>
			        <button class="w-btn-outline w-btn-red-outline" type="submit">질문 작성</button>
			    </form>
			    <hr class="comment-separator">
			</div>
			
			<!-- <h2>디버깅용 - 총 원본질문 개수(parent_id가 null인거만 카운트함): ${fn:length(qnaList)}</h2> -->
			<!-- <h2>디버깅용 - 총 답변 개수(원본 질문 제외한 모든 답변): ${fn:length(answerList)}</h2> -->
	
	

<!-- ▲질문 작성 -->	
<!-- ===================================================================================================================== -->	
<!-- ▼내용 출력 및 답글 작성 -->
	
	
			<!-- 전체 질문 보기 버튼 -->
			<button class="w-btn-outline w-btn-red-outline" type="button" onclick="toggleQnAList()">전체 Q&A 보기</button>
			
			<!-- ▼ 원본 질문 리스트 -->
			<div id="qnaListForm" class="comment-list mt-4" style="display: none;">  
			    <c:forEach var="qna" items="${qnaList}">
			        <div class="comment">
			            <div class="comment-header"> <!-- 프로필 , 닉네임 , 작성/수정일자 -->
			                <div class="profile-image">
			                    <img src="${pageContext.request.contextPath}/resources/images/${qna.img_path}" alt="Profile Image">
			                </div>
			                <div class="comment-details">
			                    <span class="username">${qna.nickname}</span>
			                    <span class="date-time"> <!-- ▼수정하고나면 수정한 시간으로 초기화 -->
			                        <c:if test="${empty qna.update_date}">
			                            <fmt:formatDate value="${qna.create_date}" pattern="yyyy-MM-dd HH:mm" />
			                        </c:if>
			                        <c:if test="${not empty qna.update_date}">
			                            <fmt:formatDate value="${qna.update_date}" pattern="yyyy-MM-dd HH:mm" />(수정됨)
			                        </c:if>
			                    </span>
			                    	<!-- ▼질문 내용 -->
			                    <p>${qna.comments}</p>

			                    
			                </div>
			            </div>
			
			            <div class="comment-content"> <!-- 답글/수정/삭제 버튼 -->
			                <c:if test="${not empty buyerInfo}">
			                    <a href="javascript:void(0);" class="w-btn-outline w-btn-red-outline" onclick="toggleAnswerForm(${qna.cmt_rcp_qna_id})">답글</a>
			                    <c:if test="${qna.byr_id eq buyerInfo.byr_id}">
			                        <button class="w-btn-outline w-btn-red-outline" type="button" onclick="toggleEditForm(${qna.cmt_rcp_qna_id})">수정</button>
			                        <button class="w-btn-outline w-btn-red-outline" type="button" onclick="confirmDeleteQna(${qna.cmt_rcp_qna_id}, ${qna.rcp_id})">삭제</button>
			                    </c:if>
			                </c:if>
			            </div>
			
			            <!-- 원본 질문에 대한 답글 작성 폼 -->
			            <div id="answerForm-${qna.cmt_rcp_qna_id}" class="answer-form" style="display:none;">
			                <form method="post" action="${pageContext.request.contextPath}/recipe/addRecipeQnaAnswer">
			                    <input type="hidden" name="rcp_id" value="${param.rcp_id}">
			                    <input type="hidden" name="parent_id" value="${qna.cmt_rcp_qna_id}">
			                    <textarea class="form-control" rows="4" name="comments" placeholder="답변을 남겨주세요"></textarea>
			                    <button type="submit" class="w-btn-outline w-btn-red-outline">작성완료</button>
			                </form>
			            </div>
			            
			            <!-- 원본 질문 수정 폼 ==============================================================================================================-->
						<div id="editForm-${qna.cmt_rcp_qna_id}" class="edit-form" style="display:none;">
						    <form method="post" action="${pageContext.request.contextPath}/recipe/updateRecipeQna">
						        <input type="hidden" name="rcp_id" value="${param.rcp_id}">
						        <input type="hidden" name="cmt_rcp_qna_id" value="${qna.cmt_rcp_qna_id}">
						        <textarea class="form-control" rows="4" name="comments" placeholder="수정할 내용을 입력하세요">${qna.comments}</textarea>
						        <button type="submit" class="w-btn-outline w-btn-red-outline">수정완료</button>
						    </form>
						</div>
									
			            <!-- 원본 질문에 대한 답변 리스트 -->
			            <div class="answer-list" id="answerList-${qna.cmt_rcp_qna_id}">
			                <c:forEach var="answer" items="${answerList}">
			                    <c:if test="${answer.parent_id == qna.cmt_rcp_qna_id}">
			                        <div class="answer">
			                            <div class="answer-header">
			                                <span class="username">${answer.nickname}</span>
			                                <span class="date-time"> <!-- ▼수정하고나면 수정한 시간으로 초기화 -->
			                                    <c:if test="${empty answer.update_date}">
			                                        <fmt:formatDate value="${answer.create_date}" pattern="yyyy-MM-dd HH:mm" />
			                                    </c:if>
			                                    <c:if test="${not empty answer.update_date}">
			                                        <fmt:formatDate value="${answer.update_date}" pattern="yyyy-MM-dd HH:mm" />(수정됨)
			                                    </c:if>
			                                </span>
			                            </div>
			                            	<!-- ▼원본 질문의 답글 내용 -->
			                            <p><span style="color: #ff6347;">↳</span> ${answer.comments}</p>

			                           
			
			                            <div class="answer-content">
			                            			<!-- ▼답글 작성 버튼 ( 모든 사용자가 해당 댓글에 답글을 남길 수 있으니 로그인 되어있는지만 체크하면됨 ) -->
			                                	<c:if test="${not empty buyerInfo}"> 
			                                    <a href="javascript:void(0);" class="w-btn-outline w-btn-red-outline" onclick="toggleAnswerForm(${answer.cmt_rcp_qna_id})">답글</a>
			                                    	<!-- ▼질문 수정, 삭제 버튼 ( 해당 댓글의 작성자만 수정 및 삭제할 수 있도록 조건 처리) -->	
			                                    <c:if test="${answer.byr_id eq buyerInfo.byr_id}">
			                                        <button class="w-btn-outline w-btn-red-outline" type="button" onclick="toggleEditForm(${answer.cmt_rcp_qna_id})">수정</button>
			                                        <button class="w-btn-outline w-btn-red-outline" type="button" onclick="confirmDeleteQna(${answer.cmt_rcp_qna_id}, ${answer.rcp_id})">삭제</button>
			                                    </c:if>
			                                </c:if>
			
			                                <!-- 답글의 댓글 작성 폼 -->
			                                <div id="answerForm-${answer.cmt_rcp_qna_id}" class="answer-form" style="display:none;">
			                                    <form method="post" action="${pageContext.request.contextPath}/recipe/addRecipeQnaAnswer">
			                                        <input type="hidden" name="rcp_id" value="${param.rcp_id}">
			                                        <input type="hidden" name="parent_id" value="${answer.cmt_rcp_qna_id}">
			                                        <textarea class="form-control" rows="4" name="comments" placeholder="답변에 대한 답글을 남겨주세요"></textarea>
			                                        <button type="submit" class="w-btn-outline w-btn-red-outline">작성완료</button>
			                                    </form>
			                                </div>
			                                
			                                <!-- 원본의 답변 수정 폼 ==============================================================================================================-->
											<div id="editForm-${answer.cmt_rcp_qna_id}" class="edit-form" style="display:none;">
											    <form method="post" action="${pageContext.request.contextPath}/recipe/updateRecipeQna">
											        <input type="hidden" name="rcp_id" value="${param.rcp_id}">
											        <input type="hidden" name="cmt_rcp_qna_id" value="${answer.cmt_rcp_qna_id}">
											        <textarea class="form-control" rows="4" name="comments" placeholder="수정할 내용을 입력하세요">${answer.comments}</textarea>
											        <button type="submit" class="w-btn-outline w-btn-red-outline">수정완료</button>
											    </form>
											</div>
			                                		
			                                <!-- 답글의 댓글 리스트 -->
			                                <div class="sub-answer-list">
			                                    <c:forEach var="subAnswer" items="${answerList}">
			                                        <c:if test="${subAnswer.parent_id == answer.cmt_rcp_qna_id}">
			                                            <div class="sub-answer"> <!-- 들여쓰기 (구분하기위한 임시 작업- 추후 모든 답글은 한라인으로 세로로 나열할 예정) -->
			                                                <div class="answer-header">
			                                                    <span class="username">${subAnswer.nickname}</span>
			                                                    <span class="date-time"> <!-- ▼수정하고나면 수정한 시간으로 초기화 -->
			                                                        <c:if test="${empty subAnswer.update_date}">
			                                                            <fmt:formatDate value="${subAnswer.create_date}" pattern="yyyy-MM-dd HH:mm" />
			                                                        </c:if>
			                                                        <c:if test="${not empty subAnswer.update_date}">
			                                                            <fmt:formatDate value="${subAnswer.update_date}" pattern="yyyy-MM-dd HH:mm" />(수정됨)
			                                                        </c:if>
			                                                    </span>
			                                                </div>
			                                                	<!-- ▼답글 내용 -->
			                                                <p><span style="color: #ff6347;">↳</span> ${subAnswer.comments}</p>

			
			                                                <div class="answer-content">			                                                   
			                                                    	<!-- ▼답글의 답글 작성 버튼 ( 모든 사용자가 해당 댓글에 답글을 남길 수 있으니 로그인 되어있는지만 체크하면됨 ) 
								                                	<c:if test="${not empty buyerInfo}"> 
								                                    <a href="javascript:void(0);" class="w-btn-outline w-btn-red-outline" onclick="toggleAnswerForm(${subAnswer.cmt_rcp_qna_id})">답글</a>
								                                    </c:if>
								                                    -->
								                                    
								                                    <!-- ▼ 수정, 삭제 버튼 ( 해당 댓글의 작성자만 수정 및 삭제할 수 있도록 조건 처리) -->	
			                                                        <c:if test="${subAnswer.byr_id eq buyerInfo.byr_id}">
			                                                            <button class="w-btn-outline w-btn-red-outline" type="button" onclick="toggleEditForm(${subAnswer.cmt_rcp_qna_id})">수정</button>
			                                                            <button class="w-btn-outline w-btn-red-outline" type="button" onclick="confirmDeleteQna(${subAnswer.cmt_rcp_qna_id}, ${subAnswer.rcp_id})">삭제</button>
			                                                        </c:if>
			                                                </div>
			                                                
			                                                <!-- Sub답변 작성 폼 (무한대댓글기능 구현 후 처리) 
							                                <div id="answerForm-${subAnswer.cmt_rcp_qna_id}" class="answer-form" style="display:none;">
							                                    <form method="post" action="${pageContext.request.contextPath}/recipe/addRecipeQnaAnswer">
							                                        <input type="hidden" name="rcp_id" value="${param.rcp_id}">
							                                        <input type="hidden" name="parent_id" value="${subAnswer.cmt_rcp_qna_id}">
							                                        <textarea class="form-control" rows="4" name="comments" placeholder="답변에 대한 답글을 남겨주세요"></textarea>
							                                        <button type="submit" class="w-btn-outline w-btn-red-outline">작성완료</button>
							                                    </form>
							                                </div>
			                                                -->
			                                                <!-- 답글의 답글 수정 폼 ==============================================================================================================-->
															<div id="editForm-${subAnswer.cmt_rcp_qna_id}" class="edit-form" style="display:none;">
															    <form method="post" action="${pageContext.request.contextPath}/recipe/updateRecipeQna">
															        <input type="hidden" name="rcp_id" value="${param.rcp_id}">
															        <input type="hidden" name="cmt_rcp_qna_id" value="${subAnswer.cmt_rcp_qna_id}">
															        <textarea class="form-control" rows="4" name="comments" placeholder="수정할 내용을 입력하세요">${subAnswer.comments}</textarea>
															        <button type="submit" class="w-btn-outline w-btn-red-outline">수정완료</button>
															    </form>
															</div>			                                                
			                                            </div>
			                                        </c:if>
			                                    </c:forEach>
			                                </div>
			                            </div>
			                        </div>
			                    </c:if>
			                </c:forEach>
			            </div>
			        </div>
			    </c:forEach>
			</div>		
		</div>
		<div class="custom-btn-container">
		    <button class="w-btn-outline w-btn-red-outline custom-btn" type="button" onclick="location.href='${pageContext.request.contextPath}/recipe/recipe_list'">
		        레시피 목록으로
		    </button>
		</div>

	</div>
	
	
	
	
    <script>
    
	 // ▼ 전체 질문 및 답변 보기 버튼
	    function toggleQnAList() {
	        var qnaForm = document.getElementById("qnaListForm");
	        var button = document.querySelector("button[onclick='toggleQnAList()']");
	
	        if (qnaForm.style.display === "none" || qnaForm.style.display === "") {
	            qnaForm.style.display = "block";  // Q&A 리스트 표시
	            button.textContent = "전체 Q&A 닫기"; // 버튼 텍스트 변경
	        } else {
	            qnaForm.style.display = "none";   // Q&A 리스트 숨김
	            button.textContent = "전체 Q&A 보기"; // 버튼 텍스트 변경
	        }
	    }
    	
	 // ▼ 원본 질문 답글 폼 열기
	    function toggleAnswerForm(qnaId) {
	        // 해당 수정 폼 ID 찾기
	        var editForm = document.getElementById("editForm-" + qnaId);
	        if (editForm) {
	            editForm.style.display = "none";  // 수정폼 숨기기
	        }

	        // 해당 답변 폼 ID 찾기
	        var form = document.getElementById("answerForm-" + qnaId);
	        
	        // 현재 폼이 보이는 상태라면 숨기고, 숨겨져 있다면 보이게 함
	        if (form.style.display === "none" || form.style.display === "") {
	            form.style.display = "block"; // 폼 보이게 하기
	        } else {
	            form.style.display = "none";  // 폼 숨기기
	        }
	    }

	    // ▼ 원본 질문 수정 폼 열기  
	    function toggleEditForm(qnaId) {
	        // 기존의 답글폼을 숨기기
	        var answerForm = document.getElementById("answerForm-" + qnaId);
	        if (answerForm) {
	            answerForm.style.display = "none";  // 답글폼 숨기기
	        }

	        // 해당 수정 폼 ID 찾기
	        var editForm = document.getElementById("editForm-" + qnaId);
	        
	        // 수정 폼이 보이는 상태라면 숨기고, 숨겨져 있다면 보이게 함
	        if (editForm.style.display === "none" || editForm.style.display === "") {
	            editForm.style.display = "block"; // 수정 폼 보이게 하기
	        } else {
	            editForm.style.display = "none";  // 수정 폼 숨기기
	        }
	    }
	    
	 	// ▼QnA 삭제 확인 함수
	    function confirmDeleteQna(cmt_rcp_qna_id, rcp_id) {
	        // 사용자가 삭제를 확인했는지 확인
	        const isConfirmed = confirm("정말로 이 질문을 삭제하시겠습니까?");
	        
	        if (isConfirmed) {
	            // 삭제 요청을 서버로 전송
	            window.location.href = "${pageContext.request.contextPath}/recipe/deleteRecipeQna?cmt_rcp_qna_id=" + cmt_rcp_qna_id + "&rcp_id=" + rcp_id;
	        }
	    }
    </script>
    
</body>
</html>