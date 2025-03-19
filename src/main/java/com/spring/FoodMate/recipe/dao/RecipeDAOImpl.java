package com.spring.FoodMate.recipe.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.spring.FoodMate.common.exception.DBException;
import com.spring.FoodMate.product.dto.CategoryDTO;
import com.spring.FoodMate.recipe.dto.RecipeCategoryDTO;
import com.spring.FoodMate.recipe.dto.RecipeDTO;
import com.spring.FoodMate.recipe.dto.RecipeIngredientDTO;
import com.spring.FoodMate.recipe.dto.RecipeQnaDTO;
import com.spring.FoodMate.recipe.dto.RecipeRatingDTO;
import com.spring.FoodMate.recipe.dto.RecipeStepDTO;

@Repository
public class RecipeDAOImpl implements RecipeDAO {

    @Autowired
    private SqlSession sqlSession;

    // 레시피 등록
    @Override
    public void insertRecipe(RecipeDTO recipe) throws Exception {
        sqlSession.insert("mapper.recipe.insertRecipe", recipe);  // 레시피 삽입
    }

    // 레시피 ID 반환
    @Override
    public int selectLastInsertedRecipeId() throws Exception {
        return sqlSession.selectOne("mapper.recipe.selectLastInsertedRecipeId");  // 마지막 삽입된 레시피 ID 조회
    }

    // 재료 삽입
    @Override
    public void insertRecipeIngredients(RecipeIngredientDTO ingredient) throws Exception {
        sqlSession.insert("mapper.recipe.insertRecipeIngredients", ingredient);  // 재료 삽입
    }

    // 단계 삽입
    @Override
    public void insertRecipeSteps(RecipeStepDTO step) throws Exception {
        sqlSession.insert("mapper.recipe.insertRecipeSteps", step);  // 단계 삽입
    }

    // 레시피 목록 조회
    @Override
    public List<RecipeDTO> selectRecipeList() throws Exception {
        return sqlSession.selectList("mapper.recipe.selectRecipeList");  // 레시피 목록 조회
    }
    
    // 대분류 카테고리 레시피 조회
    @Override
    public List<RecipeDTO> selectRecipeByParent(int parent_id) {
        return sqlSession.selectList("selectRecipeByParent", Map.of("parent_id", parent_id));
    }

    // 중분류 카테고리 레시피 조회
    @Override
    public List<RecipeDTO> selectRecipeByChild(int category_id) {
        return sqlSession.selectList("selectRecipeByChild", Map.of("category_id", category_id));
    }
    
        // 레시피 목록 평점순으로 조회
    @Override
    public List<RecipeDTO> selectRecipeListByRating() throws Exception {
        return sqlSession.selectList("mapper.recipe.selectRecipeListByRating");  // 레시피 목록 조회
    }    

    // 레시피 목록 검색
    public List<RecipeDTO> searchRecipeList(String keyword) throws Exception {
    	Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("keyword", keyword);
        return sqlSession.selectList("mapper.recipe.searchRecipeList", paramMap);  // 레시피 목록 조회
    }
    
    @Override
    // 레시피 목록 조회 회원ID로
    public List<RecipeDTO> selectRecipeListByrID(String byr_id) throws Exception {
        return sqlSession.selectList("mapper.recipe.selectRecipeListByrID", byr_id);  // 레시피 목록 조회
    }
    
    // 레시피 상세 조회
    @Override
    public RecipeDTO selectRecipeDetail(int rcp_id) throws Exception {   
    	RecipeDTO recipeDTO = (RecipeDTO) sqlSession.selectOne("mapper.recipe.selectRecipeDetail", rcp_id);
    	return recipeDTO;
    }
	
	@Override
	public List<RecipeIngredientDTO> selectIngredientDetail(int rcp_id) throws DataAccessException {
		List<RecipeIngredientDTO> ingredientVO = sqlSession.selectList("mapper.recipe.selectIngredientDetail",rcp_id);
		return ingredientVO;
	}
	
	@Override
	public List<RecipeStepDTO> selectStepDetail(int rcp_id) throws DataAccessException {
		List<RecipeStepDTO> stepVO = sqlSession.selectList("mapper.recipe.selectStepDetail",rcp_id);
		return stepVO;
	}
    
	@Override
	public List<RecipeCategoryDTO> getGrandCategoryList() {
		try {
			List<RecipeCategoryDTO> list = sqlSession.selectList("mapper.recipe.getGrandCategory");
			return list;
		} catch (DataAccessException e) {
			throw new DBException("RecipeDAOImpl.getGrandCategoryList 에러!", e);
		}
	}
	
	// 중분류 카테고리 조회 (페이지 출력용)
	@Override
    public List<RecipeCategoryDTO> selectChildCategoryList() {
        return sqlSession.selectList("mapper.recipe.selectChildCategoryList");
    }
	@Override
	public List<RecipeCategoryDTO> getChildCategoryList(int parent_id) {
		try {
			List<RecipeCategoryDTO> list = sqlSession.selectList("mapper.recipe.getChildCategory", parent_id);
			return list;
		} catch (DataAccessException e) {
			throw new DBException("RecipeDAOImpl.getChildCategoryList 에러! parent_id = '" + parent_id + "'", e);
		}
	}
	
	@Override
	public List<RecipeCategoryDTO> getCategoryStep(int category_id) {
		try {
			List<RecipeCategoryDTO> list = sqlSession.selectList("mapper.recipe.getCategoryStep", category_id);
			return list;
		} catch (DataAccessException e) {
			throw new DBException("RecipeDAOImpl.getCategoryStep 에러! category_id = '" + category_id + "'", e);
		}
	}
	
	@Override
	public List<CategoryDTO> select_all_IngrdCategory() {
		try {
			List<CategoryDTO> ProductCategoryList = sqlSession.selectList("mapper.recipe.select_all_IngrdCategory");
			return ProductCategoryList;
		} catch (DataAccessException e) {
			throw new DBException("RecipeDAOImpl.select_all_IngrdCategory() 에러!", e);
		}
	}
	
	@Override
	public List<CategoryDTO> select_Child_IngrdCategory(int parentIngrdCategoryId) {
		try {
			List<CategoryDTO> ProductSubCategoryList = sqlSession.selectList("mapper.recipe.select_Child_IngrdCategory", parentIngrdCategoryId);
			return ProductSubCategoryList;
		} catch (DataAccessException e) {
			throw new DBException("RecipeDAOImpl.select_Child_IngrdCategory 에러! parentIngrdCategoryId = '" + parentIngrdCategoryId + "'", e);
		}
	}
	
	//레시피 후기 작성
	@Override
	public void addRecipeRating(RecipeRatingDTO ratingDTO) throws Exception {
        sqlSession.insert("mapper.recipe.addRecipeRating", ratingDTO); 
    }
	
	//후기 작성 시 중복 작성 확인 (별점 테러 방지)
	@Override
    public int alreadyExistRating(int rcpId, String byrId) throws Exception {
        // 쿼리문 실행 (평점이 이미 존재하는지 확인)
		return sqlSession.selectOne("mapper.recipe.alreadyExistRating", Map.of("rcpId", rcpId, "byrId", byrId));
    }
	
	@Override
	public List<RecipeRatingDTO> getRatingsByRecipeId(int rcp_id) throws Exception {
        return sqlSession.selectList("mapper.recipe.getRatingsByRecipeId", rcp_id);
    }
	
	//레시피 후기 수정
	@Override
	public void updateRecipeRating(RecipeRatingDTO ratingDTO) {
	    sqlSession.update("mapper.recipe.updateRecipeRating", ratingDTO);
	}
	
	@Override
	public List<RecipeRatingDTO> selectRecipeReviewByrIDList(String byr_id) throws Exception {
        return sqlSession.selectList("mapper.recipe.selectRecipeReviewByrIDList", byr_id);  // 레시피 목록 조회
    }
	//레시피 후기 삭제
	@Override
	public void deleteRecipeRating(RecipeRatingDTO ratingDTO) {
	    sqlSession.delete("mapper.recipe.deleteRecipeRating", ratingDTO);
	}
	
	//레시피 질문 저장
	@Override
	public void addRecipeQna(RecipeQnaDTO qnaDTO) throws Exception {
	    sqlSession.insert("mapper.recipe.addRecipeQna", qnaDTO);  // 맵퍼 호출
	}
	
	//레시피 질문만 조회
	@Override
	public List<RecipeQnaDTO> getQnasByRecipeId(int rcp_id) throws Exception {
	    return sqlSession.selectList("mapper.recipe.getQnasByRecipeId", rcp_id);
	}
	
	//레시피 답변만 조회
	@Override
	public List<RecipeQnaDTO> getAnswersByRecipeId(int rcp_id) throws Exception {
	    return sqlSession.selectList("mapper.recipe.getAnswersByRecipeId", rcp_id);
	}
	
	//레시피 답변 작성
	@Override
	public void addRecipeQnaAnswer(RecipeQnaDTO answerDTO) throws Exception {
	    sqlSession.insert("mapper.recipe.addRecipeQnaAnswer", answerDTO);
	}
	
	//레시피 조회수더하기
	@Override
	public void updateRecipeViews(int rcp_id) throws Exception{
	    sqlSession.update("mapper.recipe.updateRecipeViews", rcp_id);
	}

	// 레시피 질문,답변 수정
	@Override
	public void updateRecipeQna(RecipeQnaDTO qnaDTO) {
	    sqlSession.update("mapper.recipe.updateRecipeQna", qnaDTO);
	}

	// 레시피 질문,답변 삭제
	@Override
	public void deleteRecipeQna(RecipeQnaDTO qnaDTO) {
	    sqlSession.delete("mapper.recipe.deleteRecipeQna", qnaDTO);
	}
	
}