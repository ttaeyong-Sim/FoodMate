<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.spring.FoodMate.member.dto.BuyerDTO" %>
<c:set var="contextPath" value="${pageContext.request.contextPath }"/>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>레시피 작성 폼 페이지</title>
    <!-- jQuery 예시 -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<style>	
	body {
	background-color: #f1e9e0;
	}
  
    .recipe-form-container {
    	width:65%;
        margin: 50px auto;
        background-color: #fff;
        padding: 40px;
        border-radius: 8px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    }

    
    h2 {
        text-align: center;
        font-size: 2.5rem;
        color: #333;
        margin-bottom: 20px;
    }

    
    .form-group {
        margin-bottom: 20px;
    }
    
    .form-group label{
        margin-bottom: 10px;
    }
    
    label {
        font-size: 1.1rem;
        font-weight: bold;
        color: #333;
    }

    input, select, textarea {
        width: 100%;
        padding: 15px;
        font-size: 1rem;
        border-radius: 6px;
        border: 1px solid #ddd;
        box-sizing: border-box;
    }

	#select_category label {
		display: block;
	}
	
	#select_category select {		
		width: 20%;
	}

    input:focus, select:focus, textarea:focus {
        border-color: #f39c12;
        outline: none;
    }

    textarea {
        resize: vertical;
    }

    .btn {
        background-color: #f39c12;
        color: white;
        border: none;
        padding: 15px 30px;
        font-size: 1.1rem;
        border-radius: 6px;
        cursor: pointer;
        transition: background-color 0.3s ease;
        width: 15%;
        margin-top:15px;
    }

    
    .btn:hover {
        background-color: #e67e22;
    }

    .btn:active {
        background-color: #d87f1c;
    }

    
    .submit-btn {
       width: 100%; 
    }

    .ingredient-card {
        background-color: #f9f9f9;
        border-radius: 8px;
        padding: 15px;
        margin-bottom: 15px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .ingredient-input {
        width: 100%;
        padding: 12px;
        font-size: 1rem;
        border-radius: 6px;
        border: 1px solid #ddd;
        box-sizing: border-box;
        margin-bottom: 10px;
    }

    .ingredient-card input {
        width: 85%;
    }
	
    .ingredient-card button {
        background-color: #e1eef6;
        border: none;
        padding: 10px;
        font-size: 1rem;
        border-radius: 6px;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    .ingredient-card button:hover {
        background-color: #c5d6eb;
    }

    .ingredient-card button:active {
        background-color: #a8c3e1;
    }

    .ingredient-list {
        margin-bottom: 20px;
    }

    .col-md-6 {
        margin-bottom: 10px;
    }

    .step-card {
        background-color: #f9f9f9;
        border-radius: 8px;
        padding: 15px;
        margin-bottom: 15px;
    }

    .step-card textarea {
        width: 100%;
    }

    .step-card button {
        background-color: #e1eef6;
        border: none;
        padding: 10px;
        font-size: 1rem;
        border-radius: 6px;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    .step-card button:hover {
        background-color: #c5d6eb;
    }

    .step-card button:active {
        background-color: #a8c3e1;
    }

    .step-card .image-upload {
        margin-top: 10px;
    }
    
    button.delete-btn {
		margin-top: 10px;
	}
</style>




<body>
	<div class="recipe-form-container">
	<h2>📖레시피 작성</h2>

		<form id="recipeForm" enctype="multipart/form-data">
		    <!-- 레시피 기본 정보 -->
		     <!-- 작성자 정보 (수정 불가) -->
			<%
			    BuyerDTO buyerDTO = (BuyerDTO) session.getAttribute("buyerInfo");
			    if (buyerDTO != null) {
			        String byr_id = buyerDTO.getByr_id(); // 예시로 getId() 사용
			%>
			    <label for="byr_id">작성자:</label>
			    <input type="text" id="byr_id" name="byr_id" value="<%= byr_id %>" readonly>
			<%
			    } else {
			%>
			    <label for="byr_id">작성자:</label>
			    <input type="text" id="byr_id" name="byr_id" value="작성자 정보가 없습니다. 로그인 상태를 확인하세요" disabled style="color: red;">
			<%
			    }
			%>
		    
		    <div>
		        <label for="title">레시피 제목:</label>
		        <input type="text" id="title" name="title" required placeholder="레시피 제목 입력">
		    </div>
		    
		    <div>
		        <label for="food_name">음식 이름:</label>
		        <input type="text" id="food_name" name="food_name" required placeholder="음식 이름 입력">
		    </div>
		    
		    
		    
		    
		    <!-- 레시피 카테고리 입력 -->
		    <section id="select_category">
				<label for="category">카테고리</label>
				<p>&#8251;카테고리를 정확히 설정하면 조회수가 평균 20% 올라갑니다.</p>
					<select name="category_1" id="category_1">
					    <option value="" disabled selected>1단계분류</option>
					    <c:forEach var="category" items="${categories}">
					        <option value="${category.category_id}">${category.name}</option>
					    </c:forEach>
					</select>
				<div id="category_container">
				 <!-- 자식 카테고리들을 넣을 div -->
				</div>
			</section>
				<input type="hidden" id="category_id" name="category_id" readonly>
		    
		    <div>
		        <label for="req_time">조리 시간:</label>
		        <input type="text" id="req_time" name="req_time" required placeholder="조리 시간 입력">
		    </div>
		    
		    <div>
		        <label for="description">레시피 설명:</label>
		        <textarea id="description" name="description" required placeholder="레시피 설명 입력"></textarea>
		    </div>
		
		    <div>
		        <label for="mainimg_path">레시피 이미지:</label>
		        <input type="file" id="mainimg_path" name="mainimg_path">
		    </div>
		
		
		
		
		    <!-- 재료 목록 -->
		    <br>
		    <h3>재료 입력</h3>
		    <br>
		    <div id="ingredients">	    	 
		        <div>
		        <!-- 첫 번째 재료 카테고리 입력 -->
				<section id="select_category">
				    <label for="ingrd_category">재료 카테고리:</label>
				    <p>&#8251;재료의 카테고리를 선택하세요.</p>
				    			<!--▼2단계분류에선 여기 name값이 끝이 2 class도 마찬가지로 2가 되는거 분류별로 증가 ajax 요청 참조  -->
				    <select name="ingrd_category_1" class="ingrd_category_1"> <!--  -->
				        <option value="" disabled selected>1단계 분류</option>
				        <c:forEach var="ingrd_category" items="${ingrd_categories}">
				            <option value="${ingrd_category.category_id}">${ingrd_category.name}</option>
				        </c:forEach>
				    </select>
				    <div class="ingrd_category_container">
				        <!-- 자식 카테고리들을 넣을 div -->
				    </div>
				</section>
				
					<input type="hidden" class="ingrd_category_id" name="ingrd_category_id" readonly>
		            
		            <label for="ingrd_name">재료 이름:</label>
		            <input type="text" name="ingrd_name" placeholder="재료 이름 입력" required>
		            <label for="ingrd_qty">재료 수량:</label>
		            <input type="number" name="ingrd_qty" placeholder="재료 수량 입력" required>
		            <label for="unit">단위:</label>
		            <input type="text" name="unit" placeholder="단위 입력" required>
		        </div>
		    </div>
		    <button type="button" class="btn ingredient-add-btn" onclick="addIngredient()">재료 추가</button>
		    
		    
		 
		    <!-- 레시피 단계 -->
		    <br>
		    <h3>레시피 단계별 조리법</h3>
		    <br>
		    <div id="steps">
		        <div>
		            <label for="rcp_step">단계 번호:</label>
		            <input type="number" name="rcp_step" placeholder="단계 번호" required>
		            <label for="step_desc">단계 설명:</label>
		            <textarea name="step_desc" placeholder="단계 설명 입력" required></textarea>
		            <label for="stepimg_path">단계 이미지:</label>
		            <input type="file" name="stepimg_path">		           
		        </div>
		    </div>
		    <button type="button" class="btn step-add-btn" onclick="addStep()">단계 추가</button>
		
		    <button type="submit" id="submitBtn" class="btn submit-btn">레시피 등록</button>
		</form>
	</div>
	
	
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
<!-- 레시피 부모 카테고리의 자식 카테고리 불러오기 -->
var contextPath = "${contextPath}";
console.log(contextPath);

$(document).ready(function() {
    var lastCategoryId = null;  // 마지막 선택된 카테고리 ID

 	// 1단계 카테고리 선택 시
 
/*  사용자가 category_1의 값을 선택할 때마다 function 내부의 코드가 실행
	$(this)는 이벤트가 발생한 요소, 즉 #category_1를 참조
	.val() 메서드는 선택한 select 요소에서 현재 선택된 옵션의 값을 가져옴
	그 값을 selectedCategory라는 변수에 저장 */
	
    $('#category_1').on('change', function() {   
        var selectedCategory = $(this).val();

        // 이전 하위 카테고리 초기화
        $('#category_container').empty();
		//선택 시
        if (selectedCategory) {
            lastCategoryId = selectedCategory;
            $('#category_id').val(getLastCategoryId());
            loadSubCategories(selectedCategory, 2);
        }
    });
    
    // 마지막 선택된 카테고리 ID 반환
    function getLastCategoryId() {
        return lastCategoryId;
    }

    // 하위 카테고리 로드 함수
    function loadSubCategories(parentCategoryId, level) {
        var url = contextPath + '/recipe/getSubCategories?category_id=' + parentCategoryId;  // 쿼리 스트링 방식으로 변경

        $.ajax({
            url: url,
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                if (data.length > 0) {
                    var select = $('<select>')
                        .attr('name', 'category_' + level)
                        .attr('id', 'category_' + level);

                    select.append($('<option>', { value: '', text: level + '단계분류', disabled: true, selected: true }));

                    $.each(data, function(index, category) {
                        select.append($('<option>').attr('value', category.category_id).text(category.name));
                    });

                    $('#category_container').append(select);

                    select.on('change', function() {
                        var selectedSubCategory = $(this).val();
                        if (selectedSubCategory) {
                            lastCategoryId = selectedSubCategory;
                            $('#category_id').val(getLastCategoryId());
                            $('#category_' + (level + 1)).remove();
                            loadSubCategories(selectedSubCategory, level + 1);
                        }
                    });
                }
            },
            error: function(xhr, status, error) {
                console.error('자식 카테고리 로드 실패:', error);
            }
        });
    }


    
});
</script>	
	
	
	
	
	
	<!--  ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼위에는 안건드려도됨▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼ -->
	<!--  ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼ -->
	<!--  ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼ -->
	<!--  ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼ -->
	


<script>
<!-- 재료 부모 카테고리의 자식 카테고리 불러오기 -->
var contextPath = "${contextPath}";
console.log(contextPath);

$(document).ready(function() {
    var lastIngrdCategoryId = null;  // 마지막 선택된 재료 카테고리 ID

    // 1단계 재료 카테고리 선택 시
    $('.ingrd_category_1').on('change', function() {   
        var selectedIngrdCategory = $(this).val();
     // 1단계분류 바꿀 시 이전 하위 카테고리 비워줌
        $('.ingrd_category_container').empty();
        // 선택 시
        if (selectedIngrdCategory) {
            lastIngrdCategoryId = selectedIngrdCategory;   
            $('.ingrd_category_id').val(getLastIngrdCategoryId());
            loadSubIngrdCategories(selectedIngrdCategory, 2);
        }
    });
    
    // 마지막 선택된 재료 카테고리 ID 반환
    function getLastIngrdCategoryId() {
        return lastIngrdCategoryId;
    }

    // 하위 재료 카테고리 로드 함수
    function loadSubIngrdCategories(parentIngrdCategoryId, level) {
    	 var url = contextPath + '/recipe/select_Sub_IngrdCategory?ingrd_category_id=' + parentIngrdCategoryId;

        $.ajax({ //실시간 해당 페이지에서 변경이 되어야해서 ajax사용
            url: url,
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                if (data.length > 0) {
                    var select = $('<select>')
                        .attr('name', 'ingrd_category_' + level)
                        .attr('class', 'ingrd_category_' + level)
                        .addClass('ingrd_category_sub');
                  													//카테고리명 외에 구분은 선택하지 못하도록 처리했습니다. 2단계구분 표시만해주고 선택은못하게
                    select.append($('<option>', { value: '', text: level + '단계분류', disabled: true, selected: true }));


                    $.each(data, function(index, ingrd_category) {  //▼서버에서 받은 데이터 ingrd_category(◀item으로 전체 카테고리 불러오고 변수에 넣은값) .~~  
                        select.append($('<option>').attr('value', ingrd_category.category_id).text(ingrd_category.name)); //데이터없으면 option 더 생성x
                    });

                    $('.ingrd_category_container').append(select);

                    select.on('change', function() {
                        var selectedSubIngrdCategory = $(this).val();
                        if (selectedSubIngrdCategory) {
                            lastIngrdCategoryId = selectedSubIngrdCategory;
		   $('.ingrd_category_id').val(getLastIngrdCategoryId());  //마지막에 선택한 카테고리ID 값 
		   $('.ingrd_category_' + (level + 1)).remove(); //이거 설정 안하면 2단계분류 선택 시 마지막에 선택한거 말고도 이전에 선택한게 계속 남아있어서 망가짐
                            loadSubIngrdCategories(selectedSubIngrdCategory, level + 1); //단계별 선택에 따라 +1 다음단계 카테고리 입력폼이 보여지도록()
                        }
                    });
                }
            },
            error: function(xhr, status, error) {
                console.error('자식 재료 카테고리 로드 실패:', error);
            }
        });
    }
});
</script>



<script>
	<!-- 동적으로 추가된 폼 재료 부모 카테고리의 자식 카테고리 불러오기 -->

    var ingredientCount = 2; // 재료 번호
    var stepCount = 2; // 단계 번호

    // 재료 추가 함수
    function addIngredient() {
        var ingredientsDiv = document.getElementById('ingredients');
        var newIngredientDiv = document.createElement('div');

        newIngredientDiv.innerHTML = `
            <section id="select_category_` + ingredientCount + `">
                <label for="ingrd_category_` + ingredientCount + `">재료 카테고리:</label>
                <p>&#8251;재료의 카테고리를 선택하세요.</p>
                <select class="ingrd_category_` + ingredientCount + `">
                    <option value="" disabled selected>1단계 분류</option>
                    <c:forEach var="ingrd_category" items="${ingrd_categories}">
                        <option value="${ingrd_category.category_id}">${ingrd_category.name}</option>
                    </c:forEach>
                </select>
                <div class="ingrd_category_container_` + ingredientCount + `">
                    <!-- 자식 카테고리들을 넣을 div -->
                </div>
            </section>
            
            <input type="hidden" class="ingrd_category_id_` + ingredientCount + `" name="ingrd_category_id" readonly>  <!-- 카테고리 ID hidden input -->

            <label for="ingrd_name_` + ingredientCount + `">재료 이름:</label>
            <input type="text" id="ingrd_name_` + ingredientCount + `" name="ingrd_name" placeholder="재료 이름 입력" required>
            <label for="ingrd_qty_` + ingredientCount + `">재료 수량:</label>
            <input type="number" id="ingrd_qty_` + ingredientCount + `" name="ingrd_qty" placeholder="재료 수량 입력" required>
            <label for="unit_` + ingredientCount + `">단위:</label>
            <input type="text" id="unit_` + ingredientCount + `" name="unit" placeholder="단위 입력" required>

            <button type="button" class="removeIngredientBtn" onclick="removeIngredient(this)">삭제</button>
        `;

        ingredientsDiv.appendChild(newIngredientDiv);
        ingredientCount++; // 재료 추가 시마다 번호 증가

        // 동적으로 생성된 카테고리 선택에 대한 이벤트 리스너 추가
        bindCategoryChangeEvent();
    }

    // 재료 카테고리 변경 시 동적으로 자식 카테고리 로딩
    function bindCategoryChangeEvent() {
        $('.ingrd_category_' + (ingredientCount - 1)).change(function() {
            var selectedCategoryId = $(this).val();
            var categoryContainer = $('.ingrd_category_container_' + (ingredientCount - 1));

            categoryContainer.empty();  // 기존 하위 카테고리 제거

            if (selectedCategoryId) {
                loadSubIngrdCategories(selectedCategoryId, ingredientCount - 1, 1); // 1단계부터 시작
            }
        });
    }

    function loadSubIngrdCategories(parentCategoryId, ingredientNumber, level) {
        var url = contextPath + '/recipe/select_Sub_IngrdCategory?ingrd_category_id=' + parentCategoryId;

        $.ajax({
            url: url,
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                if (data.length > 0) {
                    // 이전 하위 카테고리 제거
                    $('.ingrd_category_' + (ingredientNumber) + '_level_' + (level + 1)).remove();

                    // 2단계, 3단계 등 레벨에 맞게 분류명 설정
                    var select = $('<select>')
                        .attr('name', 'ingrd_category_' + ingredientNumber + '_level_' + (level + 1))  // 레벨을 동적으로 추가
                        .attr('class', 'ingrd_category_' + ingredientNumber + '_level_' + (level + 1));  // 레벨 기반 클래스 설정

                    select.append($('<option>', { value: '', text: (level + 1) + '단계 분류', disabled: true, selected: true }));

                    $.each(data, function(index, ingrd_category) {
                        select.append($('<option>', { value: ingrd_category.category_id, text: ingrd_category.name }));
                    });

                    $('.ingrd_category_container_' + ingredientNumber).append(select);

                    // 하위 카테고리 선택 후 히든 input에 값 설정
                    select.on('change', function() {
                        var selectedSubCategory = $(this).val();  // 선택된 하위 카테고리

                        if (selectedSubCategory) {
                            // 선택된 하위 카테고리 값이 있을 때
                            $('.ingrd_category_id_' + ingredientNumber).val(selectedSubCategory);
                        }

                        // 선택된 카테고리의 하위 카테고리 확인
                        loadSubIngrdCategories(selectedSubCategory, ingredientNumber, level + 1);  // 레벨 증가
                    });
                } else {
                    // 더 이상 하위 카테고리가 없으면 최종 카테고리로 처리
                    var selectedCategoryId = $('.ingrd_category_' + ingredientNumber + '_level_' + level).val();
                    $('.ingrd_category_id_' + ingredientNumber).val(selectedCategoryId);  // 최종 카테고리 값 설정
                }
            },
            error: function(xhr, status, error) {
                console.error('하위 카테고리 로딩 실패:', error);
            }
        });
    }


    // 재료 삭제 함수
    function removeIngredient(button) {
        button.parentElement.remove(); // 버튼이 속한 div를 삭제
    }

    // 단계 추가 함수
    function addStep() {
        var stepsDiv = document.getElementById('steps');
        var newStepDiv = document.createElement('div');
        
        newStepDiv.innerHTML = `       	 
            <label for="rcp_step_` + stepCount + `">단계 번호:</label>
            	<input type="number" id="rcp_step_` + stepCount + `" name="rcp_step" placeholder="단계 번호" required>
            	
            <label for="step_desc_` + stepCount + `">단계 설명:</label>
            	<textarea id="step_desc_` + stepCount + `" name="step_desc" placeholder="단계 설명 입력" required></textarea>
            	
            <label for="stepimg_path_` + stepCount + `">단계 이미지:</label>
            	<input type="file" id="stepimg_path_` + stepCount + `" name="stepimg_path">
            <button type="button" class="removeStepBtn" onclick="removeStep(this)">삭제</button>
        `;
        stepsDiv.appendChild(newStepDiv);
        stepCount++; // 단계 추가 시마다 번호 증가 a
    }

    // 단계 삭제 함수
    function removeStep(button) {
        button.parentElement.remove(); // 버튼이 속한 div를 삭제
    }

 // 폼 데이터 서버로 전송 함수
    $('#recipeForm').submit(function(event) {
        event.preventDefault();  // 기본 폼 제출을 막음

        var formData = new FormData(this);  // 폼 데이터(FormData 객체) 받기

        // 재료 목록 처리
        $('#ingredients > div').each(function() {
            var name = $(this).find('input[name^="ingrd_name"]').val();
            var qty = $(this).find('input[name^="ingrd_qty"]').val();
            var unit = $(this).find('input[name^="unit"]').val();
            var category = $(this).find('select[name^="ingrd_category"]').val();

            // 기존 name 그대로 사용하면서 FormData에 추가
            formData.append('ingrd_name', name);
            formData.append('ingrd_qty', qty);
            formData.append('unit', unit);
            formData.append('ingrd_category', category);
        });

        // 단계 목록 처리
        $('#steps > div').each(function() {
            var stepNumber = $(this).find('input[name^="rcp_step"]').val();
            var description = $(this).find('textarea[name^="step_desc"]').val();
            var image = $(this).find('input[name^="stepimg_path"]')[0].files[0];

            // 기존 name 그대로 사용하면서 FormData에 추가
            formData.append('rcp_step', stepNumber);
            formData.append('step_desc', description);
            if (image) formData.append('stepimg_path', image);
        });


        // 서버로 전송
        $.ajax({
            url: "${contextPath}/recipe/addNewRecipe",  // 서버 URL로 변경
            type: "POST",
            data: formData,
            contentType: false,
            processData: false,
            success: function(response) {
                // 서버에서 보낸 응답 메시지 확인
                if (response.status === "success") {
                    alert(response.message);  // 서버에서 전달한 메시지를 알림창에 띄움
                    $('#recipeForm')[0].reset();  // 폼 초기화
                    window.location.href = `${contextPath}/recipe/recipe_list`;  // 목록 페이지로 리다이렉션
                } else {
                    alert('레시피 등록에 실패했습니다. 다시 시도해주세요.');
                }
            },
            error: function(error) {
                console.log(error);
                alert('에러가 발생했습니다.');
            }
        });
    });

</script>
</body>
</html>