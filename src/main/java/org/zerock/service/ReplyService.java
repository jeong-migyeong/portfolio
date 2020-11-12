package org.zerock.service;

import java.util.List;

import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyPageDTO;
import org.zerock.domain.ReplyVO;

public interface ReplyService {

	/* 등록(Create) */
	public int register(ReplyVO vo);
	
	/* 조회(Read) */
	public ReplyVO get(long rno);
	
	/* 수정(Update) */
	public int modify(ReplyVO vo);
	
	/* 삭제(Delete) */
	public long remove(long rno);

	/* 목록(List) */
	public List<ReplyVO> getList(Criteria cri, long bno);
	
	/* ReplyPageDTO를 반환하는 메서드를 추가 */
	public ReplyPageDTO getListPage(Criteria cri, long bno);
}
