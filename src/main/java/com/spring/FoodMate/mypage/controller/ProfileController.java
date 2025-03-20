package com.spring.FoodMate.mypage.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;

import com.spring.FoodMate.common.UtilMethod;
import com.spring.FoodMate.member.dto.BuyerDTO;
import com.spring.FoodMate.member.dto.SellerDTO;
import com.spring.FoodMate.mypage.dto.ProfileDTO;
import com.spring.FoodMate.mypage.dto.SellerProfileDTO;
import com.spring.FoodMate.mypage.service.ProfileService;


@Controller
public class ProfileController {
	private static final Logger logger = LoggerFactory.getLogger(ProfileController.class);
	
	@Autowired
    private ProfileService profileService;
	
	@RequestMapping(value="/mypage/profileUpdate" ,method = RequestMethod.POST)
	public ResponseEntity profileUpdate(@ModelAttribute("ProfileDTO") ProfileDTO _profileDTO,
			                HttpServletRequest request, HttpServletResponse response) throws Exception {
		response.setContentType("text/html; charset=UTF-8");
		request.setCharacterEncoding("utf-8");
		HttpSession session = request.getSession();
		BuyerDTO buyerInfo = (BuyerDTO) session.getAttribute("buyerInfo"); // 세션에서 buyerInfo 가져오기
		String byr_id = null;
		String message = null;
		ResponseEntity resEntity = null;
		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type", "text/html; charset=utf-8");
		
		if (buyerInfo != null) {
		    byr_id = buyerInfo.getByr_id(); // byr_id 값 추출
		    _profileDTO.setByr_id(byr_id);
		}
		try {
            MultipartFile file = _profileDTO.getProfileImageInput();

            if (file != null && !file.isEmpty()) {
                // 새로운 이미지 저장
            	String imagePath = UtilMethod.saveProfileImage(request, _profileDTO.getProfileImageInput(), byr_id);
                _profileDTO.setImg_path(imagePath);
            } else {
                // 기존 이미지 유지
            	ProfileDTO profileDTO = profileService.getBuyerProfile(byr_id);
                String fileUrl = profileDTO.getImg_path();
                _profileDTO.setImg_path(fileUrl);
            }

            // DB 업데이트
            boolean updateSuccess = profileService.updateUserProfile(_profileDTO);

            if (updateSuccess) {
            	message  = "<script>";
    		    message +=" alert('정상적으로 프로필이 수정되었습니다.');";
    		    message += " location.href='"+request.getContextPath()+"/mypage/myInfoManage/profileEditForm.do';";
    		    message += " </script>";
            } else {
            	message  = "<script>";
    		    message +=" alert('오류가 발생했습니다. 다시 시도해주십시오.');";
    		    message += " location.href='"+request.getContextPath()+"/mypage/myInfoManage/profileEditForm.do';";
    		    message += " </script>";
            }
        } catch (IOException e) {
        	message  = "<script>";
		    message +=" alert('프로필 사진 저장에 실패했습니다. 다시 시도해주십시오.');";
		    message += " location.href='"+request.getContextPath()+"/mypage/myInfoManage/profileEditForm.do';";
		    message += " </script>";
        }
		resEntity = new ResponseEntity(message, responseHeaders, HttpStatus.OK);
		return resEntity;
    }
	
	@RequestMapping(value="/mypage_seller/sellerProfileUpdate" ,method = RequestMethod.POST)
	public ResponseEntity profileUpdate(@ModelAttribute("SellerProfileDTO") SellerProfileDTO _profileDTO,
			                HttpServletRequest request, HttpServletResponse response) throws Exception {
		response.setContentType("text/html; charset=UTF-8");
		request.setCharacterEncoding("utf-8");
		HttpSession session = request.getSession();
		SellerDTO sellerInfo = (SellerDTO) session.getAttribute("sellerInfo"); // 세션에서 sellerInfo 가져오기
		String slr_id = null;
		String message = null;
		ResponseEntity resEntity = null;
		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type", "text/html; charset=utf-8");
		
		if (sellerInfo != null) {
			slr_id = sellerInfo.getSlr_id(); // byr_id 값 추출
		    _profileDTO.setSlr_id(slr_id);
		}
		try {
            MultipartFile file = _profileDTO.getProfileImageInput();

            if (file != null && !file.isEmpty()) {
                // 새로운 이미지 저장
            	String imagePath = UtilMethod.saveProfileImage(request, _profileDTO.getProfileImageInput(), slr_id);
                _profileDTO.setImg_path(imagePath);
            } else {
                // 기존 이미지 유지
            	SellerProfileDTO profileDTO = profileService.getSellerProfile(slr_id);
                String fileUrl = profileDTO.getImg_path();
                _profileDTO.setImg_path(fileUrl);
            }

            // DB 업데이트
            boolean updateSuccess = profileService.updateSellerProfile(_profileDTO);

            if (updateSuccess) {
            	message  = "<script>";
    		    message +=" alert('정상적으로 프로필이 수정되었습니다.');";
    		    message += " location.href='"+request.getContextPath()+"/mypage_seller/myInfoManage/profileEditForm.do';";
    		    message += " </script>";
            } else {
            	message  = "<script>";
    		    message +=" alert('오류가 발생했습니다. 다시 시도해주십시오.');";
    		    message += " location.href='"+request.getContextPath()+"/mypage_seller/myInfoManage/profileEditForm.do';";
    		    message += " </script>";
            }
        } catch (IOException e) {
        	System.out.println(e);
        	message  = "<script>";
		    message +=" alert('프로필 사진 저장에 실패했습니다. 다시 시도해주십시오.');";
		    message += " location.href='"+request.getContextPath()+"/mypage_seller/myInfoManage/profileEditForm.do';";
		    message += " </script>";
        }
		resEntity = new ResponseEntity(message, responseHeaders, HttpStatus.OK);
		return resEntity;
    }
	        

}
