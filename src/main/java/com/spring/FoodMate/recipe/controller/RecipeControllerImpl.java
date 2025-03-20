package com.spring.FoodMate.recipe.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring.FoodMate.common.UtilMethod;
import com.spring.FoodMate.member.dto.BuyerDTO;
import com.spring.FoodMate.product.dto.CategoryDTO;
import com.spring.FoodMate.recipe.dto.RecipeCategoryDTO;
import com.spring.FoodMate.recipe.dto.RecipeDTO;
import com.spring.FoodMate.recipe.dto.RecipeIngredientDTO;
import com.spring.FoodMate.recipe.dto.RecipeQnaDTO;
import com.spring.FoodMate.recipe.dto.RecipeRatingDTO;
import com.spring.FoodMate.recipe.dto.RecipeStepDTO;
import com.spring.FoodMate.recipe.service.RecipeService;

@Controller
public class RecipeControllerImpl implements RecipeController {

    @Autowired
    private RecipeService recipeService;
    


    // 레시피 수정 폼
    @RequestMapping(value = "/recipe/recipe_Edit", method = RequestMethod.GET)
    public ModelAndView RecipeEditForm(HttpServletRequest request) throws Exception {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("common/layout");
        mav.addObject("showNavbar", true);
        mav.addObject("title","레시피 수정 페이지");
        mav.addObject("body", "/WEB-INF/views/recipe/recipe_Edit.jsp");
        return mav;
    }
    
    
    // 레시피 목록 조회
    @RequestMapping(value = "/recipe/recipe_list", method = RequestMethod.GET)
    public ModelAndView selectRecipeList(@RequestParam(value = "keyword", required = false, defaultValue = "") String keyword, @RequestParam(value = "sort", required = false) String sort, HttpServletRequest request) throws Exception {
        ModelAndView mav = new ModelAndView();
		List<RecipeDTO> recipeList;
		
		/* ▼sort라는 파라미터값이 null일 경우 기본값은 "latest"(최신순)으로 출력하게 설정했습미다.
         왜냐하면 코드를 좀 줄여볼려고 레시피 조회기능에다가 정렬기능까지 다 넣어놓았어요 
         "latest", "rating" recipe_list jsp 보시면 버튼에 sort값으로 지정해놓은거 참고하시면 이해가 쉽습니다 -심*/
        if (sort == null) {
            sort = "latest";  // 기본값: 최신순
        }
		// "sort(정렬)" 파라미터 값에 따라 레시피 목록 조회
        if (keyword != null && !keyword.trim().isEmpty()) {
            // keyword가 있을 경우 검색 기능 실행
			recipeList = recipeService.searchRecipeList(keyword);
        } else if (sort.equals("rating")) {
            recipeList = recipeService.selectRecipeListByRating();  // 평점순 정렬
        } else {
            recipeList = recipeService.selectRecipeList();  // 최신순 정렬 (기본값)
        }
		System.out.println("정렬값:" + sort);        
        List<RecipeCategoryDTO> p_category = recipeService.getGrandCategoryList();  // 대분류 카테고리 조회 기존 레시피 작성시 있었던 메소드 활용
        
        List<RecipeCategoryDTO> c_category = recipeService.selectChildCategoryList();  // 중분류 카테고리 조회
        
        mav.addObject("p_category", p_category);
        mav.addObject("c_category", c_category);      
        mav.addObject("recipeList", recipeList);
        mav.setViewName("common/layout");
        mav.addObject("showNavbar", true);
        mav.addObject("title","레시피 목록");
        mav.addObject("body", "/WEB-INF/views/recipe/recipe_list.jsp");
        return mav;
    }
	
	//레시피 카테고리별 조회
    @RequestMapping(value = "/recipe/selectRecipeByCategory", method = RequestMethod.GET)
    public ModelAndView selectRecipeByCategory(
            @RequestParam(value = "category_id") int category_id, 
            @RequestParam(value = "parent_id", required = false) Integer parent_id) throws Exception {

        ModelAndView mav = new ModelAndView();
        List<RecipeDTO> recipeList;

        if (parent_id == null) {
        	        // 🔥 parent_id가 null이면 category_id를 parent_id로 사용해야함
        	parent_id = category_id;        	        
        	        // 🔥 대분류에 속한 모든 소분류 category_id를 조회
        	        recipeList = recipeService.selectRecipeByParent(parent_id);
            System.out.println("대분류의 category_id :"  + "중분류의 부모 카테고리:" + parent_id );
        } else {
            // parent_id가 있으면 중분류 카테고리만 조회
            recipeList = recipeService.selectRecipeByChild(category_id);  // 중분류 조회
            System.out.println("중분류카테고리id:"  + category_id);
            System.out.println("중분류부모카테고리id:"  + parent_id);
        }
        
        List<RecipeCategoryDTO> p_category = recipeService.getGrandCategoryList();  // 대분류 카테고리 조회 기존 레시피 작성시 있었던 메소드 활용
        
        List<RecipeCategoryDTO> c_category = recipeService.selectChildCategoryList();  // 중분류 카테고리 조회
        
        mav.addObject("p_category", p_category);
        mav.addObject("c_category", c_category);      
        
        mav.addObject("recipeList", recipeList);
        mav.setViewName("common/layout");
        mav.addObject("showNavbar", true);
        mav.addObject("title", "레시피 목록");
        mav.addObject("body", "/WEB-INF/views/recipe/recipe_list.jsp");
        return mav;
    }
    
    //레시피 상세조회
    @RequestMapping(value = "/recipe/recipe_Detail", method = RequestMethod.GET)
    public ModelAndView selectRecipeDetail(@RequestParam("rcp_id") int rcp_id, HttpServletRequest request) throws Exception {
    	ModelAndView mav = new ModelAndView();
        HttpSession session = request.getSession();
        Map<String, Object> recipeMap = recipeService.selectRecipeDetail(rcp_id);
        RecipeDTO recipe = (RecipeDTO)recipeMap.get("recipe");
        Integer category_id = recipe.getCategory_id();
	        
	        if(category_id!=null) {
	        	List<RecipeCategoryDTO> categoryStep = recipeService.categoryStep(category_id);
	        	mav.addObject("category", categoryStep);
	        }
//      // 최근 본 레시피 리스트 갱신
//      // 지금 세션에 레시피DTO를 다 주고있는거같은데, 세션에는 레시피id만 주고 
	      RecipeDTO recipeDTO = (RecipeDTO) recipeMap.get("recipe");
	      RecentRecipeView(rcp_id, recipeDTO, session);
//
//      // 지금 레시피 상세조회 페이지에 그냥 최근 본 레시피 파트까지 넣은거같은데, 
//      // "최근 본 레시피" 를 jsp include 하고 거기서 알아서 처리하게 하면 어떨까요?
//      // 지금 이대로면 모든 메서드마다 리센트레시피리스트관련처리를 해야하는데.
        
	    
	    // 조회수 더하기
	      recipeService.setViewsCount(rcp_id);
        
        
        // 업데이트된 recentRecipeList를 jsp에 전달
        mav.addObject("recentRecipeList", (List<RecipeDTO>) session.getAttribute("recentRecipeList"));
        
        // 레시피맵에서 필요한거 뿌림
        mav.addObject("recipe", recipeMap.get("recipe"));
        mav.addObject("ingredients", recipeMap.get("ingredients"));
        mav.addObject("steps", recipeMap.get("steps"));
        
        // 댓글 및 후기 목록 조회 (레시피에 달린 댓글과 그에 대한 작성자 정보 포함)
        List<RecipeRatingDTO> ratingList = recipeService.getRatingsByRecipeId(rcp_id);
        mav.addObject("ratingList", ratingList);
        
        // 레시피 질문 조회
        List<RecipeQnaDTO> qnaList = recipeService.getQnasByRecipeId(rcp_id);
        mav.addObject("qnaList", qnaList);
        
        // 레시피 답변 조회 (parent_id가 있는 경우)
        List<RecipeQnaDTO> answerList = recipeService.getAnswersByRecipeId(rcp_id);
        mav.addObject("answerList", answerList);


        mav.setViewName("common/layout");
        mav.addObject("showNavbar", true);
        mav.addObject("title", "레시피 상세");
        mav.addObject("body", "/WEB-INF/views/" + UtilMethod.getViewName(request) + ".jsp"); 
        return mav;
    }

    private void RecentRecipeView(int rcp_Id, RecipeDTO recipeVO, HttpSession session) {
        // 세션에서 '최근 본 레시피' 리스트를 가져옴
        List<RecipeDTO> recentRecipeList = (List<RecipeDTO>) session.getAttribute("recentRecipeList");

        // recentRecipeList가 null인 경우 빈 리스트로 초기화
        if (recentRecipeList == null) {
            recentRecipeList = new ArrayList<>();
        }

        // ▼비상용 코드 최근본 레시피에 불량값이 들어올경우 주석을풀고 쓸것
//        if (recentRecipeList.isEmpty() || recentRecipeList.get(0) == null) {
//            recentRecipeList.clear();
//        }

        // 최근 본 레시피가 세션에 존재할 경우
        if (recentRecipeList != null) {
            boolean alreadyExisted = false;

            // 이미 해당 레시피가 최근 본 리스트에 있는지 확인
            for (int i = 0; i < recentRecipeList.size(); i++) {
                RecipeDTO _recipe = recentRecipeList.get(i);
                if (rcp_Id == _recipe.getRcp_id()) {
                    alreadyExisted = true;
                    // 이미 리스트에 있으면 해당 레시피를 가장 앞에 오도록 이동
                    recentRecipeList.remove(i);  // 기존 항목 삭제
                    recentRecipeList.add(0, _recipe);  // 최근 항목으로 추가
                    break;
                }
            }

            // 최근 본 레시피 리스트에 없다면
            if (!alreadyExisted) {
                // 리스트가 20개 이상일 경우, 가장 오래된 레시피를 제거
                if (recentRecipeList.size() >= 20) {
                    recentRecipeList.remove(recentRecipeList.size() - 1);  // 가장 오래된 레시피 제거
                }
                // 새로운 레시피를 리스트 앞에 추가
                recentRecipeList.add(0, recipeVO);
            }
        }       
        // 세션에 최근 본 레시피 리스트 저장
        session.setAttribute("recentRecipeList", recentRecipeList);
        session.setAttribute("recentRecipeListNum", recentRecipeList.size());
    }

    //검색 기능 수정 필요
    @RequestMapping(value = "/recipe/search_recipe_list", method = RequestMethod.GET)
    public ModelAndView searchList(HttpServletRequest request) throws Exception {
        
        String searchKeyword = request.getParameter("searchKeyword");

        ModelAndView mav = new ModelAndView();
        
       
        mav.addObject("recipeList", recipeService.selectRecipeList()); 
        mav.setViewName("common/layout");
        mav.addObject("showHeadermenu", true);
        mav.addObject("title", "레시피 목록");
        mav.addObject("body", "/WEB-INF/views/recipe/recipe_list.jsp");
        
        return mav;
    }
    
    // 레시피 작성 폼으로 이동
	@RequestMapping(value="/recipe/recipe_Add", method=RequestMethod.GET)
	public ModelAndView addRecipeForm(HttpServletRequest request) throws Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("common/layout");
		mav.addObject("showNavbar", true);
		mav.addObject("title", "FoodMate - 레시피 작성");
		mav.addObject("body", "/WEB-INF/views" +  UtilMethod.getViewName(request) + ".jsp");
		mav.addObject("categories", recipeService.getGrandCategoryList());
		mav.addObject("ingrd_categories", recipeService.select_all_IngrdCategory());
		return mav;
	}
	
	// jsp에서 레시피 작성 눌렀을때 처리 메소드
	@Override
	@RequestMapping(value = "/recipe/addNewRecipe", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> addNewRecipe(
	    @RequestParam("title") String title,
	    @RequestParam("food_name") String foodName,
	    @RequestParam("category_id") Integer category_id,
	    @RequestParam("req_time") String reqTime,
	    @RequestParam("description") String description,
	    
	    @RequestParam(value = "mainimg_path", required = false) MultipartFile mainImg,
	    @RequestParam(value = "ingrd_name") List<String> ingredientsNames,
	    @RequestParam(value = "ingrd_qty") List<Integer> ingredientsQty,
	    @RequestParam(value = "unit") List<String> ingredientsUnits,
	    @RequestParam(value = "ingrd_category_id") List<Integer> ingredientsCategoryIds,
	    
	    @RequestParam(value = "rcp_step") List<Integer> stepNumbers,
	    @RequestParam(value = "step_desc") List<String> stepDescriptions,
	    @RequestParam(value = "stepimg_path") List<MultipartFile> stepImages,
	    
	    HttpServletRequest request,
	    HttpSession session
	) throws Exception {
	    System.out.println("가져온 레시피 카테고리 id : " + category_id);
	    System.out.println("가져온 재료 카테고리 id : " + ingredientsCategoryIds);
	    
	    
	    BuyerDTO buyerDTO = (BuyerDTO) session.getAttribute("buyerInfo");
	    String byr_id = buyerDTO.getByr_id();
	    
	    // 레시피 객체 생성
	    RecipeDTO recipe = new RecipeDTO();
	    recipe.setTitle(title);
	    recipe.setFood_name(foodName);
	    recipe.setCategory_id(category_id);
	    recipe.setReq_time(reqTime);
	    recipe.setDescription(description);
	    recipe.setByr_id(byr_id);
	    
	    if (!mainImg.isEmpty()) {
	        String mainImgPath = UtilMethod.saveRecipeImage(request, mainImg);
	        recipe.setMainimg_path(mainImgPath);
	    }
	    
	    int recipeId = recipeService.addRecipe(recipe);

	    // 재료 객체 생성 후 배치 삽입
	    List<RecipeIngredientDTO> ingredients = new ArrayList<>();
	    List<String> uniqueIngredients = new ArrayList<>();
	    
	    for (int i = 0; i < ingredientsNames.size(); i++) {
	        // 중복된 재료가 이미 리스트에 있으면 추가하지 않도록 함
	        if (!uniqueIngredients.contains(ingredientsNames.get(i))) {
	            RecipeIngredientDTO ingredient = new RecipeIngredientDTO();
	            ingredient.setRcp_id(recipeId);  // 생성된 레시피 ID
	            ingredient.setIngrd_name(ingredientsNames.get(i));
	            ingredient.setIngrd_qty(ingredientsQty.get(i));
	            ingredient.setUnit(ingredientsUnits.get(i));
	            ingredient.setCategory_id(ingredientsCategoryIds.get(i)); // 각 재료의 카테고리 ID 저장
	            ingredients.add(ingredient);
	            uniqueIngredients.add(ingredientsNames.get(i));
	        }
	    }
	    
	    recipeService.insertRecipeIngredients(ingredients);  // 재료 추가

	    // 단계 객체 생성 후 배치 삽입
	    List<RecipeStepDTO> steps = new ArrayList<>();
	    List<Integer> uniqueStepNumbers = new ArrayList<>();

	    for (int i = 0; i < stepNumbers.size(); i++) {
	        if (!uniqueStepNumbers.contains(stepNumbers.get(i))) {
	            RecipeStepDTO step = new RecipeStepDTO();
	            step.setRcp_id(recipeId);  // 생성된 레시피 ID
	            step.setRcp_step(stepNumbers.get(i));
	            step.setStep_desc(stepDescriptions.get(i));
	            if (!(stepImages == null || stepImages.isEmpty() || stepImages.get(0).getSize() == 0)) {
	                String stepImgPath = UtilMethod.saveRecipeImage(request, stepImages.get(i));
	                step.setStepimg_path(stepImgPath);
	            }
	            steps.add(step);
	            uniqueStepNumbers.add(stepNumbers.get(i));
	        }
	    }
	    
	    recipeService.insertRecipeSteps(steps);  // 단계 추가
	    
	    Map<String, Object> response = new HashMap<>();
	    response.put("message", "레시피 등록에 성공했습니다.");
	    response.put("status", "success");
	    return new ResponseEntity<>(response, HttpStatus.OK);
	}

	
	@RequestMapping(value="/recipe/getSubCategories", method=RequestMethod.GET)
	@ResponseBody
	public List<RecipeCategoryDTO> getSubCategories(@RequestParam("category_id") int category_id) throws Exception {
		System.out.println("받아온 레시피 카테고리: " + category_id);
	    // 데이터베이스에서 category_id에 해당하는 자식 카테고리 가져오기
	    List<RecipeCategoryDTO> subCategories = recipeService.getChildCategoryList(category_id);
	    return subCategories;
	}

	
	@RequestMapping(value="/recipe/select_Sub_IngrdCategory", method=RequestMethod.GET)
	@ResponseBody
	public List<CategoryDTO> select_Sub_IngrdCategory(@RequestParam("ingrd_category_id") int ingrd_category_id) throws Exception {
	    // 데이터베이스에서 category_id에 해당하는 자식 카테고리 가져오기
	    List<CategoryDTO> IngrdsubCategories = recipeService.select_Child_IngrdCategory(ingrd_category_id);
	    System.out.println("재료의 카테고리id: " + ingrd_category_id);
	    return IngrdsubCategories;
	}

	
	//레시피후기작성
	@RequestMapping("/recipe/addRecipeRating")
	public String addRecipeRating(
	        @RequestParam("rcp_id") int rcp_id,  // 레시피 ID
	        @RequestParam("rating") int rating,  // 입력한 별점
	        @RequestParam("comments") String comments,  // 댓글
	        HttpSession session, 
	        RedirectAttributes redirectAttributes
	        ) {
	    
	    try {
	    	System.out.println("rcp_id: " + rcp_id);
	        System.out.println("rating: " + rating);
	        System.out.println("comments: " + comments);
	    	
	        // 세션에서 로그인한 사용자 정보 받기
	        BuyerDTO buyerDTO = (BuyerDTO) session.getAttribute("buyerInfo");
	        String byr_id = buyerDTO.getByr_id();  // 댓글 작성자의 ID
	        
	        // 이미 후기가 작성되었는지 확인
	        int alreadyRated = recipeService.alreadyExistRating(rcp_id, byr_id);
	        
	        //true일경우
	        if (alreadyRated> 0) {
	            
	            redirectAttributes.addFlashAttribute("error", "이미 후기를 작성하셨습니다.");
	        } else {
	            // 후기가 존재하지 않으면 새로 등록
	            RecipeRatingDTO ratingDTO = new RecipeRatingDTO();
	            ratingDTO.setRcp_id(rcp_id);
	            ratingDTO.setByr_id(byr_id);
	            ratingDTO.setRating(rating);
	            ratingDTO.setComments(comments);
	            
	            // 서비스 호출하여 DB에 후기 저장
	            recipeService.addRecipeRating(ratingDTO);
	            
	            // 성공 메시지 추가
	            redirectAttributes.addFlashAttribute("message", "후기가 성공적으로 등록되었습니다.");
	     }
	    } catch (Exception e) {
	        // 오류 발생 시
	        redirectAttributes.addFlashAttribute("error", "후기 등록 중 오류가 발생했습니다.");
	    }

	    return "redirect:/recipe/recipe_Detail?rcp_id=" + rcp_id;
	}
	
	@RequestMapping("/recipe/updateRecipeRating")
	public String updateRecipeRating(
	        @RequestParam("cmt_rcp_rating_id") int cmt_rcp_rating_id,  // 댓글 ID
	        @RequestParam("rcp_id") int rcp_id,  // 레시피 ID (리다이렉트용)
	        @RequestParam("rating") int rating,  // 수정할 별점
	        @RequestParam("comments") String comments,  // 수정할 댓글 
	        RedirectAttributes redirectAttributes) {

	    try {

	        // RecipeRatingDTO에 데이터 세팅 (rcp_id는 안 넣음!)
	        RecipeRatingDTO ratingDTO = new RecipeRatingDTO();
	        ratingDTO.setCmt_rcp_rating_id(cmt_rcp_rating_id);
	        ratingDTO.setRating(rating);
	        ratingDTO.setComments(comments);

	        // 서비스 호출하여 후기 수정
	        recipeService.updateRecipeRating(ratingDTO);

	        // 성공 메시지 추가
	        redirectAttributes.addFlashAttribute("message", "후기가 성공적으로 수정되었습니다.");
	    } catch (Exception e) {
	        redirectAttributes.addFlashAttribute("error", "후기 수정 중 오류가 발생했습니다.");
	    }

	    // ✅ rcp_id는 리다이렉트할 때만 사용
	    return "redirect:/recipe/recipe_Detail?rcp_id=" + rcp_id;
	}
	
	// 레시피 후기 삭제 처리
	@RequestMapping("/recipe/deleteRecipeRating")
	public String deleteRecipeRating(
	        @RequestParam("cmt_rcp_rating_id") int cmt_rcp_rating_id,  // 삭제할 댓글 ID
	        @RequestParam("rcp_id") int rcp_id,  // 레시피 ID (리다이렉트용)
	        RedirectAttributes redirectAttributes) {

	    try {
	    	RecipeRatingDTO ratingDTO = new RecipeRatingDTO();
	    	ratingDTO.setCmt_rcp_rating_id(cmt_rcp_rating_id);
	    	
	        // 서비스 호출하여 후기 삭제
	        recipeService.deleteRecipeRating(ratingDTO);

	        
	        // 성공 메시지 추가
	        redirectAttributes.addFlashAttribute("message", "후기가 성공적으로 삭제되었습니다.");
	    } catch (Exception e) {
	        e.printStackTrace();  // 예외 출력
	        redirectAttributes.addFlashAttribute("error", "후기 삭제 중 오류가 발생했습니다.");
	    }

	    return "redirect:/recipe/recipe_Detail?rcp_id=" + rcp_id;
	}

	//레시피 질문 등록
	@RequestMapping("/recipe/addRecipeQna")
	public String addRecipeQna(
	        @RequestParam("rcp_id") int rcp_id,  // 레시피 ID
	        @RequestParam("comments") String comments,  // 질문 댓글
	        HttpSession session, 
	        RedirectAttributes redirectAttributes) {

	    try {
	        // 세션에서 로그인한 사용자 정보 받기
	        BuyerDTO buyerDTO = (BuyerDTO) session.getAttribute("buyerInfo");
	        String byr_id = buyerDTO.getByr_id();  // 댓글 작성자의 ID

	        // RecipeQnaDTO에 데이터 세팅
	        RecipeQnaDTO qnaDTO = new RecipeQnaDTO();
	        qnaDTO.setRcp_id(rcp_id);
	        qnaDTO.setByr_id(byr_id);
	        qnaDTO.setComments(comments);

	        // 서비스 호출하여 DB에 질문 등록
	        recipeService.addRecipeQna(qnaDTO);

	        // 성공 메시지 추가
	        redirectAttributes.addFlashAttribute("qna_message", "질문이 성공적으로 등록되었습니다.");
	    } catch (Exception e) {
	        // 오류 발생 시
	        redirectAttributes.addFlashAttribute("qna_error", "질문 등록 중 오류가 발생했습니다.");
	    }
	    return "redirect:/recipe/recipe_Detail?rcp_id=" + rcp_id;
	}
	
	@RequestMapping("/recipe/addRecipeQnaAnswer")
	public String addRecipeQnaAnswer(@RequestParam("rcp_id") int rcp_id,  // 레시피 ID
									 @RequestParam("parent_id") int parentId, 
	                                 @RequestParam("comments") String comments, 
	                                  HttpSession session) throws Exception {
	    
	    // 세션에서 로그인한 사용자 정보 가져오기
	    BuyerDTO buyerInfo = (BuyerDTO) session.getAttribute("buyerInfo");
	    
	    // RecipeQnaDTO 객체 생성 및 값 설정
	    RecipeQnaDTO answerDTO = new RecipeQnaDTO();
	    answerDTO.setParent_id(parentId);  // 답변ID = 해당 질문의 ID를 담음 (parent_id)
	    answerDTO.setComments(comments);   // 답변 내용
	    answerDTO.setByr_id(buyerInfo.getByr_id());  // 답변 작성자 ID
	    answerDTO.setRcp_id(rcp_id);
	    //System.out.println("댓글아이디 :" + parentId); 정상적으로 넘어옴
	    // 답변을 추가하는 서비스 메소드 호출
	    recipeService.addRecipeQnaAnswer(answerDTO);
	    //System.out.println("리다이렉트할 rcp_id: " + rcp_id); 정상적으로 넘어옴
	    // 답변 후 해당 질문 페이지로 리다이렉트
	    return "redirect:/recipe/recipe_Detail?rcp_id=" + rcp_id;
	    
	}
	// 레시피 질문 수정 처리
	@RequestMapping("/recipe/updateRecipeQna")
	public String updateRecipeQna(
	        @RequestParam("cmt_rcp_qna_id") int cmt_rcp_qna_id,  // 질문 ID
	        @RequestParam("rcp_id") int rcp_id,  // 레시피 ID (리다이렉트용)
	        @RequestParam("comments") String comments,  // 수정할 댓글 
	        RedirectAttributes redirectAttributes) {
	    try {
	        // RecipeQnaDTO에 데이터 세팅
	        RecipeQnaDTO qnaDTO = new RecipeQnaDTO();
	        qnaDTO.setCmt_rcp_qna_id(cmt_rcp_qna_id);
	        qnaDTO.setComments(comments);
	        
	        System.out.println("rcp_id =" + rcp_id);
	        System.out.println("원본,답글,답글의답글 ID = " + cmt_rcp_qna_id);
	        // 서비스 호출하여 질문 수정
	        recipeService.updateRecipeQna(qnaDTO);

	        // 성공 메시지 추가
	        redirectAttributes.addFlashAttribute("message", "질문이 성공적으로 수정되었습니다.");
	    } catch (Exception e) {
	        e.printStackTrace();  // 예외 출력
	        redirectAttributes.addFlashAttribute("error", "질문 수정 중 오류가 발생했습니다.");
	    }

	    return "redirect:/recipe/recipe_Detail?rcp_id=" + rcp_id;
	}

	// 레시피 질문 삭제 처리
	@RequestMapping("/recipe/deleteRecipeQna")
	public String deleteRecipeQna(
	        @RequestParam("cmt_rcp_qna_id") int cmt_rcp_qna_id,  // 삭제할 질문 ID
	        @RequestParam("rcp_id") int rcp_id,  // 레시피 ID (리다이렉트용)
	        RedirectAttributes redirectAttributes) {

	    try {
	        // RecipeQnaDTO에 데이터 세팅
	        RecipeQnaDTO qnaDTO = new RecipeQnaDTO();
	        qnaDTO.setCmt_rcp_qna_id(cmt_rcp_qna_id);

	        // 서비스 호출하여 질문 삭제
	        recipeService.deleteRecipeQna(qnaDTO);

	        // 성공 메시지 추가
	        redirectAttributes.addFlashAttribute("message", "질문이 성공적으로 삭제되었습니다.");
	    } catch (Exception e) {
	        e.printStackTrace();  // 예외 출력
	        redirectAttributes.addFlashAttribute("error", "질문 삭제 중 오류가 발생했습니다.");
	    }

	    return "redirect:/recipe/recipe_Detail?rcp_id=" + rcp_id;
	}


}

	
