package org.zerock.mapper;

import java.util.List;

import org.zerock.domain.MemberVO;
import org.zerock.domain.AuthVO;
import org.zerock.domain.Criteria;


/* PK를 이용한다!! */
/* 쿼리를 수행하지 않으면 작성할 필요 X */


//8.1.2 Mapper 인터페이스와 Mapper XML
public interface MemberMapper {

	//SQL을 작성할 때는 반드시 ';'이 없도록 작성해야 합니다.
	//@Select("select * from tbl_member where bno>0")		//MemberMapper.xml에서 SQL문이 처리 되었기 때문제 주석처리
	public List<MemberVO> getList();
	
	public List<MemberVO> getListWithPaging(Criteria cri);
	
	//8.2.1 create(insert) 처리
	public void insert(MemberVO member);	
	public void insertSelectKey(MemberVO member);
	public void insertAuth(AuthVO auth);
	
	//8.2.2 read(select) 처리
	//insert가 된 데이터를 조회하는 작업은 PK를 이용해서 처리
	public MemberVO read (String userid);
	
	//8.2.3 delete 처리
	//특정한 데이터를 삭제하는 작업 역시 PK값응 이용하여 처리
	public int remove(String userid);
	
	//8.2.4 update 처리
	public int update(MemberVO member);
	
	//totalCount를 구해서 PageDTO를 구성할때 전달해 주어야 한다.
	public int getTotalCount(Criteria cri);
}
