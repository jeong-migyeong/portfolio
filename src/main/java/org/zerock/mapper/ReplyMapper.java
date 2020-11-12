package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;

public interface ReplyMapper {

	/* 등록(Create) */
	public int insert(ReplyVO vo);
	
	/* 조회(Read) */
	public ReplyVO read(long bno);
	
	/* 삭제(Delete) */
	public long delete(long rno);
	
	/* 수정(Update) */
	public int update(ReplyVO reply);
	
	/* 댓글 목록 */
	public List<ReplyVO> getListWithPaging(
			@Param("cri") Criteria cri,
			@Param("bno") long bno
			);
	
	/* 댓글의 숫자 파악 */
	public int getCountByBno(long bno);
}
