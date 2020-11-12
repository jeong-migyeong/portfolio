package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.zerock.domain.NoticeVO;
import org.zerock.domain.Criteria;


/* PK를 이용한다!! */
/* 쿼리를 수행하지 않으면 작성할 필요 X */

public interface NoticeMapper {

	//SQL을 작성할 때는 반드시 ';'이 없도록 작성해야 합니다.
	//@Select("select * from tbl_board where bno>0")		//BoardMapper.xml에서 SQL문이 처리 되었기 때문제 주석처리
	public List<NoticeVO> getList();
	
	public List<NoticeVO> getListWithPaging(Criteria cri);
	
	// create(insert) 처리
	public void insert(NoticeVO board);	
	public void insertSelectKey(NoticeVO board);
	
	// read(select) 처리
	//insert가 된 데이터를 조회하는 작업은 PK를 이용해서 처리
	public NoticeVO read (long bno);
	
	// delete 처리
	//특정한 데이터를 삭제하는 작업 역시 PK값응 이용하여 처리
	public int delete(long bno);
	
	// update 처리
	public int update(NoticeVO board);
	
	//totalCount를 구해서 PageDTO를 구성할때 전달해 주어야 한다.
	public int getTotalCount(Criteria cri);
	
	//댓글이 등록되면 1이 증가 댓긋이 삭제되면 1이 감소
	public void updateReplyCnt(@Param("bno") long bno, @Param("amount") int amount);
	
	//조회수
	public void boardHit(long bno);
}
