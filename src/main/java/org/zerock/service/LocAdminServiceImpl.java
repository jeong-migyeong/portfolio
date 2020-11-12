package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import org.zerock.domain.LocAdminVO;
import org.zerock.mapper.LocAdminMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;

@Repository
@AllArgsConstructor	//모든 파라미터를 이용하는 생성자를 만듦
@Service	//계층 구조상 주로 비즈니스 영역을 담당하는 객체임을 표시하기 위해 사용
public  class LocAdminServiceImpl implements LocAdminService {
	
	//spring 4.3 이상에서 자동 처리
	@Setter(onMethod_ = @Autowired)
	private LocAdminMapper mapper;

	//현재 테이블에 저장된 모든 데이터를 가져오는 getList()
	@Override  
	public List<LocAdminVO> getList() { 
		return mapper.getList(); 
	}
	
}
