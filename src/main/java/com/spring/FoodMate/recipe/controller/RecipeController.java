package com.spring.FoodMate.recipe.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring.FoodMate.product.dto.CategoryDTO;
import com.spring.FoodMate.recipe.dto.RecipeCategoryDTO;
import com.spring.FoodMate.recipe.dto.RecipeRatingDTO;

public interface RecipeController {

 
    // 레시피 작성 폼
    ModelAndView addRecipeForm(HttpServletRequest request) throws Exception;

    // 레시피 등록
    ResponseEntity<Map<String, Object>> addNewRecipe(
            String title, 
            String foodName, 
            Integer category_id, 
            String reqTime, 
            String description, 
            MultipartFile mainImg, 
            List<String> ingredientsNames,
            List<Integer> ingredientsQty, 
            List<String> ingredientsUnits, 
            List<Integer> ingredientsCategoryIds, // 재료 카테고리 ID
            
            List<Integer> stepNumbers, 
            List<String> stepDescriptions,
            List<MultipartFile> stepImages, 
            HttpServletRequest request,
            HttpSession session
        ) throws Exception;
    
     // 레시피 상세 조회
    ModelAndView selectRecipeDetail(int rcp_Id, HttpServletRequest request) throws Exception;
    
    //레시피 수정
    ModelAndView RecipeEditForm(HttpServletRequest request) throws Exception;
    
    //레시피 하위 카테고리 가져오기
	List<RecipeCategoryDTO> getSubCategories(int category_id) throws Exception;
	
	//재료 하위 카테고리 가져오기
	List<CategoryDTO> select_Sub_IngrdCategory(@PathVariable("ingrd_category_id") int ingrd_category_id) throws Exception;
	 
	//레시피 후기 작성
	public String addRecipeRating(
	        @RequestParam("rcp_id") int rcpId,  // 레시피 ID
	        @RequestParam("rating") int rating,  // 입력한 별점
	        @RequestParam("comments") String comments,  // 댓글
	        HttpSession session, 
	        RedirectAttributes redirectAttributes
			);
	
	//레시피 후기 수정
	@RequestMapping("/recipe/updateRecipeRating")
	public String updateRecipeRating(
	        @RequestParam("cmt_rcp_rating_id") int cmt_rcp_rating_id, // 댓글 ID
	        @RequestParam("rcp_id") int rcp_id,
	        @RequestParam("rating") int rating,  // 수정할 별점
	        @RequestParam("comments") String comments,  // 수정할 댓글
	        RedirectAttributes redirectAttributes);
	
	// 레시피 후기 삭제 처리
	@RequestMapping("/recipe/deleteRecipeRating")
	public String deleteRecipeRating(
	        @RequestParam("cmt_rcp_rating_id") int cmt_rcp_rating_id,  // 삭제할 댓글 ID
	        @RequestParam("rcp_id") int rcp_id,  // 레시피 ID (리다이렉트용)
	        RedirectAttributes redirectAttributes);

	//레시피 질문 작성
	@RequestMapping("/recipe/addRecipeQna")
	public String addRecipeQna(
	        @RequestParam("rcp_id") int rcp_id,  // 레시피 ID
	        @RequestParam("comments") String comments,  // 질문 댓글
	        HttpSession session, 
	        RedirectAttributes redirectAttributes);
	
	//레시피 답변 작성
	@RequestMapping("/recipe/addRecipeQnaAwnser")
	public String addRecipeQnaAnswer( @RequestParam("rcp_id") int rcp_id,
									  @RequestParam("parent_id") int parentId, 
	                                  @RequestParam("comments") String comments, 
	                                  HttpSession session) throws Exception;
	
	
}