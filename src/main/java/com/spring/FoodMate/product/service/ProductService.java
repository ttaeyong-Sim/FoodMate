package com.spring.FoodMate.product.service;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.spring.FoodMate.common.SessionDTO;
import com.spring.FoodMate.common.UtilMethod;
import com.spring.FoodMate.common.exception.DBException;
import com.spring.FoodMate.product.dao.PdtReviewDAO;
import com.spring.FoodMate.product.dao.ProductDAO;
import com.spring.FoodMate.product.dto.CategoryDTO;
import com.spring.FoodMate.product.dto.ProductDTO;
import com.spring.FoodMate.product.dto.ProductRatingDTO;
import com.spring.FoodMate.product.exception.ProductException;
import com.spring.FoodMate.recipe.dto.RecipeRatingDTO;

@Service("productService")
public class ProductService {
	@Autowired
	private ProductDAO productDAO;
	@Autowired
	private PdtReviewDAO pdtReviewDAO;
	
	//기존에 쓰던 전체상품+검색어로 상품조회
	public List<ProductDTO> pdtList(String keyword) {
		try {
			if(keyword.equals("")) {
				return productDAO.pdtAllList();
			} else {
				return productDAO.pdtSearchList(keyword);
			}
		} catch (DBException e) {
			throw new ProductException("ProductService에서 DB예외 전달.", e);
		} catch (Exception e) {
			throw new ProductException("ProductService.pdtList 에러! keyword = '" + keyword + "'", e);
		}
	}
	
	// 앞으로 쓸 전체상품 & 판매자별 & 카테고리별 & 검색어별 상품목록조회
	public List<ProductDTO> searchList(String slr_id, Integer category_id, String keyword, String sort) {
		try {
			return productDAO.searchList(slr_id, category_id, keyword, sort);
		} catch (DBException e) {
			throw new ProductException("ProductService에서 DB예외 전달.", e);
		} catch (Exception e) {
			throw new ProductException("ProductService.searchList 에러!", e);
		}
	}
	
	public List<ProductDTO> ms_pdtList(String slr_id) {
		try {
			return productDAO.pdtListBySlrId(slr_id);
		} catch (DBException e) {
			throw new ProductException("ProductService에서 DB예외 전달.", e);
		} catch (Exception e) {
			throw new ProductException("ProductService.ms_pdtList 에러! slr_id = '" + slr_id + "'", e);
		}
	}
	
	// 상품 재고및 상태변경 페이지에 필요한 데이터 제공 메서드
	public List<ProductDTO> mypageseller_pdtListForStock(String slr_id) {
		try {
			return productDAO.pdtListForStockBySlrId(slr_id);
		} catch (DBException e) {
			throw new ProductException("ProductService에서 DB예외 전달.", e);
		} catch (Exception e) {
			throw new ProductException("ProductService.ms_pdtList 에러! slr_id = '" + slr_id + "'", e);
		}
	}
	
	// 판매자 마이페이지 메인 내 best3
	public List<ProductDTO> myBest3(String slr_id) {
		try {
			return productDAO.myBest3(slr_id);
		} catch (DBException e) {
			throw new ProductException("ProductService에서 DB예외 전달.", e);
		} catch (Exception e) {
			throw new ProductException("ProductService.myBest3 에러! slr_id = '" + slr_id + "'", e);
		}
	}
	
	// 상품 상태 변경 메서드
	public boolean changeStatus(int pdt_id, String currentStatus) {
        String newStatus = (currentStatus.equals("Y")) ? "N" : "Y";  // 상태 반전

        try {
            // 상품 상태 변경
            return productDAO.updateStatus(pdt_id, newStatus) > 0;
        } catch (Exception e) {
            throw new ProductException("음...", e);
        }
    }
	
	public ProductDTO select1PdtByPdtId(int pdt_id) {
		try {
			ProductDTO pdt = productDAO.select1Pdt(pdt_id);
			if(pdt != null) {
				return pdt;
			} else {
				throw new ProductException("ProductService.select1PdtByPdtId 에러!", 201);
			}
		} catch (DBException e) {
			throw new ProductException("ProductService에서 DB예외 전달.", e);
		}
	}
	
	public List<CategoryDTO> getGrandCategoryList() {
		try {
			return productDAO.getGrandCategoryList();
		} catch (DBException e) {
			throw new ProductException("ProductService에서 DB예외 전달.", e);
		} catch (Exception e) {
			throw new ProductException("ProductService.getGrandCategoryList 에러!", e);
		}
	}
	
	public List<CategoryDTO> getChildCategoryList(int category_id) {
		try {
			return productDAO.getChildCategoryList(category_id);
		} catch (DBException e) {
			throw new ProductException("ProductService에서 DB예외 전달.", e);
		} catch (Exception e) {
			throw new ProductException("ProductService.getChildCategoryList 에러! category_id = '" + category_id + "'", e);
		}
	}
	
	public List<CategoryDTO> categoryStep(int category_id) {
		try {
			return productDAO.getCategoryStep(category_id);
		} catch (DBException e) {
			throw new ProductException("ProductService에서 DB예외 전달.", e);
		} catch (Exception e) {
			throw new ProductException("ProductService.categoryStep 에러! category_id = '" + category_id + "'", e);
		}
	}
	
	@Transactional(rollbackFor = ProductException.class)
	public boolean insertNewProduct(HttpServletRequest request, ProductDTO newPdt) throws Exception {
		try {
			HttpSession session = request.getSession();
			SessionDTO userInfo = (SessionDTO)session.getAttribute("sessionDTO");
			String slr_id = userInfo.getUserId();
			newPdt.setSlr_id(slr_id);
			// 세션에서 id꺼내와서 ProductDTO newPdt에 저장
			
			String imagePath = UtilMethod.savePdtImage(request, newPdt.getPdt_img(), 1); // 유틸메서드로 일단 경로에 이미지 저장해
		    newPdt.setImg_path(imagePath);
		    // newPdt에서 멀티파트파일형 이미지파일 꺼내와서 서버에 저장하고 저장경로 받아와서 newPdt에 저장
			
			int result = productDAO.insertNewProduct(newPdt);
			// 받아온 내용 DTO에 insert
			
			if(result <= 0) {
				throw new ProductException("ProductService.insertNewProduct 에러!" + newPdt.toLogString(), 202);
				// 오류나면 로깅하면서 에러띄움
			}
			
			boolean result2 = insertProductDescImgs(request, newPdt);
			// 상품설명이미지들 다른테이블에 저장
			
			boolean result3 = (result > 0) || result2;
			
			return result3;
		} catch (DBException e) {
			throw new ProductException("ProductService에서 DB예외 전달.", e);
		}
	}
	
	public boolean insertProductDescImgs(HttpServletRequest request,ProductDTO newPdt) throws Exception {
	    List<MultipartFile> descimgs = newPdt.getPdt_descimg();
	    int pdt_id = productDAO.getNewPdtId(); //방금만들어진 상품아이디 갖고오기

	    // 향상된 for문을 사용하여 각 MultipartFile에 대해 처리
	    for (MultipartFile file : descimgs) {
	        if (!file.isEmpty()) { // 꺼내온 파일이 비어있지않으면
	        	String imgPath = UtilMethod.savePdtImage(request, file, 2);
	            int result = productDAO.insertProductDescImg(pdt_id, imgPath);
	            if (result < 1) {
	            	System.out.println("상품설명이미지넣는중오류");
	            	throw new ProductException(206);
	            }
	        }
	    }
	    return true;
	}
	
	public boolean updateProduct(ProductDTO editPdt) {
		try {
			int result = productDAO.updateProduct(editPdt);
			if(result <= 0) {
				throw new ProductException("ProductService.updateProduct 에러!" + editPdt.toLogString(), 204);
			}
			return result > 0;
		} catch (DBException e) {
			throw new ProductException("ProductService에서 DB예외 전달.", e);
		}
	}
	
	public boolean deleteProduct(int pdt_id) {
		try {
			int result = productDAO.deleteProduct(pdt_id);
			if(result <= 0) {
				throw new ProductException("ProductService.deleteProduct 에러! pdt_id = " + pdt_id, 205);
			}
			return result > 0;
		} catch (DBException e) {
			throw new ProductException("ProductService에서 DB예외 전달.", e);
		}
	}
	
	// 재고 수 업데이트하는 메서드
	public int updateStock(int pdt_id, int stock) throws Exception {
		return productDAO.updateStock(pdt_id, stock);
	}
	
	// 상품 설명 이미지들 불러와서 html 태그로 준비해주는 메서드
	public String getDescImgs(int pdt_id) throws Exception {
	    List<String> imgPaths = productDAO.getDescImgPaths(pdt_id);  // DAO에서 이미지 경로 리스트 가져오기
	    StringBuilder descriptionHtml = new StringBuilder();
	    
	    // 이미지 경로들을 <img> 태그로 감싸기
	    for (String imgPath : imgPaths) {
	        descriptionHtml.append("<img src=/FoodMate/resources/images/")
	        			   .append(imgPath)
	        			   .append(" alt=\"상품 설명 이미지\" />");
	    }
	    
	    return descriptionHtml.toString();  // HTML로 구성된 이미지 태그 반환
	}
	
	// 레시피 정보 가져오기
    public List<ProductRatingDTO> selectProductReviewByrIDList(String byr_id) throws Exception {
        return productDAO.selectProductReviewByrIDList(byr_id);  // 레시피 목록 조회
        
    }
	
	

}