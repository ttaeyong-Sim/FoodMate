<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8" isELIgnored="false"%>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />  
<html>
<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
<style>
@import url('https://fonts.googleapis.com/css2?family=Black+Han+Sans&family=Do+Hyeon&family=Noto+Sans+KR:wght@100..900&display=swap');

#wrap_cmp {
    background-color: #f1f3f5;
}

#wrap_cmp #rcp_intro {
	padding: 20px 20px 10px;
	display: flex;
	justify-content: space-between;
}

#wrap_cmp #rcp_intro #rcp_imgAndName {
	font-family: "Do Hyeon", "Noto Sans KR", serif;
	text-align: center;
	font-size: 1.5rem;
}

#wrap_cmp #rcp_step {
    padding: 20px 30px 0 10px;
    font-size: 1.5rem;
    font-family: "Noto Sans KR", serif;
}

#wrap_cmp #rcp_step span.step-number {
    display: inline-block;
    width: 30px;
    height: 30px;
    line-height: 30px;
    border-radius: 50%;
    background-color: #2ecc71; /* 초록색 */
    color: white;
    text-align: center;
    font-weight: bold;
    margin-right: 10px;
}

#wrap_cmp .rcp_img {
	width: 200px;
	border-radius: 10px;
}

#wrap_cmp .section_container {
    background-color: white;
    width: 1200px;
    margin: 0px auto;
    display: flex;
}

#wrap_cmp #cmp_pdt {
    width: 65%;
}

#wrap_cmp #cmp_pdt .pdt_row {
	padding: 15px;
	border-bottom: 1px solid black;
}

#wrap_cmp #cmp_pdt .pdt_Name {
	font-family: "Noto Sans KR", serif;
	font-size: 1.5rem;
}

#wrap_cmp #cmp_pdt .pdt_Selr,
#wrap_cmp #cmp_pdt .pdt_Rank {
	font-family: "Noto Sans KR", serif;
	font-size: 1.2rem;
}

#wrap_cmp .pdt_img {
    width: 100px;
}

#wrap_cmp #cmp_pdt article {
    display: flex;
}

#wrap_cmp #cmp_pdt article div:first-child {
    margin-right: 20px;
}

#wrap_cmp #cmp_pdt article div:nth-child(2) {
    font-weight: bold;
    max-width: 60%;
}

#wrap_cmp #cmp_pdt article div:nth-child(3) {
	font-family: "Do Hyeon", "Black Han Sans", "Noto Sans KR", serif;
	font-size: 2rem;
    text-align: right;
    margin-left: auto;
    font-weight: 500;
    color: red;
    align-self: center;
}

#wrap_cmp #cmp_pdt article div:nth-child(3) .pdt_Qty,
#wrap_cmp #cmp_pdt article div:nth-child(3) .pdt_Unit {
	font-family: "Noto Sans KR", serif;
	font-size: 1.2rem;
    text-align: right;
    margin-left: auto;
    color: black;
    align-self: center;
}

#wrap_cmp #cmp_pdt article div:nth-child(3) .pdt_Unit {
	margin-right: 10px;
}

#wrap_cmp #cmp_pdt article div:nth-child(3) .pdt_UnitPrice {
	font-size: 1.2rem;
	color: black;
}

#wrap_cmp .pdt_chk {
	font-family: "Noto Sans KR", serif;
	font-size: 1.25rem;
}

#wrap_cmp #rcp_spread {
	font-family: "Noto Sans KR", serif;
	width: 100%;
	text-align: center;
	font-size: 1.5rem;
	background-color: #fa9820;
	margin-bottom: 20px;
	padding-top: 10px;
	padding-bottom: 10px;
	color: white;
}

<!-- 페이지네이션 부분 css -->

#wrap_cmp #pdt_pagenation {
    display: flex;
    justify-content: center;
    align-items: center;
    margin: 20px 0;
    font-family: "Noto Sans KR", sans-serif;
}

#wrap_cmp #pdt_pagenation .page_btn {
    background-color: #fa9820;
    color: white;
    border: none;
    padding: 10px 15px;
    margin: 0 5px;
    font-size: 1rem;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s ease;
}

#wrap_cmp #pdt_pagenation .page_btn:hover {
    background-color: #d9791b;
}

.product-qty {
	width: 30px;
}

.sort_button {
	width: 1200px;
    display: flex;
    justify-content: flex-start; /* 왼쪽 정렬 */
    align-items: center; /* 세로 정렬 */
}

.sort_button .sort {
    padding: 5px 10px 5px; /* 내부 여백 */
    border: 1px solid #ccc; /* 외곽선 */
    background-color: #f5f5f5; /* 입력창 배경색과 유사 */
    font-family: 'Noto Sans KR', sans-serif; /* 한국어 폰트 */
    text-align: center; /* 텍스트 중앙 정렬 */
    cursor: pointer; /* 클릭 가능 표시 */
    height: auto; /* 버튼 높이 설정 */
    line-height: 30px; /* 텍스트 정렬 */
    border-left: none; /* 왼쪽 외곽선 제거 */
    transition: background-color 0.3s, border-color 0.3s;
}

.hidden { display: none; }

#toggleBtn {
    background-color: #74b243; /* Bootstrap primary 색상 */
    color: white;
    font-weight: bold;
    padding: 12px 24px;
    border-radius: 50px;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.2);
    border: none;
    display: block;
    margin: 0 auto;
    align-items: center;
    gap: 8px;
}

#toggleBtn:hover {
    background-color: #0056b3;
}

</style>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
var contextPath = "${contextPath}";

// 레시피 재료 누르면 비교 시작하게 상품들 띄워주는 스크립트
$(document).on('click', '.rcp_Mtrs', function() {
    var categoryId = $(this).find('input[name="category_id"]').val();
    // 히든input에서 category_id 값 가져오기
    
    $.ajax({
        url: contextPath + '/product/categorycompare',  // 요청할 URL
        method: 'GET',
        data: { category_id: categoryId },  // category_id를 GET 파라미터로 전달
        success: function(response) {
        	$("#currentCategory_id").val(categoryId);  // 상품정렬버튼의 hidden input에 카테고리ID 넣어두고
	        var products = response.products;  // 상품 목록 받기
	        var productHtml = '';
	
	        products.forEach(function(product) {
	        	let rating = Math.round(product.avg_rating); // 평균 평점을 반올림
	            let stars = '⭐'.repeat(rating); // 별 개수 생성
            productHtml += '<article class="pdt_row">' +          
                '<div>' +
	                '<a href="' + contextPath + '/product/pdtdetail?pdt_id=' + product.pdt_id + '" target="_blank" rel="noopener noreferrer">' + 
	                // rel="noopener noreferrer" 속성이 보안에 도움된다고 함. 새로 연 페이지에서 기존 페이지에 간섭 못하게 막는거. 
	                
		                '<img class="pdt_img" src="' + contextPath + '/resources/images/' + product.img_path + '">' +
		            '</a>' +
                '</div>' +
                '<div>' +
                    '<span class="pdt_Name">' + product.name + '</span><br>' +
                    '<span class="pdt_Selr">판매자 : ' + product.slr_nickname + '</span><br>' +
                    '<span class="pdt_Id">상품번호 : ' + product.pdt_id + '</span><br>' +
                    '<span class="pdt_Rank">' + stars + '(후기 ' + product.review_count + '개)' + '</span><br>' +
                '</div>' +
                '<div>' +
                	'<span class="pdt_Qty">' + product.qty + '</span>' + '<span class="pdt_Unit">' + product.unit + '</span>' +
                	'<span class="pdt_Price" data-price="' + product.price + '">' + product.price.toLocaleString() + '</span>원 ';
	      	if (product.unit === 'ml' || product.unit === 'g') {
	      	    if (product.unit_price) {
	      	        productHtml += '<br><span class="pdt_UnitPrice">100' + product.unit + '당 가격 : ' + Math.floor(product.unit_price * 100).toLocaleString() + '원</span><br>';
	      	    }
	      	} else if (product.unit === 'l') {
	      	    if (product.unit_price) {
	      	        productHtml += '<br><span class="pdt_UnitPrice">100ml당 가격 : ' + Math.floor(product.unit_price * 100).toLocaleString() + '원</span><br>';
	      	    }
	      	} else if (product.unit === 'kg') {
	      	    if (product.unit_price) {
	      	        productHtml += '<br><span class="pdt_UnitPrice">100g당 가격 : ' + Math.floor(product.unit_price * 100).toLocaleString() + '원</span><br>';
	      	    }
	      	} else {
	      	    productHtml += '<br><span class="pdt_UnitPrice">1' + product.unit + '당 가격 : ' + Math.floor(product.unit_price || 0).toLocaleString() + '원</span><br>';
	      	}
	      	
	      	productHtml += '<button class="pdt_chk" data-category-id="' + product.category_id + '">담기</button>' +
				            '</div>' +
				        '</article>';
			
	        });
	
	        $('#cmp_pdt').html(productHtml);  // 결과를 페이지에 반영
            
        } ,
        error: function(xhr, status, error) {
            console.error('AJAX 요청 실패', error);
            alert('상품 비교 중 오류가 발생했습니다.');
        }
    });
});


// 상품 정렬 버튼 누르면 상품들 정렬해주는 스크립트
$(document).on('click', '.sort', function() {
	var categoryId = $('#currentCategory_id').val().trim(); // 올바르게 카테고리 ID 가져오기
    var sortType = $(this).data('sort'); // data-sort 속성 값 가져오기
    
    console.log("Category ID:", categoryId);
    console.log("Sort Type:", sortType);
    // 정렬버튼과 같이있는 히든input에서 currentCategory_id 값 가져오기
    if (!categoryId) {
        alert("가격을 비교할 재료를 먼저 선택하세요.");
        return;  // 여기서 함수 종료 -> ajax 요청 안 보냄
    }
    // 여기서 커런트카테고리ID가 null이면 한번 걸러야함. /////////////////////////////////////////
    
    $.ajax({
        url: contextPath + '/product/categorycompare',  // 요청할 URL
        method: 'GET',
        data: { category_id: categoryId,
        		sort: sortType
        },  // category_id를 GET 파라미터로 전달
     // 여기서 sort방식도 같이 줘야함. /////////////////////////////////////////
     
        success: function(response) {
	        var products = response.products;  // 상품 목록 받기
	        var productHtml = '';
	
	        products.forEach(function(product) {
	        	let rating = Math.round(product.avg_rating); // 평균 평점을 반올림
	            let stars = '⭐'.repeat(rating); // 별 개수 생성
	        	
            productHtml += '<article class="pdt_row">' +          
                '<div>' +
	                '<a href="' + contextPath + '/product/pdtdetail?pdt_id=' + product.pdt_id + '" target="_blank" rel="noopener noreferrer">' + 
	                // rel="noopener noreferrer" 속성이 보안에 도움된다고 함. 새로 연 페이지에서 기존 페이지에 간섭 못하게 막는거. 
	                
		                '<img class="pdt_img" src="' + contextPath + '/resources/images/' + product.img_path + '">' +
		            '</a>' +
                '</div>' +
                '<div>' +
                    '<span class="pdt_Name">' + product.name + '</span><br>' +
                    '<span class="pdt_Selr">판매자 : ' + product.slr_nickname + '</span><br>' +
                    '<span class="pdt_Id">상품번호 : ' + product.pdt_id + '</span><br>' +
                    '<span class="pdt_Rank">' + stars + '(후기 ' + product.review_count + '개)' + '</span><br>' +
                '</div>' +
                '<div>' +
                	'<span class="pdt_Qty">' + product.qty + '</span>' + '<span class="pdt_Unit">' + product.unit + '</span>' +
                	'<span class="pdt_Price" data-price="' + product.price + '">' + product.price.toLocaleString() + '</span>원 ';
	      	if (product.unit === 'ml' || product.unit === 'g') {
	      	    if (product.unit_price) {
	      	        productHtml += '<br><span class="pdt_UnitPrice">100' + product.unit + '당 가격 : ' + Math.floor(product.unit_price * 100).toLocaleString() + '원</span><br>';
	      	    }
	      	} else if (product.unit === 'l') {
	      	    if (product.unit_price) {
	      	        productHtml += '<br><span class="pdt_UnitPrice">100ml당 가격 : ' + Math.floor(product.unit_price * 100).toLocaleString() + '원</span><br>';
	      	    }
	      	} else if (product.unit === 'kg') {
	      	    if (product.unit_price) {
	      	        productHtml += '<br><span class="pdt_UnitPrice">100g당 가격 : ' + Math.floor(product.unit_price * 100).toLocaleString() + '원</span><br>';
	      	    }
	      	} else {
	      	    productHtml += '<br><span class="pdt_UnitPrice">1' + product.unit + '당 가격 : ' + Math.floor(product.unit_price || 0).toLocaleString() + '원</span><br>';
	      	}
	      	
	      	productHtml += '<button class="pdt_chk" data-category-id="' + product.category_id + '">담기</button>' +
				            '</div>' +
				        '</article>';
			
	        });
	
	        $('#cmp_pdt').html(productHtml);  // 결과를 페이지에 반영
            
        } ,
        error: function(xhr, status, error) {
            console.error('AJAX 요청 실패', error);
            alert('상품 비교 중 오류가 발생했습니다.');
        }
    });
});


// 담기 누르면 재료목록에 담는 기능
$(document).on('click', '.pdt_chk', function() {
    var categoryId = $(this).data('category-id'); // 상품의 category_id 가져오기
    var productId = $(this).closest('.pdt_row').find('.pdt_Id').text().replace("상품번호 : ", "").trim();
    var productName = $(this).closest('.pdt_row').find('.pdt_Name').text(); // 상품 이름
    var price = parseInt($(this).closest('.pdt_row').find('.pdt_Price').data("price"));
    
    
    console.log(price);
    
    var productUnit = $(this).closest('.pdt_row').find('.pdt_Unit').text();

    var existingItem = $("#" + categoryId).find('.rcp_Mtrs_Product input[name="product-id"][value="' + productId + '"]').closest('.rcp_Mtrs_Product');
    
    if (existingItem.length > 0) {
        // 같은 상품이 이미 존재하면 수량 증가
        var qtyInput = existingItem.find('.product-qty');
        qtyInput.val(parseInt(qtyInput.val()) + 1);

        // 총 가격 업데이트
        updateTotalPrice(existingItem, price);
    } else {
        // 새로운 상품 추가
        var newItem = `
        	<div class="rcp_Mtrs_Product">
	            <div class="rcp_Mtrs_Cart">` + productName + `</div>
	            <div class="rcp_Mtrs_Cart_Amount">
	                <input type="number" class="product-qty" value="1" min="1">
	                <button class="remove-item">X</button>
	                <div class="total-price">` + price.toLocaleString() + `원</div>
	            </div>
	            <input type="hidden" name="product-id" value='` + productId + `'>
	            <input type="hidden" name="price" value='` + price + `'>
            </div>
        `;
        $("#" + categoryId).append(newItem);
    }updateTotalPrice(existingItem, price);
    updateLastTotalPrice();
});

//개별 상품 총 가격 업데이트 함수
function updateTotalPrice(item, price) {
    var qty = parseInt(item.find('.product-qty').val());
    var totalPriceElem = item.find('.total-price');
    var totalPrice = price * qty;
    
    totalPriceElem.text(totalPrice.toLocaleString() + "원");

    // 전체 최종 가격 업데이트
    updateLastTotalPrice();
}

// 전체 최종 가격 업데이트 함수
function updateLastTotalPrice() {
    var lastTotalPrice = 0;

    $(".rcp_Mtrs_Product").each(function() {
        var totalPriceText = $(this).find('.total-price').text().replace(/,/g, "").replace("원", "").trim();
        lastTotalPrice += parseInt(totalPriceText);
    });

    // 천 단위마다 쉼표 추가 후 적용
    $("#last_total_price").text(lastTotalPrice.toLocaleString());
}

// 수량 인풋 변경 시 총 가격 업데이트
$(document).on('input', '.product-qty', function() {
    var item = $(this).closest('.rcp_Mtrs_Product');
    var price = parseInt(item.find('input[name="price"]').val());  // hidden input의 value 가져오기

    updateTotalPrice(item, price);
});

// 삭제 버튼 클릭 시 해당 상품 삭제
$(document).on('click', '.remove-item', function() {
    $(this).closest('.rcp_Mtrs_Product').remove();
    updateLastTotalPrice();
});

// 담은 상품 모아서 장바구니로 ajax 던지기
$(document).on("click", "#cart-button", function() {
    console.log("장바구니 버튼 클릭됨!"); // 버튼 클릭 확인

    var dataToSend = [];

    $(".rcp_Mtrs_Product").each(function() {
        var productId = $(this).find('input[name="product-id"]').val();
        var quantity = $(this).find('.product-qty').val();

        dataToSend.push({
            pdt_id: productId,
            qty: quantity
        });
    });
    
    console.log('보낼데이터는');
    console.log(dataToSend);

    $.ajax({
    	url: contextPath + "/cart/compareaddtocart",
        type: "POST",
        contentType: "application/json",
        data: JSON.stringify(dataToSend),
        success: function(response) {
            alert("장바구니에 상품들을 추가했습니다. 장바구니로 이동합니다.");
            window.location.href = contextPath + "/cart/cartlist";
        },
        error: function(error) {
            alert("장바구니에 상품들을 담는 중 오류가 발생하였습니다. 다시 시도해 주세요.");
        }
    });
});

$(document).ready(function(){
    $("#toggleBtn").click(function(){
        $(".recipe-step.hidden").slideToggle();

        // 버튼 텍스트 및 아이콘 변경
        let isExpanded = $(this).data("expanded");
        if (isExpanded) {
            $(this).html('<i class="bi bi-chevron-down"></i> 레시피 펼치기');
        } else {
            $(this).html('<i class="bi bi-chevron-up"></i> 레시피 접기');
        }
        $(this).data("expanded", !isExpanded);
    });
});

</script>


</head>
<body>
<main id="wrap_cmp">
	<div class="section_container">
		<section id="rcp_intro">
			<article id="rcp_imgAndName">
				<a href="${contextPath}/recipe/recipe_Detail?rcp_id=${recipe.rcp_id}" target="_blank">
					<img class="rcp_img" src="${contextPath}/resources/images/<c:out value='${recipe.mainimg_path}'/>">
				</a>
				<br><c:out value="${recipe.title}" />
				<br>작성자 : <c:out value="${recipe.nickname }" />
			</article>
		</section>
		
		<section id="rcp_step" class="mb-2">
		    <c:forEach var="step" items="${steps}" varStatus="status">
			    <div class="recipe-step ${status.index >= 7 ? 'hidden' : ''}">
			        <span class="step-number">${step.rcp_step}</span> ${step.step_desc}<br>
			    </div>
			</c:forEach>
		</section>
	</div>

	<div class="section_container">
		<section id="rcp_spread">
			<div class="d-flex justify-content-center mt-3">
			    <button id="toggleBtn">
			        <i class="bi bi-chevron-down"></i> <span>레시피 펼치기</span>
			    </button>
			</div>
		</section>
	</div>
	
	<div class="section_container">
		<section class="sort_button">
		    <a href="javascript:void(0)" class="sort" data-sort="price_asc">낮은 가격순</a>
		    <a href="javascript:void(0)" class="sort" data-sort="price_desc">높은 가격순</a>
		    <a href="javascript:void(0)" class="sort" data-sort="unitprice_asc">단위당 낮은 가격순</a>
		    <a href="javascript:void(0)" class="sort" data-sort="unitprice_desc">단위당 높은 가격순</a>
		    <input type="hidden" name="currentCategory_id" id="currentCategory_id" value="">
		</section>
	</div>

	<div class="section_container">
		<section id="cmp_pdt">
			<article class="pdt_row">
				<div>
					구매할 재료를 선택하세요
				</div>
			</article>
		</section>
		
<style>

#wrap_cmp #cmp_rcp {
    width: 35%;
    border: 1px solid black;
    background-color: #f1f3f5;
    font-family: "Noto Sans KR", sans-serif;
    padding: 20px 20px;
}

#cmp_rcp #rcp_Name,
#cmp_rcp #rcp_Writer,
#cmp_rcp #rcp_Rq_Mtr,
#cmp_rcp #rcp_Rq_Spice {
	text-align: center;
	font-size: 1.5rem;
}

#cmp_rcp #rcp_Rq_Mtr,
#cmp_rcp #rcp_Rq_Spice {
	font-size: 1.25rem;
	font-weight: 600;
}

#cmp_rcp .Mtrs,
#cmp_rcp .Spices {
	border: 1px solid black;
	background-color: white;
	margin-bottom: 20px;
}

#cmp_rcp .rcp_Mtrs,
#cmp_rcp .rcp_Spices {
	width: 100%;
	background-color: #fa9820;
	color: white;
	text-align: left;
	font-size: 1.1rem;
	font-weight: 600;
	border: none;
}

#cmp_rcp .rcp_Mtrs_Cart,
#cmp_rcp .rcp_Mtrs_Cart_Amount,
#cmp_rcp .rcp_Spices_Cart,
#cmp_rcp .rcp_Spices_Cart_Amount {	
	text-align: left;
	font-size: 1rem;
	padding-left: 20px;
	padding-right: 20px;
}

#cmp_rcp .rcp_Mtrs,
#cmp_rcp .rcp_Spices {
	padding: 5px 10px 5px;
	border-bottom: 1px solid gray;
}

#cmp_rcp .rcp_Mtrs_Cart,
#cmp_rcp .rcp_Spices_Cart {
	margin-top: 10px;
}

#cmp_rcp .rcp_Mtrs_Cart_Amount,
#cmp_rcp .rcp_Spices_Cart_Amount {
	margin-bottom: 10px;
	display: flex;
	justify-content: space-between;
	align-items: center
}

.Mtrs {
	border-bottom: 1px solid black !important; 
}

.Mtrs .rcp_Mtrs_Cart_Amount div:nth-child(2) {
  font-family: "Noto Sans KR", serif;
  font-size: 1.25rem;
  font-weight: 600;
}

.Mtrs .rcp_Mtrs_Cart_Amount div:last-child {
	margin-left: auto;
}

#cmp_rcp #cart-button {
    display: block;
    width: 250px;
    text-align: center;
    margin: 20px auto;
    padding: 10px 0;
    font-size: 1.5rem;
    font-weight: 600;
    color: white;
    background-color: #fa9820;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s ease;
}

#cmp_rcp .cart-button:hover {
    background-color: #d9791b;
}

#last_total_price_container {
	font-family: "Noto Sans KR", serif;
	font-size: 1.5rem;
	color: red;
}

</style>
		
		<section id="cmp_rcp">
			<article id="rcp_Rq_Mtr">
				재료 목록
				
				<c:forEach var="ingredient" items="${ingredients}">
				    <div class="Mtrs" id="<c:out value='${ingredient.category_id}' />">
				        <button class="rcp_Mtrs">
				            <c:out value="${ingredient.ingrd_name}" /> 
				            <c:out value="${ingredient.ingrd_qty}" /> 
				            <c:out value="${ingredient.unit}" />
				            <input type="hidden" name="category_id" value="<c:out value='${ingredient.category_id}' />">
				        </button>
				    </div>
				</c:forEach>

			</article>
			
			<article id="last_total_price_container">
			총 가격 : <span id="last_total_price"></span>원
			</article>
			
			<button id="cart-button">장바구니에 담기</button>
		</section>
	</div>
</main>

</body>
</html>