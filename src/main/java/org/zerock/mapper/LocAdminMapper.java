package org.zerock.mapper;

import java.util.List;

import org.zerock.domain.LocAdminVO;


/* PK를 이용한다!! */
/* 쿼리를 수행하지 않으면 작성할 필요 X */

public interface LocAdminMapper {
	

	//SQL을 작성할 때는 반드시 ';'이 없도록 작성해야 합니다.
	//@Select("select * from tbl_board where bno>0")		//BoardMapper.xml에서 SQL문이 처리 되었기 때문제 주석처리
	public List<LocAdminVO> getList();
}
