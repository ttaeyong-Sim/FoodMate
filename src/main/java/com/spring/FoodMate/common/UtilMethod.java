package com.spring.FoodMate.common;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
public class UtilMethod {
	public static String getViewName(HttpServletRequest request) throws Exception{
		String contextPath = request.getContextPath();
		String uri = (String) request.getAttribute("javax.servlet.include.request_uri");
		if(uri == null || uri.trim().equals("")) {
			uri=request.getRequestURI();
		}
		int begin = 0;
		if(!((contextPath==null) || ("".equals(contextPath))))
		{
			begin=contextPath.length();
		}
		int end;
		if(uri.indexOf(";")!= -1) {
			end = uri.indexOf(";");
		} else if(uri.indexOf("?")!= -1) {
			end = uri.indexOf("?");
		} else {
			end = uri.length();
		}
		
		String fileName = uri.substring(begin, end);
		if (fileName.indexOf(".")!= -1) {
			fileName = fileName.substring(0,fileName.lastIndexOf("."));
		}
		if (fileName.lastIndexOf("/")!=-1) {
			fileName = fileName.substring(fileName.lastIndexOf("/",1),fileName.length());
		}
		return fileName;
	}
	
	@RequestMapping(value="/deleteSession")
	public ResponseEntity<Void> deleteSession(HttpSession session) {
	    session.invalidate(); // 세션 삭제
	    return ResponseEntity.ok().build();
	}
	
	public static String savePdtImage(HttpServletRequest request, MultipartFile file, int type) throws Exception {
	    // 웹 애플리케이션 내 저장 경로 설정
	    String uploadDir;
	    
	    // `getRealPath()`로 절대 경로 동적으로 가져오기
	    if (type == 1) {
	        uploadDir = request.getServletContext().getRealPath("/resources/images/pdt");
	    } else {
	        uploadDir = request.getServletContext().getRealPath("/resources/images/pdt/description");
	    }

	    File dir = new File(uploadDir);
	    if (!dir.exists()) {
	        dir.mkdirs(); 
	    }

	    // 파일 저장 로직 (중복 처리 포함)
	    String originalFilename = file.getOriginalFilename();
	    String filePath = uploadDir + File.separator + originalFilename;
	    File dest = new File(filePath);
	    int count = 1;

	    while (dest.exists()) {
	        String fileNameWithoutExtension = originalFilename.substring(0, originalFilename.lastIndexOf('.'));
	        String extension = originalFilename.substring(originalFilename.lastIndexOf('.'));
	        String newFileName = fileNameWithoutExtension + "_" + count + extension;
	        filePath = uploadDir + File.separator + newFileName;
	        dest = new File(filePath);
	        count++;
	    }

	    file.transferTo(dest);

	    // **웹에서 접근할 수 있는 상대 경로 반환**
	    return "resources/images/pdt/" + dest.getName();
	}
	
	public static String saveRecipeImage(HttpServletRequest request, MultipartFile file) throws Exception {
	    // 저장할 디렉토리 경로 설정
		String uploadDir = request.getServletContext().getRealPath("/resources/images/recipe");

	    File dir = new File(uploadDir);
	    // 디렉토리가 존재하지 않으면 생성
	    if (!dir.exists()) {
	        dir.mkdirs(); 
	    }
	    // 파일명 생성 (기존 파일명 유지)
	    String originalFilename = file.getOriginalFilename();
	    String filePath = uploadDir + File.separator + originalFilename;

	    // 파일이 이미 존재하는지 확인하여 중복 방지 처리
	    File dest = new File(filePath);
	    int count = 1;
	    while (dest.exists()) {
	        // 중복된 파일명이 있을 경우, 뒤에 'a', 'b', ... 를 붙여서 변경
	        String fileNameWithoutExtension = originalFilename.substring(0, originalFilename.lastIndexOf('.'));
	        String extension = originalFilename.substring(originalFilename.lastIndexOf('.'));
	        String newFileName = fileNameWithoutExtension + "_" + count + extension;
	        filePath = uploadDir + File.separator + newFileName;
	        dest = new File(filePath);
	        count++;
	    }

	    // 파일을 서버에 저장
	    file.transferTo(dest);

	    // 저장된 파일 경로 반환 (웹에서 접근할 수 있는 경로)
	    return "recipe/" + dest.getName();
	}
	
	public static String saveProfileImage(HttpServletRequest request, MultipartFile file, String id) throws Exception {
	    // 저장할 디렉토리 경로 설정
		String uploadDir = request.getServletContext().getRealPath("/resources/images/recipe");

	    File dir = new File(uploadDir);
	    // 디렉토리가 존재하지 않으면 생성
	    if (!dir.exists()) {
	        dir.mkdirs(); 
	    }
	    // 파일명 생성 (기존 파일명 유지)
	    String extension = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf("."));
	    String profileImageFilename = id + "profileImage" + extension;
	    String filePath = uploadDir + File.separator + profileImageFilename;

	    File dest = new File(filePath);

	    // 파일을 서버에 저장
	    file.transferTo(dest);

	    // 저장된 파일 경로 반환 (웹에서 접근할 수 있는 경로)
	    return "profile/" + dest.getName();
	}
	
	public static String getTopLevelPath(HttpServletRequest request) throws Exception {
	    String contextPath = request.getContextPath();
	    String uri = (String) request.getAttribute("javax.servlet.include.request_uri");

	    if (uri == null || uri.trim().equals("")) {
	        uri = request.getRequestURI();
	    }

	    int begin = 0;
	    if (contextPath != null && !contextPath.equals("")) {
	        begin = contextPath.length();
	    }

	    int end = uri.length();
	    if (uri.indexOf(";") != -1) {
	        end = uri.indexOf(";");
	    } else if (uri.indexOf("?") != -1) {
	        end = uri.indexOf("?");
	    }

	    // 최상위 경로 추출
	    String path = uri.substring(begin, end);
	    String[] pathParts = path.split("/");
	    
	    if (pathParts.length > 1) {
	        return pathParts[1]; // 최상위 경로만 반환
	    } else {
	        return ""; // 최상위 경로가 없으면 빈 문자열 반환
	    }
	}
}
