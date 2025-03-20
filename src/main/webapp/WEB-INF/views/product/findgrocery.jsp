<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8" isELIgnored="false"%>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />  
<html>
<head>

<style>

body {
	background-color : #f1f3f5;
}

main {
	margin : 0 auto;
	max-width : 1200px;
}

</style>

</head>

<body>

<main>

<div id="map" style="width:100%;height:350px;"></div>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=70bfb029888956792157d3adcb1952c3"></script>
<script>
const contextPath = '${contextPath}'; 
var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = { 
        center: new kakao.maps.LatLng(36.34925773590161, 127.37753449978128), // 지도의 중심좌표
        level: 5 // 지도의 확대 레벨 
    }; 

const thatLat = 36.34925773590161;
const thatLon = 127.37753449978128;


var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

var positions = [
    {
        grocery_id: 1,
        content: '<div><strong>하나로마트</strong><br><img src="' + contextPath + '/resources/images/grocery/하나로마트.png" width="200"></div>', 
        latlng: new kakao.maps.LatLng(36.35117386173951, 127.37931230045496)
    },
    {
        grocery_id: 2,
        content: '<div><strong>시티마켓</strong><br><img src="' + contextPath + '/resources/images/grocery/시티마켓.jpg" width="200"></div>', 
        latlng: new kakao.maps.LatLng(36.351002619440564, 127.38214671238417)
    },
    {
        grocery_id: 3,
        content: '<div><strong>042마트</strong><br><img src="' + contextPath + '/resources/images/grocery/042마트.jpg" width="200"></div>', 
        latlng: new kakao.maps.LatLng(36.34686388428628, 127.3814692361245)
    }    
];

// 마커 생성 및 이벤트 등록
for (var i = 0; i < positions.length; i++) {
    (function(position) {
        var marker = new kakao.maps.Marker({
            map: map,
            position: position.latlng
        });

        var infowindow = new kakao.maps.InfoWindow({
            content: position.content
        });

        // 마우스 오버 시 인포윈도우 표시
        kakao.maps.event.addListener(marker, 'mouseover', makeOverListener(map, marker, infowindow));
        kakao.maps.event.addListener(marker, 'mouseout', makeOutListener(infowindow));

        // 마커 클릭 시 URL 이동
        kakao.maps.event.addListener(marker, 'click', function() {
            window.location.href = contextPath + "/product/compareatgrocery?grocery_id=" + position.grocery_id;
        });
    })(positions[i]);
}

// 인포윈도우 표시
function makeOverListener(map, marker, infowindow) {
    return function() {
        infowindow.open(map, marker);
    };
}

// 인포윈도우 닫기
function makeOutListener(infowindow) {
    return function() {
        infowindow.close();
    };
}




// HTML5의 geolocation으로 사용할 수 있는지 확인합니다 
if (navigator.geolocation) {
    
    // GeoLocation을 이용해서 접속 위치를 얻어옵니다
    navigator.geolocation.getCurrentPosition(function(position) {
        
        var lat = position.coords.latitude, // 위도
            lon = position.coords.longitude; // 경도
        
        var locPosition = new kakao.maps.LatLng(thatLat, thatLon), // 마커가 표시될 위치를 geolocation으로 얻어온 좌표로 생성합니다
            message = '<div style="padding:5px;">여기에 계신가요?!</div>'; // 인포윈도우에 표시될 내용입니다
        
        // 마커와 인포윈도우를 표시합니다
        displayMarker(locPosition, message);
            
      });
    
} else { // HTML5의 GeoLocation을 사용할 수 없을때 마커 표시 위치와 인포윈도우 내용을 설정합니다
    
    var locPosition = new kakao.maps.LatLng(33.450701, 126.570667),    
        message = 'geolocation을 사용할수 없어요..'
        
    displayMarker(locPosition, message);
}



// 지도에 마커와 인포윈도우를 표시하는 함수입니다
function displayMarker(locPosition, message) {

    // 마커를 생성합니다
    var marker = new kakao.maps.Marker({  
        map: map, 
        position: locPosition
    }); 
    
    var iwContent = message, // 인포윈도우에 표시할 내용
        iwRemoveable = true;

    // 인포윈도우를 생성합니다
    var infowindow = new kakao.maps.InfoWindow({
        content : iwContent,
        removable : iwRemoveable
    });
    
    // 인포윈도우를 마커위에 표시합니다 
    infowindow.open(map, marker);
    
    // 지도 중심좌표를 접속위치로 변경합니다
    map.setCenter(locPosition);      
}    
</script>

</main>

</body>
</html>