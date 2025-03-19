<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    request.setCharacterEncoding("UTF-8");
%>
<c:set var="contextPath" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>결제 내역 관리</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
    }

    .container {
        margin: 20px;
    }

    /* 탭 스타일 */
    .tabs {
        display: flex;
        cursor: pointer;
        border-bottom: 2px solid #ddd;
    }

    .tab-item {
        padding: 10px 20px;
        background-color: #f4f4f4;
        border-radius: 5px 5px 0 0;
        margin-right: 10px;
        transition: background-color 0.3s;
    }

    .tab-item:hover {
        background-color: #007bff;
        color: #fff;
    }

    .tab-item.active {
        background-color: #007bff;
        color: #fff;
    }
             /* 검색창 스타일 */
        .search-bar {
            display: flex;
            margin-bottom: 20px;
        }
        .search-bar input {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            flex: 1;
        }
        .search-bar select {
            padding: 8px 12px;
            margin-left: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .search-bar button {
            padding: 8px 16px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            margin-left: 10px;
            cursor: pointer;
        }
        .search-bar button:hover {
            background-color: #0056b3;
        }

    /* 결제 내역 테이블 스타일 */
    table {
        width: 100%;
        border-collapse: collapse; /* 경계선 병합 */
        margin-top: 20px;
    }

    th, td {
        padding: 12px 20px;
        text-align: left;
        border-bottom: 1px solid #ddd; /* 하단 경계선 추가 */
    }

    th {
        background-color: #f4f4f4;
        color: #333;
        font-weight: bold;
    }

    td {
        background-color: #ffffff;
        color: #555;
    }

    tr:hover td {
        background-color: #f1f1f1;
    }

    /* 버튼 스타일 */
    .btn {
        padding: 8px 16px;
        background-color: #007bff;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }

    .btn:hover {
        background-color: #0056b3;
    }

	.status-payment { background-color: #ffcc00; } /* 결제 완료 (노랑) */
	.status-shipping { background-color: #3399ff; } /* 배송중 (파랑) */
	.status-delivered { background-color: #33cc33; } /* 배송완료 (초록) */
	.status-confirmed { background-color: #ff3333; } /* 구매 확정 (빨강) */
    

    /* 페이지네이션 */
    .pagination {
        display: flex;
        justify-content: center;
        margin-top: 20px;
    }

    .pagination a {
        padding: 8px 16px;
        margin: 0 5px;
        background-color: #f4f4f4;
        border-radius: 5px;
        color: #007bff;
        text-decoration: none;
    }

    .pagination a.active {
        background-color: #007bff;
        color: white;
    }

    /* 탭 콘텐츠 기본 숨김 */
    .tab-pane {
        display: none;
    }

    /* active 클래스를 가진 탭 콘텐츠는 보이도록 설정 */
    .tab-pane.active {
        display: block;
    }
</style>



    <!-- jQuery 라이브러리 추가 -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <div class="container">
        <!-- 탭 메뉴 -->
        <div class="tabs">
            <div class="tab-item active" data-tab="paymentHistory">전체 결제 내역</div>
            <div class="tab-item" data-tab="paymentStats">결제 금액 관리</div>
            <div class="tab-item" data-tab="refundManagement">환불 관리</div>
        </div>
        <!-- 검색 기능 -->
        <div class="search-bar">
            <input type="text" id="searchInput" placeholder="검색어를 입력하세요" />
            <select id="searchFilter">
            	<option value="name">사용자 이름</option>
            </select>
            <button onclick="searchPayment()">검색</button>
        </div>

        <!-- 탭 내용 -->
       	<%-- 현재 페이지 정보 가져오기 (기본값: 1페이지) --%>
		<c:set var="HTcurrentPage" value="${param.page != null ? param.page : 1}" />
		<c:set var="HTitemsPerPage" value="6" />
		<c:set var="HTstartIndex" value="${(HTcurrentPage - 1) * HTitemsPerPage}" />
		<c:set var="HTendIndex" value="${HTcurrentPage * HTitemsPerPage}" />
			
		<%-- 전체 데이터 개수 구하기 --%>
		<c:set var="HTtotalItems" value="${fn:length(PaymentHistoryList)}" />
		<fmt:parseNumber var="HTparsedTotalPages" value="${(HTtotalItems + HTitemsPerPage - 1) / HTitemsPerPage}" integerOnly="true" />
		<c:set var="HTtotalPages" value="${HTparsedTotalPages}" />
        <!-- 전체 결제 내역 -->
        <div id="paymentHistory" class="tab-pane active">
            <h2>전체 결제 내역</h2>
            <table>
                <thead>
                    <tr>
                        <th>결제 날짜</th>
                        <th>사용자 이름</th>
                        <th>결제 금액</th>
                        <th>배송 상태</th>
                        <th>상세</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="paymentHS" items="${PaymentHistoryList}" varStatus="status">
			      	<c:if test="${status.index >= HTstartIndex && status.index < HTendIndex}">
	                    <tr>
	                        <td>${paymentHS.pay_Date}</td>
	                        <td>${paymentHS.name}</td>
	                        <td>₩<fmt:formatNumber value="${paymentHS.tot_Pdt_Price + paymentHS.ship_Fee}" pattern="#,###"/></td>
	                        <td>
	                        <c:choose>
	                        	<c:when test="${paymentHS.ord_stat == 1}">
							    <button class="btn status-payment">결제 완료</button>
								</c:when>
								<c:when test="${paymentHS.ord_stat == 2}">
								    <button class="btn status-shipping">배송중</button>
								</c:when>
								<c:when test="${paymentHS.ord_stat == 3}">
								    <button class="btn status-delivered">배송완료</button>
								</c:when>
								<c:when test="${paymentHS.ord_stat == 4}">
								    <button class="btn status-confirmed">구매 확정</button>
								</c:when>
							</c:choose>
							</td>
	                        <td><a href="${contextPath}/admin/PaymentManage/adminPaymentDetail">상세 보기</a></td>                        
	                    </tr>
	                 </c:if>
	            </c:forEach>
                </tbody>
            </table>
            <!-- 페이지네이션 -->
				<div class="pagination">
				    <%-- 이전 페이지 버튼 --%>
				    <c:if test="${HTcurrentPage > 1}">
				        <a href="?tab=paymentHistory&page=${HTcurrentPage - 1}">이전</a>
				    </c:if>
				
				    <%-- 페이지 번호 표시 --%>
				    <c:forEach var="i" begin="1" end="${HTtotalPages}">
				        <a href="?tab=paymentHistory&page=${i}" class="${i == HTcurrentPage ? 'active' : ''}">${i}</a>
				    </c:forEach>
				
				    <%-- 다음 페이지 버튼 --%>
				    <c:if test="${HTcurrentPage < HTtotalPages}">
				        <a href="?tab=paymentHistory&page=${HTcurrentPage + 1}">다음</a>
				    </c:if>
				</div>
        </div>

        <!-- 결제 금액 관리 -->
        <div id="paymentStats" class="tab-pane">
            <h2>결제 금액 관리</h2>
            <table>
                <thead>
                    <tr>
                        <th>기간</th>
                        <th>총 결제 금액</th>
                        <th>결제 건수</th>
                        <th>상세</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>2024-11-01 ~ 2025-11-30</td>
                        <td>₩500,000</td>
                        <td>4건</td>
                        <td><button class="btn">상세 보기</button></td>
                    </tr>
                    <tr>
                        <td>2024-12-01 ~ 2024-12-31</td>
                        <td>₩300,000</td>
                        <td>3건</td>
                        <td><button class="btn">상세 보기</button></td>
                    </tr>
                    <tr>
                        <td>2025-01-01 ~ 2025-01-31</td>
                        <td>₩400,000</td>
                        <td>5건</td>
                        <td><button class="btn">상세 보기</button></td>
                    </tr>
                </tbody>
            </table>
        </div>

       	<%-- 현재 페이지 정보 가져오기 (기본값: 1페이지) --%>
		<c:set var="RFcurrentPage" value="${param.page != null ? param.page : 1}" />
		<c:set var="RFitemsPerPage" value="6" />
		<c:set var="RFstartIndex" value="${(RFcurrentPage - 1) * RFitemsPerPage}" />
		<c:set var="RFendIndex" value="${RFcurrentPage * RFitemsPerPage}" />
			
		<%-- 전체 데이터 개수 구하기 --%>
		<c:set var="RFtotalItems" value="${fn:length(PaymentRefundList)}" />
		<fmt:parseNumber var="RFparsedTotalPages" value="${(RFtotalItems + RFitemsPerPage - 1) / RFitemsPerPage}" integerOnly="true" />
		<c:set var="RFtotalPages" value="${RFparsedTotalPages}" />
        <!-- 환불 관리 -->
        <div id="refundManagement" class="tab-pane">
            <h2>환불 관리</h2>
            <table>
                <thead>
                    <tr>
                        <th>환불 요청 날짜</th>
                        <th>사용자 이름</th>
                        <th>환불 금액</th>
                        <th>환불 상태</th>
                        <th>상세</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="paymentRF" items="${PaymentRefundList}" varStatus="status">
			      	<c:if test="${status.index >= RFstartIndex && status.index < RFendIndex}">
	                    <tr>
	                        <td>${paymentRF.pay_Date}</td>
	                        <td>${paymentRF.name}</td>
	                        <td>₩<fmt:formatNumber value="${paymentRF.tot_Pdt_Price + paymentRF.ship_Fee}" pattern="#,###"/></td>
	                        <td>
	                        <c:choose>
	                        	<c:when test="${paymentHS.pay_Status == '0'}">
							    <button class="btn status-payment">대기 중</button>
								</c:when>
								<c:when test="${paymentHS.pay_Status == '1'}">
								    <button class="btn status-shipping">성공</button>
								</c:when>
								<c:when test="${paymentHS.pay_Status == '2'}">
								    <button class="btn status-delivered">취소</button>
								</c:when>
								<c:when test="${paymentHS.pay_Status == '3'}">
								    <button class="btn status-confirmed">환불</button>
								</c:when>
							</c:choose>
							</td>
	                        <td>${paymentHS.pay_Status}<button class="btn">상세 보기</button></td>
	                    </tr>
                	</c:if>
                </c:forEach>
                </tbody>
            </table>
            <!-- 페이지네이션 -->
				<div class="pagination">
				    <%-- 이전 페이지 버튼 --%>
				    <c:if test="${RFcurrentPage > 1}">
				        <a href="?tab=refundManagement&page=${RFcurrentPage - 1}">이전</a>
				    </c:if>
				
				    <%-- 페이지 번호 표시 --%>
				    <c:forEach var="i" begin="1" end="${RFtotalPages}">
				        <a href="?tab=refundManagement&page=${i}" class="${i == RFcurrentPage ? 'active' : ''}">${i}</a>
				    </c:forEach>
				
				    <%-- 다음 페이지 버튼 --%>
				    <c:if test="${RFcurrentPage < RFtotalPages}">
				        <a href="?tab=refundManagement&page=${RFcurrentPage + 1}">다음</a>
				    </c:if>
				</div>
        </div>
    </div>

    <script>
    $(document).ready(function() {
        var tab = "${tab}"; // 서버에서 받아온 tab 값

        if (tab) {
            activateTab(tab);
        }

        $(".tab-item").on("click", function() {
            var tabId = $(this).data("tab");
            activateTab(tabId);
            history.pushState(null, null, "?tab=" + tabId);
        });

        function activateTab(tabName) {
            $(".tab-item").removeClass("active");
            $(".tab-pane").removeClass("active");
            $(".tab-item[data-tab='" + tabName + "']").addClass("active");
            $("#" + tabName).addClass("active");
        }
    });
        
    </script>
</body>
</html>
